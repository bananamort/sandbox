# App/include/v8datamodel/Handles.h

## Purpose

`Handles` Instance — the classic linear resize/move handles adorning a part: per-face mouse events replicated only on demand (EventReplicator pattern), a `VisualStyle` selector, and a `Faces` filter deciding which faces show handles.

## Declared API

`class Handles : public DescribedCreatable<Handles, HandlesBase, sHandles>`

- Remote signals: `mouseEnterSignal<void(NormalId)>`, `mouseLeaveSignal`, `mouseDragSignal<void(NormalId, float)>`, `mouseButton1DownSignal`, `mouseButton1UpSignal` — each paired with `DECLARE_EVENT_REPLICATOR_SIG(Handles, ...)`.
- `enum VisualStyle { RESIZE_HANDLES=0, MOVEMENT_HANDLES=1, ARC_HANDLES=2, VELOCITY_HANDLES=3 };` get/setVisualStyle.
- Faces: `void setFaces(Faces value); Faces getFaces() const;`
- Overrides: HandlesBase `getHandleType() const`; Instance `onPropertyChanged(...)` ("must implement in derived" per base comment); GuiBase `GuiResponse process(const shared_ptr<InputObject>&)`; protected `getHandlesNormalIdMask() { return faces.normalIdMask; }`, `setServerGuiObject()`.

## Gotchas

- Drag payload is a single float (delta distance along the face normal presumably) — units in .cpp.
- VisualStyle includes ARC_HANDLES even though ArcHandles is a separate class — legacy styling path.
- Event replication is listener-count gated; no listeners = no network traffic.

## UNKNOWN

- HandleType mapping per VisualStyle (.cpp — see [Handles.md](../../v8datamodel/Handles.md)).

## Cross-links

- Implementation: [App/v8datamodel/Handles.md](../../v8datamodel/Handles.md).
- Base: [HandlesBase.md](HandlesBase.md); sibling [ArcHandles.md](ArcHandles.md).
