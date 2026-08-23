# Network/Players.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 2329 lines)

## Purpose

Implements the `RBX::Network::Players` service (`sPlayers = "Players"`) — the DataModel service that owns all `Player` instances, plus its satellite classes defined here: `ChatMessage`, `AbuseReport`, `AbuseReporter`. It carries the server-side and client-side halves of chat (all/team/whisper/game), abuse reporting, block/unblock, friend events, character appearance fetch, golden-hash client verification ("gold hash" anti-cheat), Cloud-Edit kick/shutdown, local-player creation (`CreateLocalPlayer`), and distributed-physics region computation.

## API

### HTTP endpoints called

| Endpoint | Method | Calling symbol |
|---|---|---|
| `<baseUrl>users/get-by-username?username=<name>` (`FString::GetUserIdUrl`) | GET via `HttpRbxApiService::getAsync` | `Players::getUserIdFromName` (line ~232) |
| `<apiBaseUrl>users/<userId>` (`FString::GetUserNameUrl`) | GET via `HttpRbxApiService::getAsync` | `Players::getNameFromUserId` (line ~293) |
| `<apiBaseUrl>users/<userId>/friends` (`FString::GetFriendsUrl`) | paginated GET via `FriendPages` | `Players::getFriends` (line ~305) |
| `<baseUrl>Asset/CharacterFetch.ashx?userId=<id>` | GET via `RBX::Http::get` | `Players::getCharacterAppearance` (line 429) — **CharacterFetch** |
| `abuseReportUrl` (set by `SetAbuseReportUrl`) | POST (TextXml body `<report userID placeID gameJobID>`) via `Http::post` | `AbuseReporter::processRequests` (line ~810), worker thread `"rbx_abusereporter"` |
| `userblock/blockuser` / `userblock/unblockuser` (+`blockerId=&blockeeId=`) | POST urlencoded via `HttpRbxApiService::postAsync` | `Players::serverMakeBlockUserRequest` (line ~1613–1625) |
| `<sysStatsUrl>&UserID=<id>&Resolution=<stat>&Message=<msg>` | GET via `RBX::Http::get`, response ignored | `Players::onRemoteSysStats` (line ~2058–2137) |

Also appends `&serverplaceid=%d` to each accoutrement content id fetched in `doMakeAccoutrementRequests`.

### RakNet packets sent/received

- Sends `ID_CHAT_ALL`, `ID_CHAT_TEAM`, `ID_CHAT_PLAYER` (with sender+receiver GUID scope/index), `ID_CHAT_GAME`, `ID_REPORT_ABUSE` on `CHAT_CHANNEL` via `ConcurrentRakPeer::Send` (`chat`, `teamChat`, `whisperChat`, `gamechat`, `reportAbuse`).
- `Players::OnReceiveChat(sourceValidation, peer, packet, chatType)` parses those packets, validates source GUID against the connected `Player` (anti-spoof: returns `PLAYERS_STOP_PROCESSING_AND_DEALLOCATE` on mismatch), enforces whisper destination validity under `DFFlag::FilterInvalidWhisper`, then either adds locally (`addChatMessage`) or, on the server, forwards unfiltered when `chatFilterUrl == ""` else routes through `WebChatFilter::filterMessage` with callback into `sendFilteredChatMessageSignalHelper`.
- `Players::OnReceiveReportAbuse` decodes `ID_REPORT_ABUSE`, wraps comment as `"AbuserID:<id>;<comment>"`, queues into `AbuseReporter`.

### Reflection surface (selection)

Properties: `NumPlayers`/deprecated `numPlayers`, `MaxPlayers`(+`MaxPlayersInternal`, LocalUser-writable), `PreferredPlayers`(+internal), `LocalPlayer`/deprecated `localPlayer`, `CharacterAutoLoads` (STANDARD_NO_REPLICATE), `ClassicChat`, `BubbleChat`.
Functions: `GetPlayerById`(deprecated `GetPlayerByID`), `GetPlayerByUserId`, `Chat`, `TeamChat`, `WhisperChat`, `ReportAbuse`, `GetPlayers`(deprecated `players`/`getPlayers`), `CreateLocalPlayer(userId, isTeleport)` (Plugin), `SetAbuseReportUrl/SetChatFilterUrl/SetBuildUserPermissionsUrl` (Roblox security), `GetPlayerFromCharacter`(deprecated variants), `SetSysStatsUrl`, `SetSysStatsUrlId`, `SetLoadDataUrl/SetSaveDataUrl/SetSaveLeaderboardDataUrl/AddLeaderboardKey`, `SetChatStyle`, `GetUseCoreScriptHealthBar`, yielders `BlockUser/UnblockUser`, `GetUserIdFromNameAsync/GetNameFromUserIdAsync/GetFriendsAsync/GetCharacterAppearanceAsync`.
Events: `PlayerChatted`, `GameAnnounce` (RobloxScript), `FriendRequestEvent`, `PlayerAddedEarly`, `PlayerAdded`, `PlayerRemoving`, `PlayerRemovingLate`; remote events `BlockedRequestFinishedSignal` (server→client broadcast), `BlockUserSignal` (client→server), `RequestCloudEditKick(playerId)`, `RequestCloudEditShutdown()`.

