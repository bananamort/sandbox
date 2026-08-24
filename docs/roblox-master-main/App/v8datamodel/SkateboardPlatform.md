# SkateboardPlatform.cpp

## Purpose

Implements `SkateboardPlatform` ("SkateboardPlatform"), the legacy rideable board PartInstance: a ground-anchored joint (primitives [self, world ground]) with RotateJoint children treated as wheels, per-step force computation (push/stop/turn torques, sticky-wheel gravity cancellation), MoveState machine replicated to clients, mount/dismount flow that reparents the board Model into the character and swaps the camera subject, and client-mode seat-weld replication mirroring Seat.md.

## Key types and API

Descriptors:
- `propThrottle("Throttle")` / `propSteer("Steer")` — int, category "Control", clamped ±1.
- `propStickyWheels("StickyWheels")` — bool default true (gravity-torque cancel + stick-down forces when fully grounded).
- `propMoveState("MoveState")` — EnumPropDescriptor MoveState {Stopped, Coasting, Pushing, Stopping, AirFree}, cap **REPLICATE_ONLY**; setMoveState also raises event.
- Events: "MoveStateChanged(newState, oldState)"; "Equipped(humanoid, skateboardController)" + deprecated lowercase twin "equipped" (same signal, Security::None); "Unequipped(humanoid)" + deprecated "unequipped".
- `prop_Controller("Controller")` / `prop_ControllingHumanoid("ControllingHumanoid")` — read-only RefProps, cap UI.
- `desc_ApplySpecificImpulse("ApplySpecificImpulse(impulseWorld)")` — **Security::None**; accumulates into specificImpulseAccumulator applied next computeForce × branch mass at branch center of mass. (2-arg overload with position ignores rotation.)
- Remote events (**Security::None**, REPLICATE_ONLY, CLIENT_SERVER): "RemoteCreateMotor6D"/"RemoteDestroyMotor6D" — same pattern as Platform.md/Seat.md.

Physics constants: maxPushVelocity 40, maxPushForce 2000, stopForceMultiplier 1.5, maxTurnVelocity 2.5, maxTurnTorque 25000, turnTorqueGain 25000; minStopVelocity 0.1, deltaTurnRate 0.002, minTurnRate 0.005, maxTurnRate 1.

Step pipeline (`stepUi`): tickle primitive when throttle/steer active → loadWheels (collect assembly RotateJoints when NOT grounded... note inverted guard: loads wheels only when assembly not already grounded) → countGroundedWheels (2-stud raycasts per wheel joint via GeometryService stairs-filter) → MoveState from throttle/velocity/grounding → re-resolve motor6D with double RBXASSERT of humanoid match.

Forces (`computeForce`): forwardVelocity = −root-frame z velocity; push when throttle>0 (braking force ×1.5 if moving backward), stop when <0; steer ramps turnRate by ∓deltaTurnRate clamped to ±[min,max] then P-controller torque on Y; sticky wheels cancel gravity torque about board center, apply −½ gravity + full downforce along board normal.

Mount/dismount (`onPlatformStandingChanged`): clears old controller; LOCAL humanoid only — mount creates SkateboardController under ControllerService, camera subject→this/CUSTOM_CAMERA, moves board Model under character Model (both must be direct children of Models else MESSAGE_ERROR), fires Equipped; dismount restores camera to humanoid, fires Unequipped, clears platformStanding, DEFERS board→Workspace reparent via DataModel submitTask (delayedReparentToWorkspace validates parenting still holds).

World lifecycle: onAncestorChanged inserts/removes the special ground Joint (setPrimitive(0,self)/(1,groundPrimitive)) whenever in-workspace world changes, resetting controller/humanoid.

Camera ignore: getCameraIgnorePrimitives returns whole assembly primitives only while airborne.

## Usage / reflection touchpoints

Legacy but fully script-facing surface. Pairs with SkateboardController.md, Seat.md, Platform.md, Camera docs in this folder; V8World joints/mechanisms.

## Gotchas

- loadWheels runs ONLY when assembly is NOT grounded — grounded assemblies keep the previous wheel list (stale until airborne).
- Equipped fires ONLY when both humanoid and board are direct children of Models AND board isn't parent-locked; otherwise just an error print, no event.
- Deprecated lowercase equipped/unequipped events alias the SAME signals — connecting either catches all firings.
- stepUi's dead code blocks (auto-jump-on-flip, lean pose, findLip climb probe) document abandoned mechanics.
- countGroundedWheels requires this->humanoid non-null — wheel state stays zero before anyone mounts.
- UNKNOWN: debounceTime base-class member units header-side; Motor6D lookup helpers live elsewhere.
