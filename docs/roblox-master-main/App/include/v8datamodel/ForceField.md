# App/include/v8datamodel/ForceField.h

## Purpose

`ForceField` Instance — the spawn-shield bubble: a timed visual adornment over a character part that marks the part as damage-immune; includes static queries for whether a part is protected.

## Declared API

`class ForceField : public DescribedCreatable<ForceField, Instance, sForceField>, public IAdornable, public Effect`

- Statics: `static bool partInForceField(PartInstance* part);` `static int cycles() { return 60; }`
- File-scope constant: `static const float largeSize = 1.1f;` (non-class static in header — every TU gets a copy).
- Private state: `Time startTime; int cycle; int invertCycle; shared_ptr<Instance> torso;`
- Overrides: `askSetParent(const Instance*) const`; `shouldRender3dAdorn() → true`; `render3dAdorn(Adorn*)`.
- `ForceField(); virtual ~ForceField() {}`

## Gotchas

- No duration property in this drop — lifetime managed by creator code via startTime/cycle internals.
- `largeSize` at file scope pollutes including TUs (name-collision hazard).
- Protection semantics live behind partInForceField (.cpp).

## UNKNOWN

- How long the field lasts and what ends it (.cpp — see [ForceField.md](../../v8datamodel/ForceField.md)).

## Cross-links

- Implementation: [App/v8datamodel/ForceField.md](../../v8datamodel/ForceField.md).
- Kin: [Fire.md](Fire.md), [Sparkles.md](Sparkles.md), base [Effect.md](Effect.md).
