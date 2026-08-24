# IAdornableCollector.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/IAdornableCollector.h` (37 lines)

## Purpose

Interface for objects that own a registry of `RBX::IAdornable` items (parts with adornment rendering) and drive their per-frame draw: three `Util/IndexArray` buckets — unsorted 2D, unsorted 3D, and depth-sorted 3D — filled via add/remove notifications from the IAdornables themselves.

## API

```cpp
class RBXInterface IAdornableCollector {
    friend class IAdornable;
private:
    IndexArray<IAdornable, &IAdornable::indexFunc2d>        renderable2ds;
    IndexArray<IAdornable, &IAdornable::indexFunc3d>        renderable3ds;
    IndexArray<IAdornable, &IAdornable::indexFunc3dSorted>  renderable3dSorteds;
public:
    void onRenderableDescendantAdded(IAdornable* iR);
    void onRenderableDescendantRemoving(IAdornable* iR);
    void recomputeShouldRender(IAdornable* iR);
    IAdornableCollector();
    ~IAdornableCollector();
    void render2dItems(Adorn* adorn);
    void render3dAdornItems(Adorn* adorn);
    void append3dSortedAdornItems(std::vector<AdornableDepth>& destination, const Camera* camera) const;
};
```

Also declares at file scope: `LOGGROUP(AdornRenderStats);` (FastLog group marker used by implementation).

## Usage

Implemented in `IAdornableCollector.cpp` (same dir); mixed into workspace-like containers that hold adornable instances. `IAdornable` is a friend so it can self-register into the IndexArrays.

## Gotchas

- The three index functions are member-pointer keyed — they must exist on IAdornable with exactly those names or compilation fails.
- Depth-sorted items are NOT drawn here; `append3dSortedAdornItems` only fills the caller's vector for later z-sorted pass.
