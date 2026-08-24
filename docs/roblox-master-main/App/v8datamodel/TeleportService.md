# TeleportService.cpp

## Purpose

Implements `TeleportService`, the client↔web↔server place-teleport machinery: script API (Teleport/TeleportToPlaceInstance/TeleportToSpawnByName/TeleportToPrivateServer/ReserveServer/Get-SetTeleportSetting/GetPlayerPlaceInstanceAsync/GetLocalPlayerTeleportData), the client PlaceLauncher polling thread with retry/backoff driving TeleportState transitions, server-side grant-access + per-player dispatch, custom loading-GUI sanitization (LuaSourceContainer stripping), and cross-place carryover statics (previousPlaceId/creator, dataTable, loading gui) consumed by PlayerGui.md and ReplicatedFirst.md.

## Key types and API

Descriptors:
- Yield **Security::None**: "GetPlayerPlaceInstanceAsync(userId):Tuple", "ReserveServer(placeId):string".
- Funcs **Security::None**: "TeleportToPlaceInstance(placeId, instanceId, player=nil, spawnName='', teleportData=nil, customLoadingScreen=nil)", "TeleportToSpawnByName(placeId, spawnName, player=nil, teleportData=nil, customLoadingScreen=nil)", "Teleport(placeId, player=nil, teleportData=nil, customLoadingScreen=nil)", "TeleportToPrivateServer(placeId, reservedServerAccessCode, players, spawnName='', teleportData=nil, customLoadingScreen=nil)", "GetTeleportSetting(setting):Variant", "SetTeleportSetting(setting, value)", "GetLocalPlayerTeleportData()".
- Callbacks **Security::RobloxScript**: "ConfirmationCallback(message, placeId, spawnName):bool" (default returns false), "ErrorCallback(message)" (default no-op); "TeleportCancel()" func same tier.
- Deprecated BoundProp "CustomizedTeleportUI".
- Event "LocalPlayerArrivedFromTeleport(loadingGui, dataTable)" — NO security tier (default).

Enums: TeleportState {RequestedFromServer, Started, WaitingForServer, Failed, InProgress}; TeleportType {ToPlace, ToInstance, ToReservedServer} (+ Variant/StringConverter plumbing).

Flags: DFInt TeleportRetryTimes(5); DFFlags UserCameraZoomPersistThroughTeleport(false), UserMouseLockSettingSaveTeleport(false), GetLocalTeleportData(false); FFlag UseBuildGenericGameUrl(true), PlaceLauncherUsePOST(true).

Client flow (`TeleportImpl`): asserts NOT server; stores dataTable + sanitized loading gui (clone with EngineCreator, destroy ALL descendant LuaSourceContainers — both original and clone stripped!); requestingTeleport reentry guard; studio gate via TeleportCallback; builds PlaceLauncher URL per type under BuildGenericGameUrl flag (RequestGameJob/RequestGame/RequestPrivateGame w/ url-encoded accessCode); appends browserTrackerId; fires local player TeleportState_Started; spawns named "Teleport Thread".

Poll loop (`TeleportThreadImpl`): POSTs (flag) or GETs url every ≥1 s; status 2 ⇒ found → fetch authenticationUrl/authenticationTicket/joinScriptUrl (studio path: resolve universeId then synthesize Visit.ashx?IsPlaySolo=1&FromTeleport=1); under LegacyLock raises TeleportState_InProgress, snapshots previousPlaceId/CreatorId/CreatorType into STATICS, teleported=true, `_callback->doTeleport(au,ticket,script)` (VMProtect-free here but callback impl is native). Status 0/1 ⇒ WaitingForServer + cancelable=false; other statuses burn retries (DFInt, <0 ⇒ Failed). Exceptions ⇒ Failed + error print. Cancel via TeleportCancel clears flags before non-cancelable point.

Server flow: `ServerTeleport` resolves Player from arg (character fallback deprecated warning), once-per-type GA stats ("ToPlace"/"ToInstance"/"ToReservedServer"), sanitizes gui, parents it briefly to InsertService as replication container while raising player's TeleportState_RequestedFromServer with the gui attached, then unpublishes. `TeleportToPrivateServer` posts reservedservers/grantaccess with playerIds=… then ServerTeleports all on success / fails each on error. `ReserveServer` posts reservedservers/create returning ReservedServerAccessCode.

Settings: process-wide static settingsTable map for Set/GetTeleportSetting (server-authored client hints). getLocalPlayerTeleportData throws unless DFFlag GetLocalTeleportData.

## Usage / reflection touchpoints

Core multi-place API at Security::None (script-facing) + RobloxScript callbacks. Consumers: PlayerGui.md (loading gui handoff), ReplicatedFirst.md (arrival signal), [Network Player](../../Network/) teleport state machine, InsertService.md (gui replication container).

## Gotchas

- Script stripping is split across two sites on the CLIENT path: `sanitizeCustomLoadingGui` destroys descendant LuaSourceContainers on the ORIGINAL gui, and `TeleportImpl` strips the CLONE again before stashing it — caller's gui always loses its children permanently. Note the SERVER path (`ServerTeleport`) never strips the clone, so the loading gui handed to `onTeleportInternal`/InsertService still carries its scripts when it replicates.
- GetPlayerPlaceInstanceAsync writes the MEMBER `url` shared with the teleport thread — concurrent use races the poll URL.
- ProcessGetPlayerPlaceInstanceResultsSuccess dereferences itData after an end() check WITHOUT continue (missing-key path reads invalid iterator).
- Static carryover (teleported/previous*/customTeleportLoadingGui/dataTable) survives DataModel teardown by design — cross-session state.
- ReserveServer/TeleportToPrivateServer are silently no-op client-side except an error string/print.
- The Durango branch embeds gamerTag in URL ("drop this crap… ask me in 5 years" — Max).
