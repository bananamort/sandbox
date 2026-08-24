# App/include/v8datamodel/Backpack.h

## Purpose

`Backpack` Instance ("Backpack") — the per-player container of unequipped Tools/Hoppers; a thin subclass of [Hopper](Hopper.md) whose only addition is a script-filter rule deciding whether scripts inside it may run.

## Declared API

`class Backpack : public DescribedCreatable<Backpack, Hopper, sBackpack>, public IScriptFilter`

- `Backpack();`
- IScriptFilter override: `bool scriptShouldRun(BaseScript* script);` (comment labels it "IScriptOwner").

## Gotchas

- All containment/equip behavior is inherited from Hopper — this header adds only the run-policy hook.
- Whether `scriptShouldRun` returns true depends on .cpp logic (likely LocalScript vs Script distinctions).

## UNKNOWN

- The exact script-allow policy (see [Backpack.md](../../v8datamodel/Backpack.md)).

## Cross-links

- Implementation: [App/v8datamodel/Backpack.md](../../v8datamodel/Backpack.md).
- Base: [Hopper.md](Hopper.md); sibling containers: [StarterPack-family via PlayerGui/PlayerScripts](PlayerScripts.md), [Tool.md](Tool.md).
