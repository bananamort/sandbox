# App/include/v8datamodel/ICharacterSubject.h

## Purpose

CameraSubject specialization for character-following cameras (Humanoid-side): first-person transitions and cutoff, distance bounds, control/custom camera modes, mouse-lock offset, rotational-velocity coupling to movement.

## Declared API

`class RBXInterface ICharacterSubject : public CameraSubject`

- Ctor `ICharacterSubject();`
- First person: `bool isFirstPerson() const; bool isDistanceFirstPerson(float distance) const; bool isTransitioning() const; float firstPersonCutoff() const { return 4.5f; }`
- Modes: `int getControlMode() const; int getCustomCameraMode() const;` `RBX::Camera::CameraMode getCameraMode()/setCameraMode(...)`.
- Distance: `getMinDistance/setMinDistance(float)`, `getMaxDistance/setMaxDistance(float)`; private tuning constants `maxOutPerSecond()`=10.0f, `maxZoomOutDistance()`=26.0f ("not being used currently").
- Pure contract ("implement" block): `tellCameraNear(distance)`, `tellCursorOver(cursorOffset)`, `setFirstPersonRotationalVelocity(desiredLook, bool firstPersonOn)`, `getYAxisRotationalVelocity()`, `calcDesiredWalkVelocity() → Velocity` ("used for camera control"), `hasFocusCoord()` ("Super hacky - clean all this up").
- Pure notification: `tellCameraSubjectDidChange(oldSubject, newSubject)`.
- CameraSubject override: `onCameraHeartbeat(cameraLocation, focusPoint)`; extra `stepRotationalVelocity(Vector3& cameraLocation, Vector3& focusLocation)`.
- State: static `maxMouseLockOffset`; members `requestedDistance`, `mouseLockOffset`, `cameraTransitioning`, cameraMode, min/max distance.

## Gotchas

- firstPersonCutoff is hard-coded 4.5 studs.
- Implementer must supply six engine-coupling hooks — the interface owns transition state machine.

## UNKNOWN

- Transition trigger conditions (.cpp — see [ICharacterSubject.md](../../v8datamodel/ICharacterSubject.md)).

## Cross-links

- Implementation: [App/v8datamodel/ICharacterSubject.md](../../v8datamodel/ICharacterSubject.md).
- Kin: [ICameraOwner.md](ICameraOwner.md), [Camera.md](Camera.md).
