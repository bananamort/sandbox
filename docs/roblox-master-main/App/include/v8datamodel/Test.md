# App/include/v8datamodel/Test.h

## Purpose

Three pieces of test infrastructure: `TestService` — creatable service running Lua test scripts with BOOST-style assertions (message/checkpoint/warn/check/require2/error/fail), timeout + still-waiting callbacks, saved-and-restored physics settings, multi-player result collection over remote signals, and RBX_TEST_BUILD verb commands; `Lua::ArgumentParser` — a header-only bracket-argument scanner for test snippets (with documented limitations); and deprecated `FunctionalTest` that routes to TestService.

## Declared API

`class TestService : public DescribedCreatable<TestService, Instance, sTestService>, public Service`
- Public config fields: `bool autoRuns; std::string description; double timeout; bool isPhysicsThrottled; bool allowSleep; bool is30FpsThrottleEnabled; float physicsSendRate; int numberOfPlayers; bool clientTestService; double lagSimulation;` ("for multi-player test service" on the last three).
- Private state: resume fn, running flag, runCount/scriptCount/testCount/warnCount/errorCount, nested `struct PhysicsSettings {EThrottleType eThrottle; bool allowSleep; bool throttleAt30Fps; FLog::Channel wasLogAsserts;}` snapshot (`oldSettings`), wasRunning.
- Run control: `bool isPerformanceTest() const`; `void run(boost::function<void()> resumeFunction, boost::function<void(std::string)> errorFunction)` — comment: "returns true if done, false if timed out" (comment contradicts void return); `void done()`.
- Assertions (BOOST-parity comments in header): `message(text, source=shared_ptr(), line=0)`, `checkpoint(description, ...)`, `warn(bool cond, description, ...)`, `check(cond, ...)`, `require2(cond, ...)` (named require2!), `error(description, ...)`, `fail(...)`.
- Hook functions (public members): onMessage/onWarn/onCheck/onCheckpoint/onStillWaiting(time)/onDone.
- Read-only BoundProps: `TestCount`, `WarnCount`, `ErrorCount` (`BoundProp<int, Reflection::READONLY>`).
- RBX_TEST_BUILD-only: `getVerb(name)`, `isCommandEnabled/isCommandChecked(name)`, `doCommand(name)`, `getCommandNames() → shared_ptr<const ValueArray>`.
- Multi-player: inline `getNumberOfPlayers()`, `isMultiPlayerTest()` (>0), `isAClient()/setIsAClient(bool)`; remote signals `serverCollectResultSignal<void(std::string, shared_ptr<Instance>, int)>` and `serverCollectConditionalResultSignal<void(bool, std::string, shared_ptr<Instance>, int)>` with handlers `onRemoteResult/onRemoteConditionalResult`.
- Protected: `onServiceProvider`, virtual `askForbidChild`.
- Private machinery: timeout/stillWaiting, increment counters, script lifecycle (startScripts/stopScripts/countScript/startScript/stopScript/stop), completion handlers `onScriptEnded(runCount)` / `onScriptFailed(runCount, message, callStack, source, line)`, config save/restore `setConfiguration/restoreConfiguration`, `filterScript(source)`, static `output(MessageType, source, line, message)`, two result-collect connections.
- Header does `#undef check` if defined (Windows macro clash).

`namespace Lua { class ArgumentParser }` — static template scanners: `parseString` (escape-aware, throws "Missing string closure"), `getClosing('('→')' '['→']' '{'→'}')`, `parse_arg`, `parseBracket(first,last[,emit])` (throws "argument not separated by comma"/"Missing closing bracket"), `skipWhitespaces`, `getArgsInBracket(begin,end)/getArgsInBracket(string)`. In-header doc comment gives parse example `( a , 34+s(r, 6), 'd\'fg', "sd'fs")`, limitation (function blocks not grouped), and workaround (extra parens).

`class FunctionalTest : public DescribedCreatable<FunctionalTest, Instance, sFunctionalTest>` — "Deprecated. Use TestService instead"; routes everything to a held `shared_ptr<TestService>`; public fields hasMigratedSettingsToTestService/description/timeout/isPhysicsThrottled/allowSleep/is30FpsThrottleEnabled; `pass/warn/error(std::string message)`; `typedef enum {Passed, Warning, Error} Result;`; overrides onServiceProvider + inline askSetParent returning true ("Tests can be anywhere").

## Gotchas

- run()'s in-header comment claims a bool return but the signature is void — stale comment.
- TestService snapshots and RESTORES physics throttle/sleep/log settings around runs (setConfiguration/restoreConfiguration) — tests run under controlled physics config.
- require2 exists because require presumably collided with something (macro or Lua binder).
- FunctionalTest keeps public config fields that must be manually migrated (hasMigratedSettingsToTestService flag).

## UNKNOWN

- filterScript transformation rules (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Test.md](../../v8datamodel/Test.md).
- Script runtime: App/v8datamodel Script docs; physics settings source: [PhysicsSettings.md](PhysicsSettings.md).
