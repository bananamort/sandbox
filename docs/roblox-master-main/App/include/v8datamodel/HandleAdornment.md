# App/include/v8datamodel/HandleAdornment.h

## Purpose

Plugin/Studio handle adornment family (2015): abstract `HandleAdornment` (a PVAdornment with CFrame/offset/z-index/always-on-top state, hover/click remote events, and pure-virtual render + hit-test), plus creatable shapes `BoxHandleAdornment`, `ConeHandleAdornment`, `CylinderHandleAdornment`, `SphereHandleAdornment`, `LineHandleAdornment`, `ImageHandleAdornment`.

## Declared API

`class HandleAdornment : public DescribedNonCreatable<HandleAdornment, PVAdornment, sHandleAdornment>`

- Props: `prop_sizeRelativeOffset` (Vector3), `prop_adornCFrame` (CoordinateFrame), `prop_adornZIndex` (int), `prop_alwaysOnTop` (bool) — inline guarded setters for offset/CFrame/alwaysOnTop; setZIndex non-inline.
- Contract: `virtual void render3dAdorn(Adorn*) = 0; virtual bool isCollidingWithHandle(const shared_ptr<InputObject>&) = 0;` `virtual GuiResponse process(const shared_ptr<InputObject>&); virtual CoordinateFrame getWorldCoordinateFrame() const;`
- Remote signals: mouseEnterSignal/mouseLeaveSignal/mouseButton1DownSignal/mouseButton1UpSignal — all `void()`.
- Protected state: sizeRelativeOffset, coordinateFrame, zIndex, alwaysOnTop, `bool mouseOver;`

Creatables:
- `BoxHandleAdornment` (sBoxHandleAdornment): getSize/setSize(Vector3 boxSize).
- `ConeHandleAdornment`: radius + height get/set, overrides getWorldCoordinateFrame (non-const), render, hit-test.
- `CylinderHandleAdornment`: radius + height, same overrides.
- `SphereHandleAdornment`: radius only.
- `LineHandleAdornment`: length + thickness.
- `ImageHandleAdornment`: Vector2 size + TextureId image.

## Gotchas

- Shape sizes are plain public setters without property descriptors or change-raising — no invalidation signals.
- Hit-testing is per-shape via isCollidingWithHandle against the input ray.
- Base is non-creatable; scripts see the six shape classes.

## UNKNOWN

- Default colors/transparency of each adornment (.cpp — see [HandleAdornment.md](../../v8datamodel/HandleAdornment.md)).

## Cross-links

- Implementation: [App/v8datamodel/HandleAdornment.md](../../v8datamodel/HandleAdornment.md).
- Bases: [Adornment.md](Adornment.md) (PVAdornment), kin handles [Handles.md](Handles.md)/[ArcHandles.md](ArcHandles.md).
