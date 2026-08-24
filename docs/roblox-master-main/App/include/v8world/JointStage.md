# App/include/v8world/JointStage.h

## Purpose

Pipeline stage (`IStage::JOINT_STAGE`) that holds joints until *both* endpoint primitives have arrived here, then pushes the completed joint downstream. Mirrors the primitives' joint lists in its own BiMultiMap so incomplete joints can be found by primitive.

## Declared API

- `class JointStage : public IWorldStage`
  - Members: `ConcurrencyValidator concurrencyValidator;` `RBX::BiMultiMap<Primitive*, Joint*> jointMap;` ("is identical to the primitive fields stored … of all joints in the incompleteJoints list"), `std::set<Joint*> incompleteJoints;` `std::set<Primitive*> primitivesHere;`
  - `JointStage(IStage* upstream, World* world); ~JointStage();`
  - `/*override*/ IStage::StageType getStageType() const {return IStage::JOINT_STAGE;}`
  - `/*override*/ void onEdgeAdded(Edge*)` / `onEdgeRemoving(Edge*)`; `void onPrimitiveAdded(Primitive*)` / `onPrimitiveRemoving(Primitive*)`.
  - Private plumbing: `getGroundStage()`, `moveEdgeToDownstream/removeEdgeFromDownstream`, `moveJointToDownstream/removeJointFromDownstream`, `putJointHere/removeJointFromHere`, `edgeHasPrimitiveHere/edgeHasPrimitivesHere`, `visitAddedPrimitive(p, j, std::vector<Joint*>& jointsToPush)`.

## Gotchas

- A joint is buffered here when either primitive is missing or identical — downstream stages only ever see complete joints (this is the consumer of [CleanStage.md](CleanStage.md)'s contract).
- Single-threaded contract enforced via `ConcurrencyValidator`.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); upstream [CleanStage.md](CleanStage.md), downstream [GroundStage.md](GroundStage.md); edges: [Joint.md](Joint.md).
