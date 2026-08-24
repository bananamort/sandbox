# App/include/v8datamodel/SleepingJob.h

## Purpose

`SleepingJob` — `DataModelJob` base for jobs that sleep between wakes: an atomic awake flag, a desired FPS, and last-wake timestamp; scheduler integration via overridden `sleepTime` (long sleep while asleep) and `error` reporting.

## Declared API

`class SleepingJob : public DataModelJob`

- Private state: `rbx::atomic<int> isAwake`, `const double desiredFps`, `RBX::Time lastWakeTime`.
- Ctor: `SleepingJob(const char* name, TaskType taskType, bool isPerPlayer, shared_ptr<RBX::DataModelArbiter> arbiter, RBX::Time::Interval stepBudget, double desiredFps)`.
- `void wake(); void sleep();`
- Overrides: `virtual RBX::Time::Interval sleepTime(const Stats&)`; `virtual RBX::TaskScheduler::Job::Error error(const Stats& stats)`.

## Gotchas

- desiredFps is const-after-ctor — per-job cadence fixed at construction.
- isAwake is atomic int (not bool) — legacy atomic style.
- Subclasses implement the actual work in DataModelJob's step hook; SleepingJob only supplies scheduling rhythm.

## UNKNOWN

- Exact sleep-time formula while awake vs asleep (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/SleepingJob.md](../../v8datamodel/SleepingJob.md).
- Base: [DataModelJob.md](DataModelJob.md); arbiter: [DataModel.md](DataModel.md); render-side job: [BaseRenderJob.md](BaseRenderJob.md).
