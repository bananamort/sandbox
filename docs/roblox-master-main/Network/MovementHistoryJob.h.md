# Network/MovementHistoryJob.h

**Module**: Network (root) · **Type**: header (.h, 32 lines)

## Purpose

Declares `MovementHistoryJob`, a `DataModelJob` that periodically updates the Workspace's movement history (used by anti-cheat/movement analysis on the server). Holds a weak reference to the DataModel and a 20 Hz target rate.

## API

```cpp
class MovementHistoryJob : public DataModelJob {
public:
    MovementHistoryJob(shared_ptr<DataModel> dataModel);
private:
    /*override*/ virtual Error error(const Stats& stats);
    /*override*/ Time::Interval sleepTime(const Stats& stats);
    /*override*/ virtual TaskScheduler::StepResult stepDataModelJob(const Stats& stats);
    boost::weak_ptr<DataModel> dataModel;
    float movementHistoryRate;   // initialized to 20
};
```

## Usage

Constructed by server setup code and registered with the task scheduler; runs in the cyclic executive at `CyclicExecutiveJobPriority_Network_ProcessIncoming`.

## Gotchas

- The step body is explicitly marked `bool deprecated = true; RBXASSERT(!deprecated);` — the job still runs in release builds but trips asserts in debug/test builds.
- Write-priority job (`DataModelJob::Write`): takes a scoped write request on the DataModel each step.
