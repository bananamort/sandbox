# App/include/v8world/CleanStage.h

## Purpose

First stage of the world pipeline (`IStage::CLEAN_STAGE`), sitting between the World and the JointStage. Filters incoming primitives and edges: edges are only passed downstream when both endpoint primitives exist **and differ** ("between two primitives, both different, both non-null" per in-header comment).

## Declared API

- `class CleanStage : public IWorldStage`
  - `CleanStage(IStage* upstream, World* world); ~CleanStage() {}`
  - `/*override*/ IStage::StageType getStageType() const {return IStage::CLEAN_STAGE;}`
  - Edge flow: `onEdgeAdded(Edge*)`, `onEdgeRemoving(Edge*)`.
  - Primitive flow: `onPrimitiveAdded(Primitive*)`, `onPrimitiveRemoving(Primitive*)`.
  - Joint edits: `onJointPrimitiveNulling(Joint* j, Primitive* nulling)`, `onJointPrimitiveSet(Joint* j, Primitive* p)` — keep downstream consistent when a joint re-targets.
  - Private: `JointStage* getJointStage();` `bool primitivesAreOk(Edge* e);`

## Gotchas

- In-header contract comment is authoritative: an edge with a null endpoint or self-pair (p0==p1) must not reach JointStage.
- Header includes `<map>` but declares no map member — leftover include.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md) (CLEAN_STAGE first in enum), [IWorldStage.md](IWorldStage.md), [Edge.md](Edge.md); next hop [JointStage.md](JointStage.md).
