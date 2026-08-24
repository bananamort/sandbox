# App/include/v8world/ContactStage.h

## Purpose

Pipeline stage (`IStage::CONTACT_STAGE`) that routes edge/primitive add-remove notifications toward the tree stage — the point where contacts (from ContactManager broadphase) and joints enter the stage machinery.

## Declared API

- `class ContactStage : public IWorldStage`
  - `ContactStage(IStage* upstream, World* world); ~ContactStage() {}`
  - `/*override*/ IStage::StageType getStageType() const {return IStage::CONTACT_STAGE;}`
  - `/*override*/ void onEdgeAdded(Edge* e);` / `onEdgeRemoving(Edge*)`.
  - `void onPrimitiveAdded(Primitive* p);` / `onPrimitiveRemoving(Primitive*)`.
  - Private: `TreeStage* getTreeStage();`

## Gotchas

- Header-only surface is trivial; all filtering/registration logic is in the .cpp.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); downstream [TreeStage.md](TreeStage.md); edges: [Contact.md](Contact.md), [Joint.md](Joint.md).
