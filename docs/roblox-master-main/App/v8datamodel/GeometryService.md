# GeometryService.cpp

## Purpose

Implements `GeometryService` (registered "Geometry") — a native query facade over ContactManager: extents-overlap part queries with ignore lists, and filtered ray casts returning hit point + part + surface normal/material, with water/terrain-cube options. No script surface.

## Key types and API

Descriptors: none. Constants: `sGeometryService = "Geometry"`. DescribedNonCreatable service.

Behavior:
- `getPartsTouchingExtents(extents, ignorePrimitive, maxCount, out)` / `getPartsTouchingExtentsWithIgnore(extents, Instances* ancestors, …)` — the WithIgnore variant builds an unordered_set of primitives from each ancestor ITSELF (if a part) plus ALL descendants; converts hits to PartInstance*. Member `foundPrimitives` scratch array reused (asserts caller passes empty out).
- Ray casts: `getHitLocationFilterDescendents(Instance*|Instances*, ray, &hitPrim, &normal, &material, terrainCellsAreCubes, ignoreWaterCells)` — FilterDescendents(List) so the ancestor subtree is EXCLUDED from hits; miss returns `origin+direction` sentinel point; template wrapper also fills shared_ptr<PartInstance> result (explicitly instantiated for Instance and const Instances).
- `getHitLocationFilterStairs` — same minus material/normal, requires a dummy non-NULL ignore vector ("required, fix in CM later").
- onServiceProvider caches workspace.

## Usage / reflection touchpoints

Consumed by legacy tooling (stairs placement) and physics-adjacent queries; filters from [Filters](Filters.md); world access via [Workspace](Workspace.md).

## Gotchas

- The "filter descendents" naming is inverted from intuition — these casts IGNORE the given subtree, they don't restrict to it.
- Misses return a fake point 1 stud along the ray direction — callers must check hitPrim, not distance.
- foundPrimitives reuse makes concurrent calls unsafe.
