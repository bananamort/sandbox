# App/include/v8datamodel/ModelInstance.h

## Purpose

`Model` Instance ("Model") — a [PVInstance](PVInstance.md) container grouping parts/other models: computes aggregate CFrame/size (with optional PrimaryPart anchoring), supports move/joint operations, selection/camera framing, mass/moment queries, grouping template, and IModelModifier child lookup.

## Declared API

`class ModelInstance : public DescribedCreatable<ModelInstance, PVInstance, sModel>, public IAdornable, public CameraSubject, public Diagnostics::Countable<ModelInstance>`

- Statics: `static bool showModelCoordinateFrames; static void hackPhysicalCharacter();` primary-part adornment theme (Color4 select/hover colors + line thickness with getters/setters).
- Placement: `translateBy(Vector3)`, `getPrimaryCFrame()/setPrimaryPartCFrame-style setPrimaryCFrame(CoordinateFrame)`; `Part computePart();` size/cframe calculators; orientation resets (`setIdentityOrientation`, `resetOrientationToIdentity`); `setFrontAndTop(Vector3 front)`.
- Primary part: legacy pair `setPrimaryPartSetByUser(PartInstance*)/getPrimaryPartSetByUser()` ("Legacy - just storing for now"), computed `getPrimaryPart()` (IHasPrimaryPart), private `computedPrimaryPart` + weak user-set + `modelInPrimary` frame accessors.
- Queries: `containedByFrustum(const RBX::Frustum&) const`; part stats `computeNumParts() ("fast way of counting parts")`, `computeTotalMass() (kg)`, `computeLargestMoment() (kg*rbx^2)`, `getDescendantPartInstances()`.
- Joints: `makeJoints()/breakJoints();`
- Overrides: setName, tree hooks (onDescendantAdded/Removing, onChildAdded/Removing/Changed), askSetParent, hitTestImpl, getLocation (IHasLocation), CameraSubject trio + getCameraIgnorePrimitives, shouldRender3dAdorn/render3dAdorn/render3dSelect, isSelectable3d, computeExtentsWorld.
- Templates:
  - `template<class _InIt> shared_ptr<ModelInstance> group(_InIt first, _InIt last)` — creates a new Model under the nearest common ancestor model (or this), re-parents range; throws "The requested items cannot be grouped together" when canSetChildren fails.
  - Modifier finders: member `findFirstModifierOfType<C>()` / const twin over `std::vector<Instance*> modelModifiers` ("child model modifiers") via fastDynamicCast; static overloads accepting any Instance and casting to Model first.
- State: cached optional cframe/extents, dirty flags (needsSizeRecalc/needsCFrameRecalc), `lockedName` bool + `lockName()`.
- UI extras: `setInsertFlash(bool)`.

## Gotchas

- group() iterates raw input iterators twice — caller must pass a stable collection (the TODO admits it).
- Primary-part math caches aggressively; dirty flags must be maintained through every child mutation path.
- hackPhysicalCharacter is a process-global one-shot knob.

## UNKNOWN

- Exact primary-part fallback rule when none is set (.cpp — see [ModelInstance.md](../../v8datamodel/ModelInstance.md)).

## Cross-links

- Implementation: [App/v8datamodel/ModelInstance.md](../../v8datamodel/ModelInstance.md).
- Base: [PVInstance.md](PVInstance.md); modifiers: [IModelModifier.md](IModelModifier.md)/[CharacterAppearance.md](CharacterAppearance.md); container kin [Folder.md](Folder.md).
