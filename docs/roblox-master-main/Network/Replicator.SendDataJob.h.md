# Network/Replicator.SendDataJob.h

**Module**: Network (root) · **Type**: header (.h, 186 lines)

## Purpose

Declares the two outbound DataModel jobs: `Replicator::SendDataJob` (flushes `pendingItems`/`highPriorityPendingItems` via `dataOutStep`, with an inline Windows xxhash self-integrity check feeding `HATE_XXHASH_BROKEN`) and `Replicator::SendClusterJob` (terrain flush via `clusterOutStep`, step count scaled by pending-delta estimate). Both run on the cyclic executive at the settings' data send rate with VMProtect mutation regions "21" (data).

## API

```cpp
DFInt::MaxDataStepsPerCyclic(5), MaxDataStepsAccumulated(15),
DFInt::MaxClusterSendStepsPerCyclic(5), MaxClusterSendStepsAccumulated(15),
DFInt::MaxDataOutJobScaling(10)

class Replicator::SendDataJob : public ReplicatorJob {
    const ObscureValue<float> dataSendRate;  const PacketPriority packetPriority;
    SendDataJob(Replicator&);                // CyclicExecutivePriority_Network_ProcessOutgoing
    Error error(const Stats&);               // queue-wait based (see Replicator.cpp)
    TaskScheduler::StepResult stepDataModelJob(const Stats&);
};

class Replicator::SendClusterJob : public ReplicatorJob {   // same shape; delta-ratio multiplier
    ObscureValue<float> dataSendRate;
    ...
};
```

## Usage

Created per replicator in `onServiceProvider`; error metrics documented in `Replicator.cpp` (`SendDataJob::error`/`SendClusterJob::error`).

## Gotchas

- The xxhash check hashes a string-table-obfuscated constant ("STRING_BY_ID(HasGamePassLuaWarning)") against two golden values every ~`dataSendRate` steps — deliberately exercising all XXH32 branches to detect patched hash code.
- Data steps scale with queued item count (×count/2, capped at MaxDataOutJobScaling) — burst catch-up after a stall.
- Exceptions in either job end the job (`TaskScheduler::Done`) after logging; disconnect is handled inside `dataOutStep`/`clusterOutStep`.
