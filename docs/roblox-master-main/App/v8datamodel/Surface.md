# Surface.cpp

## Purpose

Implements `Surface` (a lightweight {PartInstance*, NormalId} view over one face of a part — NOT an Instance) plus the custom reflection descriptor machinery (`SurfacePropDescriptor`, `SurfaceEnumPropDescriptor`, `SurfaceGetSet` templates) that exposes per-face properties (Top/Bottom/Left/Right/Front/Back × Surface/Input/ParamA/ParamB) directly on PartInstance's class descriptor. Also provides static face→descriptor lookup used by tools and replication.

## Key types and API

DFFlag: `UseRemoveTypeIDTricks(true)` — switches debug asserts from typeid names to class-name strings.

Surface methods (all delegate to the owning PartInstance with fixed surfId):
- get/setSurfaceType, get/setSurfaceInput (LegacyController::InputType), get/setParamA/B.
- `toggleSurfaceType()`: NO_SURFACE ↔ GLUE.
- `flat()`: resets type + input + both params to SurfaceData::empty().

Descriptor templates:
- `SurfaceGetSet<face,V,Get,Set>`: getValue/setValue assert instance is PartInstance (debugAssertM) then call member fn ptr with the template face constant.
- `SurfacePropDescriptor`: registers against **PartInstance::classDescriptor()** (not Surface's) with STANDARD default / Security::None default parameters.
- `SurfaceEnumPropDescriptor`: full EnumPropertyDescriptor re-implementation (string/int/index conversions, XML read/write as INT, pre-10/29/05 string-value legacy fallback in readValue).

Registered descriptors (24 total): for each of 6 faces — "<Top|Bottom|Left|Right|Front|Back>Surface" (category "Surface"), "<Face>SurfaceInput" + "<Face>ParamA" + "<Face>ParamB" (category "Surface Inputs").

Static lookup: `getSurfaceTypeStatic/getSurfaceInputStatic/getParamAStatic/getParamBStatic(NormalId)` → descriptor refs; `isSurfaceDescriptor(desc)` covers the six type descriptors; `registerSurfaceDescriptors()` exists purely to force TU linkage.

Variant/StringConverter plumbing: SurfaceType + LegacyController::InputType get Variant converts; their StringConverter::convertToValue specializations return FALSE unconditionally (no string parsing via that path).

## Usage / reflection touchpoints

The entire classic "surface join" Lua property surface lives here. Pairs with PartInstance.md (storage + change events), MouseCommand.md/JointInstance.md (join semantics), factoryregistration.cpp notes for enum registration.

## Gotchas

- Descriptors are attached to PartInstance's class descriptor — iterating Surface's own descriptor finds nothing; scripts see them on BasePart.
- StringConverter<SurfaceType> deliberately never parses strings — all enum conversion must route through Reflection::EnumDesc.
- XML writes are raw ints; old-file string reads rely on the legacy branch (acknowledged perf TODO).
- Surface objects hold a RAW PartInstance pointer — lifetime is caller-managed (fine for stack usage patterns only).
