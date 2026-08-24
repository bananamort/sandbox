# App/include/v8datamodel/GeometryService.h

## Purpose

`GeometryService` (non-creatable service) — raycasting and spatial queries against the world: filtered hit locations (stairs filter, descendants filter, part-result variant), plus extents-touching part queries.

## Declared API

`class GeometryService : public DescribedNonCreatable<GeometryService, Instance, sGeometryService>, public Service`

- `Vector3 getHitLocationFilterStairs(Instance* ancestor, RbxRay ray, Primitive** hitPrim);`
- `Vector3 getHitLocationFilterDescendents(Instance* ancestor, RbxRay ray, Primitive** hitPrim, Vector3& surfaceNormal, PartMaterial& surfaceMaterial, bool terrainCellsAreCubes, bool ignoreWaterCells);`
- Overload taking `const Instances* ancestors`.
- Template: `template<class IgnoreType> Vector3 getHitLocationPartFilterDescendents(IgnoreType* ancestor, RbxRay ray, shared_ptr<PartInstance>& result, Vector3&, PartMaterial&, bool terrainCellsAreCubes, bool ignoreWaterCells)` — comment: templated "to avoid heavy code duplication: IgnoreType is currently either Instance or Instances".
- `void getPartsTouchingExtents(const Extents& extents, const Primitive* ignore, int maxCount, G3D::Array<PartInstance*>& found);`
- `void getPartsTouchingExtentsWithIgnore(const Extents&, const Instances* ancestors, int maxCount, found)`.
- Protected override: `onServiceProvider(old,new)`; private members `Workspace* workspace; G3D::Array<Primitive*> foundPrimitives;`

## Gotchas

- `foundPrimitives` is member scratch state — implies the service assumes single-threaded query use.
- Terrain handling toggled by two booleans (cells-as-cubes vs smooth; water ignored optionally).

## UNKNOWN

- Stairs-filter semantics (what counts as a step-up) (.cpp — see [GeometryService.md](../../v8datamodel/GeometryService.md)).

## Cross-links

- Implementation: [App/v8datamodel/GeometryService.md](../../v8datamodel/GeometryService.md).
- Consumers: [PathfindingService.md](PathfindingService.md) (P–Z half), [Workspace.md](Workspace.md).
