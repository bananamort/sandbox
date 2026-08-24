# App/include/v8world/MultiJoint.h

## Purpose

Base for joints that hold the two bodies together with *multiple* kernel attachment points and breakable connectors — up to 8 `Point`s and 4 `NormalBreakConnector`s. Parents: [WeldJoint.md](WeldJoint.md), [GlueJoint.md](GlueJoint.md), [SnapJoint.md](SnapJoint.md).

## Declared API

- `class MultiJoint : public Joint`
  - Members: `int numConnector; Point* point[8]; Connector* connector[4];` ("NormalBreakConnector"), `int numBreakingConnectors;`
  - Protected ctors: `MultiJoint(int numBreaking);` and full `(Primitive* p0, Primitive* p1, const CoordinateFrame& jointCoord0, const CoordinateFrame& jointCoord1, int numBreaking);` virtual dtor.
  - Kernel: `putInKernel(Kernel*)` / `removeFromKernel()` overrides — create/destroy the points & connectors in the kernel.
  - Joint override: `bool isBroken() const`.
  - Assembly helpers: `void addToMultiJoint(Point* point0, Point* point1, Connector*)`, `Point* getPoint(int id)`, `Connector* getConnector(int id)`, `float getJointK()`.
  - Validation: `pointsAligned() const`, `validateMultiJoint()`.

## Gotchas

- Fixed capacities: ≤8 points, ≤4 connectors — set by `numBreakingConnectors`; exceeding is unsupported.
- Points/connectors are kernel objects created on `putInKernel`; before kernel entry they're presumably NULL — `getPoint/getConnector` outside the kernel is invalid.

## UNKNOWN

- Exact semantics of `numBreaking` vs `numConnector` split (implementation-only).

## Cross-links

- Base: [Joint.md](Joint.md); kernel objects: [v8kernel/Point.md](../v8kernel/Point.md), [v8kernel/Connector.md](../v8kernel/Connector.md) (NormalBreakConnector).
