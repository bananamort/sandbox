# App/include/v8kernel/IStage.h

## Purpose

Base class of the kernel's linear stage pipeline: each physics pass (joints → ground → contacts → tree → moving → …→ simulate/kernel) is a stage linked upstream/downstream; `findStage` walks downstream to locate a specific stage type.

## Declared API

- `class RBXBaseClass IStage`
  - `typedef enum { CLEAN_STAGE, JOINT_STAGE, GROUND_STAGE, EDGE_STAGE, CONTACT_STAGE, TREE_STAGE, MOVING_STAGE, SPATIAL_FILTER, MECH_TO_ASSEMBLY_STAGE, ASSEMBLY_STAGE, MOVING_ASSEMBLY_STAGE, STEP_JOINTS_STAGE, HUMANOID_STAGE, SLEEP_STAGE, SIMULATE_STAGE, KERNEL_STAGE } StageType;` — 16 stages in pipeline order.
  - `IStage(IStage* upstream, IStage* downstream)`; virtual dtor **deletes downstream** (owns the tail).
  - `IStage* getUpstream();` `IStage* getDownstream()` / const overload.
  - Pure virtual `StageType getStageType() const = 0;`
  - `findStage(StageType) const → const IStage*` and non-const via const_cast — inline walk comparing `getStageType()`.
  - `virtual Kernel* getKernel()` — asserts downstream and recurses.

## Gotchas

- Ownership is one-way: deleting a stage deletes the entire downstream chain — construct pipelines head-first with care.
- `findStageImpl` loops until it finds the type with **no null guard** — querying a stage type not present downstream walks off the end (UB).
- `getKernel()` default asserts if called on the last stage; KERNEL_STAGE presumably overrides to return its kernel.
- Stage enum order encodes execution order; inserting a stage means renumbering consumers.
