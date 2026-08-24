# App/include/v8world/Buoyancy.h

## Purpose

Water interaction as a standard `Contact` type managed by ContactManager. Base `BuoyancyContact` plus per-shape subclasses (Ball, Box, Cylinder, Wedge, CornerWedge). Box-family contacts subdivide the part into 8 voxels, each contributing one connector carrying buoyancy + water-viscosity force; forces land in the kernel via [v8kernel/BuoyancyConnector.md](../v8kernel/BuoyancyConnector.md).

## Declared API

- Header comment documents the design: "Buoyancy contact is implemented as a standard contact type managed by ContactManager … Box Buoyancy is divided into 8 voxels."
- `class BuoyancyContact : public Contact`
  - Constants/statics: `static const int MAX_CONNECTORS = 8;` `static float waterViscosity;` (**mutable global**), `static const float waterDensity;`
  - `typedef RBX::FixedArray<BuoyancyConnector*, MAX_CONNECTORS> ConnectorArray; ConnectorArray connectors;`
  - Statics: `static Geometry::GeometryType determineGeometricType(Primitive*);` `static BuoyancyContact* create(Primitive* p0, Primitive* p1);` — factory picking the subclass by shape.
  - `virtual Geometry::GeometryType getType() = 0;` `getContactType() → Contact_Buoyancy` (inline override).
  - Water queries: `worldPosUnderWater(const Vector3&)`, `isTouchingWater(Primitive*)`, `getWaterCell(Vector3int16)`, `cellHasWater(Vector3int16)`, `hasDistanceSubmergedUnderWater(pos, float& waterLevel, const Vector3& searchEnd)`, `worldPosAboveWater(worldpos, int minY, float& waterLevel)`, `Vector3 cellVelocity(const Vector3& worldpos)`.
  - Kernel plumbing: `removeAllConnectorsFromKernel()/putAllConnectorsInKernel()`, `computeExtentsWaterBand(const Extents&, float& floatDistance, float& sinkDistance)`, `updateConnectors()`, `updateBuoyancyFloatingForce()`.
  - Contact overrides: `deleteAllConnectors`, inline `numConnectors()/getConnector(i)`, `stepContact`, `computeIsColliding`, and **`computeIsCollidingUi` overridden to always return false** — "so can build underwater; shouldn't affect HumanoidState code".
  - Shape hooks (pure unless noted): `createConnectors() = 0`, `updateWaterBand() = 0`, `getSurfaceAreaInDirection(vel, float& crossArea, float& tangentArea) = 0`, `initializeCrossSections() = 0`, `getCrossSections(int i, const Vector3& velocity) = 0`; virtuals with defaults: `getWaterVelocity(int)`, `updateSubmergeRatio()`.
  - Members: `Primitive* floaterPrim; Voxel::Grid* voxelGrid; Voxel2::Grid* smoothGrid; float radius; float fullSurfaceArea; Vector3 fullBuoyancy;`
- Subclasses:
  - `BuoyancyBallContact` — `getType() → GEOMETRY_BALL`; scalar `crossSectionArea`; overrides colliding/connector/water-band set.
  - `BuoyancyBoxContact` — `getType() → GEOMETRY_BLOCK`; per-axis `Vector3 crossSectionSurfaceAreas, tangentSurfaceAreas`.
  - `BuoyancyCylinderContact : BuoyancyBoxContact` — `GEOMETRY_CYLINDER`; overrides `updateSubmergeRatio`, `initializeCrossSections`.
  - `BuoyancyWedgeContact : BuoyancyBoxContact` — `GEOMETRY_WEDGE`; same two overrides.
  - `BuoyancyCornerWedgeContact : BuoyancyBoxContact` — `GEOMETRY_CORNERWEDGE`; same two overrides.

## Gotchas

- Cylinder/Wedge/CornerWedge reuse the **box** cross-section machinery with tweaks — their buoyancy fidelity is box-approximated.
- `waterViscosity` is a non-const static float — any code can retune global water behavior at runtime.
- `computeIsCollidingUi ≡ false` is deliberate product behavior (building underwater), not a stub.

## Cross-links

- Kernel force application: [v8kernel/BuoyancyConnector.md](../v8kernel/BuoyancyConnector.md).
- Water grids: [../voxel/INDEX.md](../voxel/INDEX.md), [../voxel2/INDEX.md](../voxel2/INDEX.md). Contact base: [Contact.md](Contact.md).
