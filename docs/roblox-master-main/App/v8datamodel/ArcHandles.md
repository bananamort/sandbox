# ArcHandles.cpp

## Purpose

Implements `ArcHandles` ("ArcHandles"), the rotate-gizmo HandlesBase subclass: per-axis arc handles around an adornee, hit-tested from mouse input, raising axis-parameterized mouse events that replicate to listeners.

## Key types and API

Descriptors:
- `prop_Axes("Axes", category_Data)` — Axes mask (ctor default `0x7`, all three axes), get/set change-tracked. No Security:: arguments.

Remote events (all **Security::None**, SCRIPTING, CLIENT_SERVER, each with IMPLEMENT/CONSTRUCT/CONNECT_EVENT_REPLICATOR plumbing):
- `"MouseEnter"` ("axis") / `"MouseLeave"` ("axis")
- `"MouseDrag"` ("axis","relativeAngle","deltaRadius")
- `"MouseButton1Down"` ("axis") / `"MouseButton1Up"` ("axis")

Constant: `sArcHandles = "ArcHandles"`; base `DescribedCreatable<ArcHandles, HandlesBase, sArcHandles>`.

Behavior:
- `getHandlesNormalIdMask()` — maps Axes to a Faces mask; NEG faces mirror their positive axis.
- `process(InputObject&)` — invisible → notSunk. MouseMovement: while dragging recomputes relative angle/radius via `getAngleRadiusFromHandle` and fires MouseDrag (NEG normalIds invert angle sign); hover transitions fire MouseEnter/MouseLeave with `mouseOver` NormalId tracking. MouseButton1 down: hit-test `findTargetHandle`, capture adornee location + hit point + normal into `MouseDownCaptureInfo`, sink input, fire MouseButton1Down; up clears capture and fires MouseButton1Up.
- `setServerGuiObject()` — server watches local listener presence: each replicator's `setListenerMode(!signal.empty())`.
- `getHandleType()` — HANDLE_ROTATE.

## Usage / reflection touchpoints

Studio/script rotate affordance alongside [Handles](Handles.md) (HANDLE_TRANSLATE family) under [HandlesBase](HandlesBase.md)/[Adornment](Adornment.md); input arrives via [MouseCommand](MouseCommand.md)-style processing.

## Gotchas

- MouseLeave on hover-loss fires with the NEW hitNormalId variable rather than mouseOver — after a failed findTargetHandle that variable was NEVER WRITTEN (HandlesBase::findTargetHandle returns false without touching it, and HandleHitTest::hitTestHandleLocal assigns it only on success), so scripts can receive an INDETERMINATE axis value.
- Drag events only flow while mouseDownCaptureInfo exists; there is no up-outside-cleanup beyond button-up path.
- Listener mode is evaluated ONLY in setServerGuiObject — connecting a script after that moment may not flip replication until something refreshes it.
