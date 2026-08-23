# Network/GameConfigurer.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 1024 lines)

## Purpose

Implements the two client-side game configuration entry points: `GameConfigurer::parseArgs/setupUrls/registerPlay` plus the full `PlayerConfigurer` (normal game-client join: argument parsing, service wiring, join telemetry, connection lifecycle) and `StudioConfigurer` (Studio/play-solo core-script bootstrapping and core-module loading). This is where launch-argument JSON (`PlaceId`, `UserId`, `ClientTicket`, …) becomes a configured, connecting DataModel.

## API

### .ashx / HTTP endpoints referenced

| Endpoint | Method | Calling symbol |
|---|---|---|
| `Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d` (`FString::SocialServiceFriendUrl`) | GET by SocialService consumers | URL installed in `GameConfigurer::setupUrls` (line ~127) |
| `...HandleSocialRequest.ashx?method=IsBestFriendsWith...` (`FString::SocialServiceBestFriendUrl`) | GET | same |
| `...HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d` (`FString::SocialServiceGroupUrl`) | GET | same |
| `...HandleSocialRequest.ashx?method=GetGroupRank...` (`FString::SocialServiceGroupRankUrl`) | GET | same |
| `...HandleSocialRequest.ashx?method=GetGroupRole...` (`FString::SocialServiceGroupRoleUrl`) | GET | same |
| `Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d` (`FString::GamePassServicePlayerHasPassUrl`) | GET by GamePassService | installed in `setupUrls` (line ~132) |
| `<BaseUrl>Game/JoinRate.ashx?st=<VendorId>&i=<UserId>&p=<PlaceId>&c=<category>&r=<result>&d=<msec>&b=<bytes>&platform=<os>` (`FString::MobileJoinRateFormatUrl`) | GET via `Http::get` | `PlayerConfigurer::reportDuration` (lines 297–328) — **iOS/Android builds only** |
| `<baseUrl>users/get-experiment-enrollments` and `<baseUrl>users/get-studio-experiment-enrollments` | async fetch via `FetchABTestDataAsync` → `LoadABTestFromString` | `PlayerConfigurer::configure` (lines 592–600, 726–743) |
| `<PingUrl>&disconnect=true` | GET via `HttpAsync::get` (Durango) or `dataModel->httpGet(url,true)` | `PlayerConfigurer::onDisconnection` (line ~469–474); base `PingUrl` handed to `Visit::setPing(PingUrl, PingInterval)` in `onConnectionAccepted` |

All `.ashx` formats are prefixed either with `BuildGenericGameUrl(baseUrl, ...)` when `FFlag::UseBuildGenericGameUrl` or plain `baseUrl + format`.

### Key methods

```cpp
// GameConfigurer
void GameConfigurer::parseArgs(const std::string& args);      // WebParser::parseJSONTable into parameters
int/std::string/bool GameConfigurer::getParam{Int,String,Bool}(key);
void GameConfigurer::registerPlay(const std::string& key, int userId, int placeId); // CookiesService first-play marker
void GameConfigurer::setupUrls();                              // installs the .ashx URLs above

// PlayerConfigurer
void PlayerConfigurer::configure(RBX::Security::Identities identity, DataModel* dm,
                                 const std::string& args, int lm, const char* vrDevice);
void PlayerConfigurer::requestCharacter(shared_ptr<Network::Replicator>, shared_ptr<bool> isWaiting);
void PlayerConfigurer::showErrorWindow(message, errorType, errorCategory);
void PlayerConfigurer::reportDuration(category, result, double duration, bool blocking);
void PlayerConfigurer::onConnectionAccepted(std::string url, shared_ptr<Instance> replicator);
void PlayerConfigurer::onDisconnection(const std::string& peer, bool lostConnection);
void PlayerConfigurer::onPlayerChanged(const Reflection::PropertyDescriptor*);

// StudioConfigurer
bool StudioConfigurer::findModulesAndLoad(baseModulePath, dir_path, coreModules);
void StudioConfigurer::loadCoreModules();
void StudioConfigurer::configure(identity, dm, args, launchMode, vrDevice);
```

