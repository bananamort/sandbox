# App/v8datamodel/Adornment.cpp

## Purpose

Implements the two abstract adornment base classes `PartAdornment` ("PartAdornment") and `PVAdornment` ("PVAdornment") — `GuiBase3d` descendants (created via `DescribedNonCreatable`, so they cannot be created by scripts) that attach overlay rendering (selection boxes, spheres, lassos...) to a target part or PVInstance. Concrete adornments (SelectionBox, SelectionSphere, etc.) subclass these.

## API

- `const char* const RBX::sPartAdornment = "PartAdornment"`, `sPVAdornment = "PVAdornment"`.
- Reflection:
  - `PartAdornment::prop_partAdornee` — `"Adornee"` (category_Data), RefPropDescriptor<PartAdornment, PartInstance>, backed by `getAdorneeDangerous`/`setAdornee`.
  - `PVAdornment::prop_pvAdornee` — `"Adornee"` (category_Data), RefPropDescriptor<PVAdornment, PVInstance>, same accessor pattern.
- `void setAdornee(T*)` on each class: swaps the weak reference (`adornee.lock()` compare, then `shared_from(value)`) and raises property changed.

## Usage

Base classes for all adornment-type instances rendered over their Adornee; the Lua-visible `Adornee` property comes straight from these descriptors. Rendering pipelines walk the tree for GuiBase3d instances and use the adornee weak ref for positioning.

## Gotchas

- Both classes are DescribedNonCreatable — `Instance.new("PartAdornment")` is not possible; only engine/studio-created subclasses exist.
- Adornee is stored weakly (`adornee.lock()`), so destroying the adorned part leaves the adornment alive but dangling-safe.
- UNKNOWN: rendering/`getAdorneeDangerous` implementations live in the header (V8DataModel/Adornment.h), not in this TU.
