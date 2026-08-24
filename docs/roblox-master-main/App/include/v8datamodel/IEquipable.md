# App/include/v8datamodel/IEquipable.h

## Purpose

Common base for [Tool](Tool.md) and [Accoutrement](Accoutrement.md) (per the header's own diagram): owns the equip Weld — "no weld == dropped, UNEQUIPPED" — and the weld-building helper. Backend/server-side only.

## Declared API

`class RBXInterface IEquipable`

- Protected state: `shared_ptr<Weld> weld; // Weld (I create/destroy)`
- Helper: `void buildWeld(PartInstance* humanoidPart, PartInstance* gadgetPart, const CoordinateFrame& humanoidCoord, const CoordinateFrame& gadgetCoord, const std::string& name);`
- `IEquipable(); virtual ~IEquipable();`

## Gotchas

- Everything is protected: it is pure implementation sharing, not a polymorphic API.
- Weld lifetime encodes equip state — clearing the shared_ptr is the unequip path.

## UNKNOWN

- Whether any other class derives beyond Tool/Accoutrement (grep would tell; none visible in this slice).

## Cross-links

- Implementation: [App/v8datamodel/IEquipable.md](../../v8datamodel/IEquipable.md).
- Derivers: [Accoutrement.md](Accoutrement.md), [Tool.md](Tool.md).
