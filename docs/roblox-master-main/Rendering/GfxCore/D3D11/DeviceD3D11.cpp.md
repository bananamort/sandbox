# Rendering/GfxCore/D3D11/DeviceD3D11.cpp

## Purpose

Backend-independent (Win32+Durango shared) half of DeviceD3D11: capability detection, main-framebuffer construction, frame lifecycle with GPU timestamp queries, VR hookup, resource factory methods, and shader-source/bytecode delegation to ShaderProgramD3D11 statics.

## API

Key implementations:
- `static getMaxSamplesSupported(ID3D11Device*)` — probes `CheckMultisampleQualityLevels(R8G8B8A8_UNORM, 2/4/8...)`, returns highest working power-of-two ≥1.
- `DeviceD3D11::DeviceD3D11(windowHandle)` — calls platform `createDevice()`; fills caps: FFP=false, Index32=true, DXT=true, PVR/ETC1=false, HalfFloat=true ("always supported on DX11 HW"), NPOT=not level_9_3, maxDrawBuffers = 4 (9_3) / 8, maxTextureUnits=16, no BGR/half-pixel/flipping quirks, retina=false. Then creates main framebuffer at current size, timestamp/disjoint queries, sets `IDXGIDevice1::SetMaximumFrameLatency(1)`, logs adapter name/vendor/device via DXGI_ADAPTER_DESC; **skips `Profiler::gpuInit` on Intel** (VendorId 0x8086) "to avoid a crash in Intel driver when releasing resources in gpuShutdown"; VR setup wrapped in try/catch that resets vr on exception.
- `createMainFramebuffer(w,h)` — swapchain GetBuffer(0) → RenderbufferD3D11(Format_RGBA8, external texture) + own D24S8 depth → FramebufferD3D11.
- `~DeviceD3D11()` — Profiler::gpuShutdown, then vr/immediateContext/mainFramebuffer reset and ReleaseCheck on queries, swapchain, device (order matters for leak testing).
- `defineGlobalConstants(dataSize, constants)` — asserts non-empty, `dataSize % 16 == 0`; comment: "constants are directly set to register values... every constant has to be aligned to float4 boundary".
- `beginFrame()` — returns NULL if no framebuffer or size mismatch ("Don't render anything if window size changed; wait for validate"); otherwise binds main FB, clearStates(), starts disjoint/timestamp query pair (alternate frames).
- `validate()` — ignores minimized windows (size ≤1×1); on size change: OMSetRenderTargets(NULL), drop mainFramebuffer, resizeSwapchain(), recreate.
- `endFrame()` — alternates query issue/readback to compute gpuTime ms (`(tsEnd-tsBegin)/Frequency*1000`, skipped when Disjoint); submits VR frame if enabled; `present()`.
- Factories return the concrete classes; `createShaderSource` appends defines `" DX11"` plus `" WIN_MOBILE"` when profile is 9_3 before delegating; `createShaderProgramFFP()` throws "No FFP support".

## Usage

Instantiated by Device::create(API_Direct3D11, hwnd). beginFrame returning NULL is a legal skip-frame signal callers must honor.

## Gotchas

- `beginFrame()` contains `return false;` where NULL is meant — same effect, sloppy but harmless.
- Intel GPUs never get GPU profiling hooks (driver crash workaround).
- Global constant layout must be float4-aligned end-to-end — upstream packers must respect it.
- GPU time uses double-buffered queries: one frame latency in stats.
