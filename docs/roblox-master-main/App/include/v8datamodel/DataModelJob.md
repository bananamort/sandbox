# App/include/v8datamodel/DataModelJob.h

## Purpose

Scheduler contract for jobs that touch the DataModel: `DataModelJob` (a TaskScheduler::Job with a TaskType access class) and `DataModelArbiter` (a SimpleThrottlingArbiter deciding which task types can run concurrently via a per-model lookup table).

## Declared API

`class DataModelJob : public TaskScheduler::Job`

- `enum TaskType { Read=0, Write, Render, Physics, DataOut, PhysicsOut, PhysicsOutSort, DataIn, PhysicsIn, RaknetPeer, None, TaskTypeMax };` — comments: Read = "general read-only access to the DataModel", Write = "general read-writes access". `static const int TaskTypeCount = TaskTypeMax;`
- Public member: `TaskType taskType;` `virtual TaskScheduler::StepResult step(const Stats& stats);`
- Protected contract: pure virtual `stepDataModelJob(const Stats&)`; tunable `virtual double updateStepsRequiredForCyclicExecutive(float stepDt, float desiredHz, float maxStepsPerCycle, float maxStepsAccumulated);` state `double stepsAccumulated; const bool isPerPlayer; unsigned long long profilingToken;`
- Constructor: `DataModelJob(const char* name, TaskType taskType, bool isPerPlayer, shared_ptr<DataModelArbiter> arbiter, Time::Interval stepBudget);`
- `/*implement*/ double getPriorityFactor();`

`class DataModelArbiter : public SimpleThrottlingArbiter`

- `enum ConcurrencyModel { Serial=0, Safe, Logical, Empirical };` `static const int ConcurrencyModelCount = 4; static ConcurrencyModel concurrencyModel;`
- `DataModelArbiter(); virtual ~DataModelArbiter();`
- Exclusivity: `virtual bool areExclusive(TaskScheduler::Job* j1, Job* j2); bool areExclusive(TaskType t1, TaskType t2);` backed by private `bool lookup[ConcurrencyModelCount][TaskTypeCount][TaskTypeCount];`
- Pure virtual `int getNumPlayers() const;`
- Hooks: `virtual void preStep(Job*); virtual void postStep(Job*);`

Log group declared: `LOGGROUP(DataModelJobs)`.

## Gotchas

- The 3-D lookup table is the whole concurrency policy — contents set at runtime (.cpp), model selectable via static `concurrencyModel`.
- TaskType list is serialized into job naming/telemetry; appending only.
- `step()` wraps the pure-virtual stepDataModelJob — subclasses implement the latter, not the former.

## UNKNOWN

- Which TaskType pairs each ConcurrencyModel marks exclusive (.cpp tables — see [DataModelJob.md](../../v8datamodel/DataModelJob.md)).

## Cross-links

- Implementation: [App/v8datamodel/DataModelJob.md](../../v8datamodel/DataModelJob.md).
- Owner: [DataModel.md](DataModel.md); render subclass [BaseRenderJob.md](BaseRenderJob.md); kin [SleepingJob.md](SleepingJob.md) (N–Z half).
