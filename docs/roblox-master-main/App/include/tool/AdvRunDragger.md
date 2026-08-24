# App/include/tool/AdvRunDragger.h

## Purpose

Advanced (Studio) snap dragger: extends the [RunDragger.md](RunDragger.md) concept with grid modes ([DragTypes.md](DragTypes.md) `DraggerGridMode`), joint-create mode, and a multi-part drag mode that hides parts and substitutes a temporary part (`tempPart`) dragged as one body. Owned by [AdvLuaDragger.md](AdvLuaDragger.md)/adv tools. Debug gate `DEBUG_MULTIPLE_PARTS_DRAG` (commented out by default).

## Declared API

- `typedef std::vector<weak_ptr<PartInstance>> WeakParts; typedef std::vector<CoordinateFrame> Locations;`
- `class AdvRunDragger : public IAdornable`
  - Nested `SnapInfo` — like RunDragger's but adds `NormalId surface` (init `NORM_UNDEFINED`) and drops `lastHitWorld`.
  - State: `dragPart`, `std::vector<Primitive*> dragParts; WeakParts weakDragParts; weak_ptr<PartInstance> snapPart; bool isAdornable; Workspace*; Primitive* drag; Vector3 dragPointLocal; Matrix3 dragOriginalRotation; SnapInfo snapInfo; RbxRay mouseRay; NormalId dragSurface; size_t myDragSurfaceId; Vector3 dragHitLocal; Vector3 snapGridOrigin; bool snapGridOriginNeedsUpdating; DRAG::DraggerGridMode gridMode; bool jointCreateMode;` multi-drag block: `boost::shared_ptr<PartInstance> tempPart; Locations originalLocations; G3D::Array<Primitive*> savedPrimsForMultiDrag; PartInstance* primaryPart; bool handleMultipleParts; CoordinateFrame tempOriginalCF;`
  - Private: RunDragger-like machinery plus `bool snapDragPart(bool supressGridSettings = false);` ("supress" sic), `bool pushDragPart(const Vector3& snapNormal);` `savePrimsForMultiDrag()`, `Contact* getFirstContact(Primitive*& prim); Contact* getNextContact(Primitive*&, Contact*);`
  - Public: ctors/dtor; `init(workspace, dragPart, dragPointWorld)` / `initLocal(workspace, dragPart, dragPointLocal, WeakParts dragParts)` (note: initLocal carries the extra parts array); **`bool snap(const RbxRay&)`; `bool snapGroup(const RbxRay&)`;** `getSnapHitPoint(part, ray, hitPoint&)`; rotate helpers as in RunDragger; statics `turnUpright/rotatePart/tiltPart` ("will NOT update dragOriginalRotation"); grid/joint mode accessors inline (`setGridMode/getGridMode/setJointCreateMode/getJointCreateMode`); `getSnapSurfaceCoord()`;
  - IAdornable split by macro: debug build renders adorn (`shouldRender3dAdorn() → true`, `render3dAdorn`), release returns false.
  - `static bool dragMultiPartsAsSinglePart;`

## Gotchas

- Multi-part mode *removes real parts from the world* (saved into `savedPrimsForMultiDrag`) and replaces them with `tempPart` — crash/deletion hazards if finish path is skipped.
- `initLocal` vs `init` asymmetry: only initLocal takes the extra WeakParts; calling the wrong one silently disables group behavior.
- `snapGridOriginNeedsUpdating` lazy-invalidates the local grid origin when snapping to a new face.
