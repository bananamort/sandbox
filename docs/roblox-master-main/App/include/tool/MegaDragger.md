# App/include/tool/MegaDragger.h

## Purpose

The heavyweight multi-part drag engine used by group/axis tools: owns the drag part set, performs join/unjoin per [DragTypes.md](DragTypes.md) `JoinType`, and provides collision-aware "safe" movement/rotation primitives (Y-drop, along-line, rotate-with-respect-for-collisions). Consumed by [MegaDragger](../tool/MegaDragger.md)-holding tools [GroupDragTool.md](GroupDragTool.md), [PartDragTool.md](PartDragTool.md), [AxisMoveTool.md](AxisMoveTool.md).

## Declared API

- `class MegaDragger` (plain class, not an Instance)
  - Ctors: `(PartInstance* mousePartPtr, const std::vector<PVInstance*>& pvInstances, RootInstance* rootInstance, DRAG::JoinType joinType = DRAG::UNJOIN_JOIN)` and same taking `const PartArray&`; dtor.
  - State: `weak_ptr<PartInstance> mousePart; PartArray dragParts; bool joined; DRAG::JoinType joinType; RootInstance* rootInstance; ContactManager& contactManager;` + private `bool moveSafePlaceAlongLine(const Vector3& tryDrag);`
  - Selection: `void setToSelection(const Workspace* workspace);`
  - Drag cycle: `startDragging()`, `continueDragging()` ("every drag step/move/idle"), `finishDragging()`.
  - Inquiry: `bool mousePartAlive(); bool anyDragPartAlive(); weak_ptr<PartInstance> getMousePart()` (asserts non-expired).
  - Group-dragger ops: `alignAndCleanParts()`, `cleanParts()`, `Vector3 hitObjectOrPlane(inputObject)` ("ignore the drag parts — find a hit point with the world"), `Vector3 safeMoveYDrop(tryDrag)` ("1. Go directly to new location, 2. Moves down until collision — if necessary, moves up").
  - Axis-tool ops: `safeMoveAlongLine(tryDrag, snapToWorld=true)`, `safeRotateAlongLine(tryDrag)`, `safeMoveAlongLine2(tryDrag, bool& out_isCollided)`, `safeRotateAlongLine2(tryDrag, const float& angle)`, `safeMoveToMinimumHeight(float yValue)`, `bool moveAlongLine(tryDrag)`.
  - Rotation: documented-in-header `Matrix3 rotateDragParts(const Matrix3& rotMatrix, bool respectCollisions)` — "if true then check for collision will be done in case of collisions no rotation will be performed".
  - General placement: `Vector3 safeMoveNoDrop(tryDrag)` ("On initial collision — moves up"), `bool safeRotate(rotMatrix)`, `void removeParts();` private `getPartsForDrag(G3D::Array<Primitive*>&)`.

## Gotchas

- `contactManager` is a **reference member** — MegaDragger is non-assignable and lifetime-bound to its ContactManager.
- Default `joinType = UNJOIN_JOIN`: drags unjoin from neighbors then re-join on finish unless caller passes otherwise ([DragTypes.md](DragTypes.md)).
- The `...2` suffixed variants return collision info via out-param instead of silently resolving — prefer them for new callers needing feedback.
- `getMousePart()` asserts; call `mousePartAlive()` first.
