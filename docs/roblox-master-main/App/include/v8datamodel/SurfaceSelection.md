# App/include/v8datamodel/SurfaceSelection.h

## Purpose

`SurfaceSelection` — creatable `PartAdornment` that highlights one face (`NormalId`) of its adornee part — the Studio per-surface selection visual.

## Declared API

`class SurfaceSelection : public DescribedCreatable<SurfaceSelection, PartAdornment, sSurfaceSelection>`

- Ctor; IAdornable `/*override*/ void render3dAdorn(Adorn* adorn)`.
- Inline `NormalId getSurface() const` / `void setSurface(NormalId value)` over private `NormalId surfaceId`.

## Gotchas

- Per project recon: this class is one of the decoy-hackFlag sites (hackFlag0/6/7 cluster in SurfaceSelection/PhysicsInstructions/TouchTransmitter) — anti-tamper noise; verify flag semantics against the certified doc, not this header.
- Tiny surface area: everything else inherited from [Adornment.md](Adornment.md).

## UNKNOWN

- (none — behavior fully delegated to base + render)

## Cross-links

- Implementation: [App/v8datamodel/SurfaceSelection.md](../../v8datamodel/SurfaceSelection.md).
- Base: [Adornment.md](Adornment.md); siblings: [SelectionBox.md](SelectionBox.md), [SurfaceGui.md](SurfaceGui.md).
