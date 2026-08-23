# Rendering/GfxCore/D3D11/FramebufferD3D11.cpp

## Purpose

Implementation of `FramebufferD3D11` and `RenderbufferD3D11` — the D3D11 render-target layer. Creates RTV/DSV views over texture resources (including per-cube-face and per-mip slices), standalone render textures (MSAA-capable), validates framebuffer attachment consistency, and implements synchronous color readback.

## API

- `static ID3D11View* createRenderTargetView(ID3D11Device*, Texture::Format, Texture::Type, ID3D11Resource* texture, unsigned cubeIndex, unsigned mipIndex, unsigned samples)` — depth formats → DSV (`TEXTURE2DMS` when samples>1, else `TEXTURE2D` with MipSlice; Format left DXGI_FORMAT_UNKNOWN to inherit); color → RTV with `TEXTURE2D`, or `TEXTURE2DARRAY` slice `cubeIndex` for cube faces. Throws on RTV failure; RBXASSERT on DSV failure.
- `ID3D11Texture2D* createRenderTexture(ID3D11Device*, unsigned width, unsigned height, unsigned int samples, Texture::Format)` — 1-mip DEFAULT texture bound as DEPTH_STENCIL or RENDER_TARGET with given SampleDesc.Count; throws on failure.
- `RenderbufferD3D11(Device*, const shared_ptr<TextureD3D11>& owner, unsigned cubeIndex, unsigned mipIndex)` — texture-backed view; stores owner shared_ptr; aliases `texture = owner->getObject()` **without AddRef** (comment documents this).
- `RenderbufferD3D11(Device*, Format, width, height, samples, ID3D11Texture2D* texture)` — takes ownership of an existing swapchain/backbuffer-style texture and creates its view.
- `RenderbufferD3D11(Device*, Format, width, height, samples)` — creates its own render texture + view.
- `~RenderbufferD3D11()` — releases view; releases texture only when not owner-aliased.
- `FramebufferD3D11(Device*, const std::vector<shared_ptr<Renderbuffer>>& color, const shared_ptr<Renderbuffer>& depth)` — asserts non-empty color, ≤ caps.maxDrawBuffers, all attachments same w/h/samples, color formats non-depth, depth format depth; derives width/height/samples from color[0].
- `void download(void* data, unsigned int size)` — asserts size == w*h*4 and color0 is RGBA8; staging R8G8B8A8_UNORM texture ← `CopyResource` ← color0's resource; Map READ + row-by-row memcpy honoring RowPitch; releases the view's resource reference obtained via `GetResource`.
- `~FramebufferD3D11()` — empty (attachments are shared_ptr).

## Usage

Constructed via abstract `Device::createFramebuffer(...)` / `createRenderbuffer(...)` paths in Device.cpp. `DeviceContextD3D11::bindFramebuffer/clear/copy/resolve` consume `getColor()/getDepth()/getObject()/getResource()`. Texture-as-render-target flows come through `TextureD3D11::getRenderbuffer(index, mip)` which uses the owner-based constructor.

## Gotchas

- View formats are deliberately DXGI_FORMAT_UNKNOWN for texture-backed views (inherit resource format) but explicitly set for the external-texture constructor — mismatched explicit formats there will fail creation.
- MSAA views assert mipIndex == 0 and cubes assert samples == 1.
- The owner-aliasing constructor intentionally does not AddRef the underlying texture: lifetime is guaranteed by holding `owner` shared_ptr instead.
- `download` hardcodes RGBA8/32bpp expectations (assert only) and is a full GPU sync point; it also manually Releases the resource ref returned by `GetResource`.
- Framebuffer geometry comes solely from color[0]; mismatched attachments are debug-asserts only (release builds proceed).
