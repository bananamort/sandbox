# App/include/v8datamodel/DebugSettings.h

## Purpose

Two advanced-settings items under the GlobalSettings tree: `DebugSettings` — machine/perf introspection (CPU/GPU/OS facts, memory and job counters, CDN stats, error-reporting mode, time-override) — and `TaskSchedulerSettings` — live knobs for the task scheduler (thread pool, priority/sleep methods, arbiter throttling, concurrency model). Comment: "A generic mechanism for displaying stats (like 3D FPS, network traffic, etc.)"

## Declared API

`class DebugSettings : public GlobalAdvancedSettingsItem<DebugSettings, sDebugSettings>`

- State: private `bool stackTracingEnabled; float pixelShaderModel, vertexShaderModel; bool reportExtendedMachineConfiguration;` public raw members `bool soundWarnings, fmodProfiling, enableProfiling; ErrorReporting errorReporting; bool blockingRemove;`
- `enum ErrorReporting { DontReport, Prompt, Report };`
- Statics: `std::string robloxVersion; std::string robloxProductName;` BoundProps `prop_stackTracingEnabled`, `prop_reportExtendedMachineConfiguration`, `prop_ioEnabled`.
- Toggles: Lua RAM limit (`getLuaRamLimit/setLuaRamLimit(int)`), block-mesh map count getter, profiling (`getIsProfilingEnabled/setIsProfilingEnabled`, window get/set double), error reporting enum, `noOpt() {}` (anti-optimization anchor), `Time::SampleMethod getTickCountPreciseOverride()/setTickCountPreciseOverride(...)` reading/writing the global `Time::preciseOverride`.
- Machine info: videoMemory() MBytes, cpuSpeed() MHz, cpuCount(), systemProductName/osVer/osPlatformId/osPlatform/deviceName/gfxcard/cpu/simd strings, totalPhysicalMemory/availablePhysicalMemory, resolution(), osIs64Bit().
- Perf counters: nameDatabase size/bytes, processCores, elapsed time, processor times, private bytes / working set / virtual bytes / page-file bytes / page faults per second, instance/job/player/DataModel counts via Countable singletons, CDN success/failure counters (+alternate CDN), last failure timespan, Roblox success/failure/response getters (`getRobloxFalureCount`, `getRobloxResponce`, `getCdnRespoce` — typos verbatim), `resetCdnFailureCounts()` → Tuple.

`class TaskSchedulerSettings : public GlobalAdvancedSettingsItem<TaskSchedulerSettings, sTaskSchedulerSettings>`

- Read-only gauges off TaskScheduler singleton: threadPoolSize, threadAffinity, numSleepingJobs/WaitingJobs/RunningJobs, schedulerRate, schedulerDutyCyclePerThread.
- Knobs: `addDummyJob(bool exclusive, double fps)`; arbiter throttling toggle (`getIsArbiterThrottled` reads static `SimpleThrottlingArbiter::isThrottlingEnabled`); throttledJobSleepTime (static Job member); priority method + sleep adjust method setters; thread pool config get/set; `setThreadShare(double timeSlice, int divisor)`; concurrency model get/set against static `DataModelArbiter::concurrencyModel`.

## Gotchas

- These settings mutate *global* scheduler state (statics on TaskScheduler/SimpleThrottlingArbiter/DataModelArbiter).
- Version getters RBXASSERT non-empty — reading before init asserts.
- Several typo'd accessor names are API surface (Falure, Responce, Respoce).
- blockingRemove is a plain public field with an inline setter — no property descriptor here.

## UNKNOWN

- Where these settings serialize/persist (GlobalAdvancedSettingsItem plumbing — see [DebugSettings.md](../../v8datamodel/DebugSettings.md)).

## Cross-links

- Implementation: [App/v8datamodel/DebugSettings.md](../../v8datamodel/DebugSettings.md).
- Settings base: [GlobalSettings.md](GlobalSettings.md); scheduler kin: [DataModelJob.md](DataModelJob.md), [SleepingJob.md] (T–Z half).
