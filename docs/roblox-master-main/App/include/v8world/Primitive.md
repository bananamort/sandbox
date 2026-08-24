# App/include/v8world/Primitive.h

## Purpose

The core world object — one collidable part. A Primitive bundles geometry + kernel Body + edge lists (joints/contacts), surface types per face, mass/material properties, network ownership, and pipeline membership. It is simultaneously a `SpanningNode` (assembly tree) and `BasicSpatialHashPrimitive` (broadphase), and bridges to the instance layer through its `IMoving*` owner.

## Declared API

- `enum NetworkOwnership { NetworkOwnership_Auto = 0, NetworkOwnership_Manual = 1 };`
- `class EdgeList` — per-primitive adjacency: entries of `{Edge*, Primitive* other}`; `size/getEdge/getOther` (very-fast asserts cross-check `otherPrimitive(owner)`), `getFirst`, `getNext(const Primitive*, Edge*)`, `insertEdge/removeEdge`; dtor asserts empty.
- `class Primitive : public IPipelined, public SpanningNode, public BodyPvSetter, public BasicSpatialHashPrimitive`
  - Statics: `bool allowSleep;` `defaultElasticity() = 0.75`, `defaultFriction() = 0.0`; `squaredDistance(p0,p1)`; `aaBoxCollide(p0,p1)` over fuzzy extents; `onNewOverlap/onStopOverlap(p0,p1)`.
  - Enums: `EngineType {DYNAMICS_ENGINE, HUMANOID_ENGINE}`; `SizeMultiplier {DEFAULT_SIZE, TORSO_SIZE, ROOT_SIZE, SEAT_SIZE}` — "overweights torsos and seats to make them roots of the spanning tree".
  - Identity/structure: `getGuid/setGuid`, `getSizeMultiplier/setSizeMultiplier`, `calculateSortSize()/getSortSize()`, `getWorld/setWorld`, `int& worldIndexFunc()` (fast list removal).
  - Grouping: `getClump/getConstClump`, `getAssembly/getConstAssembly`, `getMechanism/getConstMechanism`, `getMechRoot()`, `getRootMovingPrimitive()`, `isAncestorOf(Primitive*)`.
  - Geometry: `getGeometry/getConstGeometry`, `resetGeometryType/setGeometryType/getGeometryType`, `getCollideType`, private `newGeometry(GeometryType)` factory; `setGeometryParameter/getGeometryParameter` (forwarded); `setSize/getSize`, virtual `getRadius()`, `getPlanarSize()`, inline `getExtentsLocal()` (= ±½ size box), `getExtentsWorld()`, fuzzy extents (`getFastFuzzyExtents`, `getFastFuzzyExtentsNoCompute` with very-fast assert, static `fuzzyExtentsReset() = −2`), `hitTest(worldRay, hitPoint, normal)`, `isGeometryOrthogonal()`, `computeIsGrounded()`.
  - Transform/motion: `getPV()`, `getCoordinateFrame()`, **`getCoordinateFrameUnsafe()`** ("Faster: Thread must hold writer lock"), `setCoordinateFrame/setPV/setVelocity/zeroVelocity` ("doesn't tickle primitive"), `setMassInertia(float)`.
  - Physical props: `setSpecificGravity/getSpecificGravity`, `setDragging/getDragging`, `setAnchoredProperty/getAnchoredProperty`, `updateMassValues(bool physicalPropertiesEnabled)`, `getCalculateMass(bool)`, `requestFixed()` = dragging ∥ anchored ("FIXED == (anchored || dragging)"), friction/elasticity get/set, `setPhysicalProperties/getPhysicalProperties` (backed by `boost::flyweight<PhysicalProperties>` customPhysicalProperties), `setPartMaterial/getPartMaterial`.
  - Collision flags: `setPreventCollide/getPreventCollide`, `getCanCollide()` = !dragging && !preventCollide; throttle `setCanThrottle/getCanThrottle`.
  - Engine/network: `setEngineType/getEngineType`, `getNetworkOwner/setNetworkOwner(SystemAddress)`, `getNetworkOwnershipRuleInternal/setNetworkOwnershipRuleInternal`, `getNetworkIsSleeping/setNetworkIsSleeping(bool, Time wakeupNow)`, `onBuoyancyChanged(bool)`.
  - Faces/surfaces: `getFaceInObject/getFaceInWorld(NormalId)`, `getFaceCoordInObject(NormalId)`, `setSurfaceType/getSurfaceType(NormalId)`, `setSurfaceData/getSurfaceData/getConstSurfaceData(NormalId)` (NULL-safe → `SurfaceData::empty()`), `float getJointK()`.
  - Edges/joints/contacts: static `insertEdge/removeEdge(Edge*)`; `hasAutoJoints()`, `hasEdge()`, `getNumEdges/getFirstEdge/getNextEdge`; joint iteration (`getNumJoints/getFirstJoint/getNextJoint/getJoint(id)/getJointOther(id)`, const variants); contact iteration (`getNumContacts/getFirstContact/getNextContact/getContact(id)/getContactOther(id)`); rigid joints (`getFirstRigid/getNextRigid`); statics `getJoint(p0,p1,index=0)`, `getContact(p0,p1)`, `downstreamPrimitive(Joint*)`.
  - Members (private): `world, geometry, body, myOwner (IMoving*, "forward declared outside of engine"), contacts/joints EdgeLists, networkOwner, guid ("used for tree stuff"), sortSize, worldIndex, fuzzyExtents(+stateId), specificGravity, jointK(+dirty flag), friction, elasticity, flyweight PhysicalProperties, CompactEnum material(uint16), dragging/anchoredProperty/preventCollide/networkIsSleeping bools, CompactEnums networkOwnershipRule/engineType/sizeMultiplier(uint8), `CompactEnum<SurfaceType,uint8> surfaceType[6]`, `SurfaceData* surfaceData`.

## Gotchas

- `getCoordinateFrameUnsafe` requires the writer lock — using it outside the physics thread is a data race by contract.
- `SizeMultiplier` is a *spanning-tree weight hack*: torso/root/seat parts are made heavier so they become assembly roots — changing it restructures assemblies.
- `surfaceType[6]` is indexed by NormalId and only meaningful for orthogonal faces.
- The odd public constant `static const bool hasGetFirstContact = true;` exists "to simulate __if_exists(getFirstContact)" — SFINAE hook for generic code.
- `allowSleep` is a process-wide toggle.

## UNKNOWN

- Exact fuzzy-extents inflation factor (computed in .cpp).

## Cross-links

- Kernel body & PV ladder: [v8kernel/Body.md](../v8kernel/Body.md), [v8kernel/SimBody.md](../v8kernel/SimBody.md), [v8kernel/BodyPvSetter.md](../v8kernel/BodyPvSetter.md).
- Grouping: [Assembly.md](Assembly.md), [Clump.md](Clump.md), [Mechanism.md](Mechanism.md). Edges: [Edge.md](Edge.md), [Joint.md](Joint.md), [Contact.md](Contact.md). Broadphase mixin: [BasicSpatialHashPrimitive.md](BasicSpatialHashPrimitive.md). Surfaces: [SurfaceData.md](SurfaceData.md).
