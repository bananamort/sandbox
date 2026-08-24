# App/humanoid/Seated.cpp

## Purpose

Implements the two passive seated-family humanoid states declared in Seated.h: `HUMAN::Seated` (sitting on a Seat) and `HUMAN::PlatformStanding` (riding a moving platform without sitting). Both are zero-force states whose entire implementation is enabling state throttling in the constructor and restoring humanoid control flags via signals in the destructor.

## API

Real definitions:

- `const char* const sSeated = "Seated"`.
- `Seated::Seated(Humanoid*, StateType)` — body: `setCanThrottleState(true)`; source comment above the dtor: "note - constructor always sets to false" (referring to the base ctor's throttle default).
- `Seated::~Seated()` — `setSeatPart(NULL)`, `setSit(false)`, fires `doneSittingSignal()`.
- `const char* const sPlatformStanding = "PlatformStanding"`.
- `PlatformStanding::PlatformStanding(Humanoid*, StateType)` — body: `setCanThrottleState(true)`.
- `PlatformStanding::~PlatformStanding()` — `setPlatformStanding(false)`, fires `donePlatformStandingSignal()`.

`onComputeForceImpl`, limb-collision overrides, and auto-jump-off remain header-inline no-ops/false.

## Usage

Implements Seated.h in the HumanoidState machine. Transition triggers:

- **→ SEATED**: SIT_CMD from every ordinary state — the master table routes SIT_CMD to SEATED from FALLING_DWN, GETTING_UP, JUMPING, SWIMMING, FREE_FALL, FLYING, LANDED, RUNNING, RUNNING_SLAVE, RUNNING_NO_PHYS, STRAFING_NO_PHYS, CLIMBING, and PLATFORM_STANDING (RAGDOLL's SIT column stays xx).
- **SEATED exits**: NO_SIT_CMD → RUNNING, JUMP_CMD → JUMPING, PLATFORM_STAND_CMD → PLATFORM_STANDING, DEAD.
- **→ PLATFORM_STANDING**: PLATFORM_STAND_CMD from every ordinary state except RAGDOLL (its column is xx) and DEAD/PHYSICS; PLATFORM_STANDING's own row is xx (no self-transition needed).
- **PLATFORM_STANDING exits**: NO_PLATFORM_STAND_CMD → RUNNING, JUMP_CMD → JUMPING, SIT_CMD → SEATED, DEAD.
- Both are also the only states for which `updateHumanoidFloorStatus` deliberately retains lastFloor when the floor changes ("If we Sit, we still want to remember last floor", HumanoidState.cpp).

## Gotchas

- These are the ONLY states that call `setCanThrottleState(true)` — matching HumanoidState.h's comment that only Seated may throttle, because a seated character is jointed to parts and must keep simulating while others throttle. The flag flips six primitives' canThrottle at once (head/torso/arms/legs).
- The certified header doc guessed "weld teardown lives in the .cpp" — it does not; the destructors only clear SeatPart/sit/platformStanding and fire internal signals. Weld/joint cleanup happens through normal seat un-welding elsewhere.
- `doneSittingSignal` / `donePlatformStandingSignal` are the internal (non-reflected) counterparts of the reflected Seated/PlatformStanding events — they fire on BOTH client and server whenever the state is destroyed, including death transitions.
