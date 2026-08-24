# DebugSettings.cpp

## Purpose

Implements `DebugSettings` (instance name "Diagnostics") and `TaskSchedulerSettings` ("Task Scheduler") — the diagnostics singletons: machine/GPU/OS profile read-only props, perf-counter props, CDN/Roblox HTTP counters with reset Tuple, error-reporting + stack-tracing toggles, profiling switches, Lua RAM limit, and scheduler configuration enums whose SETTERS ARE MOSTLY NO-OPS in this build.

## Key types and API

Enums registered: "ThreadPoolConfig" {Auto, PerCore1-4, Threads1/2/3/4/8/16, legacy 201 "PartialThread"→Auto}, "PriorityMethod" {LastError, AccumulatedError, FIFO}, "SleepAdjustMethod" {None, LastSample, AverageInterval}, "ErrorReporting" {DontReport, Prompt, Report}, "EnviromentalPhysicsThrottle" {DefaultAuto, Disabled, Always, Skip2/4/8/16 — note misspelled descriptor name}, "TickCountSampleMethod" {Fast, Benchmark, Precise}.

DebugSettings descriptors by category:
- "Profile" (read-only): RobloxVersion, RobloxProductName, VertexShaderModel/PixelShaderModel floats, VideoMemory, CpuSpeed (**always 0**), CpuCount (**always 1**), OsPlatformId/OsPlatform/OsVer/OsIs64Bit, SystemProductName (Windows registry BIOS key), GfxCard, CPU (empty string), SIMD, RAM + alias TotalPhysicalMemory (**always 0**), Resolution (empty).
- "Performance": NameDatabaseSize/Bytes, AvailablePhysicalMemory(0), ElapsedTime, ProcessCores, TotalProcessorTime/ProcessorTime/PrivateBytes/PrivateWorkingSetBytes/VirtualBytes/PageFileBytes/PageFaultsPerSecond (Win: CProcessPerfCounter; POSIX: getrusage approximations), InstanceCount, PlayerCount, DataModel, JobCount, CDN counters (CdnSuccess/FailureCount, AltCdn*, RobloxSuccess/FalureCount [sic], RobloxRespoceTime/CdnResponceTime averages), LastCdnFailureTimeSpan.
- `func_ResetCdnFailureCounts("ResetCdnFailureCounts", Security::LocalUser)` — 9-value Tuple of swapped counters + cleared averages.
- "Errors": prop_SoundWarnings("ReportSoundWarnings"), prop_errorReporting("ErrorReporting", default Report = silently report), DebugSettings::prop_stackTracingEnabled("IsScriptStackTracingEnabled", default true), prop_reportExtendedMachineConfiguration("ReportExtendedMachineConfiguration", default false); `func_LegacyScriptMode("LegacyScriptMode", LocalUser, deprecated)` → noOpt; `func_BlockingRemove("SetBlockingRemove", LocalUser)`.
- "Benchmarking": prop_Profiling("IsProfilingEnabled"), prop_ProfilingWindow, prop_PrecisionOverride("TickCountPreciseOverride"), prop_IsFmodProfilingEnabled.
- "Limits": prop_LuaRamLimit("LuaRamLimit") — reads/writes static `LuaAllocator::heapLimit`.

TaskSchedulerSettings descriptors:
- "Diagnostics" read-only: ThreadPoolSize, ThreadAffinity, NumSleepingJobs/WaitingJobs/RunningJobs, SchedulerRate, SchedulerDutyCycle; `func_AddDummyJob("AddDummyJob", exclusive[true], fps[30], LocalUser)` — **empty body** despite full DummyJob/DummyArbiter scaffolding compiled in.
- "Configuration": prop_ThreadPool("ThreadPoolConfig" — REAL setter calling TaskScheduler::setThreadCount), SetThreadShare (deprecated empty), PriorityMethod / SleepAdjustMethod / Concurrency("Concurrency") / AreArbitersThrottled / ThrottledJobSleepTime setters — ALL EMPTY BODIES (source comment: "The setters here no longer do anying, get rid of these TaskSchedulerSettings!"); StepTimeThreshold behind HANG_DETECTION.

Statics: robloxVersion/robloxProductName strings default "?".

## Usage / reflection touchpoints

Feeds the F9 debug console and crash reporting; counters come from Http util and Diagnostics::Countable; profiling via Profiling::setEnabled.

## Gotchas

- Most TaskScheduler Configuration setters are silent no-ops — scripts setting PriorityMethod/ConcurrencyModel get property-changed feedback but zero effect (only ThreadPoolConfig works).
- CpuSpeed/CpuCount/totalPhysicalMemory are hardcoded stubs (0/1/0) — profile reports on this build understate hardware.
- Typos preserved verbatim in registered names: "RobloxFalureCount", "RobloxRespoceTime", "CdnResponceTime", "EnviromentalPhysicsThrottle".
- AddDummyJob is exposed but does nothing; the DummyJob/DummyArbiter classes it would create are dead code here.
