# PVInstance.cpp

## Purpose

Implements `PVInstance`, the abstract base (registered class name "PVInstance") for everything placeable with a coordinate frame in the world — ancestor of PartInstance and its geometry family. This TU is small: legacy drag move helpers delegating into Workspace::moveToPoint with different join modes, top-level PV-parent walk, debug axis rendering, legacy file-format tolerance for old "Feature"-tagged parts, and a booby-trapped legacy "CoordinateFrame" UI property that always throws.

## Key types and API

Descriptor:
- `desc_CoordFrame("CoordinateFrame")` — PropDescriptor CoordinateFrame, category_Data, NULL getter, setter = `setPVGridOffsetLegacy`, cap UI. The setter unconditionally throws `runtime_error("CoordinateFrame is not a valid member of %s")` — exists purely so old UI/places surface an intelligible error (legacy offset property).

Methods:
- `moveToPointNoUnjoinNoJoin(point)` / `moveToPointAndJoin(point)` / `moveToPointNoJoin(point)`: locate Workspace via findWorkspace, delegate to `Workspace::moveToPoint(this, point, DRAG::{NO_UNJOIN_NO_JOIN | UNJOIN_JOIN | UNJOIN_NO_JOIN})`.
- `readProperty(XmlElement*, binder)`: format shim — when the element tag is "Feature", treats name=="Part" as legacy PartInstance data and name=="Item" as legacy PVAttribute data, both read via readProperties directly instead of Super dispatch.
- `getTopLevelPVParent()` (+const): recursive walk up typed PVInstance parents until `isTopLevelPVInstance()` (no parent or root).
- `renderCoordinateFrame(Adorn*)`: axes adorn (RGB, length 10) at getLocation().
- Ctor wires Described<PVInstance, sPVInstance, Instance>.

## Usage / reflection touchpoints

No Lua-facing surface beyond the throwing CoordinateFrame trap. Base for PartInstance.md, BasePart-family, and every geometry instance doc in this folder; DRAG modes pair with Workspace.md/MouseCommand.md.

## Gotchas

- Reading "CoordinateFrame" via this descriptor has a NULL getter (reflection returns nothing) while WRITING always throws — deliberate legacy kill-switch.
- Feature-tag tolerance means malformed modern files with Feature tags named anything other than Part/Item fall through to Super and likely fail there.
- getTopLevelPVParent recursion assumes well-formed PV chains; a cycle would stack-overflow (no depth guard).
- UNKNOWN: isTopLevelPVInstance definition (header); getLocation() semantics inherited from Instance-side CF storage.
