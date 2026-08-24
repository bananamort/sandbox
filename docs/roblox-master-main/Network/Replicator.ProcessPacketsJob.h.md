# Network/Replicator.ProcessPacketsJob.h

**Module**: Network (root) · **Type**: header (.h, 147 lines)

## Purpose

Declares `Replicator::ProcessPacketsJob`, the incoming-side DataModel job: under a `scoped_write_request` it loops `Replicator::processNextIncomingPacket()` within a time budget scaled by queue depth, then calls `postProcessPacket()` (client streaming capacity update). Error/sleep metrics are driven by queue length and head wait time.

## API

```cpp
DFInt::MaxWaitTimeBeforeForcePacketProcessMS(0), MaxProcessPacketsStepsPerCyclic(5),
MaxProcessPacketsStepsAccumulated(15), MaxProcessPacketsJobScaling(10)

class Replicator::ProcessPacketsJob : public ReplicatorJob {
    ProcessPacketsJob(Replicator&);      // CyclicExecutivePriority_Network_ProcessIncoming
    void wake();  void sleep();          // atomic isAwake; used for debugging/tests
    Time::Interval sleepTime(const Stats&);   // receive-rate when packets pending else 0.1s
    Error error(const Stats&);                // 1.0 when cyclic+queued, else wait-time or count based
    TaskScheduler::StepResult stepDataModelJob(const Stats&);
};
```

## Usage

Registered per replicator; rescheduled by `pushIncomingPacket` when non-cyclic. During join (`processAllPacketsPerStep=true`, set in ClientReplicator ctor) it drains everything per step subject to `MaxNetworkReadTimeInCS`; afterwards each step processes a time slice unless head-of-queue age exceeds `MaxWaitTimeBeforeForcePacketProcessMS`.

## Gotchas

- The job takes a DataModel **write** request per step — every inbound replication item applies under exclusive lock.
- Budget formula: `processTimeScale * (0.5 / receiveRate)` seconds where scale = min(MaxProcessPacketsJobScaling, steps × min(5, queueDepth)).
