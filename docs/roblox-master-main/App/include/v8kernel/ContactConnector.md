# App/include/v8kernel/ContactConnector.h

## Purpose

Contact-resolution connectors: `ContactConnector` base holds the contact point cache, impulse math matrices, resting/penetration state and the kernel's force/impulse entry points; concrete `GeoPairConnector` (point-plane / edge pairs via [Pair.md](Pair.md)), `BallBallConnector`, and `BallBlockConnector` (ball-point/edge/plane). Base class of [PolyConnectors.md](PolyConnectors.md) and [BuoyancyConnector.md](BuoyancyConnector.md) (which reuses the plumbing with BUOYANCY type).

## Declared API

- `class ContactConnector : public Connector`
  - Ctor `(Body* b0, Body* b1, const ContactParams&)` — sets geoPair bodies, calls reset(); kernel type CONTACT.
  - Statics: `int inContactHit/outOfContactHit;` counters; `static float percentActive();` debug; `static float overlapGoal()` inline → **0.01f** ("standard goal seek for overlapping objects").
  - State: `int age; Matrix3 deltaVelPerUnitImpulse; Matrix3 impulsePerUnitDeltaVel; float inverseMass; float penetrationVelocity, reboundVelocity; bool impulseComputed;` protected: `GeoPair geoPair; ContactParams contactParams; PairParams oldContactPoint, contactPoint; float firstApproach, threshold; float forceMagLast; Vector3 frictionOffset;`
  - Public: `virtual void updateContactPoint();` body access `getBody(BodyIndex)` from geoPair + `setBody(int id, Body*)`; `void reset()` ("cleans up state variables for buffered version"); inline `clearImpulseComputed()`; `bool isIntersecting()` (asserts POINT_PLANE_PAIR type! then `length < -overlapGoal()`);
  - Reordering: `bool getReordedSimBody(SimBody*& s0, SimBody*& s1, Body*& bodyNotInKernel, PairParams&)` and 3-arg overload — "Reorder the SimBody(s) so that simBody0 is always in kernel".
  - Velocities: `getSimBodyAndContactVelocity(SimBody*& ×2, PairParams&, float& normalVel, Vector3& perpVel)`, `float computeRelativeVelocity(const PairParams&, Vector3* deltaVnormal, Vector3* perpVel)`, zero-arg `computeRelativeVelocity()`.
  - Symmetry detection: `applyContactPointForSymmetryDetection(SimBody*, SimBody*, const PairParams&, float direction);`
  - Params: `getContactParams()/setContactParams()`.
  - Kernel-called: computeForce override, computeImpulse override (`float& residualVelocity`), `canThrottle() const` override.
  - Queries: `computeOverlap()` (calls updateContactPoint, returns `-contactPoint.length`, "positive == bigger overlap"); `getContactPoint()` const/non-const; `getLengthNormalPosition(Vector3&, Vector3&, float&)`; inline `isRestingContact()` → `age > 4`.
- `class GeoPairConnector : public ContactConnector, public Allocator<...>` — updateContactPoint computes geoPair then calls base; forwarding setters `setPointPlane/setEdgeEdgePlane/setEdgeEdge` + `match(...)` mirroring GeoPair's.
- `class BallBallConnector : public ContactConnector, public Allocator<...>` — private `radius0/radiusSum`; `setRadius(r0, r1)` (computes sum); override updateContactPoint.
- `class BallBlockConnector : public ContactConnector, public Allocator<...>` — private `radius0` (ball), `Vector3 offset1; NormalId normalId1; GeoPairType geoPairType;` computers `computeBallPoint/BallEdge/BallPlane(PairParams&)`; `setBallBlock(radius0, offset1*, normalID, geoPairType)`; override.

## Gotchas

- `isIntersecting()` asserts the pair is POINT_PLANE — calling it on ball/ball or edge connectors aborts in checked builds and is meaningless otherwise; use `computeOverlap()` instead.
- `age > 4` defines resting contact — age resets in `reset()`, incremented by the contact pipeline.
- Sign convention: `contactPoint.length < 0` means penetration; overlap goal seeks −0.01.
- `setBody(int, ...)` takes a raw int while getBody uses the BodyIndex enum — no range check on the int path.

## UNKNOWN

- Cross-links: physics implementation details live under App/script + Base docs where present; the contact solver math itself is in v8kernel .cpps outside this tree.
