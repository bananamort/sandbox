# Rendering/GfxCore/D3D11/OculusVRD3D11.cpp

## Purpose

Oculus (LibOVR 0.x-era CAPI) implementation of `DeviceVRD3D11` — session setup, per-eye swap-texture-set framebuffers wrapped in the engine's Framebuffer abstraction, tracking-state conversion, and frame submission. Exposes `DeviceVRD3D11::createOculus(IDXGIAdapter** outAdapter)` used by device creation to co-select the HMD's GPU adapter.

## API

Compiled only when neither `RBX_PLATFORM_DURANGO` nor `RBX_PLATFORM_UWP` is defined. Links `../Rendering/LibOVR/Lib/Windows/Win32/Release/VS2012/LibOVR.lib` via pragma.

- `OVR_CHECK(call)` macro — logs failed ovrResult calls to FLog::VR.
- `static TypeCreateDXGIFactory getFactoryCreationFunction()` — GetProcAddress("CreateDXGIFactory") from d3d11.dll.
- `static IDXGIAdapter* getAdapterForLuid(LUID luid)` — NULL LUID → default adapter; else enumerate factory adapters matching the HMD LUID.
- `static DeviceVR::Pose getPose(const ovrPosef&, unsigned int statusFlags)` — valid = OrientationTracked; copies position xyz + quaternion xyzw.
- `struct VRTexture { static const int kMaxCount = 4; shared_ptr<Framebuffer> fb[kMaxCount]; ovrSwapTextureSet* textureSet; }`.
- `struct OculusVRD3D11 : DeviceVRD3D11` with `ovrSession session; ovrHmdDesc desc; VRTexture textures[2]; ovrEyeRenderDesc eyeDesc[2]; double sensorSampleTime; ovrTrackingState trackingState;`
  - destructor: destroys both swap texture sets, session, then `ovr_Shutdown()`.
  - `void update()` — predicted display time + `ovr_GetTrackingState(session, frameTime, ovrTrue)`; sensorSampleTime captured immediately before.
  - `void recenter()` — `ovr_RecenterPose`.
  - `Framebuffer* getEyeFramebuffer(int eye)` — returns the framebuffer for `textureSet->CurrentIndex` (ring buffer of ≤4 textures).
  - `State getState()` — head/hand poses, per-eye HmdToEyeViewOffset and FOV tans (up/down/left/right); `needsMirror = true`.
  - `void submitFrame(DeviceContext*)` — builds one `ovrLayerEyeFov`, `ovr_CalcEyePoses` from cached head pose + offsets, submits via `ovr_SubmitFrame(session, 0, &viewScaleDesc, &layers, 1)`, advances each set's CurrentIndex modulo TextureCount; if FFlag DebugRenderVRHUD, toggles OVR_PERF_HUD_MODE on Ctrl+F8 edge.
  - `void setup(Device*)` — ShowWindow(SW_SHOWNORMAL) workaround for a LibOVR bug; ideal texture size per eye (`ovr_GetFovTextureSize`, max of both); shared D24S8 renderbuffer; per eye creates an SRGB swap texture set (`DXGI_FORMAT_R8G8B8A8_UNORM_SRGB`, Typeless flag) and wraps each texture AddRef'd into `RenderbufferD3D11(device, Format_RGBA8, w, h, 1, tex)` + `device->createFramebuffer(colorBuffer, depthStencil)`.
- `static void logCallback(uintptr_t, int level, const char* message)` — FASTLOGS to FLog::VR.
- `static DeviceVRD3D11* DeviceVRD3D11::createOculus(IDXGIAdapter** outAdapter)` — `ovr_Initialize` (with log callback) → `ovr_Create`; both failures log + return NULL (shutdown on the second); fills hmd desc + per-eye render descs; outputs adapter for VR LUID; FASTLOGs product/vendor/firmware.

## Usage

Called from D3D11 device creation (see DeviceD3D11.cpp/.h): try Oculus first; if it returns non-NULL, `setup(device)` allocates eye buffers, then each frame: `update()` → render into `getEyeFramebuffer(eye)` → `submitFrame(context)`; `getState()` feeds camera/HUD math. All calls go through the abstract `DeviceVR` interface above this layer.

## Gotchas

- Entire file is compiled out on Durango/UWP — Oculus support is Windows-desktop only.
- Eye color buffers are declared Format_RGBA8 but the underlying swap textures are R8G8B8A8_UNORM_SRGB typeless — format mismatch is intentional (typeless reinterpretation); sRGB write behavior depends on the RTV path.
- `getEyeFramebuffer` dereferences `textureSet->CurrentIndex` without null-checking the set — must call `setup()` before any eye fetch.
- The Ctrl+F8 perf-HUD easter egg polls GetAsyncKeyState every submitted frame when the debug flag is on.
- LibOVR lib path is hardcoded to a VS2012 Win32 Release build directory.
- Swap-set ring capacity asserted at 4 (kMaxCount); more textures would silently overrun the fb array beyond the assert in debug.
