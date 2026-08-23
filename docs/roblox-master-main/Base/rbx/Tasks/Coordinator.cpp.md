# Tasks/Coordinator.cpp

## Purpose
Implements the four Coordinator policies. Barrier tracks a per-job step counter against a global counter (a job is inhibited until every other member catches up); SequenceBase rotates nextJobIndex across the registration vector; Exclusive guards a single runningJob pointer.

## API
```cpp
bool Barrier::isInhibited(Job*);      // jobs[job] > counter  => must wait for slower members
void Barrier::onPostStep(Job*);       // count==counter -> ++count; when remainingTasks hits 0, releaseBarrier()
void Barrier::releaseBarrier();       // remainingTasks = jobs.size(); counter++
void Barrier::onAdded/onRemoved(Job*);// maintain map + remainingTasks invariant
bool SequenceBase::isInhibited(Job*); // true unless job == jobs[nextJobIndex] (and index in range)
void SequenceBase::advance();         // ++nextJobIndex mod jobs.size()
void SequenceBase::onAdded/onRemoved(Job*); // vector push/erase with index fixup
bool Exclusive::isInhibited(Job*);    // any runningJob != NULL inhibits everyone else
void Exclusive::onPreStep/onPostStep; // set/clear runningJob with asserts
```

## Usage
Wired into jobs by TaskScheduler.Job.cpp: isInhibited checked at scheduling time (findJobToRun asserts !isDisabled), onPreStep/onPostStep notified under the scheduler mutex around each run, onAdded/onRemoved from add/removeCoordinator.

## Gotchas
- Barrier's onPostStep tolerates steps "slipping through the cracks" (comment): only exact count==counter advances — an over-stepped job never re-triggers release; recovery relies on other members' postSteps.
- Barrier counts REMOVED jobs that had already stepped by decrementing remainingTasks only if their count <= counter — asymmetric bookkeeping can wedge remainingTasks above reality (asserts would catch).
- Exclusive has NO mutex — relies entirely on scheduler-mutex serialization of pre/postStep and isInhibited calls; volatile pointer only.
- SequenceBase::isInhibited returns TRUE once nextJobIndex >= size (defensive; advance() wraps so unreachable normally).
- Erase-from-vector while scheduler threads hold Job* raw pointers: onRemoved does not defer destruction — caller ordering matters.
