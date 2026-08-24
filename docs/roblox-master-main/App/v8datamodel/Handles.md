# Handles.cpp

## Purpose

Implements `Handles` ("Handles") — the DescribedCreatable HandlesBase subclass providing classic face-based drag handles on a Part: Faces mask, four VisualStyle variants (resize/movement/arc/velocity), mouse hover/down/drag event replication with per-face NormalId payloads, and input processing that captures MouseDown geometry for drag-distance reporting.

## Key types and API

Descriptors:
- Props: Style (EnumPropDescriptor VisualStyle → HANDLE_RESIZE/MOVE/ROTATE/VELOCITY mapping via getHandleType; default RESIZE_HANDLES), Faces (`Faces` mask, default NORM_ALL_MASK) — both category Appearance/Data respectively, no Security arg.
- RemoteEvents (Security::None, SCRIPTING|CLIENT_SERVER): MouseEnter(face NormalId), MouseLeave(face), MouseDrag(face,distance float), MouseButton1Down(face), MouseButton1Up(face). All wired through IMPLEMENT/CONSTRUCT/CONNECT_EVENT_REPLICATOR like [GuiObject](GuiObject.md).

Behavior:
- process(event): mouse-only; invisible → notSunk. MOUSEMOVEMENT — while captured (mouseDownCaptureInfo), getDistanceFromHandle(event, captured normal, captured point) emits MouseDrag(normalId, distance); then re-hit-tests via findTargetHandle to fire enter/leave transitions (mouseOver tracking; note leave fires with the NEW hitNormalId argument when leaving to nothing — see gotchas). BUTTON1 — down-over: capture `new MouseDownCaptureInfo(adornee location, hitPointWorld, hitNormalId)`, emit Down, SINK; up: clear capture, emit Up only if still over a handle.
- setServerGuiObject/onPropertyChanged mirror the replicator listener-mode pattern for all five events.

## Usage / reflection touchpoints

Base [HandlesBase](HandlesBase.md) supplies findTargetHandle/getDistanceFromHandle math; rendering via DrawAdorn::handles3d with getHandleType() selecting handle art; adornee PartInstance ([PartInstance](PartInstance.md)); rays from MouseCommand/HitTest utils; sibling modern system [HandleAdornment](HandleAdornment.md); ArcHandles is the separate rotate-focused class ([ArcHandles](ArcHandles.md)).

## Gotchas

- MouseLeave bug on exit: when the cursor leaves ALL handles, `mouseLeaveSignal(hitNormalId)` passes the CURRENT (invalid/unset) hitNormalId from the failed findTargetHandle rather than the previous mouseOver face — listeners receive garbage NormalId on leave-to-nothing.
- Drag distances after MouseDown are computed against the CAPTURED face/point even if the part or camera moves — stale-geometry drift by design.
- mouseDownCaptureInfo holds adornee location at down time (adornee.lock()->getLocation()) — no null check beyond HandlesBase guarantees; unparenting mid-drag relies on weak adornee semantics upstream.
- Up events don't sink and don't require a prior Down on this instance (stateless up).
- Style enum values ARC_HANDLES exist here but real arc handles are the separate ArcHandles class — Style=ArcHandles renders rotate-type handles through Handles' own pipeline.
