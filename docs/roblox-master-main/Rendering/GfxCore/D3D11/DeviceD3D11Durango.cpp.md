# Rendering/GfxCore/D3D11/DeviceD3D11Durango.cpp

## Purpose

Xbox (Durango XDK) platform half of DeviceD3D11: creates an `ID3D11DeviceX` via D3D11XCreateDeviceX, a flip-sequential swapchain for the CoreWindow, presents through DXGIXPresentArray with overscan centering, and implements suspend/resume on the X context. Compiled only under RBX_PLATFORM_DURANGO.

## API

- `IDXGISwapChain* createSwapchain(ID3D11Device*, w, h)` — QI chain device→adapter→factory2; DXGI_SWAP_CHAIN_DESC1: R8G8B8A8_UNORM, BufferCount=2 ("to enable flip effect"), **DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL**, Scaling=STRETCH, Flags=ALLOW_MODE_SWITCH; created via `CreateSwapChainForCoreWindow(..., CoreWindow::GetForCurrentThread(), ...)`.
- `void DeviceD3D11::suspend()/resume()` — static_cast to ID3D11DeviceContextX → `Suspend(0)` / `Resume()`.
- `createDevice()` — flags add INSTRUMENTED|VALIDATED|DEBUG when DebugD3D11DebugMode; `D3D11X_CREATE_DEVICE_PARAMETERS` with `DeferredDeletionThreadAffinityMask = 0x20 // default value`; shaderProfile forced to shaderProfile_DX11; swapchain built at current render size.
- `present()` — assumes 1920×1080 TV ("for now... we're simply dealing with overscan"): DXGIXPresentArray of 1 swapchain with SourceRect = full framebuffer and DestRect centered on 1080p.
- `resizeSwapchain()` — destroys and recreates swapchain (no ResizeBuffers on this path).
- `getFramebufferSize()` — returns external hack `xboxPlatformGetRenderSize_Hack(windowHandle)`; comment: "This is a hacky bridge to get overscan-aware resolution from XboxClient. There's no simple way to refactor this :(".

## Usage

Console build only; the rest of the backend is shared with Win32.

## Gotchas

- Resolution/overscan policy lives outside GfxCore behind the `_Hack` bridge — any port must supply it.
- Present always targets 1080p center; non-HD TVs rely on platform scaling.
- Durango Release() returns are not trustworthy (see ReleaseCheck note), so leak assertions differ there.
