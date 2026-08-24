# App/include/v8world/EdgeStage.h

## Purpose

Pipeline stage (`IStage::EDGE_STAGE`) in the edge-notification chain between CleanStage and ContactStage: forwards edge add/remove and primitive add/remove events downstream.

## Declared API

- `class EdgeStage : public IWorldStage`
  - `EdgeStage(IStage* upstream, World* world); ~EdgeStage() {}`
  - `/*override*/ IStage::StageType getStageType() const {return IStage::EDGE_STAGE;}`
  - `/*override*/ void onEdgeAdded(Edge* e);` / `onEdgeRemoving(Edge*)`.
  - `void onPrimitiveAdded(Primitive* p);` / `onPrimitiveRemoving(Primitive*)`.
  - Private: `ContactStage* getContactStage();`

## Gotchas

- Pure plumbing on the header surface — logic lives in the .cpp.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); neighbors [CleanStage.md](CleanStage.md), [ContactStage.md](ContactStage.md).
