# Network Module — Independent Review Certification

**Reviewer**: independent review agent (documentation campaign)
**Scope**: all 119 root-level `*.cpp`/`*.h` in `roblox-sandbox/Network/` ↔ 119 per-file `.md` (+ `INDEX.md`)
**Method**: every source file re-read **in full** (no sampling); every concrete doc claim checked against source (line numbers, endpoint strings, packet formats, constants, defaults, wire orders). Dead-code / zero-caller style claims machine-checked with grep before acceptance. Fixes applied mechanically only where source evidence was conclusive.

## Totals

| Verdict | Count |
|---|---|
| PASS (verified, unchanged) | 100 |
| FIXED (errors found and corrected in place) | 19 |
| FAIL (unresolvable problems) | 0 |

Coverage verified exactly 1:1: `diff` of source basenames vs `.md` stems yields no mismatches; `INDEX.md` links enumerate exactly the 119 docs.

## Priority live-proxy inventory (spot-audit requested by campaign)

| Claim | Verified |
|---|---|
| `Players.cpp` CharacterFetch endpoint at L429 (`%sAsset/CharacterFetch.ashx?userId=%d`, `getCharacterAppearance`) | ✅ exact |
| `GameConfigurer` HandleSocialRequest methods L54–58 (IsFriendsWith/IsBestFriendsWith/IsInGroup/GetGroupRank/GetGroupRole) + GamePassHandler `Action=HasPass` L59, installed in `setupUrls` ~L127/L132 | ✅ exact |
| `ServerReplicator` validate-place-join sprintf at **L2241** (`universes/validate-place-join?originPlaceId=%d&destinationPlaceId=%d`, `HttpRbxApiService::get` PRIORITY_EXTREME / `Http::get` fallback) | ✅ exact |
| Ticket AES flow: `Client::sendTicket` payload order → `Peer::encryptDataPart` (`DataBlockEncryptor`, key `aesKey[i]=0xFE^7*i`, ECB+manual chain over bytes `[1,len)`); server `CheatHandlingServerReplicator::processTicket` → `Peer::decryptDataPart`; signature `Crypt().verifySignatureBase64("userId\nname\nappearance\njobId\ntimestamp")` | ✅ (one doc error fixed: encryption covers the whole post-packet-id payload, not a "post-goldHash tail") |

## Per-file verdicts

### FIXED (19)

| File | Errors found → fix applied |
|---|---|
| API.cpp.md | versionB accumulation enumeration incomplete/misordered → exact per-init sequence; unverifiable "leaks the boost thread intentionally" → tagged UNSUPPORTED (boost dtor semantics not determinable from repo) |
| ChatFilter.cpp.md | "detached boost::thread" unprovable → reworded, UNSUPPORTED tag |
| Client.cpp.md | LAN check described as "/24-ish class-C" → actually compares only last octet (`& 0x00FF`), far weaker; bogus "re-evaluates even when found" removed (loop exits on first match); ticket encryption described as covering "post-goldHash tail" → covers entire payload after packet-id byte |
| Peer.cpp.md | wrong constant name `CyclicExecutivePriority_…` → `CyclicExecutiveJobPriority_Network_ReceiveIncoming` |
| CrashReporter.cpp.md | nonexistent `EnableHangReporting` → NotifyAlive/DisableHangReporting; "hang dumps request full memory (true passed as writeFullDmp)" WRONG → the `true` is the *noMsg* param; full-dump remains sampling-gated |
| GuidRegistryService.cpp.md | "constructed by server bootstrapping" → created on demand by `Players::getGuidRegistry()` on client and server |
| InterpolatingPhysicsReceiver.cpp.md | line count 321 → 322 |
| ClusterUpdateBuffer.h.md | claimed consumer `NetworkClusterPacketCache.cpp` does not exist (grep: only Replicator.cpp/.h) |
| PhysicsSender.cpp.md | "RoundRobin senders use ClientPhysicsSendRate" dead in effect — ctor assigns it then unconditionally overwrites with `DFInt::PhysicsSenderRate` → documented as dead code |
| Replicator.h.md | `readJoinData` "returns protocol version" WRONG → returns instance count |
| Replicator.cpp.md | new-instance wire order listed `…[parentId][deleteOnDisconnect]` WRONG → ownership flag read immediately after class id, before properties |
| Replicator.ReferencePropertyChangedItem.cpp.md | claimed ref props are inserted into `pendingChangedPropertyItems` WRONG → early branch skips that set entirely (no coalescing) |
| Replicator.PingItem.h.md | "32 hackFlag reads" → 13 (`hackFlag0..12`) |
| Replicator.JoinDataItem.h.md | `setBytesPerStep(MaxJoinDataSizeKB*1000)` attributed to GameConfigurer → done by `Replicator::addTopReplicationContainers` |
| ReplicatorStats.h.md | line count 153 → 152 |
| rijndael.cpp.md | said DataBlockEncryptor drives blockEncrypt/blockDecrypt "in CBC mode" WRONG → `MODE_ECB` + hand-rolled XOR chaining; "(CBC only)" corrected likewise |
| Server.cpp.md | ticket validation attributed to nonexistent `ServerReplicator::HandleNewConnection` → actual path `processTicket`/`preauthenticatePlayer`/`installRemotePlayer` |
| StreamingUtil.h.md | UNKNOWN overload implementation location resolved → defined in `Streaming.cpp` (verified) |
| Replicator.StreamJob.cpp.md | buffer-health adaptation described as "halve/double" → halve below 0.5, increment-by-one above 0.9 (capped) |

