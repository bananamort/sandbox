# Network Module — Documentation Index

Per-file documentation for every root-level `*.cpp`/`*.h` in `roblox-sandbox/Network/` (119 source files; vendored subtrees such as `raknet/` are out of scope). Each `<file>.md` documents Purpose, API (real signatures), Usage (real symbols), and Gotchas, verified against the source in this tree.

## Module overview

The Network module implements Roblox's client/server replication stack on top of a vendored RakNet 3.x.

**Replication.** Every connection is represented by a `Replicator` (`Replicator.h/.cpp`) — an Instance + RakNet plugin that owns reflection dictionaries (`DescriptorDictionary`s over class/property/event/type descriptors, taught once via `ID_TEACH_DESCRIPTOR_DICTIONARIES`, schema via gzip `ID_SCHEMA_SYNC`), guid-based id serialization (`IdSerializer` in `Streaming.cpp`), and typed wire items: join data (`Replicator.JoinDataItem.*`, gzip batch of dictionary-less instance records), live create/delete (`NewInstanceItem`, `DeleteInstanceItem`), property changes (`ChangePropertyItem`, `ReferencePropertyChangedItem`), remote events (`EventInvocationItem` → `Instance::processRemoteEvent`), pings carrying anti-cheat bitfields (`PingItem`/`PingBackItem`/`PingJob`), completion barriers (`TagItem` 12/13, `MarkerItem`), server stats (`StatsItem`), and security telemetry (`HashItem`, `RockyItem`). Terrain streams as voxel deltas (`ID_CLUSTER`, `ClusterUpdateBuffer`, smooth+legacy paths). Outbound flow: combined-signal filters → pooled items on `pendingItems` → `SendDataJob`/`SendClusterJob`; inbound: `OnReceive` → optional `deserializePacketsThread` → `ProcessPacketsJob` under DataModel write lock. Protocol versions 24 (min, Release 0.157) through 34; legacy-client tolerance via `ClientReplicator`'s learned-schema skip machinery and `ServerReplicator::ProcessOutdated*` hooks. PropSync (`PropertySynchronization.h`) resolves concurrent-edit conflicts with master/slave versioned acknowledgements.

**Join flow.** Client: `GameConfigurer::configure` parses launch JSON, installs `.ashx` service URLs, then `Client::playerConnect` starts RakNet with the obfuscated `versionB` password; on accept, `HandleConnection` sends place-id verification, the AES-encrypted `ID_SUBMIT_TICKET` (userId + ticket + DataModel hash + protocolVersion + securityKey + platform/product + session + gold hash), spawn name, and creates the `ClientReplicator`. Server: `Server::start` listens; `ID_NEW_INCOMING_CONNECTION` spawns a `ServerReplicator` (RCC builds: `CheatHandlingServerReplicator`) which teaches dictionaries/schema and, after validating the ticket signature (`Crypt::verifySignatureBase64` over userId/name/appearance/jobId/timestamp) plus security key, hash, and protocol, runs web place authentication (`GET universes/validate-place-join?originPlaceId&destinationPlaceId`), sends `ID_SET_GLOBALS` (distributed physics, streaming, filtering, CharacterAutoLoad, scope, XOR-obfuscated script keys, top-container GUIDs), installs the remote Player (`loadCharacter` from character3.rbxm/StarterPlayer), and answers the character request. Duplicate tickets/userIds, hash mismatch, or protocol mismatch each map to a distinct `DisconnectReason`.

**GameConfigurer.** `GameConfigurer.cpp` hosts argument parsing and URL wiring: five `Game/LuaWebService/HandleSocialRequest.ashx` methods (friends/best-friends/group/rank/role), `Game/GamePass/GamePassHandler.ashx`, mobile-only `Game/JoinRate.ashx` telemetry, A/B enrollment fetches, Visit ping/disconnect URLs, Selenium cookie markers, join analytics (GA + InfluxDB `ClientJoin`), and Studio core-module loading/bootstrapping.

