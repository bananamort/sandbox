# Tasks/Coordinator.h

## Purpose
Declares Tasks::Coordinator and four concrete coordination policies that constrain HOW attached TaskScheduler jobs run: Exclusive (never parallel), Barrier (all coordinated jobs must complete a round before any starts the next), Sequence (must start in registration order, may overlap), ExclusiveSequence (strict order, no overlap). Jobs attach coordinators via Job::addCoordinator.

## API
```cpp
namespace RBX::Tasks {
class Coordinator {   // contract: implementations must be thread-safe
    virtual bool isInhibited(Job*) = 0;      // scheduler consults before granting run
    virtual void onPreStep/onPostStep/onAdded/onRemoved(Job*) {}
};
class Exclusive : Coordinator        { volatile Job* runningJob; isInhibited/preStep/postStep; };
class Barrier : Coordinator          { unsigned counter, remainingTasks; mutex; map<Job*,unsigned> jobs; releaseBarrier(); };
class SequenceBase : Coordinator     { unsigned nextJobIndex; mutex; vector<Job*> jobs; protected advance(); };
class Sequence : SequenceBase        { onPreStep -> advance(); };            // start-order only
class ExclusiveSequence : SequenceBase { onPostStep -> advance(); };        // order + exclusivity
}
```

## Usage
Included by rbx/TaskScheduler.Job.h; implemented in rbx/Tasks/Coordinator.cpp. Header comment notes a Coordinator "affects execution order but not parallelism" and that resource locks are better done by specializing the scheduler (see DataModel scheduler).

## Gotchas
- isInhibited is called under the scheduler mutex from findJobToRun — coordinator internal locks nest inside it.
- Sequence vs ExclusiveSequence distinction is WHERE advance() happens: pre-step (allow overlap of Nth with N+1th start) vs post-step (fully serialized).
