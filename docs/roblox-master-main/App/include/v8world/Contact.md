# App/include/v8world/Contact.h

## Purpose

Contact edge base + the classic analytic contact types: `BallBallContact`, `BallBlockContact`, `BlockBlockContact` (SAT with plane/edge GeoPairs, hysteresis via `BlockBlockContactData`). Contacts are `Edge`s whose kernel-side connectors carry the actual impulse math.

## Declared API

- Macros: `#define CONTACT_ARRAY_SIZE 40`, `#define BULLET_CONTACT_ARRAY_SIZE 40`.
- `class RBXBaseClass Contact : public Edge`
  - `enum ContactType { Contact_Simple, Contact_Cell, Contact_Buoyancy };` default `getContactType() → Contact_Simple`.
  - `Contact(Primitive* p0, Primitive* p1); virtual ~Contact();`
  - CollisionStage bookkeeping: `short getNumTouchCycles()`, `int& steppingIndexFunc()` ("fast removal from stepping list"), `bool isInContact()` (`lastUiContactStep > 0`), static `ignoreBool`.
  - Proximity: `typedef bool (Contact::*ProximityTest)(float);` `bool computeIsAdjacentUi(float spaceAllowed);` `virtual bool computeIsCollidingUi(float)`; pure `computeIsColliding(float overlapIgnored) = 0`.
  - Pure interface: `deleteAllConnectors() = 0`, `stepContact() = 0`, `int numConnectors() const = 0`, `ContactConnector* getConnector(int i) = 0`.
  - Lifecycle: `bool step(int uiStepId);` `onPrimitiveContactParametersChanged();` `primitiveMovedExternally();` `virtual void generateDataForMovingAssemblyStage(void);` `virtual void invalidateContactCache();`
  - Access: `static bool isContact(Edge*);` `ContactParams* getContactParams();` protected `contactParams`, `Body* getBody(int)`. Edge overrides route put/remove through Super; `removeFromKernel` deletes all connectors first.
- `class BallBallContact : public Contact, public Allocator<...>` — single optional `BallBallConnector*`; `numConnectors()` = 1 or 0; ctor/dtor inline with dtor assert.
- `class BallBlockContact : public Contact, public Allocator<...>` — single optional `BallBlockConnector*`; private `computeIsColliding(int& onBorder, Vector3int16& clip, Vector3& projectionInBlock, float overlapIgnored)` using Block's clip-space queries; identifies ball/block prims internally.
- `class BlockBlockContact : public Contact, public Allocator<...>`
  - Static debug counters: `pairMatches/pairMisses/featureMatches/featureMisses` + `static float pairHitRatio()/featureHitRatio()`.
  - `typedef FixedArray<GeoPairConnector*, 8> ConnectorArray;` data offloaded to friend `BlockBlockContactData* myData`.
  - GeoPair loading: `findGeoPairConnector(Body*, Body*, GeoPairType, int param0, int param1)`, `loadGeoPairEdgeEdge(...)`, `loadGeoPairPointPlane(pointBody, planeBody, pointID, NormalId pointFaceID, NormalId planeFaceID)`.
  - SAT helpers (inline): `boxProjection(normal0, R1, extent1, float& projectedExtent)`, `updateBestAxis(proj0, p0p1, proj1, float& _overlap, float overlapIgnored)` — `_overlap = proj0 + proj1 − |p0p1|`, contact iff `> overlapIgnored`.
  - Plane/edge selection: `getBestPlaneEdge(float, bool& planeContact)`, `intersectRectQuad(Vector2&, Vector2(&)[4])`, `geoFeaturesOverlap(...)`; full override set of the Contact interface.
- `class BlockBlockContactData` (friend of the above)
  - Double-buffered `connectors[2]` + `connectorsIndex`; hysteresis fields `witnessId`, `separatingAxisId`; feature encoding `feature[2]`: "−1 no feature, 0..5 plane, 6..8 edge Normal" plus `bPlane/bOther/planeID/otherPlaneID`; back-pointer `myOwner`.
  - API mirrors owner: `numConnectors/getConnector/clearConnectors/findGeoPairConnector/stepContact/loadGeoPairEdgeEdgePlane/getBestPlaneEdge/computePlaneContact/intersectRectQuad`.

## Gotchas

- `removeFromKernel()` asserts kernel presence and destroys all connectors — a Contact removed while in kernel must re-create connectors on re-add.
- BlockBlock uses cached witness/separating-axis hysteresis — connector sets are only as good as the last step's feature match; forcing cache invalidation (`invalidateContactCache`) is required after teleports.
- `CONTACT_ARRAY_SIZE`/`BULLET_CONTACT_ARRAY_SIZE` are preprocessor macros (not typed constants) — leak into every includer.

## Cross-links

- Kernel impulse side: [v8kernel/ContactConnector.md](../v8kernel/ContactConnector.md), [v8kernel/ContactParams.md](../v8kernel/ContactParams.md) (kFriction ×−0.5 storage quirk).
- Specializations: [CellContact.md](CellContact.md), [PolyContact.md](PolyContact.md), [Buoyancy.md](Buoyancy.md), [BulletShapeContact.md](BulletShapeContact.md); base edge: [Edge.md](Edge.md).
