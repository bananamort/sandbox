# Part.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/Part.h` (67 lines)

## Purpose

Plain-value description of a drawable part geometry — "Simple description of a part suitable for drawing, etc. Build Instance on top of this. Low level." (verbatim header comment). Pure data, no behavior; the render layer's input record.

## API

```cpp
enum RBX::PartType {
    BALL_PART = 0, BLOCK_PART, CYLINDER_PART, TRUSS_PART, WEDGE_PART,
    PRISM_PART, PYRAMID_PART, PARALLELRAMP_PART, RIGHTANGLERAMP_PART,
    CORNERWEDGE_PART, MEGACLUSTER_PART, OPERATION_PART
};

class RBX::Part {
public:
    PartType type;
    G3D::Vector3 gridSize;                  // snapped/grid size
    G3D::Color4 color;
    Vector6<SurfaceType> surfaceType;       // 6 faces
    G3D::CoordinateFrame coordinateFrame;

    Part();                                 // default, leaves members uninitialized
    Part(PartType _type, const G3D::Vector3& _gridSize, const G3D::Color4 _color,
         const G3D::CoordinateFrame& c);    // surfaceType = NO_SURFACE all faces
    Part(PartType type, const G3D::Vector3& gridSize, const G3D::Color4 color,
         const Vector6<SurfaceType>& surfaceType, const G3D::CoordinateFrame& c);
};
```

## Usage

Includes `Util/SurfaceType.h`, `Util/Vector6.h`, and three G3D core headers. Consumed by drawing/mesh-generation code that switches on `PartType`; the in-code note "hash code hashes this block of data" says hashing starts at `type`.

## Gotchas

- Default ctor leaves ALL members uninitialized — use only the parameterized ctors.
- `OPERATION_PART` marks union/negate CSG outputs (pairs with the CSG module).
- Enum order is load-bearing (serialization/hashing by value) — never reorder.
- Comment says enum is "alpha order for simplification on dialogs" but it is not alphabetical — stale comment.
