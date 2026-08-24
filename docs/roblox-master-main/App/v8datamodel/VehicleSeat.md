# VehicleSeat.cpp

## Purpose

Implements `VehicleSeat` ("VehicleSeat"), the drivable seat PartInstance: Throttle/Steer/MaxSpeed/TurnSpeed/Torque control surface, automatic detection of aligned RotateJoint "hinges" in its assembly with per-wheel torque lookup tables, optional speed HUD, ground-anchored joint lifecycle like SkateboardPlatform.md, CollectionService tagging, and client-mode weld replication like Seat.md.

## Key types and API

Descriptors (category "Control"):
- `propDisabled("Disabled")` bool; `propOccupant("Occupant")` read-only RefProp Humanoid cap SCRIPTING.
- `propThrottle("Throttle")` / `propSteer("Steer")` int clamped ±1; `propMaxSpeed("MaxSpeed")` float default 25; `propTurnSpeed("TurnSpeed")` float default 1.0; `propTorque("Torque")` float default 10; `propEnableHud("HeadsUpDisplay")` bool default true; `propNumHinges("AreHingesDetected")` int read-only cap UI (getter const_casts to recompute — "hack hack hack").
- Remote events (**Security::None**, REPLICATE_ONLY, CLIENT_SERVER): "RemoteCreateSeatWeld(humanoid)", "RemoteDestroySeatWeld".

DFFlag SmootherVehicleSeatControlSystem(false); FFlag UseInGameTopBar consumed.

Drive model:
- Hinge discovery: loadMotorsAndHinges walks assembly primitives ONLY when NOT grounded, collecting RotateJoints whose axle aligns with the seat's right vector (|dot|>0.8); records onRight (joint offset side) and axlePointingIn (axle direction parity).
- stepUi tickles both hinge primitives when throttle/steer active; computeForce → stepHinges: per hinge, velocity sign corrected by axlePointingIn, polarity from `throttleSteerRightSpeedTurn[3][3][2][2][2]` lookup keyed by (throttle+1, steer+1, right?, overMaxSpeed, overTurnSpeed) — zero entries mean LOCK (oppose current joint velocity); applied torque = polarity × axleDirection × torque × 1000 ("make properties nice"), split +/− across axle/hole bodies.
- Smoother flag path (PGS solver only): gain shaping — steer==0 blends by |velocity|/10 with sign-flip damping and turnCorrectionFactor (rotY×throttle×5 clamped ±1), throttle>0 eases near MaxSpeed; steering gains from TurnSpeed headroom.

Seat lifecycle:
- onSeatedChanged local-only: seated ⇒ camera CUSTOM + subject=this + initial CF 15 behind/10 above torso look; unseated ⇒ camera back to humanoid + setSit(false); always zeroes throttle/steer; render-dirty.
- onServiceProvider adds/removes itself to CollectionService; onAncestorChanged inserts/removes the ground joint (primitives [self, groundPrimitive]) and raises AreHingesDetected ("not perfect, but a start").
- HUD render2d draws blue speed bar + text unless HeadsUpDisplay off or UseInGameTopBar.
- Weld replication identical pattern to Seat.md (client debounce).

## Usage / reflection touchpoints

Full classic vehicle API script-facing. Pairs with UserController.md VehicleController (drives these properties), Seat.md/SkateboardPlatform.md siblings, CollectionService.md here, [Network](../../Network/).

## Gotchas

- AreHingesDetected getter recomputes via const_cast and REBUILDS hinge lists — reading the property has side effects on cached arrays.
- Hinge list is stale while grounded (load skipped) — torque applies to last airborne snapshot after landing until next liftoff.
- Lookup table treats throttle=−1 rows as "Backward" with asymmetric left/right lock behavior; out-of-range throttle/steer can't occur (clamped ±1).
- Torque ×1000 multiplier means property values are cosmetic-scale; physics sees 1000×.
- UNKNOWN: getLocalHumanoidFromContext vs getTorsoFast details header-side; RotateJoint axle math in V8World docs.
