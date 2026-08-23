# TaskScheduler.Job.cpp

## Purpose
Implements TaskScheduler::Job bookkeeping: state transitions (startWaiting/startSleeping/preStep/postStep), running-average stats (duty cycle, sleep rate, error), the standard error/sleep-time math used by typical jobs, coordinator notification, and priority computation under the three PriorityMethods.

## API
Key implementations (signatures per TaskScheduler.Job.h):
```cpp
static double throttledSleepTime = 0.01;                 // min sleep when arbiter is throttled
static SleepAdjustMethod sleepAdjustMethod = AverageInterval;
Error  computeStandardError(stats, desiredHz);           // timespanSinceLastStep * desiredHz
Error  computeStandardErrorCyclicExecutiveSleeping(...); // zero-out error <0.98 while cyclic-executive sleeping
Interval computeStandardSleepTime(stats, desiredHz);     // interval - timespanSinceLastStep, floor=throttledSleepTime
void preStep();   // state=Running; FASTLOG JobStart; arbiter->preStep
void postStep(StepResult); // records timespanOfLastStep, samples dutyCycle(+window), arbiter->postStep, state=Unknown
void updatePriority();     // FIFO:1.0 | LastError:error | AccumulatedError:(avg||err)*factor/max(0.01,dutyCycle)
```
Log group declared: FLog::TaskSchedulerSteps.

## Usage
Linked into every binary that runs jobs; jobs across DataModel/physics/rendering/network rely on computeStandard* helpers instead of rolling their own cadence math. The extern `RBX::Time::Interval maxDutyCycleWindow` is DEFINED in TaskScheduler.cpp and read at Job construction — cross-TU init-order dependency.

## Gotchas
- postStep's over-budget branch is an EMPTY if-body ("We were over budget") — stepBudget enforcement never implemented.
- HANG_DETECTION block includes `../../App/include/util/standardout.h` by a relative path OUTSIDE Base — an upward App-tree dependency, compiled out today.
- AccumulatedError priority divides by max(0.01, averageDutyCycle()) — low-duty-cycle jobs get boosted; chatty jobs sink (deliberate anti-starvation inversion).
- computeStandardSleepTime returns no sleep when the actual interval exceeds 1.05×desired — late jobs run back-to-back to catch up.
- Coordinator callback asymmetry: removeCoordinator calls onRemoved BEFORE erasing; addCoordinator calls onAdded AFTER inserting — reentrant callbacks see different list states.
- Destructor asserts neither intrusive hook is linked — destroying a queued job without TaskScheduler::remove trips RBXASSERT.
