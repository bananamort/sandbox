# LogService.cpp

## Purpose

Implements `LogService` ("LogService") — the script-visible console pipe: taps StandardOut into a 512-entry ring (MessageOut event + GetLogHistory), sensitive-key redaction (apikey=/accesskey=/rbxcdn.com/ inside http URLs) with Influx "BadLog" reporting, server-log streaming to place managers (CanManage web check), and the dev-console ExecuteScript remote — guarded by a kill flag with an explicit "Do not remove" exploit note.

## Key types and API

Descriptors:
- `func_GetLogHistory("GetLogHistory", Security::None)` — ValueArray of {timestamp, message, messageType} tables; GA-tracks placeId per call.
- `func_RequestServerOutput("RequestServerOutput", **Security::RobloxScript**)` — client asks for server logs.
- `func_executeScript("ExecuteScript", "source", **Security::RobloxScript**)` — client→server console eval.
- `event_OutputMessage("MessageOut", "message","messageType")` — plain event.
- Remote events: `event_ServerOutputMessage("ServerMessageOut", "message","messageType","timestamp", **Security::RobloxScript**, SCRIPTING, CLIENT_SERVER)`; `event_RequestServerOutputSignal("…", "requestingPlayer", **Security::Roblox**, REPLICATE_ONLY, CLIENT_SERVER)`; `event_requestScriptExecutionSignal("…", "requestingPlayer","source", Security::Roblox, …)`.

Enum registered "MessageType": MessageOutput, MessageInfo, MessageWarning, MessageError.

Tunables: DFInt MaxLogHistory(512), BadLogInfluxHundredthsPercentage(0), BadLogMask(0); DFFlag DebugDisableLogServiceExecuteScript(false).

Behavior:
- ctor hooks StandardOut messageOut; onMessageOut skips MESSAGE_SENSITIVE + re-entrancy guard, defers via DataModel Write task.
- doFireEvent: filterSensitiveKeys erases keyword→[& :space:] spans inside http(s)+roblox/rbxcdn strings (returns bitmask; masked hits reported to Influx at sampling %); fires MessageOut; resizes ring keeping newest; fans out ServerMessageOut to connected player addresses.
- Server log access: RequestServerOutputSignal handler verifies player validity in processRemoteEvent ("ignore invalid calls for security reasons") then web-checks `/users/%d/canmanage/%d` (CanManage JSON bool) before connecting backlog + live stream.
- executeScript → same CanManage gate → executeServerScript runs source as **GameScript_** identity in new thread named "console"; kill-switch flag returns silently.
- maybeConnectPlayerToServerLogs/maybeExecuteServerScript assert+check serverIsPresent.

## Usage / reflection touchpoints

Feeds dev console UI ([Stats](Stats.md)-adjacent tooling); StandardOut tap shared with all services' printf logging ([DataModel](DataModel.md) etc.).

## Gotchas

- ExecuteScript grants arbitrary SERVER code execution to anyone passing the CanManage web check — hence the permanent kill flag comment ("used in cases where an exploit gains access to devconsole").
- Redaction only triggers when "http" AND roblox/rbxcdn appear — keys in non-Roblox URLs pass through unredacted.
- GetLogHistory is Security::None — any script can read the full local console history including pre-redaction? No: history stores POST-filter messages, but SENSITIVE-type messages are excluded from events yet still pushed? They're skipped entirely (return before submitTask).
