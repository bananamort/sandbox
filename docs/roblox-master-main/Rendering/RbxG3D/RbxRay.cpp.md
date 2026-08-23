# RbxG3D/RbxRay.cpp

## Purpose

Non-inline implementation of `RBX::RbxRay`: reflection/refraction ray construction, ray-plane hit points, and `intersectionTime` for sphere/plane/box/AABB that delegate to G3D's `CollisionDetection`.

## API (key behaviors)

- `RbxRay refract(const Vector3& newOrigin, const Vector3& normal, float iInside, iOutside) const` — direction via `Vector3::refractionDirection`; origin bumped by `(direction + normal·sign(dot))·0.001f` to avoid self-hit.
- `RbxRay reflect(const Vector3& newOrigin, const Vector3& normal) const` — direction via `reflectionDirection`; origin bumped by `(D + normal)·0.001f`.
- `Vector3 intersectionPlane(const Plane& plane) const` (lines 42–72, replacing commented legacy): parallel test `|direction·normal| < 1e-6f` → `Vector3::inf()`; else `t = (plane.distance() − origin·normal)/(direction·normal)`; negative t → inf. Unlike stock G3D this hits **regardless of which side** the plane faces ("modified from G3D").
- `float intersectionTime(const Sphere&) / (const Plane&) / (const Box&) / (const AABox&)` — one-line delegates to `G3D::CollisionDetection::collisionTimeForMovingPointFixedSphere/Plane/Box/AABox`. For Box/AABox: if the collision time is infinite but the origin is **inside** the solid, returns 0.0f.

Triangle intersections are header-inline (see RbxRay.h.md).

## Lua globals and events

Indirect only: this class is the storage behind the Lua `Ray` datatype (`Ray.new`, `ray.Unit`, `ray.ClosestPoint(point)`), so every Lua ray-plane/part query ultimately runs through code here or its inline siblings.

## Usage (who loads it)

Compiled into the RbxG3D static lib by all three build systems (vcxproj ClCompile, CMake SOURCES, both Xcode targets). Linked wherever RbxRay.h is used — picking tools, humanoid probes, Camera worldRay, v8world mesh casts.

## Gotchas

- The 0.001f epsilon bumps in reflect/refract are in *direction-magnitude units*; with the non-unit directions this class permits, tiny directions make the bump negligible and large ones overshoot.
- `intersectionTime(Box/AABox)` returning 0 inside-the-box is a Roblox-local tweak; raw CollisionDetection would return inf there.
- Legacy implementations kept as comment blocks (lines 43–56).
