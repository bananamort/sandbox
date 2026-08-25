# App/include/tool/DragUtilities.h

## Purpose

Static utility bag for the whole drag family: ray casting against world/planes with grid snapping, join/unjoin of part sets, dragging flags, movement helpers (safe moves, Y-drop, grid quantization), and conversions between Instances/PVInstances/parts/primitives. Defines `PartArray` = `std::vector<weak_ptr<PartInstance>>`, used by every tool header.

## Declared API

- `typedef std::vector<weak_ptr<PartInstance> > PartArray;`
- `class DragUtilities` — all static.
  - Private: `hitObjectOrPlane(contactManager, unitSearchRay, ignorePrims, hit&, snapToGrid=true)`, `hitObject(...)` (ray-level primitives).
  - Joining: `notJoined(parts)`, `notJoinedToOutsiders(parts)`, `unJoinFromOutsiders(parts)`, `joinToOutsiders(parts)`, `unJoin(parts)`, `join(parts)`, `joinWithInPartsOnly(parts)` — "WithIn" sic.
  - Drag lifecycle: `setDragging(parts)`, `stopDragging(parts)`, `clean(parts)`.
  - Movement: `move(parts, CoordinateFrame from, to)`, `move2(...)`, `alignToGrid(PartInstance*)` ("force alignment to grid"), `clean(PartInstance*)` ("clean up alignment if already aligned"), `moveByDelta(part, delta, snapToWorld)`.
  - Conversions: `pvsToParts(pvInstances, parts&)`, `instancesToParts(vector<Instance*>, PartArray&)`, `instancesToParts(const Instances&, PartArray&)`, `removeDuplicateParts(PartArray&)`, three `partsToPrimitives` overloads (one returns `World*`, fills G3D::Array or std::vector const/non-const), `computeExtents(parts)` → Extents.
  - Ray queries: `Vector3 hitObjectOrPlane(parts, unitMouseRay, contactManager, snapToGrid=true)`, `bool hitObject(parts, ray, contactManager, Vector3& hit, snapToGrid=true)`, `anyPartAlive(parts)`.
  - Primitive extraction: inline `getPrimitives2(shared_ptr<Instance>, vector<Primitive*>&)` → forwards to `getPrimitives(const Instance*, ...)`; also `getPrimitivesConst`; comment: "replacement for PVInstance::getPrimitives()".
  - Placement math: `safeMoveYDrop(parts, tryDrag, contactManager, customPlaneHeight = Dragger::groundPlaneDepth())`, `toGrid(point, grid = Vector3::zero())`, `toLocalGrid(deltaIn)`, `getGrid()`.

## Gotchas

- Two overloads named `hitObjectOrPlane` / three `partsToPrimitives` overloads with different contracts — easy to call the wrong one; only the G3D::Array variant returns a `World*`.
- Weak-pointer arrays everywhere: `anyPartAlive` exists precisely because entries die mid-drag.
- `toGrid` default arg `Vector3::zero()` means "use the global grid" by convention — zero is a sentinel, not a literal cell size.
