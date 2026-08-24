# Network/Replicator.PingJob.h

**Module**: Network (root) · **Type**: header (.h, 65 lines)

## Purpose

Declares `Replicator::PingJob`, the DataModel job that emits data-channel pings at 2 Hz (max 5 per catch-up step), and on RCC builds also drives `sendNetPmcChallenge()` each tick. Entire step body is wrapped in VMProtect mutation "20".

## API

```cpp
class Replicator::PingJob : public ReplicatorJob {
    static const int desiredPingHz = 2;
    static const int maxPingsPerStep = 5;
    PingJob(Replicator&);                       // cyclic executive, DataIn task type
    Time::Interval sleepTime(const Stats&);     // 2 Hz
    Error error(const Stats&);
    TaskScheduler::StepResult stepDataModelJob(const Stats&);
};
```

## Usage

Created/registered per replicator in `Replicator::onServiceProvider`; catch-up math via `updateStepsRequiredForCyclicExecutive`.

## Gotchas

- Under RCC security the NetPmc challenge pump lives here — disabling pings would also stall memory-check challenges.
- The job holds a `scoped_write_request` per ping batch, so pings contend with gameplay writes.
