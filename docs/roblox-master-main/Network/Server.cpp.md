# Network/Server.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 732 lines)

## Purpose

Implements the game server peer: `start(port)` binds RakNet (all IPv4 interfaces in Studio builds), accepts `ID_NEW_INCOMING_CONNECTION` and creates a `ServerReplicator` per client through the `Server::createReplicator` factory (replaced by the secure `CheatHandlingServerReplicator` under `RBX_RCC_SECURITY` — see API.cpp), verifies incoming tickets/security keys/protocol versions (verification logic lives in ServerReplicator; this file supplies `securityKeyMatches`/`protocolVersionMatches` and ticket sets), maintains the legal-script registry compiled to both current and legacy LuaVM bytecode, Cloud-Edit mode, periodic analytics reporting, and lifecycle wiring of packet caches + `NetworkOwnerJob`.

## API

Reflection: `Start`, `Stop`, `GetClientCount`, `Port`, `SetIsPlayerAuthenticationRequired`, `ConfigureAsCloudEditServer`, events `DataBasicFiltered`, `DataCustomFiltered`, `IncommingConnection(peer, replicator)`.

```cpp
static const int maxClients = 128;
void Server::start(int port, int threadSleepTime);
void Server::stop(int blockDuration = 1000);
void Server::configureAsCloudEditServer();   // initWithCloudEditSecurity + SetIncomingPassword(versionB)
void Server::onCreateRakPeer();              // SetMaximumIncomingConnections(128); SetIncomingPassword(Network::versionB)
bool Server::securityKeyMatches(const std::string& key);      // true when allowedSecurityVersions empty
bool Server::protocolVersionMatches(int protocolVer);          // NETWORK_PROTOCOL_VERSION_MIN..NETWORK_PROTOCOL_VERSION
int  Server::getClientCount();
static std::vector<std::string> Server::getAllIPv4Addresses(); // WinSock gethostbyname / getifaddrs (+ "127.0.0.1" on Windows)
bool Server::isScriptLegal(Instance*) const;                   // source must be pre-registered
void Server::registerLegalScript(const std::string& source);   // compiles via LuaVM::compile + compileLegacy
boost::optional<int> Server::getPlaceAuthenticationResultForOrigin(int originPlaceId);
void Server::registerPlaceAuthenticationResult(int, int);
```

### Telemetry (no first-party game HTTP; GA/EphemeralCounter only)

| Report | Cadence | Symbol |
|---|---|---|
| `GA_CATEGORY_GAME/"ServerStartTime"` user timing | once after start | `Server::start` |
| EphemeralStats `ServerBytesSentPerSec[PerPlayer]`, `ServerData…`, `ServerPhysics…`, `ServerPacketLossPercent_<os>` | every 10 min (first at 5 min), players >5 min connected only | static `reportServerStats` |
| GA `"PlaceID"`, `"NetworkStreamingEnabled"`, `"SmoothTerrain"/"LegacyTerrain"` | provider attach / workspace loaded | `onServiceProvider`, `onWorkspaceLoaded` |
| GA `"CloudEdit"/"Server Start"` + `"5 Minute Usage"` | on configure / every 5 min | `reportCloudEditGA`, `reportCloudEditStats` |

## Usage

- Join flow server side: `onServiceProvider` creates `Players` (`setConnection(rakPeer)`), physics/instance/cluster packet caches, and the `NetworkOwnerJob` when distributed physics is enabled; throws if a `Client` is present (server+client mutually exclusive unless `DFFlag::CloudEditCheckClientPresent` gates). On `ID_NEW_INCOMING_CONNECTION` it creates + parents the replicator and fires `incommingConnectionSignal`; the actual ticket validation then happens in `CheatHandlingServerReplicator::processTicket` → `preauthenticatePlayer`/`installRemotePlayer` (uses `usedTickets`/`preusedTickets`, `securityKeyMatches`, `protocolVersionMatches`).
- Script legality: every descendant Script/ModuleScript source is registered at workspace load and on `descendantAddedSignal`; `isLegalReceiveInstance` rejects any replicated script whose source isn't registered (client can't inject new script sources).
- Cloud Edit: `configureAsCloudEditServer` re-inits security with the special versionB and swaps the incoming password.

## Gotchas

- Incoming RakNet password = obfuscated `Network::versionB`; `FFlag::DebugLocalRccServerConnection` forces it to `"test"` (and makes `securityKeyMatches` always true).
- `securityKeyMatches` returns **true when `allowedSecurityVersions` is empty** — an unconfigured server accepts any key.
- Studio `start()` binds every local IPv4 address (and Windows list appends `127.0.0.1`) so same-machine clients can connect.
- `stop()` removes children **before** shutting down RakNet because Replicators hold packets from RakNet's pool (explicit comment).
- `reportServerStats` self-reschedules forever via TimerService; only counts connections older than 5 minutes and divides by numPlayers without zero-guard when totals are nonzero (safe in practice because totalKBytesSendPerSec>0 implies players).
- UNKNOWN: where `usedTickets`/`preusedTickets` are populated/consumed (in ServerReplicator.cpp); values of `NETWORK_PROTOCOL_VERSION(_MIN)`.
