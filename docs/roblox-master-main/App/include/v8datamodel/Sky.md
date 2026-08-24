# App/include/v8datamodel/Sky.h

## Purpose

`Sky` — creatable `Instance` holding the six-texture skybox cube (Up/Lf/Rt/Bk/Ft/Dn), celestial bodies (sun/moon textures + angular sizes), `CelestialBodiesShown`, and star count. Pure data holder; rendering consumes the descriptors.

## Declared API

`class Sky : public DescribedCreatable<Sky, Instance, sSky>`

- Public data members: `TextureId skyUp, skyLf, skyRt, skyBk, skyFt, skyDn; bool drawCelestialBodies; TextureId sunTexture, moonTexture; float sunAngularSize, moonAngularSize;`
- Private: `int numStars;` with `getNumStars()` inline / `setNumStars(int)`.
- Ctor; per-face setters (`setSkyboxUp/Lf/Rt/Bk/Dn/Ft(const TextureId&)`) and sun/moon texture + angular-size setters; matching const-ref inline getters for all.
- Descriptors: `prop_StarCount(int)`; `prop_SkyUp/Lf/Rt/Bk/Ft/Dn(TextureId)`; `prop_CelestialBodiesShown(BoundProp<bool>)`; `prop_SunTexture/prop_MoonTexture(TextureId)`; `prop_SunAngularSize/prop_MoonAngularSize(float)`.

## Gotchas

- Face fields are PUBLIC — code can bypass setters entirely (setters presumably exist for change-notification).
- Skybox face naming is compass-style (Lf/Rt/Bk/Ft/Up/Dn), not NormalId order.

## UNKNOWN

- Angular-size units (degrees?) and clamping rules out-of-line.

## Cross-links

- Implementation: [App/v8datamodel/Sky.md](../../v8datamodel/Sky.md).
- Environment siblings: [Lighting.md](Lighting.md); part decoration faces: [Decal.md](Decal.md), [FaceInstance.md](FaceInstance.md).