**Players networking.** `Players.cpp` owns the Player container: chat pipeline (all/team/whisper/game RakNet packets, GUID anti-spoofing, WebChatFilter moderation round-trip), abuse reporting (`Http(abuseUrl).post` XML), block/unblock (`userblock/blockuser|unblockuser` API POSTs), identity lookups (`users/get-by-username`, `users/<id>`, friends pagination), character appearance fetch (`Asset/CharacterFetch.ashx?userId=` — also consumed by `Player::loadCharacterAppearance`/`loadStarterGear`), golden-hash client verification with kick decisions (`hashMatches`, `checkGoldMemHashes`, `onRemoteSysStats` → `disconnectPlayer`), CloudEdit kick/shutdown remote events, and player lifecycle signals (`playerAdded*`/`playerRemoving*`). `Player.cpp` carries per-user replicated state, persistence HTTP (`LoadData/SaveData/SaveLeaderboardData` URLs), friendship POSTs (`user/request-friendship`, `user/decline-friend-request`), chat-filter metadata fetch, kick, idle detection, simulation radius, and teleport plumbing.

**Physics.** `PhysicsSender.cpp` frames all physics traffic; four selection policies (`ErrorCompPhysicsSender*`, `RoundRobinPhysicsSender`, default `TopNErrorsPhysicsSender`) choose what to send, with lossy `CustomSerializer` float/vector/quat compression and movement-history deltas; receivers (`DirectPhysicsReceiver`, `InterpolatingPhysicsReceiver`) and distributed-physics ownership arbitration live in `NetworkOwnerJob` + `ServerReplicator::checkDistributedSend*`. Touches travel reliably; state is UNRELIABLE on PHYSICS_CHANNEL.

**Transport & infra.** `Peer` wraps a profiled `ConcurrentRakPeer` (send/stats jobs, buffer health); ` rijndael.cpp`/`Rijndael*.h` provide the AES used by `DataBlockEncryptor` for handshake payloads; `NetworkSettings` exposes every tunable; caches (`NetworkPacketCache.cpp`, `NetworkClusterPacketCache.cpp`), streaming GC (`Replicator.GCJob.*`, `StreamJob`), diagnostics (`NetworkProfiler`, `CrashReporter`, `GamePerfMonitor`), and the NetPmc networked memory-check round out the module.

## File roster

### Core replication
- [API.cpp](API.cpp.md) — module registration, security bootstrap, versionB/securityKey
- [Replicator.h](Replicator.h.md) / [Replicator.cpp](Replicator.cpp.md) — replication engine base
- [ClientReplicator.h](ClientReplicator.h.md) / [ClientReplicator.cpp](ClientReplicator.cpp.md)
- [ServerReplicator.h](ServerReplicator.h.md) / [ServerReplicator.cpp](ServerReplicator.cpp.md)
- [Streaming.h](Streaming.h.md) / [Streaming.cpp](Streaming.cpp.md) — dictionaries, ids, wire primitives
- [StreamingUtil.h](StreamingUtil.h.md) — BitStream operator overloads
- [PropertySynchronization.h](PropertySynchronization.h.md) — PropSync master/slave
- [ReplicatorStats.h](ReplicatorStats.h.md) / [ReplicatorStats.cpp](ReplicatorStats.cpp.md)

