# Rendering/GfxCore/DeviceCreate.cpp

## Purpose

Implements the `Device::create(API, void* windowHandle)` factory — the single switch point that maps the abstract `Device::API` enum to a concrete backend constructor, with platform guards.

## API

- `static Device* Device::create(API api, void* windowHandle)`:
  - `_WIN32` and **not** `RBX_PLATFORM_DURANGO`: `API_Direct3D9` → `new DeviceD3D9(windowHandle)`.
  - `_WIN32` (including Durango): `API_Direct3D11` → `new DeviceD3D11(windowHandle)`.
  - not Durango: `API_OpenGL` → `new DeviceGL(windowHandle)`.
  - otherwise throws `RBX::runtime_error("Unsupported API: %d", api)`.

## Usage

The bootstrap path for every client: callers pass an API enum (chosen by platform/settings elsewhere, UNKNOWN where that policy lives — likely in the render settings layer outside GfxCore) plus the OS window handle (`HWND`, X11/GLX handle, etc.).

## Gotchas

- D3D9 is compiled out on Xbox 360 (Durango codename in this tree); GL is likewise unavailable on Durango — D3D11 is the only backend there.
- Backend headers are included unconditionally on their platforms (GL always; D3D* only under `_WIN32`), so this file is the compile-time linkage point for the whole backend set.
