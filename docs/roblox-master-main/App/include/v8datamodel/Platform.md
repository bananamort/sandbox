# App/include/v8datamodel/Platform.h

## Purpose

Class-template `PlatformImpl<Base>` (over `ActionStation<Base>`) implements rideable-platform behavior: when a humanoid touches an upright platform, a non-archivable `Motor6D` named "PlatformMotor6D" welds torso↔platform; dismount destroys it. Concrete `Platform` instantiates `PlatformImpl<BasicPartInstance>` with remote signals for create/destroy — header comment: "changed to described, we don't ship right now. need to fix dismount issue."

## Declared API

- `template<class Base> class PlatformImpl : public ActionStation<Base>`
  - Private signal wiring: scoped_connections `platformTouched` (to `ActionStation::onDemandWrite()->localSimulationTouchedSignal`) and `humanoidDonePlatformStanding`.
  - `onEvent_platformTouched(shared_ptr<Instance> other)` — full inline mount gate: humanoid from body part, sleep time up, no existing platform motor, not already platform-standing, not dead, network owner is self, both contexts in workspace, and `getCoordinateFrame().rotation.column(1).y > 0.7f` ("must be within 45 degrees of upright to mount"); else the kick impulse branch is commented out ("disable and do in lua for now").
  - `onEvent_humanoidDonePlatformStanding()` → destroy motor.
  - `createPlatformMotor6DInternal(Humanoid*)` — inline: builds Motor6D named "PlatformMotor6D", C0 at platform surface (`partSizeXml.y * 0.5f`), C1 torso offset (0,-3,0), zeroes root velocity, sets `propArchivable=false`, parents to platform.
  - Child hooks: `onChildAdded/onChildRemoved(Instance*)` detect PlatformMotor6D by NAME + cast; on add: destroy other platform motors, set humanoid platform-standing, connect done-signal; on remove: disconnect, reset sleepTime.
  - Protected virtuals: `createPlatformMotor6D(Humanoid*)`, `findAndDestroyPlatformMotor6D()` (+Internal impls), helpers `humanoidFromMotor6D`, `findPlatformMotor6D`, `isChildPlatformMotor6D` (name-string check), `destroyOtherMotor6D(s)`; `onServiceProvider` override re-wires touch signal; pure-ish extension points `/*implement*/ virtual void onPlatformStandingChanged(bool, Humanoid*) {}` and `virtual void applySpecificImpulse(Vector3, Vector3) {}` ("implement this if platform is 'kickable'").
- `extern const char* const sPlatform;`
- `class Platform : public Reflection::Described<Platform, sPlatform, PlatformImpl<BasicPartInstance>>`
  - Public remote signals: `rbx::remote_signal<void(shared_ptr<Instance>)> createPlatformMotor6DSignal`, `rbx::remote_signal<void()> destroyPlatformMotor6DSignal` — ctor connects them to the internal create/destroy paths.
  - Overrides `createPlatformMotor6D/findAndDestroyPlatformMotor6D`.

## Gotchas

- Platform motor identified by the literal child name "PlatformMotor6D" — user instances with that name get hijacked by the logic.
- Mount threshold hard-coded upright test (>0.7 column-y ≈ 45°); kick-on-fail path deliberately disabled in C++ (moved to Lua).
- Header comment admits the class doesn't ship in this build pending a dismount fix — treat as dormant content.
- RBXASSERTs rely on assembly inequality of torso vs platform before welding.

## UNKNOWN

- Whether any vcxproj still registers/creates Platform instances.

## Cross-links

- Implementation: [App/v8datamodel/Platform.md](../../v8datamodel/Platform.md).
- Base machinery: [ActionStation.md](ActionStation.md), [BasicPartInstance.md](BasicPartInstance.md), [PartInstance.md](PartInstance.md); sibling vehicle seat: [VehicleSeat.md](VehicleSeat.md), [Seat.md](Seat.md).
