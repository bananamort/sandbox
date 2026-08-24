# App/include/v8datamodel/SkateboardPlatform.h

## Purpose

`SkateboardPlatform` — creatable part combining `PlatformImpl<BasicPartInstance>` (ride-on-mount machinery) with `KernelJoint`: a physics-driven skateboard with wheels (RotateJoint array), throttle/steer ints, gyro targeting, MoveState machine (ground: STOPPED/COASTING/PUSHING/STOPPING; air: AIR_FREE), tunable force/velocity BoundProps, and equip signals. Legacy vehicle-era content.

## Declared API

`class SkateboardPlatform : public DescribedCreatable<SkateboardPlatform, PlatformImpl<BasicPartInstance>, sSkateboardPlatform>, public KernelJoint`

- `enum MoveState { STOPPED=0, COASTING, PUSHING, STOPPING, AIR_FREE }`; static inline classifiers `isGroundState(state) {return state <= STOPPING;}`, `isAirState {state >= AIR_FREE;}`.
- Public control API: `setThrottle(int)/getThrottle()`, `setSteer(int)/getSteer()` (ints −1/0/1); `setMoveState(const MoveState&)/getMoveState()`; `setStickyWheels(bool)/getStickyWheels()` ("apply downforce to stabilize board").
- Signals: `moveStateChangedSignal<void(MoveState newState, MoveState oldState)>`; `equippedSignal<void(shared_ptr<Instance> humanoid, shared_ptr<Instance> controller)>` ("this is better"); `unequippedSignal<void(humanoid)>`; remote signals `createPlatformMotor6DSignal<void(shared_ptr<Instance>)>` / `destroyPlatformMotor6DSignal<void()>` (PlatformImpl plumbing).
- Accessors: `SkateboardController* getController() const`, `Humanoid* getControllingHumanoid() const`.
- Impulses: `applySpecificImpulse(Vector3 impulseWorld)` + overload `(Vector3, Vector3 worldpos)` (implements PlatformImpl's kick hook).
- Static BoundProps: `prop_MaxPushVelocity`, `prop_MaxPushForce`, `prop_StopForceMultiplier`, `prop_MaxTurnVelocity`, `prop_MaxTurnTorque`, `prop_TurnTorqueGain`.
- PlatformImpl overrides: `createPlatformMotor6D(Humanoid*)`, `findAndDestroyPlatformMotor6D()`.
- Private physics internals: turnRate float; controller-interface ints; `gyroTarget/gyroConvergeSpeed`, moveState, `specificImpulseAccumulator`; `World* world`; per-step caches (`Motor6D* motor6D`, `Humanoid* humanoid`, `numWheelsGrounded`); `float forwardVelocity` ("accumulated on ApplyForces, meant for use on StepUI"); `struct Wheel { RotateJoint* joint; bool grounded; }`; `shared_ptr<SkateboardController> myController`; `G3D::Array<Wheel> wheels`; motion helpers (`doTurn(yRotVelocity)/doPush(forwardVelocity)/doStop(...)/applyForwardForce(force)/getGroundSpeed()`), wheel management (`doLoadWheels(Primitive*)/loadWheels()/isFullyGrounded()/countGroundedWheels()`); tuning floats (maxPushVelocity/maxPushForce/stopForceMultiplier/maxTurnVelocity/maxTurnTorque/turnTorqueGain — "if deltaV == 1, apply maxTorque essentially"); static `delayedReparentToWorkspace(weak_ptr<ModelInstance> Board, weak_ptr<ModelInstance> Figure)`.
- Overrides: Instance `onAncestorChanged/onServiceProvider`; PlatformImpl `onPlatformStandingChanged(bool, Humanoid*)`; IAdornable `shouldRender2d()/render2d(Adorn*)`; KernelJoint `computeForce(bool throttling)/getEngineBody()/canStepUi(){true}/stepUi(double distributedGameTime)`; CameraSubject `getCameraIgnorePrimitives`.

## Gotchas

- Dual inheritance from an Instance chain AND KernelJoint — the platform is simultaneously a part and a joint in the physics kernel.
- Controller↔platform interface uses int quantization while SkateboardController keeps floats.
- Wheels are raw RotateJoint* in a G3D::Array — lifetime tied to world/primitive teardown order.
- Camera ignores its primitives via getCameraIgnorePrimitives (seated-camera handling).

## UNKNOWN

- Where delayedReparentToWorkspace is scheduled from (deferred teardown path).

## Cross-links

- Implementation: [App/v8datamodel/SkateboardPlatform.md](../../v8datamodel/SkateboardPlatform.md).
- Base: [Platform.md](Platform.md), [BasicPartInstance.md](BasicPartInstance.md); controller: [SkateboardController.md](SkateboardController.md); seating kin: [Seat.md](Seat.md).
