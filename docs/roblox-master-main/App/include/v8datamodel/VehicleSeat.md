# App/include/v8datamodel/VehicleSeat.h

## Purpose

`VehicleSeat` — creatable seat combining `SeatImpl<PartInstance>` (seating welds) with `KernelJoint`: when occupied, drives hinge joints per throttle/steer through a lookup-table force policy with MaxSpeed/TurnSpeed/Torque tuning and optional HUD; pairs with a weak `VehicleController`.

## Declared API

`class VehicleSeat : public DescribedCreatable<VehicleSeat, SeatImpl<PartInstance>, sVehicleSeat>, public KernelJoint`

- Remote signals: `createSeatWeldSignal<void(shared_ptr<Instance>)>`, `destroySeatWeldSignal<void()>`.
- Ctor/virtual dtor.
- Public control/tuning API: `getNumHinges()`; inline getters + setters for `Throttle(int)`, `EnableHud(bool)`, `Steer(int)` (each −1/0/1 for throttle/steer), `MaxSpeed(float)`, `TurnSpeed(float)`, `Torque(float)` ("dominates low-end startup performance"); `Humanoid* getLocalHumanoid()`.
- Private state: saved floats maxSpeed/turnSpeed/torque + enableHud; controller-interface ints; `World* world`; parallel G3D arrays `hinges (RotateJoint*)`, `onRights`, `axlePointingIns`, `axleVelocities`; `weak_ptr<VehicleController> myController`.
- Private machinery: `computeNumHinges()`, `doLoadHinges(Primitive*)`, `loadMotorsAndHinges()`, `getJointInfo(RotateJoint*, bool& aligned, bool& onRight, bool& axlePointingIn)`, `stepHinges()`, **`int lookupFunction(int throttle, int steer, bool onRight, bool overMaxSpeed, bool overTurnSpeed, float jointVelocity)`** — the drive-policy table lookup.
- Overrides: Instance `onAncestorChanged/onServiceProvider`; SeatImpl `onSeatedChanged(bool, Humanoid*)`, `createSeatWeld(Humanoid*)`, `findAndDestroySeatWeld()`, `setOccupant(Humanoid*)`; KernelJoint `computeForce(bool throttling)`, `getEngineBody()`, `canStepUi(){true}`, `stepUi(double distributedGameTime)`; IAdornable `shouldRender2d()/render2d(Adorn*)`; CameraSubject `getCameraIgnorePrimitives(...)`; local seated/unseated handlers.

## Gotchas

- Dual inheritance: an Instance AND a KernelJoint — the seat itself participates in physics as a joint.
- Drive behavior is a discrete lookupFunction over quantized inputs — smooth analog input is flattened to −1/0/1 upstream.
- Hinge bookkeeping uses four PARALLEL arrays — index desync is a latent bug class.
- Controller held by WEAK ref (opposite of SkateboardPlatform's shared_ptr) — controller lifetime is external.

## UNKNOWN

- lookupFunction table contents (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/VehicleSeat.md](../../v8datamodel/VehicleSeat.md).
- Base seating: [Seat.md](Seat.md); controller: [UserController.md](UserController.md) (VehicleController); skate kin: [SkateboardPlatform.md](SkateboardPlatform.md).
