# Adornment.cpp

## Purpose

Implements the two adornment base classes: `PartAdornment` ("PartAdornment") — a GuiBase3d overlay anchored to a single `PartInstance` — and `PVAdornment` ("PVAdornment"), the same idea anchored to any `PVInstance`. Both are DescribedNonCreatable bases for the concrete Selection*/Handles* adornments.

## Key types and API

Descriptors:
- `prop_partAdornee("Adornee", category_Data)` — RefPropDescriptor<PartAdornment, PartInstance>, get via `getAdorneeDangerous`, set with change-tracked raise. No Security:: arguments.
- `prop_pvAdornee("Adornee", category_Data)` — RefPropDescriptor<PVAdornment, PVInstance>, same shape. Note both classes register a property literally named "Adornee".

Constants: `sPartAdornment = "PartAdornment"`, `sPVAdornment = "PVAdornment"`.

Behavior: ctors take a name string (DescribedNonCreatable); setters store a weak/shared ref (`adornee.lock()` compare + `shared_from(value)`) and raise PropertyChanged only on actual change.

## Usage / reflection touchpoints

Base for SelectionBox/SelectionSphere ([SelectionBox](SelectionBox.md), [SelectionSphere](SelectionSphere.md)) under PartAdornment, and lassos/handles families under PVAdornment; GuiBase3d render path shared with [GuiBase3d](GuiBase3d.md).

## Gotchas

- Getter is `getAdorneeDangerous` — returns raw pointer from a weak ref; dangling if the adornee is destroyed without clearing the property.
- Two different classes expose identical "Adornee" property names with different target types — descriptor lookup is per-class.
- Non-creatable: these exist only as scripting/serialization base types.
