# App/include/tool/AdvLuaDragger.h

## Purpose

`AdvLuaDragger` — advanced-arrow flavor of [LuaDragger.md](LuaDragger.md): same drag phase machine and API surface, but driven by an `AdvRunDragger`, tracking `hitPointOffset` (background-hit → mouse-part-hit vector captured at drag start) plus original CoordinateFrames of all dragged parts, with toggles for rotate mode and joint-create mode.

## Declared API

- `extern const char* const sAdvLuaDragger;`
- `class AdvLuaDragger : public DescribedCreatable<AdvLuaDragger, Instance, sAdvLuaDragger>`
  - Same private `DragPhase` enum as LuaDragger: `{NO_PARTS, MOUSE_DOWN, DRAGGING, MOUSE_UP_DRAGGED, MOUSE_UP_NO_DRAG}`.
  - State: `jointsIMade` (shared_ptr Joints), `weak_ptr<PartInstance> rootPart; std::auto_ptr<AdvRunDragger> advRunDragger; float hitPointHeight; WeakParts dragParts; weak_ptr<PartInstance> mousePart; Vector3 pointOnMousePart; Vector3 hitPointOffset;` ("at the start of the drag process this [is] the vector from the hitPoint on the background to hit point on the mouse part") + `std::vector<CoordinateFrame> m_originalPositions;`
  - Private ops mirror LuaDragger (`tryStartDragging/startDragging/doDrag/getSnapHitPoint/getContactManager/breakFreeDistance()` — note non-inline here), `addPart`, `askSetParent` → false.
  - Public: `mouseDownPublic(shared_ptr<Instance>, Vector3, shared_ptr<const Instances>)`; typed `mouseDown`; `mouseMove(RbxRay)`; `mouseUp()`; `getParts()`; `rotateOnSnapFace(Vector3::Axis, const Matrix3&)`; `axisRotate(Vector3::Axis)`; `isDragging()/didDrag()`; **adv-only**: `void toggleRunDraggerRotateMode(void); void toggleRunDraggerJointCreateMode(void);` and `alignPartToGrid(void)`.

## Gotchas

- Duplicates ~90% of LuaDragger by subclass-free copy-paste — fixes in one dragger do not propagate to the other.
- Unlike LuaDragger's inline `breakFreeDistance() {return 1.5f;}`, this one declares it without a body — value set in .cpp and may differ.
- `m_originalPositions` backs undo/restore semantics for multi-part adv drags.
