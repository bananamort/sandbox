# App/script/ScriptStats.cpp

## Purpose

Implements `ScriptStats` (per-hash script activity accounting used by GetScriptStats reflection functions) and `LuaStatsItem` (the stats-service tree node exposing live VM counters). Activity is tracked as a stack of currently-running script hashes so nested resumes attribute time correctly.

## API

- `ScriptStats::ScriptStats()` — empty.
- `void ScriptStats::stopCollection(const std::string& scriptHash)` — decrements `scriptActivityMap[hash].activity`; missing entry tolerated ("We lost this sample somehow").
- `void ScriptStats::startCollection(const std::string& scriptHash, bool firstTime)` — creates `{ boost::shared_ptr<ActivityMeter<2>> activity, boost::shared_ptr<InvocationMeter<2>> invocations }` on first sight, increments activity always and invocations when firstTime.
- `void ScriptStats::scriptResumeStarted(const std::string& scriptHash)` — stops the hash currently on top of `scriptStack`, starts collection for the new hash, pushes it.
- `void ScriptStats::scriptResumeStopped(const std::string& scriptHash)` — asserts top == scriptHash, stops/pops, restarts collection for the restored top (firstTime=false).
- `void LuaStatsItem::init()` — creates bound child items "disabled" (scriptContext->scriptsDisabled), int item "threads" (`ScriptContext::getThreadCount`), rate items "ThreadsResumed"/"ThreadsThrottled" (scriptContext->resumedThreads / throttlingThreads meters), "AverageGcInterval"/"AverageGcTime".
- `void LuaStatsItem::update()` — formats GC interval/time ("%.2f msec", "%.4f msec") and resumed-thread rates from the context's sampled meters.

## Usage

Driven by `ScriptContext::resume(ThreadRef,int)` around every resumeImpl (scriptResumeStarted/stopped keyed by `script->requestHash()`); enabled/disabled via `SetCollectScriptStats` (creates/destroys the ScriptStats object when StatsService exists). Aggregated results are read back by `getScriptStats/getScriptStatsTyped/getScriptStatsNew` in App/script/ScriptContext.cpp. LuaStatsItem is parented under StatsService in `ScriptContext::onServiceProvider`.

## Gotchas

- Attribution is stack-based: a yield inside script A that later resumes B pushes/pops correctly, but an unbalanced stop (exception paths skipping scriptResumeStopped) would corrupt the stack — the asserts fire only in debug.
- Meters are templated <2> (two-second windows per the meter template elsewhere); invocations count only first-time starts per resume chain, so recursive re-entry within one chain counts once.
- All aggregation keys are content hashes (requestHash), identical sources merge across instances — name/count columns in stats output come from ScriptContext::scriptHashInfo, not from this file.
