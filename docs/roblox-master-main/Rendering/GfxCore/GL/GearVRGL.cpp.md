# Rendering/GfxCore/GL/GearVRGL.cpp

## Purpose

Samsung Gear VR (Oculus Mobile VrApi) implementation of `DeviceVRGL` for Android — session enter/leave, per-eye GL texture swap chains wrapped as external TextureGLs into engine framebuffers, head-model-applied tracking, and timed-frame submission. Exposes `DeviceVRGL::createGear()` plus a C entry point `vrGearSetJava` for the JVM handoff.

## API

Compiled only under `__ANDROID__`. Includes Oculus Mobile `VrApi.h`/`VrApi_Helpers.h`.

- Flag: `GearVR` (default false) — master gate in createGear.
- `static ovrJava gJava;` — file-global JVM/Env/Activity triple.
- `static DeviceVR::Pose getPose(const ovrPosef&, unsigned statusFlags)` — valid = VRAPI_TRACKING_STATUS_ORIENTATION_TRACKED; xyz + quat copy.
- `struct VRTexture { static const int kMaxCount = 4; shared_ptr<Framebuffer> fb[kMaxCount]; ovrTextureSwapChain* swapChain; unsigned int swapChainIndex; }`.
- `struct GearVRGL : DeviceVRGL` — members `ovrMobile* session; float eyeFovX, eyeFovY; VRTexture textures[2]; long long frameIndex; double sensorSampleTime; ovrTracking trackingState;`
  - dtor — LeaveVrMode, destroy both swap chains, vrapi_Shutdown.
  - `void update()` — frameIndex++, predicted display time → GetPredictedTracking → ApplyHeadModel(default parms).
  - `void recenter()` — vrapi_RecenterPose.
  - `Framebuffer* getEyeFramebuffer(int eye)` — fb[swapChainIndex].
  - `State getState()` — head pose from tracking state; eye offsets synthesized as ±IPD/2 on x from default head model (no per-eye API); FOV tans from suggested degrees (same tanX/tanY both eyes); **needsMirror = false**.
  - `void submitFrame(DeviceContext*)` — projection fov matrix → tan-angle matrix; default FrameParms with FrameIndex; fills WORLD layer Textures[eye] with swap chain/index/tanAngle matrix/head pose; vrapi_SubmitFrame; advances swapChainIndex modulo chain length.
  - `void setup(Device*)` — suggested eye texture dims from system properties; shared D24S8 renderbuffer; per eye CreateTextureSwapChain(2D, 8888, w, h, 1, true), each handle adopted via the **external-id TextureGL constructor** → framebuffer over its renderbuffer(0,0).
- `DeviceVRGL* DeviceVRGL::createGear()` — flag gate; vrapi_Initialize(DefaultInitParms(&gJava)) (log+NULL on failure); vrapi_EnterVrMode(DefaultModeParms) — note return not checked; fills eye FOVs from system properties.
- `void vrGearSetJava(JavaVM*, JNIEnv*, jobject activity)` — populates gJava; called from Android activity glue before any VR use.

## Usage

Android-only alternative to Cardboard under DeviceGL's VR slot (wired through DeviceVRGL surface; DeviceGL.cpp's createVR() currently only tries Cardboard — Gear VR is reachable when its own factory is invoked). Lifecycle: set java → createGear → setup(device) → per-frame update/getEyeFramebuffer/getState/submitFrame.

## Gotchas

- `vrGearSetJava` must run before createGear/setup — gJava is a raw global with no synchronization or validation.
- EnterVrMode failure (NULL session) is unchecked; subsequent calls would crash.
- Eye offsets are approximated from IPD rather than device-reported values; FOV assumes symmetric horizontal/vertical tans.
- Swap-chain textures are RGBA8888 single-mip; kMaxCount=4 asserted against chain length.
- needsMirror=false — phone screen shows nothing meaningful during VR mode.
