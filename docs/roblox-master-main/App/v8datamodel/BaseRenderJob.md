# BaseRenderJob.cpp

## Purpose

Implements `BaseRenderJob` — the TaskScheduler DataModelJob base for rendering ("Render", Render duty, 20 ms target interval). Encapsulates the cyclic-executive vs standard scheduling decision and the min/max FPS error policy, with an intentional choice to render EARLY in each cycle for visual stability at the cost of input latency.

## Key types and API

No descriptors, no class-name constant (non-Instance job object).

- ctor `BaseRenderJob(minFps, maxFps, shared_ptr<DataModel>)` — `RBX::DataModelJob("Render", DataModelJob::Render, false, dataModel, Time::Interval(.02))`; starts awake; `cyclicExecutive = true`.
- `cyclicPriority = CyclicExecutiveJobPriority_EarlyRendering` with source comment: running after Network/Physics "introduced a weird variability into the dt between each RenderJob::step"; first-in-cycle grants "more visual stability at the cost of potentially some latency in input".
- `wake()` — sets isAwake; non-cyclic jobs reschedule via `TaskScheduler::singleton().reschedule(shared_from_this())`.
- `tryJobAgain()` — cyclic + asleep → true (asks scheduler for another slice).
- `error(Stats)` — asleep + non-cyclic → no error; cyclic → `computeStandardError(stats, maxFrameRate)`, else `computeStandardError(stats, minFrameRate)`.
- `timeSinceLastRender()` — now − lastRenderTime.
- `step(Stats)` — `Profiler::onFrame()` then defers to `DataModelJob::step`.

## Usage / reflection touchpoints

Base for the concrete render loop; scheduling peers documented via [DataModelJob](DataModelJob.md) and [SleepingJob](SleepingJob.md); profiler integration noted in Stats.md-adjacent tooling.

## Gotchas

- The min/max FPS parameters swap MEANING by scheduler mode: maxFrameRate drives error under cyclic executive, minFrameRate otherwise.
- wake() on a cyclic job only flips a flag — the cyclic scheduler picks it up on its own cadence; rescheduling happens exclusively for non-cyclic mode.
- 20 ms interval is a target, not a cap; actual pacing comes from the Job::Error feedback.
