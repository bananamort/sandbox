# Test.cpp

## Purpose

Implements TWO classes: `TestService` ("TestService", the automated functional-test harness — Run lifecycle with timeout/watchdog, Message/Checkpoint/Warn/Check/Require/Error/Fail/Done assertion surface, client→server result collection, C++-macro-to-Lua source rewriting via MacroSubstituter, physics/network settings save+restore, and TEST_BUILD-only verb command execution) and `FunctionalTest` ("FunctionalTest", the deprecated single-test instance whose Pass/Warn/Error forward into TestService, with settings-migration support).

## Key types and API

### FunctionalTest
Enum `FunctionalTestResult`: Passed / Warning / Error (+Variant/StringConverter plumbing).
Descriptors (BoundProps): "Description" (Data), "Timeout" (Settings, cap LEGACY, default 60), "PhysicsEnvironmentalThrottle"/"AllowSleep"/"Is30FpsThrottleEnabled" (cap LEGACY), "HasMigratedSettingsToTestService" (cap STREAMING).
Funcs **Security::None**: "Warn(msg)", "Pass(msg)", "Error(msg)" + deprecated aliases "Passed"/"Failed".
Behavior: onServiceProvider finds-or-creates TestService; when created fresh AND HasMigratedSettings flag set (old files), copies description/timeout/physics settings across. pass/warn/error each throw without a TestService, call check/warn, then done().

### TestService
Config BoundProps: Description(""), Timeout(10s), IsPhysicsEnvironmentalThrottled(true), IsSleepAllowed(true), Is30FpsThrottleEnabled(true), AutoRuns(category "Physics"!, true), NumberOfPlayers(0), SimulateSecondsLag(0); RBX_TEST_BUILD-only PhysicsSendRate float (seeded from NetworkSettings).
Results READONLY BoundProps: TestCount/WarnCount/ErrorCount.
Assertion funcs (**Security::None**): yield "Run()"; "Message(text, source=nil, line=0)"; "Checkpoint(...)"; "Warn(condition, description, ...)"; "Check(condition, ...)"; "Require(condition, ...)" (failure ⇒ done()); "Error(description, ...)"; "Fail(...)" (always done()); "Done()".
Remote events (**Security::None**, SCRIPTING, CLIENT_SERVER): "ServerCollectResult(text, script, line)", "ServerCollectConditionalResult(condition, text, script, line)" — clients fire these; server handlers route into onMessage/onCheck directly (asserting numberOfPlayers>0).
TEST_BUILD-only LocalUser funcs: GetCommandNames/DoCommand/IsCommandEnabled/IsCommandChecked over DataModel verbs — source comment flags DoCommand as "an easy exploit" since it bypasses getWhitelistVerb.

Run lifecycle:
- `run()` throws if already running; resets counters (raises all three), `setConfiguration()` snapshots EThrottle/AllowSleep/30fps/FLog::Asserts + sets NetworkSettings physicsSendRate (performance tests zero FLog::Asserts); TimerService watchdog: 5 s stillWaiting notice when timeout>10, timeout ⇒ counted error + done; autoRuns drives RunService::run(); startScripts registers every child Script via ScriptContext::addScript with success/error continuations bound to runCount, **identity elevated to Security::Context::current().identity of the CALLER**, and filterScript = MacroSubstituter rewrite.
- Assertions increment counters with per-change property raises; clients ALSO replicate results to server.
- `done()` guards !running; prints summary or "Doesn't include any assertions"; stop() → stopScripts, pause RunService if it wasn't running before, restoreConfiguration, resumeFunction().
- askForbidChild: only Script instances allowed.

MacroSubstituter (line-based, 1000-char limit, errors wrapped as LuaSyntaxError): rewrites RBX_CHECK/WARN/_REQUIRE_{EQUAL,NE,GE,LE,GT,LT} into do-blocks evaluating both operands once (aZZZZ/bZZZZ) calling Check/Warn/Require with stringized expression + tostring diff; RBX_*_MESSAGE simple substitutions; RBX_*_THROW / NO_THROW via ypcall(function() … end) == false/true; bare RBX_WARN/CHECK/REQUIRE; RBX_ERROR/FAIL/MESSAGE/CHECKPOINT passthrough calls. All insertions pass `script, <lineNumber>`.

## Usage / reflection touchpoints

Run is Plugin-security; everything else None/LocalUser(TEST). Pairs with TimerService.md, PhysicsSettings.md (singleton mutation), ServerScriptService.md semantics, ScriptContext at [App/script](../../script/).

## Gotchas

- setConfiguration mutates GLOBAL singletons (PhysicsSettings, FLog::Asserts, NetworkSettings send rate) — concurrent tests or live games share the damage until restoreConfiguration.
- Client assertion replication means Check counts TWICE server-side for client-run scripts (remote handler increments again via onRemoteConditionalResult).
- Require/Fail trigger done() immediately even mid-script batch; remaining scripts keep running but results freeze... actually stopScripts runs, killing siblings.
- MacroSubstituter's [==[ ]==] long-bracket embedding breaks on test expressions CONTAINING "==]".
- identity elevation uses caller's current security context at addScript time — Run() from Plugin yields Plugin-identity test scripts.
