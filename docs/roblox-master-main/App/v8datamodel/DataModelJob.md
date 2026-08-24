# DataModelJob.cpp

## Purpose

Implements `DataModelJob` — the TaskScheduler Job base class for everything that runs against a DataModel arbiter, carrying a TaskType and the cyclic-executive fractional-step accumulator — plus `DataModelArbiter`, whose 4-model × TaskType×TaskType exclusivity lookup tables define which job pairs may run in parallel.

## Key types and API

Descriptors: none. Enum registered "ConcurrencyModel": Serial, Safe, Logical (STATIC DEFAULT), Empirical.

DataModelJob:
- ctor `(name, taskType, isPerPlayer, arbiter, stepBudget)` — asserts arbiter; RBXPROFILER token per job name.
- `step(Stats)` — profiler scope then pure-virtual `stepDataModelJob`.
- `updateStepsRequiredForCyclicExecutive(stepDt, desiredHz, maxStepsPerCycle, maxStepsAccumulated)` — fractional accumulator: floor(desired+carried), clamp to per-cycle max, carry remainder clamped to accumulated max; ≤0 → 0 steps.
- `getPriorityFactor()` — isPerPlayer ? 1 : max(1, arbiter player count) (per-player jobs don't scale with population).

DataModelArbiter:
- `areExclusive(job1, job2)` / `(type1, type2)` — table lookup `[concurrencyModel][f1][f2]`.
- Table construction: Serial = ALL exclusive; Safe opens PhysicsOut↔PhysicsOut, DataOut↔DataOut, None↔everything, RaknetPeer with everything except Write/Physics/RaknetPeer, PhysicsOutSort with everything except PhysicsOut; Logical additionally opens Read↔Read/DataOut/PhysicsOut and DataOut↔PhysicsOut — Render kept exclusive everywhere ("Render can modify the Camera", "currently makes changes to the DataModel"); Empirical = copy of Logical with its two extra openings COMMENTED OUT (so identical to Logical).
- preStep/postStep tick an activityMeter.

## Usage / reflection touchpoints

Base for [BaseRenderJob](BaseRenderJob.md) ("Render"), DataModel's GenericJobs ([DataModel](DataModel.md)), and the physics/network jobs; consumers via TaskScheduler singleton.

## Gotchas

- Empirical mode is dead-equivalent to Logical — both of its distinguishing setConcurrent calls are commented out.
- The concurrency tables are built ONCE per process in the arbiter ctor; changing static concurrencyModel afterwards still re-reads the same prebuilt rows (all four are always constructed).
- Comment notes ~DataModelArbiter "does not get called closing a place in Studio" — arbiter lifetime differs between shells.
