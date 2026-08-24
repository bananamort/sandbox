# App/include/v8datamodel/Camera.h

## Purpose

`Camera` Instance ("Camera", PERSISTENT_LOCAL) — the full 3D view controller: position/focus CFrames with goal/prev interpolation slots, subject tracking (CameraSubject), zoom/pan/tilt primitives, frustum/projection math (project, worldRay, frustum), first-person/head-lock state, and camera history for undo-style navigation.

## Declared API

`class Camera : public DescribedCreatable<Camera, Instance, sCamera, Reflection::ClassDescriptor::PERSISTENT_LOCAL>, public HeartbeatInstance`

- Signals: `interpolationFinishedSignal<void()>`, `firstPersonTransitionSignal<void(bool)>`, `cframeChangedSignal<void(CoordinateFrame)>`.
- Enums: `CameraType { FIXED_CAMERA=0, ATTACH_CAMERA=1, WATCH_CAMERA=2, TRACK_CAMERA=3, FOLLOW_CAMERA=4, CUSTOM_CAMERA=5, LOCKED_CAMERA=6, NUM_CAMERA_TYPE=7 }` — comment: "part of the XML - only append". `ZoomType { ZOOM_IN_OR_OUT, ZOOM_OUT_ONLY }`. `CameraMode { CAMERAMODE_CLASSIC=0, CAMERAMODE_LOCKFIRSTPERSON=1 }`. `CameraPanMode { CAMERAPANMODE_CLASSIC=0, CAMERAPANMODE_EDGEBUMP=1 }`.
- Static constants: `distanceDefault()=36.0f`, `distanceMin()=0.5f` ("down from 4.0"), `distanceMax()=1000.0f`, `distanceMaxCharacter()=400.0f`, `distanceMinOcclude()=4.0f`, `interpolationSpeed()=5.0f` studs/s; static tunables `CameraKeyMoveFactor`, `CameraMouseWheelMoveFactor`, `CameraShiftKeyMoveFactor`; `static bool legalCameraCoord(const CoordinateFrame&);` `static float getNewZoomDistance(float currentDistance, float in);`
- Frame stepping: `void step(double elapsedTime); void stepSubject();` ("Yuck - called by Window code"); heartbeat via `onHeartbeat` hooked in `onServiceProvider`.
- History: `pushCameraHistoryStack()`; `std::pair<CoordinateFrame,CoordinateFrame> popCameraHistoryStack(bool backward)`; `stepCameraHistoryForward()/stepCameraHistoryBackward()`.
- Orientation query/set: `getHeadingElevationDistance(float& heading, float& elevation, float& distance)`; private `setHeadingElevationDistance(...)`.
- Subject: `CameraSubject* getCameraSubject(); const CameraSubject* getConstCameraSubject() const; Instance* getCameraSubjectInstanceDangerous() const; // for reflection only`; `setCameraSubject(Instance*)`; `bool hasClientPlayer() const;`
- Focus/position: `getCameraFocus()/setCameraFocus(value)` ("sets focus and focus goal"), `setCameraFocusWithoutPropertyChange`, `setCameraFocusOnly` ("sets focus" only), `setCameraFocusOnlyWithoutPropertyChange`, `setCameraFocusAndMaintainFocus(value, bool maintainFocusOnPoint)`; `getCameraCoordinateFrame()/setCameraCoordinateFrame(...)`; `setCameraLerpGoals(coordValue, focusValue)`; `beginCameraInterpolation(CoordinateFrame endPos, CoordinateFrame endFocus, float duration)`.
- Render frame: `getRenderingCoordinateFrame()` + Lua alias; `coordinateFrame() const`.
- First person: `isFirstPersonCamera()` ("hack for now - this should be in CameraSubject?? discuss"), `isLockedToFirstPerson()`, `bool getHeadLocked()/setHeadLocked(bool)`, `isCharacterCamera() const`.
- Frustum tests: `isPartInFrustum(const PartInstance&)`; `isPartVisibleFast(part, contactManager, filter=NULL)` — "one ray ... can have inaccurate results, but takes 1/4 the time".
- Type/mode: `getCameraType()/setCameraType(CameraType)`; `setCameraPanMode/getCameraPanMode`.
- Zoom: `bool canZoom(bool inwards) const; bool zoom(float in);` `bool setDistanceFromTarget(float newDistance[, CoordinateFrame& newCameraPos, const CoordinateFrame& newCameraFocus]);` overloads `zoomExtents()` (world), `(const ModelInstance*, ZoomType)`, `(const Extents&, ZoomType)`; `lerpToExtents(const Extents&)`; private `characterZoom/nonCharacterZoom(float)`, `zoomOut(...)`, `tryZoomExtents(const Extents&)`.
- Pan/Tilt: `onMousePan(const Vector2& wrapMouseDelta)`, `onMouseTrack(...)`; `panRadians(float)/panUnits(int)/panSpeedRadians(float)/getPanSpeed()`; `bool canTilt(int up) const`; `tiltRadians(bool-returning float arg up)/tiltUnits(int)/tiltSpeedRadians(float)/getTiltSpeed()`.
- LookAt/fly: `lookAt(const Vector3& point, bool lerpCamera); setImageServerViewNoLerp(const CoordinateFrame& modelCoord); doFly(const NavKeys& nav, int steps);`
- Imaging plane: `nearPlaneZ()` (negative z), inline `farPlaneZ() = -5e3f`; `getFieldOfView()` (radians)/`getFieldOfViewDegrees()`/`setFieldOfViewDegrees(float)`; `getRoll()/setRoll(float)/getRollSlow()`; `getImagePlaneDepth()`, `getViewportWidth()/getViewportHeight()`, `Vector2int16 getViewport()/setViewport(Vector2int16)`.
- Projection: `Vector3 project(const Vector3&) const` (+`projectLua(Vector3)`, `projectViewportLua` returning Reflection::Tuple), `Vector4 projectPointToScreen(const Vector3&) const`, `RbxRay worldRay(float x, float y, float depth = 0.0f) const` (+Lua/Viewport variants), `void frustum(float farPlaneZ, RBX::Frustum&) const` + `RBX::Frustum frustum() const`, `float dot(const Vector3& point) const`.
- Private state: interpolation enum `{CAM_INTERPOLATION_CONSTANT_TIME, CONSTANT_SPEED, NONE}`; CFrames `cameraCoord/cameraFocus/cameraCoordGoal/cameraFocusGoal/cameraCoordPrev/cameraFocusPrev`, `G3D::Vector3 cameraUpDirPrev`, durations/times, `headLocked`, `cameraType`, `shared_ptr<Instance> cameraSubject` ("Guaranteed to be a CameraSubject"), `fieldOfView`, `roll`, `viewport`, `panSpeed/tiltSpeed`, `cameraPanMode`, `imagePlaneDepth`, `hasFocalObject`, `ICameraOwner* getCameraOwner();`, `std::vector<std::pair<CoordinateFrame,CoordinateFrame>> cameraHistoryStack`, `currentCameraHistoryPosition`, `lastHistoryPushTime`.

## Gotchas

- CameraType enum order is serialized — never reorder, only append.
- `farPlaneZ()` hard-codes −5000 regardless of scene scale.
- Three distinct "set focus" flavors differ in goal-propagation and property-change signaling — picking the wrong one breaks undo/replication expectations.
- `getRollSlow()` exists alongside getRoll — smoothing variant (.cpp).

## UNKNOWN

- Exact interpolation policy switch between CONSTANT_TIME/SPEED (`interpolationDuration < 0` means constant speed per comment; rest in .cpp — see [Camera.md](../../v8datamodel/Camera.md)).

## Cross-links

- Implementation: [App/v8datamodel/Camera.md](../../v8datamodel/Camera.md).
- Interfaces: [ICameraOwner.md](ICameraOwner.md), [ICharacterSubject.md](ICharacterSubject.md); subjects via [Accoutrement.md](Accoutrement.md)/Humanoid family.