### Replication items & jobs
- [Replicator.ItemSender.h](Replicator.ItemSender.h.md) / [Replicator.ItemSender.cpp](Replicator.ItemSender.cpp.md)
- [Replicator.JoinDataItem.h](Replicator.JoinDataItem.h.md) / [Replicator.JoinDataItem.cpp](Replicator.JoinDataItem.cpp.md)
- [Replicator.NewInstanceItem.h](Replicator.NewInstanceItem.h.md) / [Replicator.NewInstanceItem.cpp](Replicator.NewInstanceItem.cpp.md)
- [Replicator.DeleteInstanceItem.h](Replicator.DeleteInstanceItem.h.md) / [Replicator.DeleteInstanceItem.cpp](Replicator.DeleteInstanceItem.cpp.md)
- [Replicator.ChangePropertyItem.h](Replicator.ChangePropertyItem.h.md) / [Replicator.ChangePropertyItem.cpp](Replicator.ChangePropertyItem.cpp.md)
- [Replicator.ReferencePropertyChangedItem.h](Replicator.ReferencePropertyChangedItem.h.md) / [Replicator.ReferencePropertyChangedItem.cpp](Replicator.ReferencePropertyChangedItem.cpp.md)
- [Replicator.EventInvocationItem.h](Replicator.EventInvocationItem.h.md) / [Replicator.EventInvocationItem.cpp](Replicator.EventInvocationItem.cpp.md)
- [Replicator.TagItem.h](Replicator.TagItem.h.md) / [Replicator.TagItem.cpp](Replicator.TagItem.cpp.md)
- [Replicator.MarkerItem.h](Replicator.MarkerItem.h.md) / [Replicator.MarkerItem.cpp](Replicator.MarkerItem.cpp.md)
- [Replicator.PingItem.h](Replicator.PingItem.h.md) / [Replicator.PingItem.cpp](Replicator.PingItem.cpp.md)
- [Replicator.PingBackItem.h](Replicator.PingBackItem.h.md) / [Replicator.PingBackItem.cpp](Replicator.PingBackItem.cpp.md)
- [Replicator.PingJob.h](Replicator.PingJob.h.md)
- [Replicator.SendDataJob.h](Replicator.SendDataJob.h.md)
- [Replicator.ProcessPacketsJob.h](Replicator.ProcessPacketsJob.h.md)
- [Replicator.HashItem.h](Replicator.HashItem.h.md) / [Replicator.HashItem.cpp](Replicator.HashItem.cpp.md)
- [Replicator.RockyItem.h](Replicator.RockyItem.h.md) / [Replicator.RockyItem.cpp](Replicator.RockyItem.cpp.md)
- [Replicator.StatsItem.h](Replicator.StatsItem.h.md) / [Replicator.StatsItem.cpp](Replicator.StatsItem.cpp.md)

### Streaming (part/terrain)
- [Replicator.StreamJob.h](Replicator.StreamJob.h.md) / [Replicator.StreamJob.cpp](Replicator.StreamJob.cpp.md)
- [Replicator.GCJob.h](Replicator.GCJob.h.md) / [Replicator.GCJob.cpp](Replicator.GCJob.cpp.md)
- [NetworkClusterPacketCache.cpp](NetworkClusterPacketCache.cpp.md)
- [NetworkPacketCache.cpp](NetworkPacketCache.cpp.md)

### Transport peers
- [Peer.h](Peer.h.md) / [Peer.cpp](Peer.cpp.md)
- [Client.h](Client.h.md) / [Client.cpp](Client.cpp.md)
- [Server.h](Server.h.md) / [Server.cpp](Server.cpp.md)
- [ConcurrentRakPeer.h](ConcurrentRakPeer.h.md) / [ConcurrentRakPeer.cpp](ConcurrentRakPeer.cpp.md)

### Players & Player
- [Players.cpp](Players.cpp.md)
- [Player.cpp](Player.cpp.md)
- [WebChatFilter.cpp](WebChatFilter.cpp.md)
- [PersistentDataStore.h](PersistentDataStore.h.md) / [PersistentDataStore.cpp](PersistentDataStore.cpp.md)
- [Marker.h](Marker.h.md) / [Marker.cpp](Marker.cpp.md)
- [GuidRegistryService.h](GuidRegistryService.h.md) / [GuidRegistryService.cpp](GuidRegistryService.cpp.md)

