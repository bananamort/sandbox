# util/BrickColor.h

## Purpose
The classic Roblox palette type: a named, numbered brick color (`BrickColor::Number`) with conversion to/from G3D float/byte colors and palette lookup. "A collection of official ROBLOX colors."

## Declared API
```cpp
class BrickColor {
public:
    enum Number { brick_1 = 1, ..., brick_365 = 365, roblox_1001 = 1001, ..., roblox_1032 = 1032 };
    // (sparse numbering: e.g. no 4,7,8,10,...; 326 commented out)

    Number number;                                        // public data member
    typedef std::vector<BrickColor> Colors;
    static const Colors& colorPalette();      // shown in UI
    static const Colors& renderingPalette();  // supported by renderer
    static const Colors& allColors();         // all known

    size_t getClosestRenderingPaletteIndex() const; // closest GFX-supported index
    size_t getClosestPaletteIndex() const;
    static const size_t paletteSize = 128;          // supported by UI + data model
    static const size_t paletteSizeMSB = 7;         // log2(paletteSize)
    static void setRenderingSupportedPaletteSize(size_t maxSupportedColors);

    BrickColor(Number number);   // e.g. BrickColor(brick_194)
    BrickColor();                // defaults to brick_194 (medium stone grey)
    explicit BrickColor(int number);
    static BrickColor closest(G3D::Color3uint8);  // nearest match overloads
    static BrickColor closest(G3D::Color4uint8);
    static BrickColor closest(G3D::Color3);
    static BrickColor closest(G3D::Color4);
    static BrickColor parse(const char* name);
    static BrickColor random();

    static BrickColor brickWhite();     // brick_1
    static BrickColor brickGray();      // brick_194
    static BrickColor brickDarkGray();  // brick_199
    static BrickColor brickBlack();     // brick_26
    static BrickColor brickRed();       // brick_21
    static BrickColor brickYellow();    // brick_24
    static BrickColor brickGreen();     // brick_28
    static BrickColor baseplateGreen(); // brick_37
    static BrickColor brickBlue();      // brick_23
    static BrickColor defaultColor();   // brick_194

    BrickColor& operator=(const BrickColor& other);

    G3D::Color4uint8 color4uint8() const;
    G3D::Color3uint8 color3uint8() const;
    G3D::Color4 color4() const;
    G3D::Color3 color3() const;
    const std::string& name() const;
    int asInt() const;                  // the Number as int, NOT ARGB

    bool operator==(const BrickColor&) const;  // number equality
    bool operator!=, >, < /* likewise */;
};

std::size_t hash_value(const BrickColor& c);   // boost hash support
```

## Gotchas
- `number` is public and unvalidated — `BrickColor((int)9999)` constructs an out-of-palette value; validity checks are implementation-side.
- `asInt()` returns the palette Number, not an RGB/ARGB value.
- Default is `brick_194` ("Medium stone grey") — the historical default part color.
- `explicit BrickColor(int)` bypasses enum safety; `parse()` on an unknown name returns some fallback (UNKNOWN which).
- `paletteSize=128` fixed for UI/data model; rendering palette can be resized via `setRenderingSupportedPaletteSize`.
- Enum skips numbers (e.g., `brick_326` commented out) — do not iterate assuming contiguity.

## UNKNOWN
- Color table location (the actual RGB per number lives in the .cpp / BrickMap, outside App/include).
- Behavior of `parse()` and `closest()` tie-breaking.
