# Rendering/GfxCore/D3D11/OpenVRD3D11.cpp

## Purpose

OpenVR (SteamVR) implementation of `DeviceVRD3D11` — loads openvr_api.dll dynamically, initializes IVRSystem/IVRCompositor, creates plain engine textures/framebuffers for the eyes, converts tracking matrices to engine poses, and submits per-eye textures each frame. Exposes `DeviceVRD3D11::createOpenVR(IDXGIAdapter** outAdapter)`.

## API

Compiled only when neither `RBX_PLATFORM_DURANGO` nor `RBX_PLATFORM_UWP` is defined. Includes `../Rendering/OpenVR/headers/openvr.h`; uses G3D Quat/Matrix3 for orientation extraction.

- `FASTFLAGVARIABLE(OpenVR, true)` — master switch; when false, `createOpenVR` returns NULL immediately.
- `OVR_CHECK(call)` macro — logs non-zero int results to FLog::VR (name reused from the Oculus file despite OpenVR semantics).
- `template<typename F> static F getOpenVRFunction(const char* name)` — GetProcAddress from `openvr_api.dll`.
- `static IDXGIAdapter* getAdapterForIndex(int index)` — EnumAdapters wrapper over CreateDXGIFactory.
- `static std::string getStringProperty(IVRSystem*, TrackedDeviceIndex_t, TrackedDeviceProperty)` — 128-byte buffer GetStringTrackedDeviceProperty.
- `static DeviceVR::Pose getPose(const TrackedDevicePose_t&)` — builds G3D quaternion from the 3x4 device-to-abs matrix rotation block; position from translation column; valid = bPoseIsValid.
- `static DeviceVR::Pose getPoseForIndex(IVRCompositor*, TrackedDeviceIndex_t)` — `GetLastPoseForTrackedDeviceIndex`.
- `static DeviceVR::Pose getPoseForRole(IVRSystem*, IVRCompositor*, ETrackedControllerRole)` — invalid index → default (invalid) Pose.
- `struct OpenVRD3D11 : DeviceVRD3D11` with `IVRSystem* system; IVRCompositor* compositor; shared_ptr<Framebuffer> fb[2]; shared_ptr<Texture> textures[2];`
  - destructor: resolves + calls `VR_ShutdownInternal` if present.
  - `void update()` — `compositor->SetTrackingSpace(TrackingUniverseSeated)` every frame.
  - `void recenter()` — `system->ResetSeatedZeroPose()`.
  - `Framebuffer* getEyeFramebuffer(int eye)` — static per-eye framebuffer.
  - `State getState()` — head pose by Hmd index; hands by controller role; per-eye offset = EyeToHeadTransform translation; FOV tans from `GetProjectionRaw` with **negated** upTan/leftTan; needsMirror = true.
  - `void submitFrame(DeviceContext*)` — RBXPROFILER_SCOPE("VR","submitFrame"); per eye `compositor->Submit(EVREye, Texture_t{TextureD3D11::getObject(), API_DirectX, ColorSpace_Gamma})`, then `WaitGetPoses(NULL, 0, NULL, 0)`.
  - `void setup(Device*)` — recommended RT size; D24S8 renderbuffer via device factory; per eye an RGBA8 Usage_Renderbuffer texture + framebuffer over its (0,0) renderbuffer.
- `static DeviceVRD3D11* DeviceVRD3D11::createOpenVR(IDXGIAdapter** outAdapter)` — flag gate → resolve VR_InitInternal/VR_ShutdownInternal/VR_GetGenericInterface (NULL on any miss) → `VR_InitInternal(&error, VRApplication_Scene)` → fetch IVRSystem and IVRCompositor by interface version (each failure: log, shutdown, NULL) → `GetDXGIOutputInfo(&adapterIndex)` for adapter output → FASTLOG model number.

## Usage

Second-priority VR backend after Oculus in D3D11 device creation. Same lifecycle contract as the Oculus adapter: create → setup(device) → per-frame update/getEyeFramebuffer/getState/submitFrame through the abstract `DeviceVR`/`DeviceVRD3D11` layer.

## Gotchas

- All OpenVR entry points are resolved at runtime; missing openvr_api.dll degrades silently to "no VR" (NULL), not an error.
- FOV sign flips (`-upTan`, `-leftTan`) are required by the engine's tan-convention — removing them inverts axes.
- `update()` does NOT poll poses (unlike the Oculus path); pose data comes from the implicit sync of `WaitGetPoses` inside submitFrame.
- Eye textures are ordinary engine render-target textures, not OpenVR swap sets — no ring buffering; compositor handles accumulation internally.
- `getAdapterForIndex` ignores EnumAdapters failure result (adapter may be NULL).
- Compiled out entirely on Durango/UWP like its Oculus sibling.
