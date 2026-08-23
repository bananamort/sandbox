# Network/Replicator.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 5068 lines)

## Purpose

Implements the replication engine declared in `Replicator.h`: wire-format (de)serialization for every reflected property/event type, instance create/delete/parent-change items, gzip-compressed join data, terrain/voxel cluster delta streaming (`ID_CLUSTER`), descriptor-dictionary teaching (`ID_TEACH_DESCRIPTOR_DICTIONARIES`), data pings with stats piggybacking, marker round-trips, the packet receive pipeline (`OnReceive` → `pushIncomingPacket` → optional `deserializePacketsThread` → `ProcessPacketsJob` → `processDeserializedPacket`), send jobs (`SendDataJob`, `SendClusterJob`) with scheduler error metrics, chat-filter rebroadcast, disconnect handling with GA reason tracking, and clock-offset conversion between RakNet and RBX time.

## API

### RakNet packets handled / sent (DATA_CHANNEL unless noted)

| Packet | Direction | Handling symbol |
|---|---|---|
| `ID_DATA` (item stream) | both | `processPacket` → `receiveData`/`deserializeData`; items dispatched by `readItem`/`deserializeItem` (`ItemTypeNew/Delete/ChangeProperty/Marker/Ping/PingBack/EventInvocation/JoinData`) |
| `ID_CLUSTER` (terrain) | both | `processPacket` → `receiveCluster`; sent by `sendClusterPacket`/`sendClusterChunk` |
| `ID_TIMESTAMP`+`ID_PHYSICS` | both | physicsReceiver->receivePacket (exceptions wrapped as `physics_receiver_exception`) |
| `ID_PHYSICS_TOUCHES` | both | physicsReceiver->readTouches / deserializeTouches |
| `ID_TEACH_DESCRIPTOR_DICTIONARIES` | both | `learnDictionaries` (recv) / `sendDictionaries`+static `teachDictionaries` (send); schema only server→client when `protocolSyncEnabled` |
| `ID_SCHEMA_SYNC`, `ID_SET_GLOBALS` | recv | queued via `pushIncomingPacket` (processed by ClientReplicator overrides) |
| `ID_REQUEST_MARKER` | both | reply queues `MarkerItem`; initiator side `sendMarker()` pushes `incomingMarkers` and waits for `processMarker(id)` → `Marker::fireReturned` |
| `ID_CHAT_GAME/TEAM/ALL/PLAYER`, `ID_REPORT_ABUSE` | recv | delegated to `Players::OnReceiveChat` / `Players::OnReceiveReportAbuse` |
| `ID_CONNECTION_LOST` / `ID_DISCONNECTION_NOTIFICATION` | recv | fire `disconnectionSignal(peer, lost)` then submit `scheduledRemove` task (teleport suppresses the signal) |

Item wire format (`writeChangedProperty`): `[ItemTypeChangeProperty][instance GUID id][propDictionary id][value]`. New instances: `[id][classDictionary id][non-cacheable props][cacheable props][parentId][deleteOnDisconnect]`. JoinData: count + gzip stream of `readInstanceNew(..., isJoinData=true)` records without dictionary ids.

### Key methods

```cpp
bool Replicator::sendItemsPacket();              // flushes highPriorityPendingItems + pendingItems into ItemSender packets
bool Replicator::sendClusterPacket();            // initial smooth/legacy terrain + update deltas, MTU-bounded
void Replicator::sendClusterChunk(const StreamRegion::Id&);  // streaming path
unsigned int Replicator::readJoinData(BitStream&);           // returns instance count
void Replicator::requestDisconnect(DisconnectReason);        // GA "Server/ClientDisconnectReason" + scheduledRemove
void Replicator::requestDisconnectWithSignal(DisconnectReason);
shared_ptr<Instance> Replicator::sendMarker();
bool Replicator::processNextIncomingPacket();    // pops one packet, catches stream errors → disconnect
void Replicator::sendDataPing();                 // PingItem; HashTimeOut after >120 s w/o hashes (RCC), TimeOut w/o pings
void Replicator::sendStats(int version);         // StatsItem
FilterResult Replicator::filterChangedProperty(Instance*, const PropertyDescriptor&);
void Replicator::onPropertyChanged(...);         // character-owned props pushed to FRONT of pendingItems
static void Replicator::compressBitStream/decompressBitStream(...); // boost iostreams gzip
std::string/double Replicator::getMetric(Value)(...) const; // "Network Send/Receive", "Total Bytes Received"
```

