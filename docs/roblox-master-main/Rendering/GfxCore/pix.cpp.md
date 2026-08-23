# Rendering/GfxCore/pix.cpp

## Purpose

Implements the PIX debug-marker helpers declared in pix.h: `PixMarker` (one-shot `setDebugMarker`) and `PixScope` ctor/dtor (push/pop marker group), both gated on FastFlag `FFlag::GraphicsDebugMarkersEnable` and formatting via vsnprintf into a 512-byte buffer.

## API

- `void PixMarker(DeviceContext* ctx, const char* fmt, ...)` — if flag set: format → `ctx->setDebugMarker(buffer)`.
- `PixScope::PixScope(DeviceContext* ctx, const char* fmt, ...)` — stores ctx; if flag set: format → `ctx->pushDebugMarkerGroup(buffer)`.
- `PixScope::~PixScope()` — if flag set: `devctx->popDebugMarkerGroup()`.
- Compiled only when `PIX_ENABLED` (1 in this tree); otherwise a dummy static keeps the TU non-empty.

## Usage

Wraps passes in backend contexts for PIX/RGP-style captures; zero cost when `GraphicsDebugMarkersEnable` is false (default).

## Gotchas

- The enable flag is checked at every call, but PixScope caches only `devctx` — if the flag flips between ctor and dtor the push/pop pair can become unbalanced.
- 512-char truncation with manual null-termination (`buffer[511] = 0`).