### Configuration
- [GameConfigurer.cpp](GameConfigurer.cpp.md)
- [GamePerfMonitor.h](GamePerfMonitor.h.md) / [GamePerfMonitor.cpp](GamePerfMonitor.cpp.md)

### Settings, filters, diagnostics
- [NetworkSettings.h](NetworkSettings.h.md) / [NetworkSettings.cpp](NetworkSettings.cpp.md)
- [NetworkFilter.h](NetworkFilter.h.md) / [NetworkFilter.cpp](NetworkFilter.cpp.md)
- [NetworkProfiler.h](NetworkProfiler.h.md) / [NetworkProfiler.cpp](NetworkProfiler.cpp.md)
- [CrashReporter.cpp](CrashReporter.cpp.md)
- [NetPmc.cpp](NetPmc.cpp.md)
- [PacketIds.h](PacketIds.h.md)

### Distributed physics ownership
- [NetworkOwnerJob.h](NetworkOwnerJob.h.md) / [NetworkOwnerJob.cpp](NetworkOwnerJob.cpp.md)

### Physics senders/receivers infrastructure
- [PhysicsReceiver.h](PhysicsReceiver.h.md) / [PhysicsReceiver.cpp](PhysicsReceiver.cpp.md)
- [PhysicsSender.h](PhysicsSender.h.md) / [PhysicsSender.cpp](PhysicsSender.cpp.md)
- [DirectPhysicsReceiver.h](DirectPhysicsReceiver.h.md) / [DirectPhysicsReceiver.cpp](DirectPhysicsReceiver.cpp.md)
- [InterpolatingPhysicsReceiver.h](InterpolatingPhysicsReceiver.h.md) / [InterpolatingPhysicsReceiver.cpp](InterpolatingPhysicsReceiver.cpp.md)
- [ErrorCompPhysicsSender.h](ErrorCompPhysicsSender.h.md) / [ErrorCompPhysicsSender.cpp](ErrorCompPhysicsSender.cpp.md)
- [ErrorCompPhysicsSender2.h](ErrorCompPhysicsSender2.h.md) / [ErrorCompPhysicsSender2.cpp](ErrorCompPhysicsSender2.cpp.md)
- [RoundRobinPhysicsSender.h](RoundRobinPhysicsSender.h.md) / [RoundRobinPhysicsSender.cpp](RoundRobinPhysicsSender.cpp.md)
- [TopNErrorsPhysicsSender.h](TopNErrorsPhysicsSender.h.md) / [TopNErrorsPhysicsSender.cpp](TopNErrorsPhysicsSender.cpp.md)

### Crypto & low-level utilities
- [rijndael.cpp](rijndael.cpp.md) · [Rijndael.h](Rijndael.h.md) · [Rijndael-Boxes.h](Rijndael-Boxes.h.md)
- [DataBlockEncryptor.h](DataBlockEncryptor.h.md) / [DataBlockEncryptor.cpp](DataBlockEncryptor.cpp.md)
- [Compressor.h](Compressor.h.md) / [Compressor.cpp](Compressor.cpp.md)
- [Util.h](Util.h.md) / [Util.cpp](Util.cpp.md)
- [BoostAppend.h](BoostAppend.h.md) / [BoostAppend.cpp](BoostAppend.cpp.md)
- [Dictionary.h](Dictionary.h.md) / [Dictionary.cpp](Dictionary.cpp.md)
- [Item.h](Item.h.md) / [Item.cpp](Item.cpp.md)
- [MechanismItem.h](MechanismItem.h.md) / [MechanismItem.cpp](MechanismItem.cpp.md)
- [ClusterUpdateBuffer.h](ClusterUpdateBuffer.h.md) / [ClusterUpdateBuffer.cpp](ClusterUpdateBuffer.cpp.md)
- [MovementHistoryJob.h](MovementHistoryJob.h.md) / [MovementHistoryJob.cpp](MovementHistoryJob.cpp.md)
- [ChatFilter.cpp](ChatFilter.cpp.md)
