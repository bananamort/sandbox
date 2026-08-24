# App/include/v8datamodel/Feature.h

## Purpose

Legacy joint-anchor family: `Feature` (non-creatable) marks a point on a part face via face + 9-cell position enums; `MotorFeature` and `Hole` are the creatable pair used by the old snap-together motor system; `VelocityMotor` (a JointInstance) drives rotation between a Hole/Feature pair.

## Declared API

`class Feature : public DescribedNonCreatable<Feature, Instance, sFeature>, public IAdornable`

- Enums ("ouch - for properties" — public for reflection): `TopBottom {TOP, CENTER_TB, BOTTOM}`, `LeftRight {LEFT, CENTER_LR, RIGHT}`, `InOut {EDGE, INSET, CENTER_IO}`; `typedef NormalId FaceId;`
- Public fields: `FaceId faceId; TopBottom topBottom; LeftRight leftRight; InOut inOut;` each with getter/setter (`getFaceId/setFaceId(NormalId)` etc.).
- `CoordinateFrame computeLocalCoordinateFrame() const;` protected `bool getRenderCoord(CoordinateFrame& c) const;`
- Protected: `enum InOutZ {Z_IN, Z_OUT}; virtual InOutZ getCoordOrientation() const { return Z_OUT; }` — Holes invert orientation.
- Overrides: askSetParent → true; adorn render of the feature marker.

`class MotorFeature : public DescribedCreatable<MotorFeature, Feature, sMotorFeature>`

- `MotorFeature(); static bool canJoin(Instance* i0, Instance* i1); static void join(Instance* i0, Instance* i1);` private no-op `otherFeatureChanged()`; renders its own adorn.

`class Hole : public DescribedCreatable<Hole, Feature, sHole>` — `getCoordOrientation() → Z_IN`; renders its own adorn; ctor only.

`class VelocityMotor : public DescribedCreatable<VelocityMotor, JointInstance, sVelocityMotor>`

- Joint surface: `float getMaxVelocity()/setMaxVelocity(float)`, `getDesiredAngle()/setDesiredAngle`, `getCurrentAngle()/setCurrentAngle`.
- Hole link: `Hole* getHole() const; void setHole(Hole* value);` private `shared_ptr<Hole> hole`, connection `holeAncestorChanged` + handler, `setPart(int i, Feature*)`, `MotorJoint* motorJoint()` accessors.
- Ctor/dtor; overrides `askSetParent → true`, `onAncestorChanged`.

## Gotchas

- Position is a 3-axis enum product (27 cells), not a free Vector3.
- The comment "ouch - for properties" concedes the enum placement was forced by reflection.
- VelocityMotor wraps a MotorJoint pointer obtained at runtime; null until joined (.cpp).
- Feature itself non-creatable — only MotorFeature/Hole appear in scripts.

## UNKNOWN

- Exact join rules of MotorFeature::canJoin (.cpp — see [Feature.md](../../v8datamodel/Feature.md)).

## Cross-links

- Implementation: [App/v8datamodel/Feature.md](../../v8datamodel/Feature.md).
- Joints: [JointInstance.md](JointInstance.md), [ManualJointHelper.md](ManualJointHelper.md), [Gyro.md](Gyro.md).
