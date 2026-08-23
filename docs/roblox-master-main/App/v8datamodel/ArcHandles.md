# App/v8datamodel/ArcHandles.cpp

## Purpose

Implements `ArcHandles` ("ArcHandles") — the studio-style rotation handles adornment (subclass of HandlesBase). Renders arc handles on the Adornee for each enabled Axis and converts raw mouse input into per-axis MouseEnter/Leave/Drag/Button events, replicable to server listeners via event replicators.

## API

Reflection:
- `prop_Axes` — `"Axes"` (category_Data), type Axes (default 0x7 = all three axes), `getAxes`/`setAxes` with raisePropertyChanged.
- RemoteEvents (Security::None, SCRIPTING, CLIENT_SERVER) + IMPLEMENT/CONSTRUCT/CONNECT_EVENT_REPLICATOR wiring:
  - `"MouseEnter"(axis)` / `"MouseLeave"(axis)`
  - `"MouseDrag"(axis, relativeAngle:float, deltaRadius:float)`
  - `"MouseButton1Down"(axis)` / `"MouseButton1Up"(axis)`.

Methods: `int getHandlesNormalIdMask()` — maps each axis to both its positive and negative NormalIds in a Faces mask (used by hit-testing/rendering); `void setServerGuiObject()` — switches each replicator into listener mode based on whether local Lua listeners exist ("watching for local listeners" on the server); `onPropertyChanged` forwards to all five replicators; `GuiResponse process(const shared_ptr<InputObject>&)` — mouse-move updates hover (MouseEnter/Leave with NORM_UNDEFINED tracking) and while captured emits MouseDrag with sign flipped for negative faces (`reverse ? -relangle : relangle`); left-down captures `MouseDownCaptureInfo(adornee location, hitPointWorld, hitNormalId)` and sinks input; left-up clears capture and fires MouseButton1Up; invisible handles (`getVisible()==false`) never sink. `HandleType getHandleType()` → HANDLE_ROTATE.

## Usage

Part of the drag/handles framework (HandlesBase → ArcHandles); used by studio-class tools and any script that parents ArcHandles to a part to implement custom rotate UX; events replicate client→server so server scripts can react.

## Gotchas

- MouseLeave uses `Axes::normalIdToAxis(hitNormalId)` even in the branch where no handle was found (hitNormalId is then uninitialized output of findTargetHandle) — latent quirk.
- Drag deltas only exist between down and up (mouseDownCaptureInfo gate); angles are relative to the captured frame.
- UNKNOWN: `getAngleRadiusFromHandle`/`findTargetHandle` geometry helpers live in HandlesBase/header, not this TU.
