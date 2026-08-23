# TaskScheduler.Thread.cpp

## Purpose
Defines TaskScheduler::Thread (the worker) and the scheduler methods that manage threads and per-thread job lifecycle: create/join/drop/enable/disable, the main loop (mutex → findJobToRun → run outside lock → 1 ms poll sleep), conflict checking via arbiters, cyclic-executive cancellation/release, and job-info queries.

## API
```cpp
class TaskScheduler::Thread : enable_shared_from_this<Thread> {
    shared_ptr<Job> job; volatile bool enabled;
    static shared_ptr<Thread> create(TaskScheduler*);   // spawns "Roblox TaskScheduler Thread %d"
    void end(); void join();                            // timed_join(20 s), skips self-join
    void loop(); StepResult runJob(); void releaseJob(); void printJobInfo();
};
void TaskScheduler::setThreadCount(ThreadPoolConfig);   // Auto=cores; PerCoreN=cores*N; else literal
bool TaskScheduler::conflictsWithScheduledJob(Job*) const; // same sync-arbiter domain + areExclusive
void TaskScheduler::disableThreads(int count, Threads& out); / enableThreads(Threads&);
RBX::Time::Interval maxDutyCycleWindow;                 // DEFINED here (extern-consumed by Job ctor)
void TaskScheduler::setJobsExtendedStatsWindow(double); void cancelCyclicExecutive();
void TaskScheduler::releaseCyclicExecutive(Job*); getJobsInfo/getJobsByName/printJobs/endAllThreads
```
JOIN_TIMEOUT = 20 s. Log groups re-declared: FLog::TaskSchedulerRun, FLog::TaskSchedulerFindJob.

## Usage
The scheduler heartbeat: each Thread::loop iteration takes the singleton mutex, finishes previous job bookkeeping, picks a new job (disabling sibling threads to grant desiredConcurrency), then runs it OUTSIDE the mutex. Idle threads Sleep(1)/usleep(1000).

## Gotchas
- Job steps run WITHOUT the scheduler mutex — all DataModel-level locking is the job's own business.
- Concurrency granting: disableThreads parks idle threads so `allotedConcurrency = parked+1`; if fewer idle threads exist than requested, job silently gets less parallelism than desired.
- runJob has NO try/catch ("If an exception is thrown here then we should abort") — a throwing step kills the process via unhandled exception on that thread.
- Thread self-removal: shouldDropThread() → dropThread(this) erases from `threads` while iterating elsewhere is possible only because drop happens under mutex with iterator-safe erase of THIS element in loop() context.
- releaseJob honors isRemoveRequested → sets joinEvent + optional cyclic release, else reschedules.
- done/enabled are plain volatile bools cross-thread — 2016-style benign-race assumption.
