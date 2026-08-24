# ICharacterSubject.cpp

## Purpose

Implements `ICharacterSubject` — the interface mixin for camera subjects that represent a character (Humanoid): zoom-distance state (min/max/requested), first-person cutoff logic, mouse-lock offset, per-heartbeat character rotation/cursor/first-person requests, and GameBasicSettings bridging.

## Key types and API

Descriptors: none (interface). Constant: `maxMouseLockOffset = 1.5f`. Consumed flag: UserAllCamerasInLua (short-circuits onCameraHeartbeat).

State: requestedDistance(10), mouseLockOffset(=max), cameraTransitioning(false), cameraMode(CLASSIC), minDistance(0), maxDistance(Camera::distanceMaxCharacter()).

Behavior:
- getControlMode/getCustomCameraMode delegate to GameBasicSettings singleton (custom via getCameraModeWithDefault).
- isFirstPerson — requestedDistance < firstPersonCutoff() (header constant); setCameraMode returning to CLASSIC resets requestedDistance to 11.
- Distance setters clamp mutually: min ≤ max, both within [Camera::distanceMin, distanceMaxCharacter].
- onCameraHeartbeat(cameraLocation, focusPoint) — flag-gated no-op; tells camera-near distance; in mouse-lock mode reports cursor-over fraction; asks workspace->requestFirstPersonCamera(mouseLocked || isFirstPerson, isTransitioning(), controlMode) ("Ugly" dynamic_cast of this to Instance); rotates character with camera pan when locked/first-person else zeroes rotational velocity.
- stepRotationalVelocity — CAMERA_RELATIVE rotation type always re-applies pan rotation from render step ([Camera](Camera.md)::stepSubject).

## Usage / reflection touchpoints

Implemented by Humanoid; consumed by [Camera](Camera.md) (isFirstPerson/isLockedToFirstPerson/tilt clamps) and [AnimatableRootJoint](AnimatableRootJoint.md)-adjacent animation paths.

## Gotchas

- The "Ugly" dynamic_cast means non-Instance implementations silently skip workspace first-person requests.
- setCameraMode's 11-stud reset is hardcoded — a custom zoom near that distance jumps on mode switch.
