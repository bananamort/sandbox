# App/include/v8datamodel/RootInstance.h

## Purpose

`RootInstance` — the `ModelInstance`-derived game root (ICameraOwner) that owns the V8World `World`, tracks the viewport and insert point, and implements ALL insertion placement policy: routing inserted instances through RAW/TREE/3D_View modes, character vs IDE vs remote insert points, special-casing HopperBins, SpawnLocations, and Decals, plus camera focusing and part moving via MegaDragger.

## Declared API

`class RootInstance : public Reflection::Described<RootInstance, sRootInstance, ModelInstance>, public ICameraOwner`

- Public insertion API:
  - `void insertInstances(const Instances&, Instance* requestedParent, InsertMode insertMode, PromptMode promptMode, const Vector3* positionHint = NULL, Instances* remaining = NULL, bool lerpCameraInStudio = true)` — in-header comment: "RAW: don't move, TREE: only move up, 3D_View: insert point".
  - `void insertPasteInstances(...same signature...)` — "Instead of putting parts in the camera's focus, we focus the camera on where parts were pasted".
  - `Vector3 computeCharacterInsertPoint(const Vector3& sizeOfInsertedModel)`.
  - `void removeInstances(const Instances&)`.
  - `void publicInsertRaw(const Instances&, Instance* requestedParent, PartArray& partArray, bool joinPartsInInstancesOnly = false, bool suppressPartMove = true)`.
  - `void moveCharacterToDefaultInsertPoint(ModelInstance* character, const Extents& extentsBeforeCharacter)`.
  - `void setInsertPoint(const Vector3& topCenter)`.
  - `void moveToPoint(PVInstance* pv, Vector3 point, DRAG::JoinType joinType)`.
  - Camera: `void movePartsToCameraFocus(PartArray&)`, `void focusCameraOnParts(PartArray&, bool lerpCameraInStudio = true)`.
  - Accessors: `World* getWorld()` (inline), `const Rect2D& getViewPort()` (inline).
- Protected: ctor/dtor; members `Rect2D viewPort`, `std::auto_ptr<World> world`.
- Private machinery: `computeIdeInsertPoint()`, `computeCharacterInsertPoint(const Extents&)`, `gatherPartExtents(PartArray&)`; `moveSafe(MegaDragger&, Vector3, DRAG::MoveType)` + PartArray overload; moveTo* trio (Character/Ide/Remote insert points); `insertRaw(...)`, `insertToTree(instances, parent, suppressMove=false, lerpCameraInStudio=true)`; view routers `insert3dView/insertRemoteCharacterView/insertCharacterView/insertIdeView`; special inserts `insertHopperBin(HopperBin*)`, `insertSpawnLocation(SpawnLocation*)`, `insertDecal(Decal*, InsertMode)`; master dispatcher `doInsertInstances(... forceSuppressMove=false ...)`.

## Gotchas

- Placement policy is deeply embedded here: changing insert behavior means touching doInsertInstances' mode/prompt matrix.
- Uses `std::auto_ptr<World>` — C++03-era ownership; transfer semantics are release-prone.
- PromptMode parameter suggests UI prompts during insert (e.g., overwrite dialogs) handled out-of-line.
- Special-case branches for HopperBin/SpawnLocation/Decal bypass the generic path.

## UNKNOWN

- Exact PromptMode enum values (declared in Tool/DragTypes.h or Util/InsertMode.h includes).

## Cross-links

- Implementation: [App/v8datamodel/RootInstance.md](../../v8datamodel/RootInstance.md).
- Base chain: [ModelInstance.md](ModelInstance.md), [PVInstance.md](PVInstance.md); world owner: [Workspace.md](Workspace.md); drag machinery: [PartDragger.md](PartDragger.md), Tool docs.
