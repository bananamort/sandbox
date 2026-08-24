# RenderHooksService.cpp

## Purpose

Implements `RenderHooksService`, a LocalUser-security debug/control service bridging reflection to the render pipeline hooks (`renderHooks`) and window hooks (`wndHooks`). Exposes shader reload, render-queue toggles, metrics capture, window resize, GPU/render timing queries, adorn toggle, and scene printing — every call guarded by NULL checks on the hook pointers.

## Key types and API

Descriptors (all BoundFuncDesc, **Security::LocalUser**):
- "ReloadShaders()" → reloadShaders; "EnableQueue(qId:int)" / "DisableQueue(qId:int)" → enableQueue/disableQueue.
- "CaptureMetrics()" → captureMetrics (fills internal `metrics` struct, memset zeroed in ctor); "PrintScene()" → printScene; "EnableAdorns(enabled:bool)" → enableAdorns.
- "ResizeWindow(width, height)" → resizeWindow → wndHooks->resizeWindow.
- Timing getters: "GetPresentTime", "GetGPUDelay", "GetRenderAve", "GetRenderConfMin", "GetRenderConfMax", "GetRenderStd", "GetDeltaAve" — all double(void).

Implemented bodies in THIS TU: resizeWindow, captureMetrics, printScene, enableAdorns (all trivial hook-forwarders). The remaining bound names (reloadShaders, enableQueue, disableQueue, and all seven timing getters) have NO body here — they resolve to inline/header definitions or other TUs.

Includes hint at intended surface: V8Xml/WebParser, Util/Http, Profiling, rbx/Log — none actually used by the implemented bodies.

## Usage / reflection touchpoints

Debug-tooling surface at Security::LocalUser (local scripts/tools). Pairs with GfxCore hook docs under [Rendering](../../Rendering/) where the IRenderHooks/IWndHooks implementations live.

## Gotchas

- Half the reflected API is not implemented in this file — behavior claims require checking header/other TU before relying on them.
- All calls silently no-op when hooks are NULL (e.g., headless/server context) — no error surfaced.
- `metrics` is captured into the service but no getter descriptor exists in this TU — CaptureMetrics output is write-only from reflection's perspective here.
- UNKNOWN: where GetPresentTime family reads its clock; whether EnableQueue ids are validated downstream.
