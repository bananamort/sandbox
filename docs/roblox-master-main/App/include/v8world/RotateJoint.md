# App/include/v8world/RotateJoint.h

## Purpose

Hinge family built on [MultiJoint.md](MultiJoint.md): `RotateJoint` (surface-driven hinge, ROTATE_JOINT) plus dynamic variants — base `DynamicRotateJoint`, position servo `RotatePJoint` (ROTATE_P_JOINT), and velocity servo `RotateVJoint` (ROTATE_V_JOINT). Axle↔hole semantics; PGS-era constraints (`ConstraintAlign2Axes`, `ConstraintBallInSocket`, `ConstraintAngularVelocity`) supplement legacy connectors.

## Declared API

- `class RotateJoint : public MultiJoint`
  - `typedef enum {AXLE_ID = 0, HOLE_ID} AxleHoleId;`
  - Ctors: default; `(Primitive* axlePrim, Primitive* holePrim, const CoordinateFrame& c0, const CoordinateFrame& c1);` virtual dtor.
  - Static factory: `static RotateJoint* canBuildJoint(p0, p1, nId0, nId1)` via private `surfaceTypeToJoint(SurfaceType, axlePrim, holePrim, c0, c1)` — builds only when surfaces are hinge/hole compatible.
  - Accessors: `getAxlePrim()/getHolePrim()`, `getAxleId()/getHoleId()` (NormalIds), `Vector3 getAxleWorldDirection()`, `float getAxleVelocity()`.
  - Protected: `getPrimitivesTorqueArmLength(float& axleArm, float& holeArm)`, `void update();` members `ConstraintAlign2Axes* align2Axes; ConstraintBallInSocket* ballInSocket;`
  - Overrides: `putInKernel/removeFromKernel`, `getJointType → ROTATE_JOINT`.
- `class DynamicRotateJoint : public RotateJoint`
  - Overrides: `canStepWorld/canStepUi → true`; `bool stepUi(double distributedGameTime);` `void setPhysics()` ("occurs after networking read"); own kernel add/remove.
  - Members: protected `float baseAngle` ("initial assembled rotation angle"), `RotateConnector* rotateConnector` ("here when in kernel"), public-ish `float uiValue;`
  - API: `getBaseAngle()/setBaseAngle(float)`, `float getTorqueArmLength()`, private `getChannelValue(double)`.
- `class RotatePJoint : public DynamicRotateJoint` — `getJointType → ROTATE_P_JOINT`; `stepWorld()`; own kernel hooks; member `float currentAngle; ConstraintAlign2Axes* alignmentConstraint;`
- `class RotateVJoint : public DynamicRotateJoint` — `getJointType → ROTATE_V_JOINT`; `stepWorld()`; own kernel hooks; member `ConstraintAngularVelocity* angularVelocityConstraint;`

## Gotchas

- Three kernel strategies coexist (legacy RotateConnector vs PGS constraints) depending on build/kernel mode — kernel add/remove is overridden at every level.
- P/V distinction: position servo steps toward a channel value each world step; velocity servo constrains angular velocity.

## UNKNOWN

- Exact surface-type → joint mapping table (`surfaceTypeToJoint`) and `getChannelValue` sources.

## Cross-links

- Bases: [MultiJoint.md](MultiJoint.md), [Joint.md](Joint.md); connectors/constraints: [v8kernel/Connector.md](../v8kernel/Connector.md), [../solver/Constraint.md](../solver/Constraint.md).