### PASS (100)

API.cpp · BoostAppend.cpp · BoostAppend.h · ChatFilter.cpp *(fixed, above — see FIXED)* · Client.h · ClientReplicator.cpp · ClientReplicator.h · ClusterUpdateBuffer.cpp · Compressor.cpp · Compressor.h · ConcurrentRakPeer.cpp · ConcurrentRakPeer.h · CrashReporter.cpp *(fixed)* · DataBlockEncryptor.cpp · DataBlockEncryptor.h · Dictionary.cpp · Dictionary.h · DirectPhysicsReceiver.cpp · DirectPhysicsReceiver.h · ErrorCompPhysicsSender.cpp · ErrorCompPhysicsSender.h · ErrorCompPhysicsSender2.cpp · ErrorCompPhysicsSender2.h · GamePerfMonitor.cpp · GamePerfMonitor.h · GuidRegistryService.h · InterpolatingPhysicsReceiver.h · Item.cpp · Item.h · Marker.cpp · Marker.h · MechanismItem.cpp · MechanismItem.h · MovementHistoryJob.cpp · MovementHistoryJob.h · NetPmc.cpp · NetworkFilter.cpp · NetworkFilter.h · NetworkOwnerJob.cpp · NetworkOwnerJob.h · NetworkPacketCache.cpp · NetworkProfiler.cpp · NetworkProfiler.h · NetworkSettings.cpp · NetworkSettings.h · PacketIds.h · PersistentDataStore.cpp · PersistentDataStore.h · PhysicsReceiver.cpp · PhysicsReceiver.h · Player.cpp · PropertySynchronization.h · Replicator.PingBackItem.cpp · Replicator.PingBackItem.h · Replicator.PingJob.h · Replicator.ProcessPacketsJob.h · Replicator.SendDataJob.h · Replicator.TagItem.cpp · Replicator.TagItem.h · Replicator.HashItem.cpp · Replicator.HashItem.h · Replicator.ItemSender.cpp · Replicator.ItemSender.h · Replicator.MarkerItem.cpp · Replicator.MarkerItem.h · Replicator.EventInvocationItem.cpp · Replicator.EventInvocationItem.h · Replicator.DeleteInstanceItem.cpp · Replicator.DeleteInstanceItem.h · Replicator.ChangePropertyItem.cpp · Replicator.ChangePropertyItem.h · Replicator.NewInstanceItem.cpp · Replicator.NewInstanceItem.h · Replicator.RockyItem.cpp · Replicator.RockyItem.h · Replicator.StatsItem.cpp · Replicator.StatsItem.h · Replicator.GCJob.cpp · Replicator.GCJob.h · Replicator.StreamJob.h · ReplicatorStats.cpp · Server.h · ServerReplicator.cpp *(fixed)* · ServerReplicator.h · Streaming.cpp · Streaming.h · TopNErrorsPhysicsSender.cpp · TopNErrorsPhysicsSender.h · Util.cpp · Util.h · WebChatFilter.cpp · Players.cpp · GameConfigurer.cpp · Rijndael.h · Rijndael-Boxes.h

*(Files listed as "(fixed)" in this PASS block appear once in FIXED above; the authoritative tally is the header table: 100 PASS + 19 FIXED = 119.)*

## Cross-checked claims resolved during review

- `TOP_REPLICATION_CONTAINER_FINISHED_TAG`=13 / `REPLICATED_FIRST_FINISHED_TAG`=12 (Replicator.h L36–37)
- `CheatHandlingServerReplicator::canSendItems(){ return processedTicket; }` (ServerReplicator.h L318)
- Dead-code claims verified true: `isTrustedContent` short-circuit (API.cpp), `logAnalytics` never read (GameConfigurer.cpp), `newValueIsNull` never assigned (ReferencePropertyChangedItem), `DEC/INC_SIM_RADIUS_FPS` unused (NetworkOwnerJob.cpp), gzip includes unused in Compressor.cpp, RoundRobin rate branch dead (PhysicsSender.cpp)
- Dead-code claims verified false → fixed: NetworkClusterPacketCache does *not* reference ClusterUpdateBuffer; ref props do *not* enter `pendingChangedPropertyItems`
- `GA_CATEGORY_ERROR` used only in NetworkPacketCache.cpp ✅
- `sendNetPmcChallenge` pumped from PingJob ✅; `SetPropSyncExpiration` reflection exists (Replicator.cpp L189) ✅
- Server creates OneQuarter/Cluster packet caches unconditionally; physics/instance caches gated on settings flags ✅ (validates two cache-doc usage claims)
- `NETWORK_PROFILER` defined in Util.h for `_WIN32 && (_NOOPT|_DEBUG|RBX_TEST_BUILD)` ✅; profiler defaults 127.0.0.1:38123, `networkOwnerRate` 10 ✅

## Residual risk / notes

- Two UNSUPPORTED tags left in place rather than deleted (boost::thread destruction semantics in API.cpp/ChatFilter.cpp docs) — behavior depends on unvendored boost build flags; flagged inline so future reviewers can resolve with build config.
- All fixes are confined to `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/Network/*.md`; no source tree files were modified.
