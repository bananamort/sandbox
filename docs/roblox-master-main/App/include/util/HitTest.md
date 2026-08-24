# util/HitTest.h

## Purpose
Static ray-vs-handle picking for the studio-style manipulation gizmos: tests a mouse `Ray` against scale/rotate/move handles attached to an extents box, in local or world space, returning hit point and face normal.

## Declared API
```cpp
class HandleHitTest {
public:
    // Local-space handle test (extents given in object space, location = object CFrame):
    static bool hitTestHandleLocal(
        const Extents& localExtents,
        const CoordinateFrame& location,
        HandleType handleType,
        const Ray& gridRay,
        Vector3& hitPointWorld,          // out
        NormalId& localNormalId,         // out (local space)
        const int normalIdMask = NORM_ALL_MASK);

    static bool hitTestHandleWorld(
        const Extents& worldExtents,
        HandleType handleType,
        const Ray& gridRay,
        Vector3& hitPointWorld,
        NormalId& worldNormalId,
        const int normalIdMask = NORM_ALL_MASK);

    static bool hitTestMoveHandleWorld(
        const Extents& worldExtents,
        const RbxRay& gridRay,
        Vector3& hitPointWorld,
        NormalId& worldNormalId,
        const int normalIdMask = NORM_ALL_MASK);
};
```

## Gotchas
- `hitTestHandleLocal` takes local extents **plus** a CoordinateFrame; the world variants expect already-transformed world extents.
- Note the type inconsistency: first two take `const Ray&` while `hitTestMoveHandleWorld` takes `const RbxRay&` — under G3DCore typedefs these may be distinct types; callers must pass the right one.
- `normalIdMask` restricts which faces/handles are eligible (see Faces.md / NormalId.md masks).
- Includes `appdraw/HandleType.h` — couples util to app draw enums.

## UNKNOWN
- Which handle geometries each HandleType maps to (.cpp outside App/include).
