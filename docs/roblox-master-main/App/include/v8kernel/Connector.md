# App/include/v8kernel/Connector.h

## Purpose

Connector base for everything the kernel iterates (contacts, joints, humanoid, buoyancy) plus joint-flavored connectors: `JointConnector` marker, `RotateConnector` (angular spring with goal stepping), `PointToPointBreakConnector` (linear breakable spring), `NormalBreakConnector` (face-normal variant). Kernel friendship exposes per-list index slots.

## Declared API

- `class RBXBaseClass Connector` — friends `KernelData`, `Kernel`.
  - Private index slots: `humanoidIndex, realTimeIndex, secondPassIndex, jointIndex, buoyancyIndex, contactIndex` (−1 = not in that kernel list); public int& getters + `isHumanoid()/isRealTime()/isSecondPass()/isJoint()/isBuoyancy()/isContact()` (≥0 tests) + combined `isInKernel()`.
  - Protected: `typedef enum { CONTACT, JOINT, HUMANOID, KERNEL_JOINT, BUOYANCY } KernelType;` ("only add types that KernelData.h can handle") + pure virtual `KernelType getConnectorKernelType() const = 0;`
  - Ctor inits all indices −1; virtual dtor.
  - Kernel-called interface: `virtual bool computeCanThrottle();` pure `void computeForce(bool throttling) = 0;` `virtual bool computeImpulse(float& residualVelocity) {return false;}` `virtual bool getBroken() {return false;}` `typedef enum { body0, body1 } BodyIndex; virtual Body* getBody(BodyIndex id) = 0;` debug `virtual float potentialEnergy() {return 0.0;}`
- `class JointConnector : public Connector` — sets kernel type JOINT; no extra members.
- Rotate spring math documented in-header: "Force = kForce * d_length … kTorque = kForce * L * L".
- `class RotateConnector : public JointConnector`
  - Ctor: `(Body* b0, Body* b1, const CoordinateFrame& j0, const CoordinateFrame& j1, float baseAngle, float kValue, float armLength)`.
  - Protected state: bodies `b0/b1`, joint frames `j0/j1`, `float k;` integrator props `currentAngle, desiredAngle, increment; bool zeroVelocity; float baseRotation;` ("rotation when assembled").
  - Protected: `computeNormalRotation(Vector3&)`, `computeNormalRotationFromBase(Vector3&)`, `...Fast(...)` variant, `virtual void stepGoals();`, getBody override, computeForce override.
  - Public: `void reset();` ("after networking receive — update to synch internal desiredRotation"); `setRotationalGoal(float)` / `setVelocityGoal(float)`; static `computeJointAngle(b0CF, b1CF, j0CF, j1CF, Vector3& normal)`.
- `class PointToPointBreakConnector : public JointConnector`
  - Ctor `(Point*, Point*, float k, float breakForce)` inline; protected `Point* point0/point1; float k; float breakForce; bool broken;`
  - `forceToPoints(const G3D::Vector3& force);` computeForce/getBroken/potentialEnergy overrides; `setBroken()` inline ("one 'Joint' may need to break all connectors"); stiffness `getStiffness/setStiffness`.
- `class NormalBreakConnector : public PointToPointBreakConnector, public Allocator<NormalBreakConnector>`
  - Adds `NormalId normalIdBody0;` ctor takes it; overrides computeForce. Header TODO: "update normal very infrequently...."

## Gotchas

- `broken` starts false and only flips via setBroken or force overload — there's no un-break.
- `getBody(BodyIndex)` semantics differ per subclass (RotateConnector returns b0/b1; PointToPoint derives from points' bodies).
- RotateConnector stores an arm length implicitly through k conversion (kTorque = kForce·L²) — changing k without L context mis-scales forces.
