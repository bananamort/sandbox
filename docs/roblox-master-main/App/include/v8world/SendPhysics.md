# App/include/v8world/SendPhysics.h

## Purpose

Networking-side scheduler of physics replication: keeps the intrusive `SimJobList` of moving assemblies and hands out SimJobs round-robin to senders via a resumable template report loop; fires assembly physics on/off signals.

## Declared API

- `class SendPhysics`
  - Signals: `rbx::signal<void(Primitive*)> assemblyPhysicsOnSignal;` / `assemblyPhysicsOffSignal;`
  - Membership: `SimJobList simJobs;` (intrusive list — see [SimJob.md](SimJob.md)); `int getNumSimJobs();` `void onMovingAssemblyRootAdded(Assembly*)` / `onMovingAssemblyRootRemoving(Assembly*)`.
  - Round-robin: `SimJob* nextSimJob(SimJob* current)` — wraps at end (asserts non-empty).
  - Template: `template<class Callback> int reportSimJobs(Callback& callback, SimJobTracker& tracker, const SimJob* ignore, int numToReport = -1)` — resumes from tracker position, skips `ignore`, calls callback per job until it returns false or count reached (`-1` = all); returns reported count. Guarded by `ReadOnlyValidator readOnlyValidator(concurrencyValidator)`.
  - Thread-safety: `mutable rbx::spin_mutex changeTrackerMutex;` wraps tracker updates.
  - Private: `buildSimJob/destroySimJob`.

## Gotchas

- The tracker persists iteration position across calls — deleting SimJobs mid-stream is only safe because trackers are re-pointed (`transferTrackers` in [SimJob.md](SimJob.md)).
- `reportSimJobs` holds a read validator: writers must not mutate the list concurrently.

## Cross-links

- Jobs: [SimJob.md](SimJob.md); producer stage: [SimulateStage.md](SimulateStage.md) (`putFirstMovingRootInSendPhysics`); assemblies: [Assembly.md](Assembly.md).
- Signal/spin mutex primitives: Base [signal.h.md](../../../Base/include/rbx/signal.h.md), [threadsafe.h.md](../../../Base/include/rbx/threadsafe.h.md).
