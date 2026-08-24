# App/include/tool/LuaDragger.h

## Purpose

`LuaDragger` — a `DescribedCreatable` Instance (reflection name `sLuaDragger`) encapsulating the script-facing drag controller: takes mouse-down/move/up rays, manages temporary drag joints, and drives a RunDragger for single-part drags. Used by [LuaDragTool.md](LuaDragTool.md).

## Declared API

- `extern const char* const sLuaDragger;`
- `class LuaDragger : public DescribedCreatable<LuaDragger, Instance, sLuaDragger>`
  - Private enum `DragPhase {NO_PARTS, MOUSE_DOWN, DRAGGING, MOUSE_UP_DRAGGED, MOUSE_UP_NO_DRAG}`.
  - State: `dragPhase`; `std::vector<shared_ptr<Joint>> jointsIMade;` `weak_ptr<PartInstance> rootPart;` `std::auto_ptr<RunDragger> runDragger;` ("only if we have one part"); `float hitPointHeight;` `WeakParts dragParts` (= `vector<weak_ptr<PartInstance>>`); `weak_ptr<PartInstance> mousePart; Vector3 pointOnMousePart;`
  - Private ops: `tryStartDragging(unitMouseRay)`, `startDragging()`, `doDrag(unitMouseRay)`, `bool getSnapHitPoint(part, ray, hitPoint)`, `ContactManager& getContactManager(part)`, `const float breakFreeDistance()` → **1.5 studs** before movement registers, `addPart(shared_ptr<const Instance>)`, `askSetParent` → false override.
  - Public: `LuaDragger()`, dtor; `void mouseDownPublic(shared_ptr<Instance> mousePart, Vector3 pointOnMousePart, shared_ptr<const Instances> dragParts);` typed `mouseDown(shared_ptr<PartInstance>, const Vector3&, const vector<weak_ptr<PartInstance>>)`; `void mouseMove(RbxRay mouseRay)` ("inefficient, but easier to have just one version"); `void mouseUp();` `const WeakParts& getParts();` `void rotateOnSnapFace(Vector3::Axis, const Matrix3& rotMatrix);` `void axisRotate(Vector3::Axis);` `bool isDragging()/didDrag() const;` `void alignPartToGrid();`

## Gotchas

- `didDrag()` only true after a mouseUp that actually moved parts — phase machine matters for callers distinguishing click from drag.
- All part references are weak: the drag survives part deletion; `getParts()` returns dead entries until cleaned.
- `jointsIMade` are owned shared_ptrs — the dragger is responsible for removing its own temporary joints on finish.
- `breakFreeDistance` returns 1.5f hardcoded; no config hook.
- This is an actual creatable Instance type (shows in reflection), unlike the tool MouseCommands around it.