### Static helpers

```cpp
bool Players::isNetworkClient(Instance* instance);
bool Players::clientIsPresent(const Instance* context, bool testInDatamodel);   // delegates Client::
bool Players::serverIsPresent(const Instance* context, bool testInDatamodel);   // delegates Server::
bool Players::frontendProcessing(const Instance* context, bool testInDatamodel=false);
bool Players::backendProcessing(const Instance* context, bool testInDatamodel=false);
int  Players::getPlayerCount(const Instance* context);
SystemAddress Players::findLocalSimulatorAddress(const Instance* context);
shared_ptr<Player> Players::findAncestorPlayer(const Instance* descendent);
shared_ptr<Player> Players::findPlayerWithAddress(const SystemAddress&, const Instance* context);
ModelInstance* Players::findLocalCharacter(Instance* context);
void Players::buildClientRegion(Region2& clientRegion);
unsigned int Players::checkGoldMemHashes(const std::vector<unsigned int>& hashes);
```

## Usage

- Join flow tail-end: `ServerReplicator` creates the replicated `Player`, the server's `onChildAdded` assigns teams (`Teams::assignNewPlayerToTeam`), creates PlayerGui, wires `killPlayerSignal`/`statsSignal`→`onRemoteSysStats`/`remoteFriendServiceSignal`, boots duplicate-userId joiners (`otherPlayer->setParent(NULL)`), and fires `playerAddedEarlySignal`/`playerAddedSignal` (also on clients when `DFFlag::FirePlayerAddedAndPlayerRemovingOnClient`). Test-mode players (userId==0, name "Player") get unique names and **negative** userIds.
- `createLocalPlayer` is used by Studio/Visit/play-solo (guarded against duplicates, sets `RbxDbgInfo::s_instance.PlayerID`); `resetLocalPlayer` destroys it.
- Kick path: `disconnectPlayer(int userId, int reason)` walks the `Server`'s children for the `Replicator` whose `findTargetPlayer()->getUserID()==userId` and calls `Replicator::requestDisconnect`; Lua kicks are GA-tracked ("ServerLuaKick"/"LocalLuaKick"). CloudEdit kick/shutdown arrive as replicated remote events handled in `processRemoteEvent` (shutdown submits `callServerStop`).
- Security: server compares client-reported hashes against `goldenHash/goldenHash2/goldenHash3` + `goldenHashes` set (`hashMatches`) and memory-hash configs (`checkGoldMemHashes`); repeat offenders are disconnected with `DisconnectReason_OnRemoteSysStats`. Kicking only happens if `canKickBecauseRunningInRealGameServer` was armed by `setGoldenHashes*`. An obfuscated literal builds `"io,io"` and auto-passes iOS clients.
- Chat visibility rules live in `ChatMessage::isVisibleToPlayer` (ALL/GAME→everyone, TEAM→same team & both non-neutral, WHISPER→source/destination only).

## Gotchas

- `getCharacterAppearance` is gated behind `DFFlag::GetCharacterAppearanceEnabled` (default false) and rejects `userId<=0`; response is a `;`-separated asset-id list, each refetched through ContentProvider with the place-id appended.
- Everyone **receives** all chat packets; team/whisper visibility is filtered at display time (`isVisibleToPlayer`), so the network carries more chat than is shown.
- When `chatFilterUrl` is empty the server blindly rebroadcasts raw packets (`peer->Send(...packet->systemAddress..., true)`) without any filtering.
- `onChildRemoving` locks removed Players' parents (`lockParent` in `onDescendantRemoving`) so an exploit can't re-parent a leaving player back in.
- `getPlayerByID` uses `shared_polymorphic_downcast` — every child of `Players` must be a `Player` (enforced by `askAddChild`); non-player children would be UB.
- `hashMatches` returns **true when the golden-hash set is empty** (`goldenHashes.size() <= 0`), i.e. an unconfigured server accepts any hash.
- UNKNOWN: exact production values of `sysStatsUrl`/`loadDataUrl`/`saveDataUrl`/`saveLeaderboardDataUrl`/`buildUserPermissionsUrl` — supplied at runtime via reflection setters; `Players.h` is not in this directory (header lives outside Network root), so member declarations were inferred from usage.
