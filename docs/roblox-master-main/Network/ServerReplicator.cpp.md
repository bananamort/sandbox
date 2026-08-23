# Network/ServerReplicator.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 2975 lines)

## Purpose

Implements the server-side per-client replicator and its `RBX_RCC_SECURITY` subclass `CheatHandlingServerReplicator`: join/ticket validation (AES-decrypt `ID_SUBMIT_TICKET`, RSA signature check via `Crypt::verifySignatureBase64`), place authentication against the web API, `ID_SET_GLOBALS` composition (`sendTop`), schema/dictionary teaching (cached gzip bitstreams), remote Player installation + character spawn, filtering pipeline (StrictNetworkFilter / basic NetworkFilter / Lua callbacks), PropSync master-side versioning, distributed-physics ownership checks, streaming quota/region-removal intake, and the full client anti-cheat verdict machinery ("hector"/"ghector"/"Zek"/"impala"/… code names mapped through JSON-ish kick/report mask strings).

## API

### Outbound HTTP endpoints

| Endpoint | Method | Calling symbol |
|---|---|---|
| `<apiBaseUrl>universes/validate-place-join?originPlaceId=<prev>&destinationPlaceId=<cur>` | GET via `HttpRbxApiService::get` (`PRIORITY_EXTREME`, cached=true) or raw `Http::get` fallback | `CheatHandlingServerReplicator::PlaceAuthenticationThreadImpl` (line ~2238–2256); response `"true"` ⇒ Authenticated else Denied; exceptions allow non-teleport joins |
| `<baseUrl>` stat reports `"Preauthenticate-TicketFail"`, `"Authenticate-TicketFail"`, `"Authenticate-DupePlayer"` | unspecified (`ReportStatisticWithMessage` helper) | `preauthenticatePlayer`, `installRemotePlayer` failure paths |

InfluxDB: `sendJoinStatsToInflux` reports `"ServerJoin"` points (`ReceivedPlayer`, `TopRepContSent`, `ProcessedTicket`, `CharacterRequestReceived`, `PlayerInstalled`, `HasTerrain`, `BytesSent`) at `DFInt::JoinInfluxHundredthsPercentage`; security telemetry reports `"ServerHashItem"`, `"ServerMccItem"`, `"ServerPingItem"`, `"mccTime"`, `"hashstats"`, `"AddedDebug"`.

### Join/ticket flow (server side)

1. `OnReceive(ID_NEW_INCOMING_CONNECTION)`: sends `ID_DICTIONARY_FORMAT` (schema sync + api compression = true), the cached `ID_TEACH_DESCRIPTOR_DICTIONARIES` blob (`sendDictionaries`), gzip level-9 `ID_SCHEMA_SYNC` (`teachSchema`); in non-RCC builds immediately `sendTop`.
2. `ID_SPAWN_NAME` → stores `initialSpawnName`; `ID_PROTOCOL_SYNC` → `remoteProtocolVersion`; `ID_PLACEID_VERIFICATION` → cached place-auth result or spawns `PlaceAuthenticationThread`.
3. RCC builds: first `ID_SUBMIT_TICKET` → `processTicket`: `Peer::decryptDataPart`, extracts userId + ticket + DataModel-hash + protocolVersion (+ gold hash ≥29) + securityKey + platform/product + gameSessionID; mismatch paths send `ID_PROTOCAL_MISMATCH` / `ID_SECURITYKEY_MISMATCH` / `ID_HASH_MISMATCH` and disconnect; then `sendTop`. `processedTicket=true` gates all further sends (`canSendItems`).
4. Ticket signature message: `"<userId>\n<playerName>\n<characterAppearance>\n<jobId>\n<timestamp>"` verified base64-RSA; duplicate tickets tracked in `server->usedTickets`; duplicates of userId rejected as `DisconnectReason_DuplicatePlayer`. Pre-auth pass uses 3-part ticket with only userId/jobId/timestamp.
5. Character request path: client's `ItemTypeRequestCharacter` item → `readRequestCharacter` (place-auth gate; Requesting ⇒ retry=true packet) → `prepareRemotePlayer` captured the replicated Player earlier; when top containers are sent (`onSentTag(TOP_REPLICATION_CONTAINER_FINISHED_TAG)`=13) physics sender starts, streamJob marks ready, and `installRemotePlayerSafe` parents the Player under Players and calls `loadCharacter(true, spawnName)` if auto-spawn.
6. `dataOutStep` denies denied-place clients via `ID_PLACEID_VERIFICATION(retry=false)`.

### Security-mask configuration

Kick/report behavior for every anti-cheat signal is driven by five FastStrings `US30605p1..p5` parsed by `getSecurityMask` (40-char pattern, every 5th char a digit; `.`=kick, `:`=gold-kick, `r`=report, `g`=gold-report). `doRemoteSysStats` consults them per bit before calling `Players::onRemoteSysStats` (which kicks only if real golden hashes were armed) or GA `"SecurityException"`. Delayed kicks (`doDelayedSysStats`) schedule at now+60+rand(128) s. Full HATE_* table enumerated in `processSendStats` with one codename per bit ("murdle"=CE stable … "impala"=impossible error), scorn bits via `US30605p5`.

## Usage

- Filtering precedence for client→server mutations: cloud-edit bypass → strict filter → basic filter (fires `Server::dataBasicFilteredSignal`) → Lua callbacks `filterNew/filterDelete/filterProperty/filterEvent` (reflection: `NewFilter/DeleteFilter/PropertyFilter/EventFilter`, Security::RobloxPlace) firing `Server::dataCustomFilteredSignal`.
- Hard receive rules: never accept `Message`, second `Player`, `Script::prop_EmbeddedSourceCode`, `BaseScript::prop_SourceCodeId`, `ModuleScript::prop_Source`, `Player::userId(_Deprecated)`, `Instance::Name`; scripts must exist in `Server::legalScripts` (`isScriptLegal`).
- ProtectedString encode: secure replication sends script **index** (for server-only Scripts), bytecode index ≥proto 28 (legacy format <33), else raw source.
- Distributed physics: `checkDistributedReceive/Send(Fast)` implement owner-only acceptance using mechanism root parts; `readPlayerSimulationRegion` feeds NetworkOwnerJob.

## Gotchas

- Base `ServerReplicator::PlaceAuthenticationThreadImpl` just sets Authenticated — only the RCC subclass performs the web call.
- `cmpIosHash` compares an obfuscated byte table to detect iOS clients and disable hash/MCC checks; non-Win32 platforms also get both checks bypassed (`enableHashCheckBypass/enableMccCheckBypass` logic inverted-looking but ends bypassed for non-"Win32" platform strings).
- Hash-item decode XORs consecutive entries (`hashes[i] ^= hashes[i-1]`) and validates nonce increments (`kPmcNonceGoodInc`), text-base==0x401000, size estimate ≤0x2000000.
- MCC report validation decodes GF(2) inner-product-encoded bits via popcnt and cross-checks run timestamps for speedhack-style skew (±10 s tolerance).
- `catch (std::exception e)` (by value) in `processTicket` swallows exploit-triggered parse errors into a disconnect — intentional hardening.
- UNKNOWN: `ReportStatisticWithMessage` implementation (RobloxServicesTools.h); exact contents of `PmcHashContainer`/`kGoldHash*` indices (util/ProgramMemoryChecker.h).
