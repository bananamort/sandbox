# util/G3DCore.h

## Purpose
Umbrella header aliasing the G3D math/geometry library into the `RBX` namespace: vectors, matrices, colors, CoordinateFrame, planes, lines, boxes, spheres, plus Roblox's RbxRay/RbxCamera. Virtually every util geometry header includes this.

## Declared API
```cpp
// Includes G3D types then re-exports as RBX names:
namespace RBX {
    typedef G3D::Vector2 Vector2;         typedef G3D::Vector3 Vector3;
    typedef G3D::Vector4 Vector4;
    typedef G3D::Vector2int16 Vector2int16;
    typedef G3D::Vector3int16 Vector3int16;
    typedef G3D::Color4uint8 Color4uint8; typedef G3D::Color3uint8 Color3uint8;
    typedef G3D::Matrix3 Matrix3;         typedef G3D::Matrix4 Matrix4;
    typedef G3D::CoordinateFrame CoordinateFrame;  // (CFrame)
    typedef RBX::RbxRay Ray;              // NOTE: Roblox's own ray, not G3D::Ray
    typedef G3D::Plane Plane;             typedef G3D::Line Line;
    typedef G3D::LineSegment LineSegment;
    typedef G3D::Color3 Color3;           typedef G3D::Color4 Color4;
    typedef G3D::Rect2D Rect2D;           typedef G3D::Box Box;
    typedef G3D::AABox AABox;             typedef G3D::Sphere Sphere;

    enum IntersectResult { irNone = 0, irPartial = 1, irFull = 2 };
}

namespace G3D {
    std::size_t hash_value(const G3D::Vector3& v);       // boost hash support
    std::size_t hash_value(const G3D::Vector3int16& v);
}
```
Also pulls in `G3D/vectorMath.h` and `G3D/Debug.h`. A commented-out `using G3D::Array;` is deliberately disabled — "this can cause namespace collisions".

## Gotchas
- `RBX::Ray` is **not** `G3D::Ray` — it's Roblox's own RbxRay from RbxG3D; don't mix them.
- Everything here is typedefs + one enum; behavior lives in the G3D headers (Vector3.md-style docs belong to the G3D slice, if any).
- Header guard uses a GUID-style macro (`_70F7A2EE...`).

## UNKNOWN
- Where RbxRay/RbxCamera are documented (RbxG3D slice outside util/).
