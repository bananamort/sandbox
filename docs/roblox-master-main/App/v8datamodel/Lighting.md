# Lighting.cpp

## Purpose

Implements `Lighting` ("Lighting"), the global lighting service (`DescribedCreatable<..., Reflection::ClassDescriptor::PERSISTENT_HIDDEN>` + `Service`, direct Instance subclass per Lighting.h): time-of-day clock, fog block, ambient/outdoor-ambient color model, Brightness/ColorShifts, Outlines, GlobalShadows, sun/moon direction queries, and Sky-child tracking that drives the `LightingChanged(skyboxChanged)` signal.

## Key types and API

Descriptors (verbatim security tiers — every function here is `Security::None`; plain props carry no tier argument):
- Event: `event_LightingChanged` — `EventDesc<Lighting, void(bool)>` "LightingChanged", legacy alias "skyboxChanged", bound to public `lightingChangedSignal`.
- Props: `TimeOfDay` (category_Data; boost posix_time string e.g. "14:00:00"), `ClockTime` (category_Data; float hours), `GeographicLatitude` (category_Data), `ShadowColor` (category_Appearance), `FogColor`/`FogStart`/`FogEnd` (category "Fog"), `GlobalShadows` (category_Appearance).
- Static `BoundProp`s on the class (member-backed, routed through `onPropChanged` → `fireLightingChanged(false)`): `Brightness`, `ColorShift_Top`, `ColorShift_Bottom`, `Ambient`, `OutdoorAmbient`, `Outlines`.
- Functions: `GetMoonPhase()` float; `GetMoonDirection()`/`GetSunDirection()` G3D::Vector3; `GetMinutesAfterMidnight()` double + `SetMinutesAfterMidnight("minutes")`; lowercase twins `getMinutesAfterMidnight`/`setMinutesAfterMidnight` registered with `Reflection::Descriptor::Attributes::deprecated(...)` pointing at the capitalized pair.

Behavior:
- Ctor defaults: shadowColor (0.7,0.7,0.72), timeOfDay 14:00:00, Brightness 1, Ambient/OutdoorAmbient mid-gray (0.5³), fogColor 0.75 gray, fogStart 0, fogEnd 100000, GlobalShadows false, Outlines true, lightColor rgb(152,137,102).
- `setTime` wraps modulo 24h (`total_seconds %= 86400`) then re-times skyParameters and fires LightingChanged(false).
- Moon/sun getters branch on `skyParameters.physicallyCorrect`: true celestial positions vs analytic ones.
- Child policy: `askAddChild` accepts ONLY `Sky`; `onChildAdded`/`onChildRemoving`/`onChildChanged` maintain the `sky` shared_ptr and fire LightingChanged(**true**) — sky edits report as skyboxChanged.
- `replaceSky(Sky*)`: unparents every existing Sky child, parents the new one.
- First-ever `GlobalShadows=true` fires once-per-process Google Analytics event "LightingShadows" (GA_CATEGORY_GAME) via `boost::call_once`.

## Usage / reflection touchpoints

Script-facing global-lighting bag consumed by the render pipeline via `getSkyParameters()` ([Sky](Sky.md) supplies textures; [Light](Light.md) instances are the per-part emitters). `replaceSky` is the insert path used by Studio tooling (see [RootInstance](RootInstance.md)). Header-only engine knobs: `suppressSky(bool)`/`isSkySuppressed()`, derived `getSkyAmbient() = max(OutdoorAmbient − Ambient, zero)`.

## Gotchas

- Registered names diverge from implementations: `GetMoonDirection` calls `getMoonPosition`, `GetSunDirection` calls `getSunPosition`.
- Fog setters (`FogColor`/`FogStart`/`FogEnd`) raise their own property but deliberately do NOT fire LightingChanged — unlike every other setter in the TU.
- `clearColor`/`clearAlpha` have setters that fire LightingChanged but NO descriptors in this TU — engine-internal, not script-settable here.
- `ClockTime` clamps silently to [0,24] and uses `ceil(hours*3600)` — fractional values round UP a second; `setTime` wraps rather than rejecting out-of-range times.
- Deprecated lowercase function aliases remain live alongside the new pair.
- Commented-out `setAmbientTop` dead code retained mid-file.
- UNKNOWN: which subsystem flips `skyParameters.physicallyCorrect` (renderer-side; not observable from this TU).
