# TextureProxyBase.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/TextureProxyBase.h` (28 lines)

## Purpose

Minimal abstract base for texture proxies — objects standing in for an uploaded texture whose original dimensions matter to layout code (decals, textures composited onto parts). Defines just one pure virtual plus strip constants used when slicing textures horizontally.

## API

```cpp
namespace RBX {
typedef boost::shared_ptr<class TextureProxyBase> TextureProxyBaseRef;

class TextureProxyBase : public boost::enable_shared_from_this<TextureProxyBase> {
public:
    TextureProxyBase();
    virtual ~TextureProxyBase();
    virtual G3D::Vector2 getOriginalSize() = 0;
    static const unsigned int numStrips = 32;
    static float stripWidth();   // returns 1.0f / numStrips == 0.03125f
};
}
```

## Usage

Subclassed by the concrete texture proxies living elsewhere (ContentSystem / GfxCore side own actual GPU handles); consumers hold `TextureProxyBaseRef` shared_ptrs. `enable_shared_from_this` means implementations are always managed via `shared_ptr` from creation onward.

## Gotchas

- Header-only; there is no TextureProxyBase.cpp anywhere in GfxBase.
- `numStrips = 32` / `stripWidth()` imply a fixed 32-strip horizontal slicing scheme — changing either affects every consumer simultaneously.
- Includes `v8datamodel`-independent headers only (g3d Vector2, boost) — safe to include from low-level code.
