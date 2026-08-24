# util/TextureId.h

## Purpose
Typed ContentId for texture assets — pure strong-typing wrapper plus a shared `nullTexture()` singleton (same call_once pattern as AnimationId::nullAnimation).

## Declared API
```cpp
class TextureId : public ContentId {
public:
    TextureId();
    TextureId(const ContentId& id);
    TextureId(const char* id);
    TextureId(const std::string& id);

    static TextureId nullTexture();   // function-local static copy; name resolved via boost call_once
};
```

## Gotchas
- No added behavior beyond typing; all semantics from ContentId.md.
- `nullTexture()` returns copies of one shared instance.

## UNKNOWN
- Nothing notable.
