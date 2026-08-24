# App/include/v8datamodel/LogService.h

## Purpose

`LogService` (INTERNAL service) — script-accessible console log plumbing: keeps a circular history of StandardOut messages, streams server output to privileged players on request, and (dangerously) executes server-side scripts from console clients.

## Declared API

`class LogService : public DescribedCreatable<LogService, Instance, sLogService, ClassDescriptor::INTERNAL>, public Service`

- Local: `void requestServerOutput();` `shared_ptr<const Reflection::ValueArray> getLogHistory();` signal `outputMessageSignal<void(std::string, MessageType)>`.
- Script exec: `void executeScript(std::string source);`
- Remote signals: `requestServerOutputSignal<void(shared_ptr<Instance>)>`; `serverOutputMessageSignal<void(std::string, MessageType, int)>`; `requestScriptExecutionSignal<void(shared_ptr<Instance>, std::string)>`.
- Override: `processRemoteEvent(descriptor, args, SystemAddress source)` — custom remote dispatch.
- Permission gate: `void runCallbackIfPlayerHasConsoleAccess(shared_ptr<Player>, function<void()>);` static `handleCanManageResponse(callback, weak_ptr<LogService>, std::string* responseString, std::exception*)` (web "can manage" check).
- Static redaction: `static int filterSensitiveKeys(std::string& text);`
- Private machinery: message-out tap (`onMessageOut`, static doFireEvent with weak_ptr), player attach helpers `maybeConnectPlayerToServerLogs` / `connectPlayerToServerLogs(weak Player)`, server-script path `maybeExecuteServerScript` / static executeServerScript, state `currentlyFiringEvent`, connections, `boost::circular_buffer_space_optimized<StandardOutMessage> logHistory`, current + list of players receiving server logs.

## Gotchas

- executeScript is a remote-code-execution surface by design — gated only by the can-manage check.
- Multiple players can subscribe to server logs (list, not single).
- filterSensitiveKeys mutates text in place and returns a count/flag (.cpp).

## UNKNOWN

- Circular buffer capacity of logHistory (.cpp ctor).

## Cross-links

- Implementation: [App/v8datamodel/LogService.md](../../v8datamodel/LogService.md).
- Kin: [ScriptService.md] (S–Z half), [Stats.md](Stats.md)-style telemetry services.
