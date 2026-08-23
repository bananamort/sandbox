# RbxG3D/Frustum.cpp

## Purpose

Implementation of `RBX::Frustum` — a plane-list view frustum (near/right/left/bottom/top/[far]) built from apex/direction/up/FOVs, with point/AABB containment and sphere-intersection tests. Constructed in a local space then transformed to world to limit floating-point error far from origin.

## API

- `Frustum(apex, dir, up, nearDist, farDist, fovx, fovy)` — asserts dir/up unit; builds 5–6 `G3D::Plane`s (far omitted when `farDist == inf()`); rotates normals by the right/up/−dir basis and re-derives d around `apex` (infinite-d case uses `Plane::fromEquation` to dodge NaNs).
- `containsPoint(p)` — all planes' half-space test.
- `intersectsSphere(center, radius)` — per-plane offset by −radius.
- `containsAABB(Extents)` — all 8 corners contained (strict).
- `intersectsAABB(aabb, extentsFrame)` — transforms box to world, does center-vs-extent projection test on the first **6** planes (safe only when a far plane exists or near/far are among the first six — they are).
- `containsAABB(aabb, extentsFrame)` — corner transform + containsPoint.

## Usage

Used for culling (render passes) and by DrawAdorn's grid axis-ray visibility check (`camera.frustum().intersectsSphere`). Distinct from the nested `RbxCamera::Frustum` (vertex+face representation) in RbxCamera.h.

## Gotchas

- `intersectsSphere` returns false when the sphere merely touches a plane boundary region outside — it is a conservative "fully visible" test, not a partial-overlap test.
- `intersectsAABB` reads only faceArray[0..5]; with an infinite far plane there are exactly 5 entries ⇒ index 5 is out of bounds! In practice callers pass finite-far cameras; treat as latent UB.
