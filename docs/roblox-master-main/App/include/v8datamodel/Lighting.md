# App/include/v8datamodel/Lighting.h

## Purpose

`Lighting` Instance (PERSISTENT_HIDDEN service) — the place's global lighting model: sky parameters (G3D LightingParameters), clear/shadow/fog colors, time-of-day clock, color shifts/ambient/brightness/shadows/outlines knobs, and the [Sky](Sky.md) child management.

## Declared API

`class Lighting : public DescribedCreatable<Lighting, Instance, sLighting, ClassDescriptor::PERSISTENT_HIDDEN>, public Service`

- Sky: public member `shared_ptr<Sky> sky;` `void replaceSky(Sky* newSky); bool isSkySuppressed() const { return !hasSky; } void suppressSky(bool value)` (inverts flag); raw G3D params `const G3D::LightingParameters& getSkyParameters() const;` sun/moon queries `getMoonPhase()`, `getMoonPosition()`, `getSunPosition()`; latitude get/set.
- Colors/fog: ClearColor/ClearAlpha, ShadowColor, FogColor/FogStart/FogEnd — getter/setter pairs.
- Time: float view (`getTimeFloat/setTimeFloat`), string view (`getTimeStr/setTimeStr`), duration setter, `G3D::GameTime getGameTime()`, minutes-after-midnight double pair; stored as `boost::posix_time::time_duration`.
- Global look props (BoundProps): desc_GlobalBrightness, desc_TopColorShift, desc_BottomColorShift, desc_GlobalAmbient, desc_GlobalOutdoorAmbient, desc_Outlines (+getOutlines without setter); derived `getSkyAmbient() = max(outdoor − ambient, zero)`; `getGlobalShadows()/setGlobalShadows(bool)`.
- Signal: `lightingChangedSignal<void(bool)>` ("arg=skyboxChanged"); private onPropChanged → fireLightingChanged(false).
- Child hooks: onChildAdded/onChildRemoving/onChildChanged (sky tracking), askAddChild (.cpp).

## Gotchas

- `suppressSky(true)` sets hasSky=false — the property name inverts the internal flag.
- TimeOfDay has four representations (float, string, duration, minutes) — conversions centralized here.
- Public shared_ptr<Sky> member: external code can reassign it directly.

## UNKNOWN

- Which child types askAddChild permits beyond Sky (.cpp).

## Cross-links

- Implementation: [App/v8datamodel/Lighting.md](../../v8datamodel/Lighting.md).
- Child: [Sky.md](Sky.md); lights family [Light.md](Light.md).
