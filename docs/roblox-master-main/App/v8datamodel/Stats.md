# Stats.cpp

## Purpose

Implements the `RBX::Stats` namespace: free-function HTTP reporting helpers (game status, user id), a hand-rolled JSON writer over Reflection tables, and TWO class families — `StatsService` (reflection-exposed reporting with per-category throttling and a signed remote "gather script" bootstrap) and `Stats::Item` plus its bound subclasses (TotalCountTimeIntervalItem, RunningAverageItemInt/Double, RunningAverageTimeIntervalItemTimeBenchmark, ProfilingItem) that mirror engine stat structures as Instance trees.

## Key types and API

### StatsService ("Stats")
Descriptors:
- `func_report("Report(category, data:Table)")` — **Security::RobloxScript**.
- `func_reportTaskScheduler("ReportTaskScheduler(includeJobs=false)")` — **Security::RobloxScript**.
- `func_reportJobsStepWindow("ReportJobsStepWindow()")` — **Security::RobloxScript**.
- `prop_reportUrl("SetReportUrl(url)")` — BoundFunc **Security::RobloxScript**.
- `prop_reporterType("ReporterType")` / `prop_minReportInterval("MinReportInterval")` — BoundProps cap UI, **Security::RobloxScript**.

Mechanics:
- Report pipeline: `checkLastReport(category)` throttles via lastReportTimes map vs MinReportInterval (warning "…was throttled"); builds hand-written JSON `{placeId?, reporter?, category, …}`; postReport → postReportWithUrl which is an EMPTY BODY marked DEPRECATED/TODO-remove — **reports currently go NOWHERE** unless custom url set (still nothing posts).
- `getDefaultReportUrl`: rewrites www.roblox.com base to logging.service.roblox.com else inserts "logging.service." after http://; appends Gatherer/LogEntry?Shard=Client. getReportUrl throws without ContentProvider.
- reportJobsStepWindow emits ThreadPoolSize + per-job stepTimes arrays; reportTaskScheduler emits DataModelCount/thread counts/scheduler rate/duty cycle/priorityMethod (+optional jobs dutyCycle/stepRate/stepTime/error filtered to this DataModel's arbiter).
- `report(category,data,percentage)` overload gates on uniformRandomInt(0,99) < percentage.
- `report_BypassThrottlingAndCustomUrl` is a hard `return;` stub.

Gather-script bootstrap (`tryToStartScript`, server-only): GETs ClientSharedSettings URL (guid D6925E56-…), regex-ish extracts "StatsGatheringScriptUrl":"…" from JSON (hand parsing, backslash stripping), Http GETs that script, submits `runScript` under DataModel Write lock: VMProtectBeginMutation("19") wrap + `ProtectedString::fromTrustedSource` + `ContentProvider::verifyRequestedScriptSignature(…, "StatsScript", true)` + executeInNewThread at Security::RobloxGameScript_; ALL exceptions swallowed "to make it harder to see (security)". onServiceProvider retries while baseUrl unset via propertyChangedSignal.

Free functions: setUserId (also Analytics::setUserId), setBrowserTrackerId, reportGameStatus → POST client-status/set with browserTrackerId+status (skipped when either empty); httpPost helper sets recordStatistics=false (avoid feedback loops) and passes a `data.size() > 256` boolean as Http::post's third argument on both sync and async paths (meaning defined by Http's signature header-side).

Influx settings declared but UNUSED in this TU: DFInt HttpInfluxHundredthsPercentage(0), DFString HttpInfluxURL(default influx host:8087), HttpInfluxDatabase "Default", HttpInfluxUser "roblox", **HttpInfluxPassword "te$tu$3r"** (hardcoded credential in source).

### Stats::Item family
- Item: RBX_REGISTER_CLASS; recursive update() bubbles to parent Item; formatMem/formatRate/formatValue<T> template specializations (bool→"true"/"false", %d/%.3g/%llu variants); createChildItem + createBoundChildItem<> specializations binding const refs into subclass items; TypedMemItem/TypedPercentItem referenced from header.
- ProfilingItem reflection: "GetTimes(window=0)" / "GetTimesForFrames(frames=1)" both returning Tuple{wallTime, sampleTime, frames} — **Security::Plugin**; update() formats "%s %.3g/s nom%.3g/s %.3g%%".
- RunningAverage items format "%g (%.0f%%CV)"; TimeInterval variant shows rate + %.2f%%CV.
- registerStatsClasses() guards against optimizer stripping.

## Usage / reflection touchpoints

StatsService surface is RobloxScript (core-script telemetry); Items are Plugin-readable. Pairs with [Base/rbx/TaskScheduler.cpp.md](../../Base/rbx/TaskScheduler.cpp.md) (job stats source), [App/script](../../script/) ScriptContext execution, Http util docs under App/util.

## Gotchas

- The actual HTTP POST of reports is COMMENTED OUT (deprecated TODO) — Report calls build JSON then discard it; only gameStatus/influx paths still hit network elsewhere.
- Hardcoded Influx credentials sit in DFString defaults regardless of usage.
- checkLastReport records timestamps for NEW categories even when the subsequent post is a no-op — throttle windows consume real attempts.
- JsonWriter key sanitization strips leading '$' and replaces dots, but quotes/backslashes in KEYS are unescaped (TODO in source) — malformed keys corrupt JSON.
- runScript executes REMOTE-fetched Lua at RobloxGameScript security inside VMProtect mutation — prime anti-tamper surface for the sandbox logger to observe.
