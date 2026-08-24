# ViewportBillboarder.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/ViewportBillboarder.h` (58 lines)

## Purpose

Computes and tracks the screen-space rectangle ("viewport") where a billboarded GUI should appear for a part in the 3D world — combining a stud-based offset on/around the part with pixel sizing (`UDim2`: studs-scale + pixels). Feeds screen offsets to drawing code each frame.

## API

```cpp
class RBX::ViewportBillboarder {
    CoordinateFrame cframe;
    Rect2D viewport;
    bool visibleAndValid;
    Vector2 screenOffset2D;

    Vector2 getScreenOffset(const Rect2D& parentviewport, const RBX::Camera& camera,
                            const CoordinateFrame& desiredModelView);   // private

public:
    // tunables (set via ctor):
    Vector3 partExtentRelativeOffset;   // offset relative to part extents
    Vector3 partStudsOffset;            // world-studs offset from the part
    Vector2 billboardSizeRelativeOffset;
    UDim2 billboardSize;                // studs*x + pixels
    const Vector2* guiScreenSize;       // null => pixel-exact mode
    bool alwaysOnTop;

    ViewportBillboarder();
    ViewportBillboarder(const Vector3& partExtentRelativeOffset,
        const Vector3& partStudsOffset, const Vector2& billboardSizeRelativeOffset,
        const UDim2& billboardSize, const Vector2* guiScreenSize /*null for pixel-exact*/);

    void update(const Rect2D& parentviewport, const Camera& camera,
                Vector3 partSize, CoordinateFrame partCFrame);
    bool hitTest(const Vector2int16& mousePosition, const Vector2int16& windowSize,
                 RBX::Workspace* workspace, Vector2& billboardMousePosition);

    const Vector2& getScreenOffset() const;
    bool isVisibleAndValid() const;     // inline
    const Rect2D& getViewport() const;  // inline
    const CoordinateFrame& getCoordinateFrame() const; // inline
};
```

## Usage

Implemented in `ViewportBillboarder.cpp` (same dir, 152 lines). Includes `V8DataModel/Workspace.h`, `util/UDim.h`. This is the mechanism behind player name-tags/billboard GUIs tracking parts.

## Gotchas

- `guiScreenSize` is a borrowed raw pointer — must point at storage that outlives the billboarder; null switches to pixel-exact sizing.
- Call `update()` every frame before trusting `getViewport()`/`getScreenOffset()` — they reflect the last update only.
- `hitTest` needs the Workspace pointer for occlusion/ray work per call.
