# App/include/v8datamodel/ArcHandles.h

## Purpose

`ArcHandles` Instance ("ArcHandles") — Studio-style rotation handles (axis arcs) adorning a part, scriptable through per-axis mouse events. Extends [HandlesBase](HandlesBase.md) with an `Axes` filter deciding which axes show.

## Declared API

`class ArcHandles : public DescribedCreatable<ArcHandles, HandlesBase, sArcHandles>`

- `ArcHandles();`
- Axes: `void setAxes(Axes value); Axes getAxes() const;` (member `Axes axes;`)
- Remote signals (replicated): `mouseEnterSignal<void(Vector3::Axis)>`, `mouseLeaveSignal<void(Axis)>`, `mouseDragSignal<void(Axis, float, float)>`, `mouseButton1DownSignal<void(Axis)>`, `mouseButton1UpSignal<void(Axis)>`.
- Script-facing event replicators via macros: `DECLARE_EVENT_REPLICATOR_SIG(ArcHandles, MouseEnter|MouseLeave|MouseDrag|MouseButton1Down|MouseButton1Up, ...)`.
- Overrides: Instance `onPropertyChanged(const Reflection::PropertyDescriptor&)`; GuiBase `GuiResponse process(const shared_ptr<InputObject>& event)`; HandlesBase `RBX::HandleType getHandleType() const`, protected `int getHandlesNormalIdMask() const`, `void setServerGuiObject()`.

## Gotchas

- Event delivery goes through the EventReplicator machinery — the raw signals are the wire form and the DECLARE_ macros expose the Lua names.
- Axis filtering is by `Vector3::Axis`; which normals render comes from `getHandlesNormalIdMask()` (.cpp).
- Drag payload carries two floats (likely delta angles) — units defined in .cpp only.

## UNKNOWN

- Exact drag-float semantics and normal-mask composition (see [ArcHandles.md](../../v8datamodel/ArcHandles.md)).

## Cross-links

- Implementation: [App/v8datamodel/ArcHandles.md](../../v8datamodel/ArcHandles.md).
- Base: [HandlesBase.md](HandlesBase.md); linear sibling [Handles.md](Handles.md); events plumbing [EventReplicator.md](EventReplicator.md).
