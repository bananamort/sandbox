# App/include/v8world/TreeStage.h

## Purpose

Pipeline stage (`IStage::TREE_STAGE`) implementing the spanning-tree that partitions primitives into Mechanism → Assembly → Clump groupings: maintains dirty mechanisms, rebuilds trees when joints change, chooses roots by "weight" (guid/size heuristics), and pushes completed structures downstream.

## Declared API

- `class JointSort { static bool heavierJoint(const Joint* j0, const Joint* j1); };`
- `class TreeStage : public IWorldStage, public SpanningTree`
  - Members: `int maxTreeDepth;` `std::set<Mechanism*> dirtyMechanisms; std::set<Mechanism*> downstreamMechanisms;`
  - SpanningTree callbacks (overrides): `onSpanningEdgeAdding(edge, child)`, `onSpanningEdgeAdded(edge)`, `onSpanningEdgeRemoving(edge)`, `onSpanningEdgeRemoved(edge, child)`, `bool validateTree(SpanningNode* root)`.
  - Tree surgery: private `removeSpanningTreeJoint(Joint*)`, `void swapTree(Joint* deactivate, Joint* activate, Primitive* newParent)` — re-rooting when a heavier joint appears.
  - Pipeline: `removeFromPipeline(Mechanism*)`, `dirtyMechanism(Mechanism*)`, `cleanMechanism(Mechanism*)` ("true if moved downstream"); teardown trio `destroyClump/destroyAssembly/destroyMechanism(Primitive*)`.
  - Stage API: ctor `(IStage*, World*)`/dtor; `getStageType() → TREE_STAGE`; `onEdgeAdded/onEdgeRemoving(Edge*)`; **`int getMetric(MetricType)` override** (answers e.g. MAX_TREE_DEPTH); `onPrimitiveAdded/onPrimitiveRemoving(Primitive*)`; `void assemble();` ("update everything"), `bool isAssembled() const {return dirtyMechanisms.empty();}`; `void sendClumpChangedMessage(Primitive* childPrim);`

## Gotchas

- Assembly roots are not user-visible state — they're chosen by joint weight (`heavierJoint`, [Primitive.md](Primitive.md) `SizeMultiplier` overweighting) and can shift as joints are added/removed (`swapTree`).
- Until `assemble()` runs, groupings are stale; `isAssembled()` is the gate.
- `maxTreeDepth` exists presumably to bound recursion/validation depth.

## UNKNOWN

- Exact weighting formula in `heavierJoint` (implementation-only).

## Cross-links

- Spanning machinery: [Joint.md](Joint.md) (SpanningEdge impl), [Assembly.md](Assembly.md), [Clump.md](Clump.md), [Mechanism.md](Mechanism.md); pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md).
