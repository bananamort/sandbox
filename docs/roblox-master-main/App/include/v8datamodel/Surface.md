# App/include/v8datamodel/Surface.h

## Purpose

`Surface` — value object pairing a `PartInstance` with one face (`NormalId`) and exposing that face's SurfaceType, legacy controller InputType, and ParamA/B (hinge/step motor parameters). Also owns the static registry of per-face reflection descriptors (`registerSurfaceDescriptors`, `get*Static(face)`).

## Declared API

`class Surface`

- Ctors: default; `Surface(PartInstance*, NormalId)`; copy ctor `Surface(const Surface&)`.
- `void flat();` — resets the face (presumably to Flat surface type).
- Accessors: inline `PartInstance* getPartInstance()`, const variant, inline `NormalId getNormalId()`.
- Face state: `SurfaceType getSurfaceType() const` / `setSurfaceType(SurfaceType)`.
- Legacy controller: `LegacyController::InputType getInput() const` / `setSurfaceInput(LegacyController::InputType)`.
- Params: `getParamA()/getParamB()` + `setParamA(float)/setParamB(float)`.
- `void toggleSurfaceType();`
- Static descriptor registry: `static const PropertyDescriptor& getSurfaceTypeStatic(NormalId face)`, `getSurfaceInputStatic(face)`, `getParamAStatic(face)`, `getParamBStatic(face)`; `static bool isSurfaceDescriptor(const PropertyDescriptor& desc)`; `static void registerSurfaceDescriptors()`.
- Header note: "NOTE: both Surface.h and Surfaces.h" (companion Surfaces container referenced by PartInstance friends).

## Gotchas

- PartInstance declares `friend class Surface; friend class Surfaces;` — Surface writes part state directly.
- Descriptors are per-face statics keyed by NormalId — 6 faces × 4 descriptor kinds; isSurfaceDescriptor is how property-change events get routed back to parts (see PartInstance::raiseSurfacePropertyChanged).
- LegacyController input only applies to specific surface types (hinges/motors); setting it on others is presumably ignored/invalid out-of-line.

## UNKNOWN

- What flat() exactly resets (type only vs params too).

## Cross-links

- Implementation: [App/v8datamodel/Surface.md](../../v8datamodel/Surface.md).
- Owner: [PartInstance.md](PartInstance.md); enums: Util/SurfaceType.h, Util/NormalId.h.
