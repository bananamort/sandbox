# App/include/v8datamodel/ManualJointHelper.h

## Purpose

Studio manual/auto joint creation helper (an IAdornable owned by [JointsService](JointsService.md)): given selected primitives, enumerates permissible surface pairs (`ConstraintSurfacePair` subclasses per joint flavor), draws potential joints in 3D, and creates the chosen joints.

## Declared API

`class ConstraintSurfacePair` (abstract base)

- Holds `const Primitive* p0/p1; size_t s0/s1;` (surface ids) + ancestor-changed connections for both primitives.
- Setters/getters for both primitives and surfaces; pure virtual `void dynamicDraw(Adorn*)`; virtual `void createJoint(void)` no-op ("override to create joints").

Subclasses:
- `AutoJointSurfacePair` — base for auto-detected pairs; empty draw.
- `StudAutoJointSurfacePair`, `WeldAutoJointSurfacePair`, `GlueAutoJointSurfacePair`, `HingeAutoJointSurfacePair` — each with own dynamicDraw.
- `DisallowedJointSurfacePair` — renders the "can't join" state.
- `FeatureSnapJointSurfacePair` — empty draw + createJoint.
- `ManualJointSurfacePair` — draws + creates.
- Terrain trio: `TerrainManualJointSurfacePair` (+Vector3int16 cellIndex, setCellIndex) and `DisallowedTerrainJointSurfacePair` (draw-only), `SmoothTerrainManualJointSurfacePair` — terrain-aware pairs with createJoint.

`class ManualJointHelper : public IAdornable`

- Ctors `(Workspace*)` and default; dtor.
- Analysis: `findPermissibleJointSurfacePairs()`, `unsigned getNumJointSurfacePairs()`, `bool autoJointsWereDetected()`, `bool surfaceIsNoJoin(p0, face0Id, p1, face1Id)`.
- Creation: `createJoints(); createJointsIfEnabledFromGui(); createJointSurfacePair(p0, face0Id, p1, face1Id);` private terrain pair factories.
- Selection: two setSelectedPrimitives overloads (`std::vector<Instance*>` and `Instances`), setPVInstanceToJoin/setPVInstanceTarget(PVInstance&), clearSelectedPrimitives.
- Render: setDisplayPotentialJoints(bool), shouldRender3dAdorn → true, render3dAdorn(Adorn*).
- State: displayPotentialJoints/isAdornable/autoJointsDetected flags, workspace pointer, selectedPrimitives, heap-owned `std::vector<ConstraintSurfacePair*> jointSurfacePairs`, targetPrimitive; ancestry-change handler.

## Gotchas

- Surface pairs are raw-newed and owned in the vector — cleared via clearAndDeleteJointSurfacePairs.
- Primitives held as const pointers with lifetime guarded only by ancestor connections.
- GUI toggle (createJointsIfEnabledFromGui) means joint creation may silently not run depending on Studio settings.

## UNKNOWN

- Which settings gate createJointsIfEnabledFromGui (.cpp — see [ManualJointHelper.md](../../v8datamodel/ManualJointHelper.md)).

## Cross-links

- Implementation: [App/v8datamodel/ManualJointHelper.md](../../v8datamodel/ManualJointHelper.md).
- Owner: [JointsService.md](JointsService.md); joints: [JointInstance.md](JointInstance.md); verbs: [Commands.md](Commands.md) TurnOnManualJointCreation.
