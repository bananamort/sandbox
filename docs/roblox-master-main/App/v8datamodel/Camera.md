# Camera.cpp

## Purpose

Implements `Camera` ("Camera") — the viewport camera Instance: seven legacy CameraType behaviors (Scriptable/Fixed/Watch/Attach/Track/Follow/Custom), focus+position model with studio lerp/interpolation, zoom machinery (character vs non-character vs edit mode), pan/tilt/roll, projection math (WorldToScreen/Ray casts with GUI inset), camera history stack ([ ] keys), frustum/visibility queries, and VR head-lock compositing.

## Key types and API

Descriptors:
- `desc_cameraType("CameraType", category_Camera)` — enum; registered "CameraType" pairs: Fixed, Watch, Attach, Track, Follow, Custom, **LOCKED_CAMERA→"Scriptable"**.
- `desc_CFrame("CFrame", category_Data)` — CoordinateFrame get/set; `desc_CoordFrame("CoordinateFrame")` — same accessors, `Attributes::deprecated(desc_CFrame, LEGACY_SCRIPTING)`.
- `desc_Focus("Focus", category_Data)` + `desc_focus("focus", deprecated(desc_Focus))` — CoordinateFrame.
- `desc_FieldOfView("FieldOfView", category_Data)` — float degrees, clamped 1..120 with warning.
- `desc_viewport("ViewportSize", category_Data)` — Vector2 read-only.
- `cameraSubjectProp("CameraSubject", category_Camera)` — RefPropDescriptor<Instance>.
- `desc_HeadLocked("HeadLocked", category_Data)` — bool, default true.

BoundFuncs:
- Security::None: `ViewportPointToRay(x,y,depth[0])`, `ScreenPointToRay(x,y,depth[0])`, `WorldToViewportPoint(worldPoint)`, `WorldToScreenPoint(worldPoint)`, `SetRoll(rollAngle)`, `GetRoll()`, `GetTiltSpeed()`, `GetPanSpeed()`, `SetCameraPanMode(mode[Classic])`, `PanUnits(units)`, `TiltUnits(units)`, `Interpolate(endPos,endFocus,duration)`, `GetRenderCFrame()`.
- `func_zoom("Zoom", "distance", **Security::RobloxScript**)`; `event_firstPersonTransition("FirstPersonTransition", "entering", **Security::RobloxPlace**)`; `event_doneInterpolating("InterpolationFinished")`.

Enums registered: CameraType (above), CameraMode {Classic, LockFirstPerson}, CameraPanMode {Classic, EdgeBump} (+ lenient StringConverter matching by substring). Statics: `defaultFieldOfView = 70°`; tunables `CameraKeyMoveFactor 1.5`, `CameraMouseWheelMoveFactor 15`, `CameraShiftKeyMoveFactor .2`. Flags: `FlyCamOnRenderStep`, `UserBetterInertialScrolling` (consumed), `UserAllCamerasInLua(false)`, `CameraInterpolateMethodEnhancement(true)`, `CameraVR(true)`.

Behavior highlights:
- ctor default pose at (0,20,20) looking at origin; `askSetParent` — Workspace only.
- `step()` per-type logic: Scriptable holds pose (+CONSTANT_TIME interpolation lerp of position/focus/up); Watch re-focuses subject; Attach orbits keeping XZ distance behind focus look; Track translates position by focus delta; Follow trails XZ distance ("distance lags and follows, height follows immediately"); Custom no-op. Then pan/tilt speeds integrate, and camera looks at focus (or straight ahead when coincident).
- Interpolation: `Interpolate` requires Scriptable type OR Studio mode (else throw); duration>0 → CONSTANT_TIME, duration==0 → CONSTANT_SPEED (studio-only heartbeat path), negative throws "Interpolation time must be positive or 0."; completion raises InterpolationFinished via onHeartbeat.
- Zoom: `zoom(in)` → edit-mode/nonCharacterZoom (wheel-step translation w/ shift slow-down, history push) or characterZoom (distance clamp to distanceMaxCharacter, y-component capped at min(6, .025·dist) to avoid gimbal loss overhead view); static `getNewZoomDistance` geometric ±25% steps clamped [distanceMin, distanceMax].
- CameraSubject setter silently upgrades a subject whose first child is named+typed Humanoid ("control schemes can't interface with camera otherwise"); notifies old ICharacterSubject via tellCameraSubjectDidChange.
- Projection: `projectPointToScreen` Matrix4 pipeline mapping to pixels (y inverted); WorldToScreenPoint subtracts GuiService `getGlobalGuiInset` xy, Viewport variant doesn't; both return Tuple{Vector3, bool isOnScreen} (z>0 AND unclamped). `worldRay` builds ray from inverse projection + near-clip offset; ScreenPointToRay adds inset before delegating.
- `getRenderingCoordinateFrame()` = cameraCoord ∘ roll(-about Z) ∘ headCFrame when HeadLocked && UserInputService present; used by rays/frustum/projection under CameraVR.
- `legalCameraCoord` rejects NaN/Inf, |rotation| >1.2, |translation| >1e6 — illegal sets only update the GOAL, not the actual CFrame.
- History: ≤50-entry stack, 0.5 s push debounce, forward/backward stepping disabled while isCharacterCamera.
- `doFly(NavKeys, steps)` — FIXED_CAMERA fly-cam WASD/QE-style movement with hold-time acceleration (render-step flag variant caps ×15 @4 s, legacy ×30), shift ×0.2 unless mouselock; non-edit forces FIXED type + 20-stud focus.

## Usage / reflection touchpoints

Owned by Workspace ([Workspace](Workspace.md)); subject contract with Humanoid/ICharacterSubject ([ICharacterSubject](ICharacterSubject.md)); inset interop with [GuiService](GuiService.md); head frame from [UserInputService](UserInputService.md).

## Gotchas

- LOCKED_CAMERA is REGISTERED as the string "Scriptable" — enum value ≠ display name everywhere in scripts.
- setRoll/setCameraPanMode/etc. silently zero/no-op outside Scriptable type with only a console warning (roll).
- Setting CFrame while an illegal value was previously "goal-set" can desync goal vs actual until next legal set.
- characterZoom comment admits duplication with ICharacterSubject ("code is not currently shared") — occlusion handled ONLY in the subject path.
- WorldToScreenPoint returns w (clip w) as z of the Vector3 — depth semantics differ from project()'s zImagePlane·2·q.z path; mixing them misorders occlusion checks.
