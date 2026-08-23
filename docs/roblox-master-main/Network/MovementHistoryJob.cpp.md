# Network/MovementHistoryJob.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 46 lines)

## Purpose

Implements `MovementHistoryJob` (see MovementHistoryJob.h): on each step it locks the DataModel via `weak_ptr`, opens a `DataModel::scoped_write_request`, and calls `Workspace::updateHistory()`.

## API

```cpp
MovementHistoryJob::MovementHistoryJob(shared_ptr<DataModel> dataModel)
    // "Movement History Job", DataModelJob::Write, cyclicExecutive=true,
    // cyclicPriority = CyclicExecutiveJobPriority_Network_ProcessIncoming,
    // movementHistoryRate = 20

Time::Interval MovementHistoryJob::sleepTime(const Stats&);   // computeStandardSleepTime @20Hz
TaskScheduler::Job::Error MovementHistoryJob::error(const Stats&); // standard cyclic-executive error
TaskScheduler::StepResult MovementHistoryJob::stepDataModelJob(const Stats&);
```

## Usage

Registered with the TaskScheduler like other DataModelJobs. If the DataModel has been destroyed (`dataModel.lock()` fails), returns `TaskScheduler::Done`.

## Gotchas

- First line of the step body: `bool deprecated = true; RBXASSERT(!deprecated);` — debug builds assert every step; the job is effectively dead code kept scheduled.
- No error handling around `getWorkspace()`; assumes Workspace exists on the DataModel.
