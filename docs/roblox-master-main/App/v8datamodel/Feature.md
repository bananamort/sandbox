# Feature.cpp

## Purpose

Implements the hole/axle joint family: `Feature` ("Feature") — a positioned face marker on a part (FaceId + TopBottom/LeftRight/InOut grid), `Hole` ("Hole") and `MotorFeature` ("MotorFeature") visual variants, and `VelocityMotor` ("VelocityMotor") — a JointInstance(MotorJoint) that connects an axle's parent primitive to a Hole's parent primitive at the feature's local frame, driven by MaxVelocity/DesiredAngle/CurrentAngle.

## Key types and API

Descriptors:
- Feature: prop_FaceId("FaceId"), prop_TopBottom("TopBottom" enum {Top, Center, Bottom}), prop_LeftRight("LeftRight" {Left, Center, Right}), prop_InOut("InOut" {Edge, Inset, Center}) — all category_Data, no Security:: arguments.
- VelocityMotor: `prop_Hole("Hole", category_Data)` RefPropDescriptor<Hole>; `prop_MaxVelocity("MaxVelocity")`, `prop_DesiredAngle("DesiredAngle")`, `prop_CurrentAngle("CurrentAngle")` floats — direct MotorJoint field mirrors.

Constants: sFeature/sHole/sMotorFeature/sVelocityMotor. Enums registered here: TopBottom/LeftRight/InOut.

Behavior:
- `computeLocalCoordinateFrame` — maps the 3-axis selector grid onto the chosen part face's UV space from extents corner; InOut=Inset pulls 1 stud inside; rotation flips to opposite face when coord orientation isn't Z_OUT.
- `MotorFeature::canJoin(i0,i1)` — exactly Hole+MotorFeature pair; static `join` creates a VelocityMotor under the axle with Hole ref set.
- VelocityMotor.setPart(i, feature) binds joint primitive i to the feature's PARENT part at the feature's local CF; onAncestorChanged re-binds part0 and moves the joint between Worlds (removeJoint "is this dangerous?..." comment); Hole ancestry change re-binds part1.
- Rendering: selection cylinder for Feature; black small cylinder (Hole), yellow long cylinder (MotorFeature).

## Usage / reflection touchpoints

JoinCommand in [Commands](Commands.md) uses canJoin/join; joint base machinery [JointInstance](JointInstance.md); V8World MotorJoint ([Base](../../Base/)).

## Gotchas

- VelocityMotor's joint lives under the AXLE instance but references BOTH parts — deleting either feature silently leaves a dangling Hole weak-ref path.
- CurrentAngle setter writes the joint's current angle directly — scripts can teleport the motor state.
- computeLocalCoordinateFrame returns identity when unparented; getRenderCoord then fails gracefully.
