# App/include/gui/GuiDraw.h

## Purpose

Declares `RBX::GuiDrawImage`, the low-level immediate-mode image renderer used by unified widgets: resolves a `TextureId`/name into up to seven state-specific texture proxies (normal, hover, down, disable, selected, selected-hover, selected-down), tracks a mutable drawn size, reacts to device resource-unbind signals to recreate proxies, and draws with clipping or rotation.

## Declared API

- `enum ImageState` bit flags — `NORMAL=0x1, HOVER=0x2, DOWN=0x4, DISABLE=0x8, SELECTED=0x10, SELECTED_HOVER=0x20, SELECTED_DOWN=0x40, ALL=0x7F`.
- `class GuiDrawImage`
  - Ctors: default (size 0) and `(Adorn*, textureName, imageState)` which calls `setImageFromName`.
  - Render overloads: `render2d(adorn, enabled, rect, WidgetState, isSelected)`; plus texul/texbr UV variants taking either `Rotation2D` or clip `Rect` + color.
  - `setImageSize(Vector2)` / `Vector2 getImageSize() const`.
  - `bool setImage(Adorn*, const TextureId&, unsigned imageStates, Vector2* outSize = NULL, Instance* contextInstance = NULL, const char* context = "")`; `bool setImageFromName(...same but name...)` — return whether the texture is ready (async load may still be waiting).
  - `static`-style helper `computeUV(uvtl, uvbr, imageRectOffset, imageRectSize, imageSize)` — computes atlas sub-UVs.
  - Private: per-state `TextureProxyBaseRef`s, `currentTexture/loadingTexture` ids, `OnUnbindResourceSignalHint()` on a scoped connection, private `draw(...)` ×2 and template `render2dImpl<Modifier>`, `tryCreateTextureProxy(adorn, contentString, context, ref, isWaiting&)`.

## Usage notes

- Widgets own a `GuiDrawImage` and call one `render2d` overload per frame from their `render2dMe`; pass the union of wanted states so proxies are created lazily per state.

## Gotchas

- Texture creation is asynchronous: `setImage*` may return false while loading; callers must keep calling render2d until ready.
- `size` is mutable and updated during draw (`getImageSize` is const).
- Device-loss handled via `unbindResourceSignalHint` — proxies are recreated on next use.
