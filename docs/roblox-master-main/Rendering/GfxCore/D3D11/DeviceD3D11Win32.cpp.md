# Rendering/GfxCore/D3D11/DeviceD3D11Win32.cpp

## Purpose

Windows-desktop platform half of DeviceD3D11: dynamically loads d3d11.dll, creates device+swapchain via D3D11CreateDeviceAndSwapChain at feature level 11_0, presents, resizes, and reads the client-rect size. Also the VR creation order (Oculus first, then OpenVR). Compiled out for Durango and UWP.

## API

- `static TypeD3D11CreateDeviceAndSwapChain getDeviceCreationFunction()` — `LoadLibraryA("d3d11.dll")` + GetProcAddress("D3D11CreateDeviceAndSwapChain"); NULL if missing.
- `static DeviceVRD3D11* createVR(IDXGIAdapter** outAdapter)` — `createOculus(outAdapter)` else `createOpenVR(outAdapter)` else NULL (gated on `FFlag::RenderVR` at call site).
- `void DeviceD3D11::createDevice()`:
  - If RenderVR flag set: vr.reset(createVR(&adapter)) — the chosen VR runtime dictates which DXGI adapter to use.
  - Throws "Unable to load d3d11.dll" if absent; creation flags = D3D11_CREATE_DEVICE_DEBUG when FFlag::DebugD3D11DebugMode.
  - Swapchain desc: BufferCount=1, R8G8B8A8_UNORM, OutputWindow=(HWND)windowHandle, SampleDesc 1x, Windowed, **DXGI_SWAP_EFFECT_DISCARD**, refresh 0/1.
  - Requests exactly one feature level: D3D_FEATURE_LEVEL_11_0; on failure throws "Unable to create D3D device: %x". `shaderProfile` = DX11 iff returned level is 11_0, else level_9_3.
  - Requires shader compiler DLL (`ShaderProgramD3D11::loadShaderCompilerDLL()`), throwing "Unable to load shader compiler dll" otherwise; then wraps the immediate context in DeviceContextD3D11.
- `present()` — `swapChain11->Present(0,0)` (no vsync interval control here).
- `resizeSwapchain()` — `ResizeBuffers(0,0,0,DXGI_FORMAT_UNKNOWN,0)`.
- `getFramebufferSize()` — GetClientRect clamped to ≥1.

## Usage

This TU supplies the four platform-dependent privates declared in DeviceD3D11.h for Win32 builds.

## Gotchas

- Only feature level 11_0 is requested, so any older GPU falls back to the 9_3 profile path with WIN_MOBILE defines — despite requesting FL 11, D3D11 may return a lower level and the code adapts.
- Note the self-assignment bug-shaped line `this->windowHandle = windowHandle;` (member assigned from itself; member was already set by ctor init list).
- BufferCount=1 + DISCARD swap effect is the old-style bitblt model (pre-fl-model).
