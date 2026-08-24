# IEquipable.cpp

## Purpose

Implements `IEquipable` — the equip-welding mixin used by Tool/Accoutrement: single `buildWeld(humanoidPart, gadgetPart, humanoidCoord, gadgetCoord, name)` helper creating a named Weld (Part0=humanoid part, Part1=gadget) parented under the HUMANOID part, tracked in member `weld`. Destructor asserts no lingering weld.

## Key types and API

No descriptors, no Security:: tiers.

- `buildWeld(...)` — computes world alignment (commented-out setCoordinateFrame line disabled — weld alone positions), destroys any EXISTING weld first (FISHING assert), creates Weld with C0=humanoidCoord/C1=gadgetCoord, parents to humanoidPart.
- Member: `weld` shared_ptr<Weld>; dtor RBXASSERT(!weld).

## Usage / reflection touchpoints

The UNKNOWN buildWeld referenced by [Accoutrement](Accoutrement.md) lives HERE; [Tool](Tool.md) uses the same mixin for RightGrip welding.

## Gotchas

- Weld parented under the CHARACTER part, not the gadget — deleting the character limb removes the weld (and triggers unequip handlers).
- buildWeld on an already-equipped item silently replaces the old weld (assert only in fishing builds).
