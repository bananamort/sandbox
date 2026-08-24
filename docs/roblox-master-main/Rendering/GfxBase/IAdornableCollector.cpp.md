# IAdornableCollector.cpp

Source: `roblox-sandbox/Rendering/GfxBase/IAdornableCollector.cpp` (169 lines)

## Purpose

Implements the IAdornable↔IAdornableCollector lifecycle: bucket registration, three-bucket membership maintenance driven by each item's `shouldRender*` overrides, and the actual per-pass render iteration. Also defines `IAdornable`'s out-of-line dtor/depth functions (declared in IAdornable.h).

## API

### File scope
- `LOGGROUP(AdornableLifetime);` — FastLog group.
- `DYNAMIC_FASTFLAGVARIABLE(DontReorderScreenGuisWhenDescendantRemoving, false)` — DFFlag controlling removal strategy.

### IAdornable (out-of-line)
- `IAdornable::~IAdornable()` — FASTLOGs, then if `bucket`, self-removes via `bucket->onRenderableDescendantRemoving(this)`.
- `void shouldRenderSetDirty()` — delegates to `bucket->recomputeShouldRender(this)` if bucketed.
- `float calculateDepth(const Camera*) const` — `camera->dot(render3dSortedPosition())`.

### IAdornableCollector
- `~IAdornableCollector()` — logs remaining counts; RBXASSERTs all three buckets are empty (release: silently leaks/dangles if not).
- `void recomputeShouldRender(IAdornable*)` — for each of 2D/3D/3DSorted: add via `fastAppend` if should-render and absent; remove via `fastRemove` if present but shouldn't.
- `void onRenderableDescendantAdded(IAdornable*)` — asserts virgin state (indices −1, bucket NULL), sets `bucket=this`, recomputes.
- `void onRenderableDescendantRemoving(IAdornable*)` — removes from all buckets (`fastRemove`, or **stable** `remove` for the 2D bucket when the DFFlag is set), clears `iR->bucket`, asserts indices back to −1.
- `void render2dItems(Adorn*)` / `render3dAdornItems(Adorn*)` — linear iteration calling the matching render hook; FLog::AdornRenderStats count line each call.
- `void append3dSortedAdornItems(std::vector<AdornableDepth>& destination, const Camera*) const` — appends `{item, camera->dot(position)}` records.

## Usage

The only place FastLog group AdornableLifetime is defined. Workspace-like owners embed a collector; items flow in/out through Instance parent/child notifications.

## Gotchas
- `fastRemove` swaps-with-last → ITERATION ORDER IS UNSTABLE across removals; ScreenGui z-order depended on this, hence the flag preserving order with O(n) stable remove.
- Destructor asserts emptiness only in debug — destroying a non-empty collector in release leaves items pointing at a dead bucket (use-after-free on their next dirty/unregister).
- `append3dSortedAdornItems` does NOT sort — sorting is the caller's job (records compare far-first).
