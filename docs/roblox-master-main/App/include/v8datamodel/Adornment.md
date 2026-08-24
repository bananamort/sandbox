# App/include/v8datamodel/Adornment.h

## Purpose

Two small abstract-ish base classes for 3D "adornments" — GuiBase3d-derived overlay objects that attach to a part: `PartAdornment` (adores a `PartInstance`, e.g. SelectionBox/Sphere) and `PVAdornment` (adores any `PVInstance`, e.g. SelectionLasso-style adornment of models/parts).

## Declared API

`class PartAdornment : public DescribedNonCreatable<PartAdornment, GuiBase3d, sPartAdornment>`

- `PartAdornment(const char* name)` (descriptor name `sPartAdornment`; non-creatable from scripts).
- `const PartInstance* getAdornee() const` / `PartInstance* getAdornee()` / `void setAdornee(PartInstance*)`.
- `PartInstance* getAdorneeDangerous() const` — identical body to `getAdornee()` (`adornee.lock().get()`); the "Dangerous" name promises nothing extra at header level.
- Storage: `weak_ptr<PartInstance> adornee`.

`class PVAdornment : public DescribedNonCreatable<PVAdornment, GuiBase3d, sPVAdornment>` — same surface with `PVInstance*` in place of `PartInstance*`; storage `weak_ptr<PVInstance> adornee`. Descriptor `sPVAdornment`.

## Gotchas

- Adornee is held weakly: if the target part is destroyed the adornment silently observes null until reset; every getter re-locks.
- Both classes are `DescribedNonCreatable` — script code cannot construct them, only engine/Studio code creates subclasses.
- The second class comment is a copy-paste of the first ("adorn PartInstances") although PVAdornment actually takes any PVInstance.

## UNKNOWN

- Rendering and adornee-lifetime behavior live in subclass/.cpp implementations (see implementation doc).

## Cross-links

- Implementation: [App/v8datamodel/Adornment.md](../../v8datamodel/Adornment.md).
- Siblings: [SelectionBox.md](SelectionBox.md), [SelectionSphere.md](SelectionSphere.md), [SelectionLasso.md](SelectionLasso.md), base [GuiBase3d.md](GuiBase3d.md).
