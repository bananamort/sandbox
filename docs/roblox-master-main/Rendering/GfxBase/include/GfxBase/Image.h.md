# GfxBase/include/GfxBase/Image.h

## Purpose

Declares `RBX::Image`, a minimal abstract interface to decoded image bytes: byte size plus the *original* (pre-resize) dimensions. It is the decoupling seam between texture content providers and the renderer's texture streaming/creation code.

## API

```cpp
namespace RBX {
class Image {
public:
    virtual ~Image() {}
    virtual size_t getSize() const = 0;
    virtual int getOriginalWidth() const = 0;
    virtual int getOriginalHeight() const = 0;
};
}
```

Header-only pure interface; no data members, no pixel accessor — implementers expose their own buffers.

## Lua globals and events

None.

## Usage (who loads it)

- `App/include/v8datamodel/TextureContentProvider.h:8` includes it; the content-provider hierarchy hands `Image` objects to texture creation. (The concrete implementation lives in App-side image decoding code, not in GfxBase.)
- Listed in this module's CMakeLists HEADERS; not referenced by any other Rendering TU directly.

## Gotchas

- The interface reports **original** dimensions only — there is no "current/resized size" getter, so consumers cannot discover post-processing rescales through this type.
- No way to reach pixels through the interface itself: anything that must read bytes must downcast to the concrete class, which couples callers to App-layer headers despite this deliberately thin abstraction.
