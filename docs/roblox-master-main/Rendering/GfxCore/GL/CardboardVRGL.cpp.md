# Rendering/GfxCore/GL/CardboardVRGL.cpp

## Purpose

Google Cardboard VR implementation of `DeviceVRGL` for iOS and Android — a self-contained software VR stack: lens-distortion math from the Cardboard 2.0 spec, 40×40 distortion meshes per eye with vignette, an embedded GLSL distortion shader, per-platform inertial HeadTracker (CoreMotion / NDK sensor loop) with gyro+orientation prediction and time-warp, neck model, heading recentering, and final composite into the main framebuffer. Also exposes C entry points for the app layer to feed device/lens/phone parameters.

## API

Compiled only under RBX_PLATFORM_IOS or __ANDROID__. Flag: `CardboardVR` (default false) — gate in createCardboard.

- `struct CardboardConfiguration { fieldOfView; interLensDistance; trayToLensCenterDistance; screenToLensDistance; distortionCoeffs[2]; screenWidth; screenHeight; screenBorderSize; }`; global `gConfiguration` preset to Cardboard v2.0 spec (120°, 63.9mm IPD, coeffs 0.34/0.55); `gScreenOrientation` ±1.
- Tunables: `kUseVsync/kUseTimeWarp/kUseAdaptivePrediction/kUseNeckModel = true`; `kNeckOffset = (0, 0.075, -0.0805)`.
- `static float distort(config, radius)` — polynomial barrel distortion (Σ coeff_i·r^(2i)); `distortInverse(...)` — secant-method iteration to 1e-4.
- `static void computeFOVPort(config, float fovPort[4])` — up/down/outer/inner tan limits clamped by distorted geometry.
- `static shared_ptr<Geometry> createDistortionMesh(Device*, config, int eye, unsigned* outIndices, float outUVScaleOffset[4])` — builds DistortionVertex{x,y,u,v,fade} grid (position Float2 + uv0 Float3 carrying fade in z), triangle-strip index buffer with degenerate stitching, outputs per-eye UV scale/offset; uses base Device factories only.
- `static shared_ptr<ShaderProgram> createDistortionProgram(Device*)` — inline ES2/ES3 shader pair: quaternion `Warp` rotation of view UVs + `UVScaleOffset` remap + fade multiply; picks variant by getShadingLanguage()=="glsles".
- `static Quat predictRotation(displayTimestamp, sensorTimestamp, rotationRate)` — capped 100ms prediction, adaptively shortened by angular speed when adaptive enabled.
- `static DeviceVR::Pose getPose(const Vector3&, const Quat&)`.
- `class HeadTracker` (iOS): CMMotionManager gyro+deviceMotion at 100 Hz on an NSOperationQueue, spin-mutex-guarded state; `getTime()`=CACurrentMediaTime; `predictOrientation(time)` = orientation · predicted delta.
- `class HeadTracker` (Android): boost::thread running an ALooper sensor loop (gyroscope + GAME_ROTATION=15 at min delay), CLOCK_BOOTTIME clock, same mutex/predict interface.
- `struct CardboardVRGL : DeviceVRGL` — members mainFramebuffer ptr, fb[2]/textures[2] (1024² RGBA8 render-target textures + D24S8), distortionProgram/mesh[2]/indices/UVScaleOffset[2][4], headTracker, configuration copy, displayTime/headOrientation/headPosition, headingRef/headingSet.
  - `Quat getHeadOrientation(orientation)` — applies X-axis −90° mount rotation and Z-axis UI orientation flip; `getHeadOrientationCentered` pre-multiplies −headingRef Y rotation.
  - `void update()` — displayTime = now + 40 ms; predict orientation; first-valid-heading capture (|heading.y|<0.95 guard); neck-model position update.
  - `void recenter()` — clears headingSet (recaptured next update).
  - `Framebuffer* getEyeFramebuffer(int)` — static per-eye FBO.
  - `State getState()` — head pose; per-eye x-offset ±IPD/2; FOV ports mirrored per eye; needsMirror=false.
  - `void submitFrame(DeviceContext*)` — binds MAIN framebuffer, black clear, binds distortion program, no-blend/no-cull/depth-off constants, optional time-warp quat (predicted⁻¹·head), per eye sets UVScaleOffset+Warp constants, binds eye texture linear/clamp, draws strip; then 4px white center divider via scissored clear (raw glEnable(GL_SCISSOR_TEST) around it).
  - `void setup(Device*)` — grabs main framebuffer, allocates eye targets + meshes + program.
- `DeviceVRGL* DeviceVRGL::createCardboard()` — flag gate; copies gConfiguration; logs HMD/eye params; Android sets eglSwapInterval(kUseVsync).
- C hooks: `vrCardboardSetDeviceParams(fieldOfView, interLensDistance, trayToLensCenterDistance, screenToLensDistance, d0, d1)`; `vrCardboardSetPhoneParams(wPx, hPx, xdpi, ydpi)` → meters via 0.0254/dpi, width=max/height=min, border 3mm; `vrCardboardSetOrientation(bool flipped)` → gScreenOrientation ∓1.

## Usage

The default VR backend on mobile GL devices (DeviceGL.cpp's createVR tries it first). App glue calls vrCardboardSetDeviceParams/vrCardboardSetPhoneParams/vrCardboardSetOrientation before enabling VR; then standard DeviceVR lifecycle (setup → update/getEyeFramebuffer/getState per frame → submitFrame composites both eyes).

## Gotchas

- Eye rendering happens offscreen at fixed **1024×1024** regardless of screen size/resolution.
- The divider line bypasses the abstraction (direct glScissor calls inside submitFrame).
- Heading capture rejects near-vertical orientations (looking straight up/down) — recenter may need several updates.
- Android GAME_ROTATION vector is stored as xyz and rebuilt to a quat with computed w each predict call.
- Configuration globals are written by C setters with no locking — set them before VR starts, not during.
- The distortion shader relies on GfxCore attribute conventions (`vertex`, `uv0`) matching GeometryGL's slot table; texcoord.z carries the vignette fade.
- iOS tracker timestamps mix CMTime vs CACurrentMediaTime domains by design (both map to mach time base).
