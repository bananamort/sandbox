# RbxG3D/include/RbxG3D/Frustum.h

## Purpose

Declares `RBX::Frustum`, a plane-list view frustum used for visibility culling. Distinct from the vertex/face-based `RbxCamera::Frustum` nested inside RbxCamera.h — this one is just an array of `G3D::Plane`s plus containment tests, and knows how to test axis-aligned boxes (`RBX::Extents`).

## API

```cpp
class Frustum {
public:
    Frustum();                                        // empty plane list
    Frustum(const G3D::Vector3& apex, const G3D::Vector3& dir,
            const G3D::Vector3& up, float nearDist, float farDist,
            float fovx, float fovy);                  // radians
    enum FrustumPlane { kPlaneNear=0, kPlaneRight, kPlaneLeft,
                        kPlaneBottom, kPlaneTop, kPlaneFar, kPlaneInvalid };
    G3D::Array<G3D::Plane> faceArray;                 // order N,R,L,B,T,[F]
    bool containsPoint(const G3D::Vector3&) const;
    bool intersectsSphere(const G3D::Vector3& center, float radius) const;
    bool containsAABB(const RBX::Extents&) const;                        // local-space corners
    bool intersectsAABB(const RBX::Extents&, const G3D::CoordinateFrame& extentsFrame) const;
    bool containsAABB(const RBX::Extents&, const G3D::CoordinateFrame& extentsFrame) const;
};
```

Implementation in `Frustum.cpp` (same directory).

## Lua globals and events

None — internal culling primitive; not surfaced to Lua.

## Usage (who loads it)

- `App/v8datamodel/Camera.cpp:1511` constructs the engine camera's culling frustum each frame: `Frustum(cframe.translation, -cframe.rotation.column(2), cframe.rotation.column(1), -nearPlaneZ(), -farPlaneZ, fovx, fieldOfView)` (both near and far z are negated).
- `PartInstance::containedByFrustum / intersectFrustum` (PartInstance.cpp:3110–3115) and `ModelInstance::containedByFrustum` (ModelInstance.cpp:454) drive `Camera::isPartInFrustum` → `RootInstance` auto-camera adjustment.
- `Rendering/GfxRender/LightGrid.cpp:718` calls `intersectsSphere` for light culling; `GfxRender/VisualEngine.h` keeps its own `updateFrustum` consumed by scene update.

## Gotchas

- The two 2-arg `containsAABB` overloads differ only in whether a `CoordinateFrame` is supplied (corner-transform vs plain); overload resolution with a temporary `cframe` reads ambiguously in review but compiles fine.
- Plane order matters: index-based consumers assume N,R,L,B,T,[F] with the far plane last and **optional** (omitted when `farDist == inf()`).
