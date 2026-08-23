# Rendering/GfxCore/include/GfxCore/States.h

## Purpose

Header-only value types for the render-state trinity plus samplers: `RasterizerState`, `BlendState`, `DepthState`, `SamplerState`. Each is immutable-after-construct, equality-comparable, and exposes `getHashId()` (boost::hash_combine of fields) so backends can intern them in hash maps of native state objects. `StateHasher<T>` adapts them for `unordered_map`/`unordered_set`.

## API

- `template<typename T> struct StateHasher { std::size_t operator()(const T& s) const { return s.getHashId(); } }`.
- `class RasterizerState`
  - `enum CullMode { Cull_None, Cull_Back, Cull_Front }`.
  - `RasterizerState(CullMode cullMode, int depthBias = 0)`; getters `getCullMode()/getDepthBias()`; `==/!=/getHashId()`.
- `class BlendState`
  - `enum Mode { Mode_None, Mode_Additive, Mode_Multiplicative, Mode_AlphaBlend, Mode_PremultipliedAlphaBlend }`.
  - `enum Factor { Factor_One, Factor_Zero, Factor_DstColor, Factor_SrcAlpha, Factor_InvSrcAlpha, Factor_DstAlpha, Factor_InvDstAlpha }`.
  - `enum ColorMask { Color_None=0, Color_R|G|B|A bits, Color_All }`.
  - Mode ctor uses a static table: None→(One,Zero), Additive→(One,One), Multiplicative→(DstColor,Zero), AlphaBlend→(SrcAlpha,InvSrcAlpha), Premultiplied→(One,InvSrcAlpha) — applied identically to color and alpha.
  - Explicit ctors: `(colorSrc, colorDst, alphaSrc, alphaDst, colorMask)` and `(src, dst, colorMask)`.
  - Predicates: `blendingNeeded()`, `separateAlphaBlend()`; getters for all factors + mask; `==/!=/getHashId()`.
- `class DepthState`
  - `enum Function { Function_Always, Function_Less, Function_LessEqual }`; `enum StencilMode { Stencil_None, Stencil_IsNotZero, Stencil_UpdateZFail }`.
  - `DepthState(Function function, bool write, StencilMode stencilMode = Stencil_None)`; getters; `==/!=/getHashId()`.
- `class SamplerState`
  - `enum Filter { Filter_Point, Filter_Linear, Filter_Anisotropic }`; `enum Address { Address_Wrap, Address_Clamp }`.
  - `SamplerState(Filter filter, Address address = Address_Wrap, unsigned int anisotropy = 0)`; getters; `==/!=/getHashId()`.

## Usage

Callers construct these as temporaries per draw and hand them to `DeviceContext::setRasterizerState/setBlendState/setDepthState/bindTexture(stage, tex, samplerState)`. Backends translate to D3D render states / D3D11 pipeline state objects keyed by hash / GL glEnable+glBlendFunc combos.

## Gotchas

- Only three depth functions exist — no Greater/GreaterEqual; callers invert comparisons by convention.
- Stencil is deliberately minimal (`Stencil_IsNotZero` test + `Stencil_UpdateZFail`) — enough for portal/shadow volume tricks, not general stencil ops; no separate front/back or op control.
- BlendState's mode ctor forces alpha factors equal to color factors; separate-alpha setups must use the explicit 4-factor ctor (and then `separateAlphaBlend()` reports true so D3D9 can enable separate alpha blend op states).
- No filter-mip separation (no "linear mip, point mag") — GL backend must approximate; UNKNOWN how it rounds (check TextureGL.cpp usage).
