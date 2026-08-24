# IAdornable.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/IAdornable.h` (71 lines)

## Purpose

Interface for Instances that draw adornments (selection boxes, outlines, GUI billboards): self-registers into an `IAdornableCollector`'s three index buckets and exposes per-frame render hooks for 2D, 3D, and depth-sorted-3D passes. Extends `Selectable` so the same object participates in selection.

## API

```cpp
class RBXInterface IAdornable : public Selectable {
    friend class IAdornableCollector;
private:
    int index2d, index3d, index3dSorted;          // IndexArray slots
    int& indexFunc2d(); int& indexFunc3d(); int& indexFunc3dSorted();
    IAdornableCollector* bucket;
protected:
    virtual bool shouldRender2d() const { return false; }
    virtual bool shouldRender3dAdorn() const { return false; }
    virtual bool shouldRender3dSortedAdorn() const { return false; }
public:
    IAdornable();                                  // bucket NULL, indices -1
    ~IAdornable();                                 // impl unregisters from bucket
    void shouldRenderSetDirty();
    float calculateDepth(const Camera* camera) const;
    virtual bool isVisible(const Rect2D& rect) const { return true; }

    virtual void renderBackground2d(Adorn*) {}
    virtual void renderBackground2dContext(Adorn*, const Instance* context); // delegates
    virtual void render2d(Adorn*) {}
    virtual void render2dContext(Adorn*, const Instance* context);           // delegates
    virtual void render3dAdorn(Adorn*) {}
    virtual void render3dSortedAdorn(Adorn*) {}
    virtual void render3dSelect(Adorn*, SelectState) {}
    virtual Vector3 render3dSortedPosition() const { return Vector3(0,0,0); }
};

struct AdornableDepth {                 // sort record for depth pass
    IAdornable* adornable; float depth;
    bool operator<(const AdornableDepth& o) const { return depth > o.depth; } // far first
};
```

## Usage

Includes `Util/IndexArray.h`, `Util/Selectable.h`, `V8Tree/Instance.h`, `SelectState.h`. Implemented by workspace adornables; driven by `IAdornableCollector` (friend). The `*Context` variants default to their non-context siblings.

## Gotchas

- `operator<` is inverted (`depth > o.depth`) — sorting ascending puts FAR objects FIRST (painter's back-to-front order).
- `render3dSortedPosition` default origin means subclasses that use sorted rendering MUST override or all sorts collapse to one point.
- Destructor and `calculateDepth` are implemented in IAdornableCollector.cpp — header alone won't link.
