# ManualJointHelper.cpp

## Purpose

Implements `ManualJointHelper`, the Studio drag-tool engine helper behind manual joint creation (AdvArrowTool's "manual joint mode"). Given the current selection, it discovers every contacting part/surface pair — including classic voxel terrain cells and smooth terrain touches — classifies each pair into what kind of auto-joint it could become or whether it is disallowed, draws those overlays in 3D, and on demand materializes `ManualWeld`/`ManualGlue` JointInstances. Not an Instance and has no script surface at all; it is pure editor plumbing registered with the Workspace's IAdornableCollector for rendering.

## Key types and API

Module constant: `autoJointLineThickness = 0.1f`.

`class ManualJointHelper`
- Ctors: `(Workspace*)`, default `(void)`. Dtor unregisters from the adornable collector (only if currently adorned), deletes all pairs, clears `autoJointsDetected`.
- `setWorkspace(Workspace*)`: one-shot attach (ignored if already set); registers itself via `workspace->getAdornableCollector()->onRenderableDescendantAdded(this)` and flips `isAdornable`.
- `clearAndDeleteJointSurfacePairs()`: deletes every `ConstraintSurfacePair` in `jointSurfacePairs` and resets `autoJointsDetected`.
- `findPermissibleJointSurfacePairs()`: the main scan. Clears old pairs; for each selected primitive asks `ContactManager::getPrimitivesTouchingExtents(getFastFuzzyExtents(), ...)` for touching primitives (terrain-on-terrain skipped), verifies actual surface contact via `findTouchingSurfacesConvex`, then `createJointSurfacePair`. Terrain handled separately by geometry type: GEOMETRY_MEGACLUSTER → per-cell `findPlanarTouchesWithGeom` + `createTerrainJointSurfacePair`; GEOMETRY_SMOOTHCLUSTER → `ManualWeldJoint::isTouchingTerrain` + `createSmoothTerrainJointSurfacePair` (balls excluded).
- `createJointSurfacePair(p0, face0Id, p1, face1Id)`: classification ladder —
  - either part under a Humanoid character (`Humanoid::modelIsConstCharacter` walk up ancestors) OR `surfaceIsNoJoin` → `DisallowedJointSurfacePair`;
  - p0 is terrain → `TerrainManualJointSurfacePair`;
  - `Joint::compatibleForStudAutoJoint` + `positionedForStudAutoJoint` → `StudAutoJointSurfacePair` (sets `autoJointsDetected=true`); stud-compatible but mis-positioned → `DisallowedJointSurfacePair` (or `ManualJointSurfacePair` under MACONLY_MANUAL_WELD_ALL_SURFACES);
  - glue/weld/hinge compat (`compatibleForGlue/Weld/HingeAutoJoint`) → respective `*AutoJointSurfacePair`, each setting `autoJointsDetected`;
  - `inCompatibleForAnyJoint` → `DisallowedJointSurfacePair` (skipped under the MAC define);
  - otherwise generic `ManualJointSurfacePair` (white/brown overlay).
  Every pair gets `ancestryChangedSignal` connections on both parts to `onPartAncestryChanged`.
- `surfaceIsNoJoin(p0, face0Id, p1, face1Id)`: true when either surface resolves to SurfaceType NO_JOIN via `Joint::getSurfaceTypeFromNormal`.
- Selection plumbing: `setSelectedPrimitives(const std::vector<Instance*>&)` / `(const Instances&)` / `setPVInstanceToJoin(PVInstance&)` all funnel through `DragUtilities::{instancesToParts,pvsToParts,partsToPrimitives}` into `selectedPrimitives`. `setPVInstanceTarget(PVInstance&)` stores just that part's primitive in `targetPrimitive` (NULL if not a PartInstance) — render-then only pairs touching it.
- `createJoints()`: calls `createJoint()` on every pair. `createJointsIfEnabledFromGui()`: same but gated on static `AdvArrowTool::advManualJointMode`.
- `render3dAdorn(Adorn*)`: draws each pair (`dynamicDraw`); filtered to `targetPrimitive` pairs when one is set.
- `onPartAncestryChanged(instance, newParent)`: when a paired part loses its parent, clears `targetPrimitive` if it matched and deletes+erases the first pair referencing that primitive (note: only ONE pair is removed per event even if the part appears in several).

`ConstraintSurfacePair` base: holds `p0/p1` Primitive pointers + face ids `s0/s1` ((size_t)-1 = unset), virtual `dynamicDraw(Adorn*)`/`createJoint()`, plus public boost connections `p0AncestorChangedConnection`/`p1AncestorChangedConnection`. Subclasses in this TU:

| Class | Overlay | createJoint behavior |
|---|---|---|
| `StudAutoJointSurfacePair`, `GlueAutoJointSurfacePair`, `WeldAutoJointSurfacePair`, `HingeAutoJointSurfacePair` | blue polygon intersection | none inherited (no override — never creates) |
| `DisallowedJointSurfacePair` | red | none |
| `ManualJointSurfacePair` | white, or brown when `AdvArrowTool::advManualJointType == DRAG::WEAK_MANUAL_JOINT` | STRONG type → `ManualWeld` named `"<Part0>-to-<Part1> Strong Joint"`; else `ManualGlue` named `"… Glue Joint"`; C0=surface-0 coord in body, C1=that world frame in p1 space, surfaces recorded, parented under PartInst0 |
| `TerrainManualJointSurfacePair` (+ `DisallowedTerrainJointSurfacePair` red variant) | per-cell intersection polygon via `MegaClusterPoly::findCellIntersectionWithGeom(cellIndex,…)`; white/brown | skips if p1 already has a `ManualWeldJoint` whose `getCell()` equals cellIndex; STRONG-only → `ManualWeld` named `"<Part1> Terrain Joint"`, parented under PartInst**1**, `setCell(cellIndex)` on the ManualWeldJoint |
| `SmoothTerrainManualJointSurfacePair` | empty draw (nothing rendered) | skips if any existing manual joint already spans these primitives; STRONG-only → `ManualWeld` `" Terrain Joint"` suffix, parented under PartInst1 |

## Usage / reflection touchpoints

No REFLECTION/descriptor macros in this TU — zero methods, properties, or events reach Lua. Consumers are Studio-side: AdvArrowTool (Tool/ToolsArrow.h owns `advManualJointMode`/`advManualJointType` statics and calls find/create/render), with parts/joint machinery living in PartInstance/JointInstance and V8World (ContactManager, WeldJoint). Terrain geometry details pair with MegaCluster.md in this folder.

## Gotchas

- The four `*AutoJointSurfacePair` classes have NO createJoint override — they visualize potential auto-joints but never create anything themselves.
- Smooth terrain potential joints draw NOTHING (`SmoothTerrainManualJointSurfacePair::dynamicDraw` is an empty body).
- Weak manual-joint mode (WEAK_MANUAL_JOINT) renders brown but still creates `ManualGlue` only through `ManualJointSurfacePair::createJoint`; terrain/smooth-terrain pairs refuse to act unless STRONG_MANUAL_JOINT.
- `onPartAncestryChanged` deletes at most ONE pair per callback (break after first match) and does not rescan — stale duplicates of the same part pair would survive until the next full `findPermissibleJointSurfacePairs`.
- `TerrainManualJointSurfacePair::createJoint` parented the weld under PartInst1 (the non-terrain part) while `ManualJointSurfacePair` parents under PartInst0 — asymmetric ownership.
- Face ids use sentinel `(size_t)-1`; several draw paths silently no-op on the sentinel rather than asserting.
- `SmoothTerrainManualJointSurfacePair::createJoint`'s duplicate check is asymmetric: it skips creation when an existing manual joint has primitive(0)==p0 **or** primitive(1)==p1 — so any pre-existing manual joint where p1 sits in slot 1 (e.g., an unrelated part-to-part manual weld) suppresses the terrain joint, even though the other side was never checked against p0.
- UNKNOWN: full `ConstraintSurfacePair` interface beyond what this TU uses (e.g., getP0/getP1 accessors used here) lives in V8DataModel/ManualJointHelper.h outside this file.
