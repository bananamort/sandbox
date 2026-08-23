# Rendering/GfxCore/include/GfxCore/pix.h

## Purpose

PIX (GPU profiler capture, D3D-only) debug-marker macros: `PIX_MARKER(ctx, ...)` fires a one-off labeled event; `PIX_SCOPE(ctx, ...)` creates an `RBX::Graphics::PixScope` RAII object whose unique variable name is built by token-pasting on `__LINE__`. Both forward to variadic printf-style helpers implemented in pix.cpp. `PIX_ENABLED` is hard-set to 1 in this tree.

## API

- `#define PIX_ENABLED 1`
- `#define PIX_MARKER(ctx,...) RBX::Graphics::PixMarker(ctx,__VA_ARGS__)`
- `#define PIX_SCOPE(ctx,...) RBX::Graphics::PixScope PIX_CONCAT(pixScopeVar,__LINE__)(ctx,__VA_ARGS__)` (via PIX_CONCAT/2/3 macro ladder)
- `namespace RBX::Graphics`: `void PixMarker(DeviceContext* ctx, const char* fmt, ...)`; `struct PixScope { PixScope(DeviceContext*, const char* fmt, ...); ~PixScope(); DeviceContext* devctx; }`.
- When disabled the macros expand to no-ops.

## Usage

Sprinkled through backend DeviceContext implementations around passes (e.g. shadow maps, UI) so PIX/GPA captures show named spans; they route into `DeviceContext::pushDebugMarkerGroup/popDebugMarkerGroup/setDebugMarker`.

## Gotchas

- Comment in-file: "PIX support, D3D-only — pix.cpp is in GfxCore/D3D9" (the comment's path claim is stale; pix.cpp actually sits at GfxCore root). On GL these calls still execute and map to marker functions, but the tooling integration is D3D-oriented.
- Variadic macros require C99/C++11-ish compiler support; MSVC's traditional preprocessor handles the trailing-arg elision.
