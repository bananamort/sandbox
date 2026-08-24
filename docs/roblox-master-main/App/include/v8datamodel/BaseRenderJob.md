# App/include/v8datamodel/BaseRenderJob.h

## Purpose

Abstract base for all rendering jobs: extends [DataModelJob](DataModelJob.md) with frame-rate bounds, wake/sleep tracking, and time-since-last-render bookkeeping used by the task scheduler's error/step decisions.

## Declared API

`class BaseRenderJob : public DataModelJob`

- Constructor: `BaseRenderJob(double minFrameRate, double maxFrameRate, boost::shared_ptr<DataModel> dataModel);`
- Virtuals: `void wake();` `bool tryJobAgain();` `bool isCyclicExecutiveJob();` `Time::Interval timeSinceLastRender() const;` `Job::Error error(const Stats& stats);` `TaskScheduler::StepResult step(const Stats& stats);`
- Commented out: `virtual RBX::TaskScheduler::StepResult stepDataModelJob(const Stats&);`
- Protected state: `Time lastRenderTime; volatile bool isAwake; double minFrameRate; double maxFrameRate;`

## Gotchas

- `isAwake` is `volatile`, not atomic — single-writer assumption baked in.
- Frame-rate bounds are constructor-injected; no accessors in the header.
- Class comment states its role verbatim: "This is the base class for all Rendering Jobs."

## UNKNOWN

- Scheduler policy mapping of min/maxFrameRate to `error()` verdicts (see [BaseRenderJob.md](../../v8datamodel/BaseRenderJob.md)).

## Cross-links

- Implementation: [App/v8datamodel/BaseRenderJob.md](../../v8datamodel/BaseRenderJob.md).
- Base: [DataModelJob.md](DataModelJob.md); sibling jobs in DataModel.h family.
