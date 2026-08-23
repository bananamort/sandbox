# TaskScheduler.cpp

## Purpose
Core of the RBX::TaskScheduler singleton: construction/teardown, job add/remove/join, sleeping→waiting promotion, and job selection — both the priority-queue mode (AccumulatedError by default) and the cyclic-executive mode (frame-phased 60 Hz cadence gated by FFlag::TaskSchedulerCyclicExecutive). Also hosts diagnostics printers and defines SimpleThrottlingArbiter statics.

## API
```cpp
TaskScheduler& TaskScheduler::singleton();          // boost::call_once Meyers singleton; Auto thread count
void add(shared_ptr<Job>);                          // registers + scheduleJob or cyclic list insert (sorted by priority)
void remove(job, bool joinTask, callbackPing);      // join: 5-min cap then RBXCRASH ("thread pool locked up")
void reschedule(shared_ptr<Job>);
static bool areExclusive(Job*, Job*, arbiterHint);
void sampleRunningJobCount();                       // dedicated thread, Wait(71) ms sampling loop
shared_ptr<Job> findJobToRun(requestingThread);
shared_ptr<Job> findJobToRunNonCyclicJobs(requestingThread, now);
int  numNonCyclicJobsWithWork(); Time::Interval getShortestSleepTime() const;
void wakeSleepingJobs(); void checkStillWaitingNextFrame(Time);
void printDiagnostics(bool aggregateJobs);          // PrintTasks/PrintAggregatedTasks/PrintArbiters via printf
static PriorityMethod priorityMethod = AccumulatedError;
RBX::ExclusiveArbiter RBX::ExclusiveArbiter::singleton;      // areExclusive always true
rbx::atomic<int> SimpleThrottlingArbiter::arbiterCount;
bool SimpleThrottlingArbiter::isThrottlingEnabled = false;
```
Fast flags/ints: TaskSchedulerCyclicExecutive(false), DebugTaskSchedulerProfiling(false), TaskSchedularBatchErrorCalcFPS(300).

## Usage
Everything that steps per-frame funnels through findJobToRun (called from TaskScheduler.Thread.cpp under the scheduler mutex). nextScheduledJob caches the runner-up for a cheap next pick ("cuts scheduler time in half" per comment).

## Gotchas
- File banner says "entry point for the console application" — copy-paste from a VS template; it is a library TU.
- Cyclic executive paces frames as 1×16.0 ms + 2×17.0 ms (minFrameDelta60Hz1every3/2every3) with loopId mod 3 — 59.94-ish effective rate.
- remove-with-callbackPing spins max 10*60*5 iterations ×100 ms waits = 5 min then RBXCRASH even in release.
- updateError/updatePriority are throttled to TaskSchedularBatchErrorCalcFPS (default 300/s) via lastSortTime — stale priorities between recalcs are expected.
- Thread-affinity bias: same-thread job wins if priority×1.5 (threadAffinityPreference TODO'd as "come up with a good number") beats best.
- wakeSleepingJobs relies on sleepingJobs being sorted by wakeTime (insert_from_back keeps order); nextWakeTime updated only when scanning stops early.
- Urgent errors jump the queue ahead of throttle checks entirely.