## Usage — client join flow driven from `configure()`

1. Snapshot `startTime`; if `FFlag::ClientABTestingEnabled`, kick off both A/B enrollment fetches immediately.
2. Parse JSON args; set `Http::gameID = GameId`, `Analytics::setUserId(UserId)`, `TeleportService::SetBrowserTrackerId(BrowserTrackerId)`; report `GameJoinStart` counters.
3. `testing = (ClientTicket empty)` — non-ticket joins are "testing"/Studio mode (no Visit upload URL, no GamePerfMonitor).
4. Create services: `InsertService`, `ContentProvider` (16-thread pool), `ChangeHistoryService` disabled, `HttpService`, `UserInputService`, `Players` (+ChatStyle), `Client`, `Visit`.
5. Wire `Client::connectionAcceptedSignal/connectionRejectedSignal/connectionFailedSignal`; then **ticket flow**: `client->setTicket(getParamString("ClientTicket"))`, `client->setGameSessionID(SessionId)`, and `client->playerConnect(UserId, MachineAddress, ServerPort, ClientPort, -1)` returns the local `Player`. Sets SuperSafeChat, Under13, MembershipType enum, AccountAge, name (`UserName`), `CharacterAppearance`, `FollowUserId`; connects `idledSignal` (>1200 s ⇒ idle-kick error window).
6. On accept: connect to the returned `ClientReplicator`'s `disconnectionSignal`, `receivedGlobalsSignal`, `gameLoadedSignal`; install Visit ping.
7. Character resolution: `gameLoadedSignal`→`onGameLoaded` or `requestCharacter()` (`Replicator::requestCharacter`); when the local `Player`'s `"Character"` property changes, `onPlayerChanged` reports `GameJoin Success`, InfluxDB `ClientJoin` points, and schedules `GamePerfMonitor::setPostDiagStats` after 2 min.
8. Failure paths funnel through `showErrorWindow` (GA events `JoinFailurePlace/IP/Vendor/DataCenter`, `EphemeralCounter JoinFailure-*`, GuiService error message) and `reportError` (client disconnect + 4 s delayed error window).
9. `registerPlay` writes `{userId, placeId, os}` cookies for first-time and 5-minute play marks (only if `CookieStoreEnabled`).
10. `StudioConfigurer::configure`: setupUrls, skip everything for CloudEdit; `loadCoreModules()` (filesystem scan of `adminScriptsPath+"/Modules"` or `assetFolder()/scripts/Modules`, fetching each source via `CoreScript::fetchSource("/Modules/<path>")`, or bytecode modules via `LuaVM::getBytecodeCoreModules()` rot13-decoded) building a RobloxLocked `Folder` tree of `ModuleScript`s under CoreGui's RobloxScreenGui; then runs `ServerStarterScript` (backend) and/or `StarterScript` (frontend) as local core scripts. Xbox variants force `StarterScript`/`XStarterScript`.

## Gotchas

- The JoinRate.ashx GET is compiled only under `RBX_PLATFORM_IOS || __ANDROID__`; on desktop only EphemeralCounter/Influx stats go out ("need to keep this until JoinRate.ashx no longer needs to track iOS join success").
- `getParamInt/getParamBool` silently return 0/false for missing keys; `parameters` is NULL until `parseArgs` runs — calling any getter before that is UB.
- `logAnalytics = rand()%100==1` — 1% sampling flag, currently unused beyond assignment.
- `onDisconnection` treats any non-empty peer + clean close as "This game has shut down" (Kick path) and destroys the local Player's `PlayerScripts` child.
- `configure()` creates `Network::Client` twice depending on `DFFlag::UseR15Character` ordering quirk (created early when R15 enabled, later otherwise) — `dataModel->create<Network::Client>()` is idempotent per-service so this is safe but easy to misread.
- UNKNOWN: signature of `FetchABTestDataAsync`/`LoadABTestFromString`/`BuildGenericGameUrl` (defined outside this file, e.g. util headers); `GameConfigurer.h`/`PlayerConfigurer.h` headers are not in Network root, so member layout was inferred from usage.
