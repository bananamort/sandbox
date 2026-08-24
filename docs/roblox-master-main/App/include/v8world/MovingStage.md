# App/include/v8world/MovingStage.h

## Purpose

Pipeline stage (`IStage::MOVING_STAGE`) receiving mechanism add/remove notifications — the point where whole mechanisms (moving structures) are registered with, and later filtered through, the spatial filter.

## Declared API

- `class MovingStage : public IWorldStage`
  - `MovingStage(IStage* upstream, World* world); ~MovingStage();`
  - `/*override*/ getStageType() → IStage::MOVING_STAGE;`
  - "From the Joint Stage": `void onMechanismAdded(Mechanism* a);` `void onMechanismRemoving(Mechanism* a);`
  - Private: `SpatialFilter* getSpatialFilter();`

## Gotchas

- Header-only surface is thin; the mechanism → assembly/phase fan-out lives in the .cpp.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); downstream filter: [SpatialFilter.md](SpatialFilter.md); mechanisms: [Mechanism.md](Mechanism.md).
