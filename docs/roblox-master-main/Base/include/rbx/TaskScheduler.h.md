# TaskScheduler.h

## Purpose
Declares RBX::TaskScheduler — the engine's cooperative job scheduler singleton. Jobs (see TaskScheduler.Job.h) are queued as sleeping/waiting intrusive lists, worker Threads pull runnable jobs via a priority policy (LastError/AccumulatedError/FIFO) or a cyclic-executive mode for frame-critical jobs. Arbiters decide job exclusivity and throttling between job families.

## API
```cpp
class TaskScheduler {
    static TaskScheduler& singleton();
    enum PriorityMethod { LastError, AccumulatedError, FIFO };
    static PriorityMethod priorityMethod;
    enum ThreadPoolConfig { PerCore4=104..PerCore1=101, Auto=0, Threads1..Threads16 };
    void setThreadCount(ThreadPoolConfig); size_t getThreadCount();
    bool shouldDropThread() const; void dropThread(Thread*);
    void add(shared_ptr<Job>); void reschedule(shared_ptr<Job>);
    void remove(shared_ptr<Job>);                 // may deadlock
    void removeBlocking(shared_ptr<Job>);         // joins job
    void removeBlocking(shared_ptr<Job>, function<void()> callbackPing); // pings during wait
    void getJobsInfo(vector<shared_ptr<const Job>>&); void getJobsByName(const string&, ...);
    // perf counters: numSleepingJobs/numWaitingJobs/numRunningJobs/threadAffinity/
    // threadPoolSize/schedulerRate/getSchedulerDutyCyclePerThread/getErrorCalculationRate/getSortFrequency
    rbx::atomic<int> taskCount;
    void printDiagnostics(bool aggregateJobs); void printJobs();
    void setJobsExtendedStatsWindow(double seconds);
    void cancelCyclicExecutive(); bool isCyclicExecutive(); void releaseCyclicExecutive(Job*);
    class Arbiter {  // per-job-family policy object
        virtual string arbiterName() = 0; virtual bool areExclusive(Job*, Job*) = 0;
        virtual bool isThrottled() = 0; virtual void preStep/postStep(Job*);   // ActivityMeter<2>
        double getAverageActivity(); virtual Arbiter* getSyncronizationArbiter(); virtual int getNumPlayers() const;
    };
    enum StepResult { Done, Stepped };
    // public mutable state: DataModel30fpsThrottle, lastCyclcTimestamp,
    // cyclicExecutiveWaitForNextFrame, nonCyclicJobsToDo, cyclicExecutiveLoopId
};
class ExclusiveArbiter : public Arbiter { static ExclusiveArbiter singleton; };     // any two members exclusive
class SimpleThrottlingArbiter : public Arbiter {                                    // hysteresis throttle vs cutoff = threads/arbiterCount
    static bool isThrottlingEnabled;
};
```

## Usage
The heart of frame stepping: DataModel jobs (workspace stepping, rendering prep, network) register via add(); scheduler threads (TaskScheduler.Thread.cpp) loop findJobToRun. Log groups: TaskSchedulerInit/Run/FindJob.

## Gotchas
- ThreadPoolConfig encodes PerCoreN as 101–104 and literal thread counts as 1–16 — collision-prone magic enum.
- remove() is documented deadlock-prone; removeBlocking(callbackPing) exists precisely to pump events while waiting.
- Scheduler keeps THREE job collections (allJobs std::set + intrusive sleeping/waiting lists) plus cyclicExecutiveJobs vector — all under one RBX::mutex.
- currentJob is thread_specific_reference — job identity is per-thread.
- SimpleThrottlingArbiter::isThrottled has hysteresis (1.1× cutoff to engage, 1.0× to release) and an updatingThrottle swap-guard so only one caller recomputes.
- Public mutable fields (DataModel30fpsThrottle etc.) are written by jobs without the mutex — trust-the-caller design.
