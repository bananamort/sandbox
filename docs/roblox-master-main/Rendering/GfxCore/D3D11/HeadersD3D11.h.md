# Rendering/GfxCore/D3D11/HeadersD3D11.h

## Purpose

Single include point for the D3D11 API headers, switching between desktop and Xbox (Durango) XDK variants.

## API

- `RBX_PLATFORM_DURANGO` → `<d3d11_x.h>`, `<D3Dcompiler_x.h>`, `<xdk.h>`.
- otherwise → `<D3D11.h>`, `<D3Dcompiler.h>`.

## Usage

Included by every D3D11 backend TU.

## Gotchas

- Durango uses the XDK-flavored d3d11_x header set; code shared between Win32 and console must stick to the intersection of both APIs.
