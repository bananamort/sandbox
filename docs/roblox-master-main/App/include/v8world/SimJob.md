# App/include/v8world/SimJob.h

## Purpose

One SimJob = one moving Assembly queued for physics replication. Provides the intrusive-list hook (`SimJobHook`/`SimJobList`) used by [SendPhysics.md](SendPhysics.md), plus `SimJobTracker` — a safe cursor that follows its job across list mutations.

## Declared API

- Typedefs: `SimJobHook = boost::intrusive::list_base_hook<tag<SimJob>>;` `SimJobList = boost::intrusive::list<SimJob, base_hook<SimJobHook>>;`
- `class SimJobTracker`
  - Members: `SimJob* simJob;` private `containedBy(SimJob*)`, `stopTracking()`.
  - Ctor NULL-init; dtor stops tracking (unregisters from the job).
  - `bool tracking();` `void setSimJob(SimJob*);` `SimJob* getSimJob();` static `transferTrackers(SimJob* from, SimJob* to)`.
- `class SimJob : public boost::noncopyable, public SimJobHook`
  - Public member: `int useCount;`
  - `SimJob(Assembly* assembly); ~SimJob();`
  - `Assembly* getAssembly()` / const.
  - Statics: `getSimJobFromPrimitive(Primitive*)` / const — via Assembly's simJob slot.

## Gotchas

- Trackers form a back-pointer vector on each job ("usually empty, or have one tracker") — jobs must route destruction through tracker cleanup or cursors dangle.
- Non-copyable; intrusive identity semantics.

## Cross-links

- Consumer: [SendPhysics.md](SendPhysics.md); owner slot: [Assembly.md](Assembly.md) (`setSimJob/getSimJob`); stage: [SimulateStage.md](SimulateStage.md).
