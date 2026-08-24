# SleepingJob.cpp

## Purpose

Implements `SleepingJob`, a TaskScheduler DataModelJob base for work that should run only on demand: stays asleep (`sleepTime` = Interval::max) until `wake()` reschedules it, then runs at its desired fps until told to sleep. Used by periodic-but-idle services.

## Key types and API

- Ctor(name, taskType, isPerPlayer, arbiter, stepBudget, desiredFps): forwards to DataModelJob, isAwake=false.
- `wake()`: atomic compare-and-swap 0→1; on first winner stamps lastWakeTime (Fast clock) and calls `TaskScheduler::singleton().reschedule(shared_from_this())`. Losers no-op — single-flight wakeup.
- `sleep()`: clears isAwake (job's sleepTime then parks it indefinitely).
- `sleepTime(Stats)`: 0 when awake else Interval::max.
- `error(Stats)`: asleep ⇒ default Error (no urgency); awake ⇒ clamps fakedStats.timespanSinceLastStep to time-since-wake so the job doesn't look starved after long sleep, then computeStandardError vs desiredFps.

## Usage / reflection touchpoints

No reflection. Pairs with [Base/rbx/TaskScheduler.cpp.md](../../Base/rbx/TaskScheduler.cpp.md) and DataModelJob semantics documented there.

## Gotchas

- wake() before first sleep works (isAwake starts false); double-wake between CAS and reschedule collapses to one reschedule by design.
- error() FAKES stats timespan — scheduler fairness metrics during the first interval after wake are synthetic.
- sleep() doesn't deschedule an already-queued step; one extra step can still run.
