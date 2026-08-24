# ViewportBillboarder.cpp

Source: `roblox-sandbox/Rendering/GfxBase/ViewportBillboarder.cpp` (152 lines)

## Purpose

Implements `RBX::ViewportBillboarder`: per-frame placement of a screen-aligned billboard rectangle relative to a part (extents-relative + studs offset, UDim2 sizing), plus mouse hit-testing against the placed rectangle with world-occlusion checks.

## API

### Constructors
- Default: `guiScreenSize=NULL`, `alwaysOnTop=false`, zero screenOffset2D.
- Parameterized (all five tunables; see header doc).

### Methods
- `Vector2 getScreenOffset(parentviewport, camera, desiredModelView)` — projects the desired model-view translation through the camera and rounds to integer pixels.
- `void update(const Rect2D& parentviewport, const Camera& camera, Vector3 partSize, CoordinateFrame partCFrame)`:
  1. Expands extents over all 8 box corners of the part in CAMERA space (bit-permutation loop).
  2. Maps `partExtentRelativeOffset` from [0,1]³ into those extents (`(off+1)*0.5*size + min`), adds `partStudsOffset`.
  3. Projects center to proj space; **visible only while `0 < z < 1000`**, else `visibleAndValid=false` + early-out.
  4. `pixelsPerStud = projected z`; computes stud-space size from UDim2, undoes perspective via inverse.
  5. viewport = full guiScreenSize rect if pointer set, else pixel-sized rect.
  6. Builds `desiredModelView`: translation = center − half size (note y uses `-0.5f`), diagonal scale matrix from UI→camera scaler.
  7. If `alwaysOnTop`, caches `screenOffset2D`; always composes final `cframe = camera.coordinateFrame() * desiredModelView`.
- `bool hitTest(const Vector2int16& mousePosition, const Vector2int16& windowSize, RBX::Workspace* workspace, Vector2& billboardMousePosition)`:
  - alwaysOnTop → use cached screen offsets; else project both corners of stored cframe to screen.
  - Inside rect → maps mouse into billboard UV space, then (non-alwaysOnTop) casts a 2048-unit ray via `ContactManager::getHit` with `FilterInvisibleNonColliding`; if nothing hit OR the part-hit is BEHIND the billboard plane (`partHitPointScreen.z < hitPointScreen.z`) returns true.

## Usage

Includes V8DataModel Filters/Camera and V8World World/ContactManager — this GfxBase TU reaches deep into data-model/world layers. Typical flow: construct once per billboard GUI, call `update(...)` each frame, then `hitTest(...)` on mouse move.

## Gotchas
- The 1000-stud far cutoff for visibility is hardcoded.
- `hitTest` ignores its `windowSize` parameter entirely.
- Occlusion compare is z-only against ONE contact hit; semi-transparent blockers still occlude.
- When not alwaysOnTop, `update()` does NOT refresh `screenOffset2D` (stale value persists).
