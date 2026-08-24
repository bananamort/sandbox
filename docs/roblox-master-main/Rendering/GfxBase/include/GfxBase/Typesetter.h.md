# Typesetter.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/Typesetter.h` (85 lines)

## Purpose

Abstract base class for text layout engines: draws a string through an `Adorn` with alignment/clipping/rotation, measures strings, maps screen positions back to cursor positions, and manages the glyph-atlas texture resources. The ASCII-only charset helpers reveal this typesetting generation's supported range.

## API

```cpp
class RBX::Typesetter {   // inside namespace RBX::(global); uses Graphics fwd decls
public:
    virtual ~Typesetter();

    virtual Vector2 draw(Adorn* adorn, const std::string& s, const Vector2& position,
        float size, bool autoScale, const Color4& color, const Color4& outline,
        RBX::Text::XAlign xalign = XALIGN_LEFT, RBX::Text::YAlign yalign = YALIGN_TOP,
        const Vector2& availableSpace = Vector2::zero(),
        const Rect2D& clippingRect = Rect2D::xyxy(-1,-1,-1,-1),
        const Rotation2D& rotation = Rotation2D()) const = 0;

    virtual int getCursorPositionInText(const std::string& s, const Vector2& pos2D,
        float size, Text::XAlign xalign, Text::YAlign yalign,
        const Vector2& availableSpace, const Rotation2D& rotation,
        Vector2 cursorPos) const = 0;

    virtual Vector2 measure(const std::string& s, float size,
        const Vector2& availableSpace = zero(), bool* textFits = NULL) const = 0;

    virtual void loadResources(Graphics::TextureManager* textureManager,
                               Graphics::TextureAtlas* glyphAtlas) = 0;
    virtual void releaseResources() = 0;
    virtual const shared_ptr<Graphics::Texture>& getTexture() const = 0;

    static bool isCharNonWhitespace(char c); // '!'..'~'
    static bool isCharWhitespace(char c);    // ' ', '\t', '\n'
    static bool isCharSupported(char c);
    static bool isStringSupported(std::string& s);
};
```

## Usage

Includes `Util/G3DCore.h`, `Util/Rotation2D.h`, `GfxBase/Type.h`. Implementations live in GfxCore (bitmap-font typesetters); consumers (Adorn text paths) hold one and call draw/measure.

## Gotchas

- Charset support is strictly ASCII printable + space/tab/newline — anything else (UTF-8, accents) fails `isStringSupported`.
- Default `clippingRect` of `(-1,-1,-1,-1)` is the sentinel meaning "no clipping" — not a valid rect.
- `measure`'s `textFits` out-param is optional (`NULL` OK).
