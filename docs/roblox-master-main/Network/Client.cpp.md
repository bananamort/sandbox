# Network/Client.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 455 lines)

## Purpose

Implements the client half of the join/ticket flow: `playerConnect` starts RakNet and issues `Connect(server, port, password=Network::versionB)`; on `ID_CONNECTION_REQUEST_ACCEPTED` it runs the auth sequence (`ID_PLACEID_VERIFICATION` → `ID_SUBMIT_TICKET` → `ID_SPAWN_NAME`) and creates the `ClientReplicator`; it translates failed/rejected connection packets into the three configurer-facing signals. Also hosts a StealthEdit (Cheat Engine) memory-permission checker thread.

## API

Reflection surface: function `PlayerConnect(userId, server, serverPort, clientPort=0, threadSleepTime=30)` (Plugin), `Disconnect(blockDuration=3000)` (LocalUser), `SetGameSessionID` (Roblox); property `Ticket` (Authentication); events `ConnectionAccepted(peer, replicator)`, `ConnectionRejected(peer)`, `ConnectionFailed(peer, code, reason)`.

```cpp
shared_ptr<Instance> Client::playerConnect(int userId, std::string server,
                                           int serverPort, int clientPort, int threadSleepTime);
void Client::disconnect(int blockDuration = 3000);
void Client::setGameSessionID(std::string value);   // sets Http::gameSessionID
void Client::configureAsCloudEditClient();
bool Client::isCloudEdit() const;
static Client* Client::findClient(const Instance* context, bool testInDatamodel=true);
static bool Client::clientIsPresent(...);
static const SystemAddress Client::findLocalSimulatorAddress(...);  // ClientReplicator's client address
static bool Client::physicsOutBandwidthExceeded(...); // delegates ClientReplicator::isLimitedByOutgoingBandwidthLimit
static double Client::getNetworkBufferHealth(...);    // rakPeer->GetBufferHealth()
```

### Join/ticket handshake packets (all on DATA_CHANNEL, DATAMODEL_RELIABILITY)

| Packet | Sender | Payload |
|---|---|---|
| `Connect(..., versionB as password)` | `playerConnect` | RakNet-level password = obfuscated protocol string |
| `ID_PROTOCOL_SYNC` | `sendVersionInfo` | `protocolVersion` int |
| `ID_PLACEID_VERIFICATION` | `HandleConnection` | `TeleportService::getPreviousPlaceId()` |
| `ID_SUBMIT_TICKET` | `sendTicket` | userId; compressed ticket; compressed `DataModel::hash`; protocolVersion; compressed `securityKey`; compressed osPlatform + product name; compressed `Http::gameSessionID`; uint gold hash (`Security::rbxGoldHash`); then `encryptDataPart(bitStream)` |
| `ID_SPAWN_NAME` | `sendPreferedSpawnName` | compressed `TeleportService::GetSpawnName()` |

## Usage — join flow order of operations

1. GameConfigurer: `client->setTicket(ClientTicket)`, `setGameSessionID(SessionId)`, then `playerConnect(UserId, MachineAddress, ServerPort, ClientPort, -1)`.
2. `playerConnect`: creates `Players`, `players->createLocalPlayer(userId, teleportedIn = previousPlaceId>0)`; binds socket on `clientPort` (0 ⇒ `NetworkSettings::preferredClientPort`); enforces LAN-only for non-Roblox-security callers unless target is localhost (`requirePermission(Roblox, "connect to an extranet game")`, skipped under `FFlag::DebugLocalRccServerConnection` which also forces `versionB="test"`); calls `rakPeer->Connect(server, serverPort, versionB, size)`.
3. Server accepts → `OnReceive(ID_CONNECTION_REQUEST_ACCEPTED)` stores `serverId`, runs `HandleConnection` (placeId packet → ticket packet → spawn-name packet → clear terrain → create+parent `ClientReplicator(packet->systemAddress, this, externalId, networkSettings)` → spawn hack-check threads on Windows player builds → fire `connectionAcceptedSignal(peer, proxy)`), then `sendVersionInfo`.
4. Failures: `ID_INVALID_PASSWORD`/`ID_HASH_MISMATCH` map to "out of date" messages; `ID_SECURITYKEY_MISMATCH` to "Version not compatible"; `ID_CONNECTION_ATTEMPT_FAILED` generic; rejected also fires `connectionRejectedSignal`.
5. Teardown: `disconnect` unlocks/removes all children (dropping the ClientReplicator), closes the connection to `serverId`, shuts the peer down after blockDuration; `onServiceProvider` auto-disconnects on provider close and nulls `Players::setConnection`.

## Gotchas

- The join **ticket never touches HTTP here** — it travels only inside the encrypted `ID_SUBMIT_TICKET` RakNet payload; HTTP-side session identity was already resolved by the launcher/web layer.
- `encryptDataPart`/`serializeStringCompressed` come from `Peer`/RakNet; the encryption covers the whole post-goldHash tail.
- LAN check compares only the low byte of binary addresses (`& 0x00FF`), i.e. same /24-ish class-C heuristic, looped over all internal IDs but with a broken early-exit pattern (`!lansubnet && i++` re-evaluates even when found).
- Under `DFFlag::DebugDisableTimeoutDisconnect` the client raises its timeout to 10 minutes for all addresses.
- `programMemoryPermissionsHackChecker` runs every 2 s forever (Windows non-studio builds), flagging `HATE_CATCH_EXECUTABLE_ACCESS_VIOLATION` if page permissions look hacked; guarded by VMProtect mutation regions ("24"/"25").
- UNKNOWN: values of `protocolVersion`, `NetworkSettings::preferredClientPort`, `DataModel::hash`, `Security::rbxGoldHash` (defined elsewhere); exact cipher used by `Peer::encryptDataPart`.
