# App/include/humanoid/RunningBase.h

## Purpose

Declares `HUMAN::RunningBase`, the shared base for grounded walking states (Running). Extends `Balancing` with floor-relative desired velocity, altitude targeting ("hover"), ground-rotation coupling, and arm/leg collision suppression; exposes three distinct turn-gain constants for the different solver paths.

## Declared API

- `class RBX::HUMAN::RunningBase : public Balancing`
  - Protected state: `Velocity floorVelocity;` — "The following velocities are w.r.t the ground that the figure is walking on. The ground may be moving"; `Velocity desiredVelocity;` ("desired velocity in world coordinates relative to the floor's velocity"); `float desiredAltitude;` ("ignored if 0.0")
  - Protected helpers: `void rotateWithGround(Body* body); void hoverOnFloor(Body* body); void move(Body* body);`
  - Overrides: `void onComputeForceImpl(); void onSimulatorStepImpl(float stepDt);` inline `float getYAxisRotationalVelocity() const {return desiredVelocity.rotational.y;}` collision arms/legs → false.
  - Ctors: `(Humanoid*, StateType)` and `(Humanoid*, StateType, const float kP, const float kD)` (gain-passing variant from Balancing).
  - Override: `void onCFrameChangedFromReflection();`
  - Public static inline gains: `kTurnP() = 7500.0f`, `kTurnPForRotatePGS() = 450.0f`, `kTurnPForFreeFallPGS() = 375.0f`.

## Usage notes

- Concrete subclass: [Running.md](Running.md).
- See [Balancing.md](Balancing.md) and [HumanoidState.md](HumanoidState.md).

## Gotchas

- Velocities are floor-relative: on a moving platform/floor the same desiredVelocity yields different world motion.
- Turn gain varies ~20× between legacy (7500) and PGS variants (450/375) — mixing constants across solver paths breaks rotation control.
- desiredAltitude == 0 disables hovering (sentinel value).