### Analytics (no first-party game HTTP)

- GA `"NetworkPacketSplitCountOverThreshold"` in `OnInternalPacket` (splitPacketCount > `DFInt::RakNetMaxSplitPacketCount`).
- InfluxDB `"PacketError"` points in `logPacketError` (rate `DFInt::PacketErrorInfluxHundredthsPercentage`).
- GA `"ServerDisconnectReason"/"ClientDisconnectReason"` per kick in `requestDisconnect`; `DisconnectReason_HashTimeOut` is deliberately reported as `"MagicDisco"`.

## Usage

- DataModel replication entry point chain: local mutation → `Instance::combinedSignal` → `Replicator::onCombinedSignal` (EVENT_INVOCATION/PROPERTY_CHANGED/CHILD_ADDED/CHILD_REMOVED) → filter → item pushed onto `pendingItems` → `SendDataJob::dataOutStep`. Terrain mutations arrive through `terrainCellChanged`/`onTerrainRegionChanged` into `clusterReplicationData` → `SendClusterJob`.
- Receive chain ends at typed handlers: `readInstanceNewItem` (create + `assignParent` + `resolvePendingReferences`), `deleteInstanceById`, `readChangedProperty(Item)` (with anti-bounce-back via `deserializingProperty`), `readEventInvocationItem` (`instance->processRemoteEvent(descriptor, args, source)` — this is the remote-event entry every service's `processRemoteEvent` sees), `processDataPing`.
- `addTopReplicationContainers` defines exactly which services replicate on join and in what order (ReplicatedFirst first, then Lighting, SoundService, StarterPack/StarterGui/StarterPlayer, CSGDictionaryService, Workspace, JointsService, Players, Teams, InsertService, ChatService, FriendService, MarketplaceService, BadgeService, ReplicatedStorage, RobloxReplicatedStorage, TestService, LogService, PointsService, AdService; CloudEdit adds ServerScriptService/ServerStorage/NonReplicatedCSGDictionaryService/HttpService). Each container's instances are funneled into the single `JoinDataItem`.
- Protocol gating: `canUseProtocolVersion(N)` (implemented in subclasses against `NETWORK_PROTOCOL_VERSION(_MIN)` = 24..34); e.g. ReplicatedFirst replication needs ≥25, AdService ≥26, ProtectedString-as-BinaryString ≥28, extra ping stats word ≥34.

## Gotchas

- Dictionary ids are connection-scoped and order-sensitive: `propDictionary.receive(..., true)` throws on outdated ids unless a `ProcessOutdated*` hook absorbs it (only ServerReplicator implements those for old clients).
- Anti-tamper: failed ProtectedString decode schedules `RemoteCheatHelper2` ("rocky" stat report); Windows player builds run `detectDllByExceptionChainStack` on every property change under `FFlag::FilterSinglePass` and smuggle the call-check result out inside a PingItem's scorn flags.
- Cluster debouncing is asymmetric by design: client skips echoing its own pending chunks; server never debounces incoming client edits (extensive comments about ships-in-the-night desync).
- `getDefault(className)` fabricates default instances via `RBX::ReplicationCreator` purely to diff properties for 1-bit "isDefault" encoding — bools always serialize raw.
- `onPropertyChanged` front-pushes changes belonging to the target Player's own character (priority), preserving queue head timestamps.
- `remoteDeleteOnDisconnect`: Players subtree, local character, and TouchTransmitter are auto-deleted when their owning replicator dies.
- UNKNOWN: exact bit layouts inside `Voxel::Serializer`/`voxel2::BitSerializer`; values of `kNoScornFlags`/scorn flag semantics (defined elsewhere); `ID_SET_GLOBALS` payload processing lives in ClientReplicator.
