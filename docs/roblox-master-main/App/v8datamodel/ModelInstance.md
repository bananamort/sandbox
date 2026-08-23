# ModelInstance.cpp

## Purpose

Implements `ModelInstance`, Instance name "Model" — the PVInstance container that groups parts (and nested Models) into one movable/selectable unit. Provides primary-part semantics, joint making/breaking across the tree, extents/CFrame computation, Studio selection rendering, and camera/frustum cooperation.

## Key types and API

`class ModelInstance : public DescribedCreatable<ModelInstance, PVInstance, sModel>` with `sModel = "Model"`.

Reflection members: property `PrimaryPart` (Ref to PartInstance, category_Data; setter `setPrimaryPartSetByUser` raises changed + dirties extents), property `ModelInPrimary` (CoordinateFrame, STREAMING category — backing `modelInPrimary` field used by `getLocation()` orientation math); functions `BreakJoints()`, `MakeJoints()`, `GetExtentsSize()` → Vector3 (`calculateModelSize`), `TranslateBy(delta)`, `GetPrimaryPartCFrame()` / `SetPrimaryPartCFrame(cframe)`, `MoveTo(position)` (`moveToPointAndJoin`). Deprecated aliases registered with Attributes::deprecated pointing at their replacements: `GetModelSize`→GetExtentsSize, `GetModelCFrame`→GetPrimaryPartCFrame, `makeJoints`→MakeJoints, `breakJoints`→BreakJoints, `moveTo` and `move`→MoveTo, `SetIdentityOrientation` and `ResetOrientationToIdentity`→SetPrimaryPartCFrame.

Internal machinery: weak-ref user primary part plus a computed fallback (`computePrimaryPart()` picks the descendant PartInstance with largest `areaXZ()` world extents); `getPrimaryPart()` self-heals stale refs (resets if stored part no longer descendant, RBXASSERT(0) tripwire). `getPrimaryCFrame()`/`setPrimaryCFrame()` throw "no PrimaryPart has been set..." when unset; SetPrimaryPartCFrame computes delta rotation+translation and applies it to every descendant part around the new-CFrame center point (orthonormalizing non-orthonormal rotations), then moves the primary part itself separately since it "may not be a descendant of this model". `translateBy` adds delta to every descendant part CFrame. `makeJoints`/`breakJoints` recurse children calling PartInstance::join/destroyJoints, descending through nested Models.

Extents caching: two regimes toggled by `DFFlag::CacheModelExtents` (default false): legacy dirty flags (`needsSizeRecalc`/`needsCFrameRecalc`) vs optional<> cached `modelCoordinateFrame`/`primaryPartSpaceExtents`. `setExtentsDirty()` propagates up to the nearest ModelInstance ancestor. Dirtying hooks: onChildAdded/onChildRemoving (also maintain the `modelModifiers` list of `IModelModifier` children), onChildChanged (any child property change dirties), onDescendantAdded/onDescendantRemoving (also clears user PrimaryPart when it is removed and resets `modelInPrimary`, marks shouldRender dirty).

Other: `hackPhysicalCharacter()` registers this class's creator under the legacy Name "PhysicalCharacter" so ancient files load as Models. `askSetParent` only allows Model parents. `hitTestImpl` ray-tests direct PVInstance children. `computePart()` builds a surrogate BLOCK_PART box (model extents, white) used for selection drawing; `render3dSelect` draws that box plus a gray outline on the user PrimaryPart when SELECT_NORMAL. `containedByFrustum` ANDs per-part AABB containment. `onCameraNear` forwards to CameraSubject children. `getCameraIgnorePrimitives` collects all drag primitives plus Humanoid parts when this is a character. Statics: `showModelCoordinateFrames` debug flag drives render3dAdorn axes for top-level PVInstances. `isSelectable3d()` is false without a primary part when `FFlag::StudioDE6194FixEnabled`.

## Usage / reflection touchpoints

Standard descriptor registration makes PrimaryPart/ModelInPrimary script-visible and streamed. Get/SetPrimaryPartCFrame are the classic scripted model-move path (character teleporting etc.). The IModelModifier child list (Humanoid etc., interface defined elsewhere) lets engine subsystems attach to Models as children. `getLocation()` composes `modelInPrimary.rotation` onto the primary part's rotation so saved model orientation survives repositioning.

## Gotchas

- All deprecated names still resolve — they are real descriptors, just flagged.
- Without a user-set PrimaryPart, Set/GetPrimaryPartCFrame THROW rather than fall back to the computed part; the computed part serves engine-internal paths only.
- Computed-primary heuristic = biggest XZ footprint among descendants, not any documented "root".
- onChildChanged dirties extents on ANY child property change — expensive for big models unless DFFlag::CacheModelExtents is on (off by default).
- Removing the PrimaryPart resets ModelInPrimary to identity.
- UNKNOWN: call site of hackPhysicalCharacter (not in this file).
