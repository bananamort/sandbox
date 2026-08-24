# HandlesBase.cpp

## Purpose

Implements `HandlesBase` ("HandlesBase") — the PartAdornment base for drag handles (Handles/ArcHandles): mouse-ray handle hit-testing, face-plane projection math for relative/absolute position and angle/radius deltas, visibility gating for input processing, and 2D/3D handle rendering with hover/drag highlighting.

## Key types and API

Descriptors: none of its own. Constants: `sHandlesBase = "HandlesBase"`; state mouseOver(NORM_UNDEFINED), serverGuiObject(false).

Behavior:
- `findTargetHandle(InputObject, &hitPointWorld, &hitNormalId)` — unit mouse ray via MouseCommand, `HandleHitTest::hitTestHandleLocal` over adornee's local extents + location, honoring getHandlesNormalIdMask().
- `getDistanceFromHandle` — projects mouse ray against the handle's world-normal axis ray; distance = axis·(closest−origin).
- `getFacePosFromHandle` — intersects mouse ray with the face plane (comment: subtle intersection change 2/15/10), converts to face UV space; returns delta and absolute UV.
- `getAngleRadiusFromHandle` — derives polar deltas from face positions (angle=abs−orig atan2).
- `canProcessMeAndDescendants()` — adornee set AND mask ≠ NORM_NONE_MASK AND visible.
- Rendering: render2d → DrawAdorn::handles2d; render3dAdorn → handles3d with highlightedNormalId = mouseOver or captured drag normal; rotate type gets special flag.
- Server-GUI detection: onAncestorChanged flips serverGuiObject when a server is present (drives ArcHandles listener-mode plumbing); setServerGuiObject virtual.

## Usage / reflection touchpoints

Base of [Handles](Handles.md)/[ArcHandles](ArcHandles.md); rays from [MouseCommand](MouseCommand.md) helpers; adornment base [Adornment](Adornment.md).

## Gotchas

- All math silently no-ops (return false) without an adornee or workspace — callers must treat false as "no data".
- getFacePosFromHandle can produce non-finite intersections when the ray is near-parallel to the face plane; guarded here but downstream consumers see stale values.
