# Network/ClientReplicator.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 3221 lines)

## Purpose

Implements the client-side replicator: processes `ID_SET_GLOBALS` (the server's join-time configuration broadcast) and `ID_SCHEMA_SYNC`, requests the character (`RequestCharacterItem` with anti-cheat send-stats payload), handles tags that mark ReplicatedFirst/game-load completion, receives server stats and "Rocky"/NetPmc memory-check challenges, hosts the Windows anti-tamper job trio (`MemoryCheckerJob` "US14116", `MemoryCheckerCheckerJob` "US14116_pt2", `BadAppCheckerJob` "BatteryProfiler"), drives instance streaming quota/GC, PropSync acknowledgements (incl. immediate CFrame acks), and the full protocol-schema fallback that lets a legacy client skip bytes for classes/properties/events it doesn't know.

## API

### Join-flow packets handled here

| Packet | Symbol | Effect |
|---|---|---|
| `ID_CONNECTION_REQUEST_ACCEPTED` (echo) | `OnReceive` | client sends dictionaries back (`sendDictionaries`) |
| `ID_DICTIONARY_FORMAT` | `OnReceive` | sets `protocolSyncEnabled`, `apiDictionaryCompression` |
| `ID_PROTOCAL_MISMATCH` | `OnReceive` | connectionFailedSignal("Network protocol mismatch. Please upgrade.") + `DisconnectReason_ProtocolMismatch` |
| `ID_PLACEID_VERIFICATION` | `OnReceive` | retry=true ⇒ re-queue `RequestCharacterItem`; false ⇒ "Illegal teleport destination." + `DisconnectReason_IllegalTeleport` |
| `ID_SCHEMA_SYNC` | `processPacket` → `learnSchema` | gzip-decompressed enum/class/prop/event schema; unknown entries flagged `needSync` |
| `ID_SET_GLOBALS` | `processPacket` | reads distributedPhysicsEnabled (⇒ RoundRobin sender + Direct receiver), streamingEnabled (⇒ GCJob), networkFilterEnabled (+third-party sales if ≥proto 32) ⇒ StrictNetworkFilter, characterAutoLoad, serverScope name, scriptKey/coreScriptModKey XORed with hash(placeID) into ScriptContext when secure replication on, binds top-replication-container GUIDs, drops containers absent on server, then `receivedGlobals=true` + signal + `enableDeserializePacketThread()` |

Outbound items: `RequestCharacterItem` (`ItemTypeRequestCharacter`: sendStats = `DataModel::sendStats | allHackFlagsOredTogether()`, spawn name, local player id), `ClientCapacityUpdateItem` (quota diff + max region radius), `CFrameAcknowledgementItem` / `writePropAcknowledgementIfNeeded` (`ItemTypePropAcknowledgement`), `HashItem` (pmcHash + tokens, from `onHashReady`), `RockyItem` (MccReport, from `onMccReady`), `NetPmcResponseItem` (result of `netPmcHashCheck(challenge ^ kChallenges[idx])`). Also `requestServerStats(bool)` sends `ID_REQUEST_STATS`.

Tags: `REPLICATED_FIRST_FINISHED_TAG`(12) → `ReplicatedFirst::setAllInstancesHaveReplicated`; `TOP_REPLICATION_CONTAINER_FINISHED_TAG`(13) → `DataModel::gameLoaded()`, `gameLoadedSignal()`, `canTimeout = true`, ping timer reset.

## Usage

- Character request path: GameConfigurer's `Replicator::requestCharacter` reflection call → `requestCharacterImpl` queues the item, fires `DataModel::gameLoaded()`, connects `characterAddedSignal`; first Character arrival flips `processAllPacketsPerStep` off (join burst over).
- Streaming loop: `readStreamData(Item)` consumes per-region join data; `postProcessPacket` → `updateClientCapacity` computes `clientInstanceQuota` from measured decode time vs `kMaxIncomePacketWaitTime` (0.25 s), bounded by `DFInt::ClientInstanceQuotaInitial/Cap`, sends capacity updates; GC via `GCJob` (`needGC`/`streamOutInstance` nulls joint refs through JointsService and unregisters guids).
- Schema tolerance: `ProcessOutdated*` overrides detect newer-server layouts (`isOutdated` class flags set by `learnSchema`) and either skip exact byte counts (`skipPropertyValue/skipPropertiesInternal/skipChangedProperty/skipEventInvocation`) or re-serialize enums with the server's bit width (`serializeEnum(..., newMSB)`).

## Gotchas

- Client can't send anything until `receivedGlobals` is true (`canSendItems`) — every outbound item queues silently before that.
- The anti-tamper jobs are dense with VMProtect regions and obfuscated flag encoding (`kGf2EncodeLut` GF(2) masks, `LINE_RAND4` random-line hack-flag macros); `MemoryCheckerCheckerJob` also calls `FreeConsole()` every 8th run explicitly to troll exploiters ("this is just to troll exploit developers who are too lazy to write a GUI") and detects hooks on `FreeConsole`/`GetThreadContext` prologs (0xFF8B hot-patch check).
- `BadAppCheckerJob` scans for Cheat Engine via DLL presence, window titles, fake attach, DBVM canary; speedhack detection exists but is `#if 0`'d due to false positives.
- Ships-in-the-night guard: during streaming, a Parent change to an unknown GUID is interpreted as server-GC racing a reparent and streams the instance out instead of applying it.
- `decodeProtectedString` returns bytecode under `LuaVM::useSecureReplication()` else raw source; failed decodes are impossible to distinguish from tampering here (that check lives in Replicator.cpp).
- UNKNOWN: layout of `RBX::Security::NetPmcChallenge`/`kChallenges`, `pmcHash`, `Tokens::*` internals (security/ headers outside Network root); `STATS_ITEM_VERSION` value.
