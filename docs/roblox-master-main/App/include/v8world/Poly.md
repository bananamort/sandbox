# App/include/v8world/Poly.h

## Purpose

Mesh-backed geometry base: every analytic shape that collides through its `POLY::Mesh` (blocks, wedges, ramps, prisms, pyramids, clusters) derives from `Poly`. Provides face-indexed dragger surfaces, mesh-derived radius/moment/CoFm, and the pure `buildMesh()` hook.

## Declared API

- `class Poly : public Geometry`
  - Members: private `float centerToCornerDistance;` protected `const POLY::Mesh* mesh;` (NULL until built).
  - Pure virtual: `/*implement*/ void buildMesh() = 0;` — subclasses assign the pooled mesh.
  - `void setSize(const Vector3&)` override (recomputes derived values); protected helpers `getCenterToCornerDistance()`, `getCenterToCornerWorst()` (= distance in all 3 axes).
  - Overrides: `getCollideType() → COLLIDE_POLY`; `hitTest(ray, hitPoint, normal)`; `float getRadius()` = centerToCornerDistance; `getCenterToCorner(Matrix3)` = worst-case vector; `getCofmOffset()`; `Matrix3 getMoment(float)`; `collidesWithGroundPlane(cf, yHeight)`.
  - `const POLY::Mesh* getMesh() const;`
  - Dragger/joiner surface API (surfaceId = **face index**): `closestSurfaceToPoint`, `getPlaneFromSurface`, virtual `getSurfaceCoordInBody`, `getSurfaceNormalInBody`, `getMostAlignedSurface`, `int getNumSurfaces()` = `mesh->numFaces()`, `getSurfaceVertInBody`, `getNumVertsInSurface`, `vertOverlapsFace`.
  - Cluster/proximity: `findTouchingSurfacesConvex`, `FacesOverlapped`, `FaceVerticesOverlapped`, `FaceEdgesOverlapped`; `polygonIntersectionWithFace(polygonInBody, surfaceId)`.

## Gotchas

- Surface ids here are mesh *face indices*, not the legacy 6-face NormalIds — mapping happens via `getFaceFromLegacyNormalId` overrides in subclasses.
- `getRadius()` is a sphere bound to the worst corner — conservative for elongated parts.
- `mesh` is a borrowed pointer into pooled payload ([GeometryPool.md](GeometryPool.md)) — valid only while the pool token lives (member of the subclass).

## Cross-links

- Mesh: [Mesh.md](Mesh.md); subclasses: [Block.md](Block.md), [WedgePoly.md](WedgePoly.md), [CornerWedgePoly.md](CornerWedgePoly.md), [PrismPoly.md](PrismPoly.md), [PyramidPoly.md](PyramidPoly.md), [ParallelRampPoly.md](ParallelRampPoly.md), [RightAngleRampPoly.md](RightAngleRampPoly.md), [MegaClusterPoly.md](MegaClusterPoly.md).
- Contact generation over polys: [PolyContact.md](PolyContact.md), [v8kernel/PolyConnectors.md](../v8kernel/PolyConnectors.md).
