# App/include/humanoid/Freefall.h

## Purpose

Declares the `HUMAN::Freefall` humanoid state — airborne descent with air-control balancing. Extends `Balancing`; tracks initial/desired velocity, applies per-limb friction (set to zero per source comment), decays velocity over the fall, and exposes turn-speed constants with legacy vs PGS solver variants.

## Declared API

- `extern const char* const sFreefall;`
- `class RBX::HUMAN::Freefall : public Named<Balancing, sFreefall>`
  - Private state: `bool initialized;` ("hack- some data is bad in the constructor - do first time through;"), `Vector3 initialLinearVelocity;`, `Velocity desiredVelocity;` ("Y is world-up"), `float torsoFriction; float headFriction;` ("I set both of these to zero!")
  - Inline overrides: `getStateType() → FREE_FALL`, `int ladderCheckRate() { return 0; }` (ladder checks suspended), collision arms/legs → false, auto-jump off.
  - Overrides declared: `void onSimulatorStepImpl(float stepDt); void onComputeForceImpl();`
  - Private statics: `characterVelocityInfluence(); floorVelocityInfluence(); velocityDecay();`
  - Public: ctor, dtor, `static float kTurnSpeed();` `static float kTurnSpeedForPGS();` inline `static const float kTurnAccelMax() {return 20000.0f * kTurnSpeed();}` ("units: 1/sec^2")

## Usage notes

- See [HumanoidState.md](HumanoidState.md) and [Balancing.md](Balancing.md).

## Gotchas

- The `initialized` flag exists because constructor-time data is invalid — first simulator step performs deferred init.
- Friction fields exist but are forced to zero — vestigial tuning surface.
- Turn speed differs between solvers (`kTurnSpeed` vs `kTurnSpeedForPGS`); `kTurnAccelMax` uses only the legacy one.
