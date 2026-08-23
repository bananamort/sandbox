# Network/Player.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 3032 lines)

## Purpose

Implements `RBX::Network::Player` (`sPlayer = "Player"`): per-user state replicated by ServerReplicator — userId/membership/appearance/chat-filter info, Character lifecycle (`loadCharacter` building from `character3.rbxm`/R15 rbxm + StarterPlayer overrides), spawn-location calculation, persistent data store (`LoadData/SaveString/...`), character-appearance fetching, friendship web calls, kick flow, idle detection, simulation radius (distributed physics), teleport signal plumbing, and PlayerGui/Backpack/PlayerScripts rebuilding.

## API

### HTTP endpoints called

| Endpoint | Method | Calling symbol |
|---|---|---|
| `<LoadDataUrl>` formatted with userId (set via `Players:SetLoadDataUrl`) | GET via `LuaWebService::asyncRequestNoCache` | `Player::loadData` (guests skip; result → `PersistentDataStore`, fires `DataReady`) |
| `<SaveDataUrl>` (userId-formatted) | POST body=persisted string via `Http::post` | `Player::saveData` |
| `<SaveLeaderboardDataUrl>` | POST via `Http::post` | `Player::saveLeaderboardData` |
| `CharacterAppearance` url (typically `Asset/CharacterFetch.ashx?userId=N`; validated against `asset/characterfetch.ashx` and `asset/avataraccoutrements.ashx` when `DFFlag::ValidateCharacterAppearanceUrl`) | GET sync or async via `RBX::Http::get`; response is a `;`-separated asset list, each refetched with `&serverplaceid=<placeId>` appended | `loadCharacterAppearance` (blocking + async), `loadStarterGear`, helpers `doMakeAccoutrementRequests`/`doMakeStarterGearRequests` |
| `user/request-friendship?recipientUserId=<id>` | POST text/plain via `HttpRbxApiService::postAsync` | `Player::requestFriendship` (+ replicates `RemoteFriendServiceSignal(true,id)`) |
| `user/decline-friend-request?requesterUserId=<id>` | POST via `HttpRbxApiService::postAsync` | `Player::revokeFriendship` |
| `GetPlayerGameDataUrl(GetBaseURL(), userId)` (game-data JSON containing `"ChatFilter"`) | GET via `Http::get` on background thread `"rbx_getPlayerMetaData"`, exponential backoff up to 2^9 s | `Player::loadChatInfo` → static `loadChatInfoInternal` (sets whitelist/blacklist chat filter under DataModel write lock) |

Social/group queries delegate to `SocialService` (`IsFriendsWith/IsInGroup/GetGroupRank/GetGroupRole` — the `.ashx` URLs installed by GameConfigurer) and FriendService (`GetFriendsOnline`).

### Key methods

```cpp
void Player::loadCharacter(bool inGame, std::string preferedSpawnName);  // backend only
SpawnData Player::calculateSpawnLocation(const std::string& preferedSpawnName);
void Player::calculateNextSpawnLocation(const ServiceProvider*);
void Player::setCharacter(ModelInstance*);          // fires characterRemoving/Added signals, rebuilds backpack/gui
void Player::loadCharacterAppearance(bool blockingCall);
void Player::kick(std::string msg);                 // reflection Kick (Security::None!)
void Player::removeCharacter();                     // backend only
bool Player::isFriendsWith/isBestFriendsWith/isInGroup(...); getRankInGroup/getRoleInGroup/getFriendsOnline;
void Player::updateSimulationRadius(float); setMaxSimulationRadius(float);
static bool Player::physicsOutBandwidthExceeded(context); // delegates Client
```

Reflection highlights: `Character` (ref prop used by replication), `UserId`(deprecated `userId`), `CharacterAppearance`, `RespawnLocation`, `SuperSafeChatReplicate`/`OsPlatform`/`MembershipTypeReplicate`/`AccountAgeReplicate` (REPLICATE_ONLY), `SimulationRadius`/`MaximumSimulationRadius`, camera/dev-mode props, remote events `SetShutdownMessage`, `Kill`, `ScriptSecurityError`, `RemoteInsert`, `StatsAvailable`, `ConnectDiedSignalBackend`, `SimulationRadiusChanged`, `OnTeleport(Internal)`, `CloudEditSelectionChanged`, `CharacterAppearanceLoaded`.

## Usage

- Join flow tail: ServerReplicator::installRemotePlayer parents the Player then calls `loadCharacter(true, initialSpawnName)`; `loadCharacter` clones StarterCharacter or loads `fonts/character3.rbxm` (R15 variant), injects humanoid sound/health-regen/animate scripts (unless overridden by StarterCharacterScripts), builds joints, `setCharacter`, parents into Workspace (scripts start), spawns at calculated SpawnLocation with forcefield.
- Death/respawn: server-side Humanoid `diedSignal` (or replicated `ConnectDiedSignalBackend`) → `onCharacterDied` → recalculate spawn + delayed `loadCharacter` after 5 s when CharacterAutoLoads.
- Kick: sends `SetShutdownMessage` targeted at that client's SystemAddress, destroys character, then `Players::disconnectPlayer(userId, LuaKick)` after 1 s if a message was sent.
- Guests: negative userId ⇒ forced SuperSafeChat/menu-only chat, skipped persistence.

## Gotchas

- Constructor, `setName`, and `setUserId` all require `Security::WritePlayer` ("REMOVE_PLAYER_PROTECTIONS" compile-out exists but is disabled).
- `Kick` is exposed at Security::None — any script can call it; message passes an optional profanity filter (`DFFlag::FilterKickMessage`).
- `getSuperSafeChat` ignores its stored flag when `Players::nonSuperSafeChatForAllPlayersEnabled` or returns true for userId<0 regardless of stored value.
- Appearance loading treats any content id containing `"equipped=1"` as website-equipped gear (cloned onto the character for thumbnailing).
- `loadChatInfoInternal` retries forever with capped exponential backoff until a valid ChatFilter value arrives — a stuck web tier means a permanently spinning thread per player.
- UNKNOWN: `GetPlayerGameDataUrl` format (RobloxServicesTools.h); `PersonalServerService::getRank/setRank` endpoint shapes.
