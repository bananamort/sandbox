# TaskScheduler.Job.h

## Purpose
Declares TaskScheduler::Job — the abstract unit of scheduler work. Subclasses implement sleepTime/error/step plus priority factor; the base handles state machine (Sleeping/Waiting/Running), duty-cycle/sleep/error running averages, arbiter attachment, coordinators (Tasks::Coordinator hooks), and cyclic-executive priority. Every engine subsystem heartbeat (physics, render, network, scripting) derives from this.

## API
```cpp
enum CyclicExecutiveJobPriority { EarlyRendering, Network_ReceiveIncoming, Network_ProcessIncoming,
                                  Default, Physics, Heartbeat, Network_ProcessOutgoing, Render };
class TaskScheduler::Job : noncopyable, enable_shared_from_this, Countable<Job>, SleepingHook, WaitingHook {
    Job(const char* name, shared_ptr<Arbiter>, Time::Interval stepBudget = 0);  // protected; budget 0 == none
    virtual ~Job();
    // subclass contract:
    virtual Time::Interval sleepTime(const Stats&) = 0;   // >0 -> sleeps
    virtual Error error(const Stats&) = 0;                // error==0 -> not scheduled
    virtual bool tryJobAgain();                           // cyclic-executive retry hook
    virtual double getPriorityFactor() = 0;
    virtual StepResult step(const Stats&) = 0;            // Done | Stepped
    virtual int getDesiredConcurrencyCount() const;       // >1 => parallel work; read allotedConcurrency in step
    // helpers:
    Error computeStandardError(const Stats&, double desiredHz);
    Error computeStandardErrorCyclicExecutiveSleeping(const Stats&, double desiredHz);
    Time::Interval computeStandardSleepTime(const Stats&, double desiredHz);
    // introspection:
    State getState() const;      // Unknown/Sleeping/Waiting/Running
    Time getWakeTime/getWake(); double getPriority();
    Time::Interval getSleepingTime() const; double averageDutyCycle/averageSleepRate/
        averageStepsPerSecond/averageStepTime/averageError() const;
    const RunningAverageDutyCycle<>& getStepStats(); WindowAverageDutyCycle<>& getDutyCycleWindow();
    bool isRunning/isDisabled(); string getDebugName();   // "ArbiterName:jobName"
    void addCoordinator/removeCoordinator(shared_ptr<Tasks::Coordinator>);
    struct Stats { Stats(Job&, Time now); timeNow; timespanSinceLastStep; timespanOfLastStep; };
    struct Error { double error; bool urgent; };          // urgent bumps priority (anti-UI-deadlock)
    static double throttledSleepTime; enum SleepAdjustMethod {None, LastSample, AverageInterval};
    static SleepAdjustMethod sleepAdjustMethod; static bool isLowerWakeTime(a,b);
};
```

## Usage
Subclassed across the engine (DataModel jobs, physics pipeline, rendering, network steps). Scheduling math lives here so jobs only express intent (desired Hz, error).

## Gotchas
- HANG_DETECTION is #defined to 0 — overStepTimeThresholdCount machinery compiled out.
- Job holds arbiter three ways (shared_ptr const, weak_ptr const, bald pointer const) — lifetime games: bald pointer for fast compare, weak for outliving arbiters.
- `urgent` Errors are an "experimental feature to prevent UI deadlocks"; generic jobs flagged urgent for Cyclic Executive per comment on isDefault().
- lastThreadUsed weak_ptr drives thread-affinity reuse of worker threads.
- joinEvent set by TaskScheduler when removing with join — external code waits on it.
