# util/Color.h

## Purpose
Fixed 16-color optimal palette (from the MIT media-lab palette page cited in the header comment) plus color-derivation helpers: from palette index, packed int, string, pointer hash, temperature ramp, and "error importance" ramp.

## Declared API
```cpp
class Color {
public:
    static const G3D::Color3& getColorByIndex(int i);   // 0..15, palette order below
    // Named accessors (all inline, delegate to getColorByIndex):
    static const G3D::Color3& black();      // idx 0
    static const G3D::Color3& darkGray();   // idx 1
    static const G3D::Color3& red();        // idx 2
    static const G3D::Color3& blue();       // idx 3
    static const G3D::Color3& green();      // idx 4
    static const G3D::Color3& brown();      // idx 5
    static const G3D::Color3& purple();     // idx 6
    static const G3D::Color3& lightGray();  // idx 7
    static const G3D::Color3& lightGreen(); // idx 8
    static const G3D::Color3& lightBlue();  // idx 9
    static const G3D::Color3& cyan();       // idx 10
    static const G3D::Color3& orange();     // idx 11
    static const G3D::Color3& yellow();     // idx 12
    static const G3D::Color3& tan();        // idx 13
    static const G3D::Color3& pink();       // idx 14
    static const G3D::Color3& white();      // idx 15

    static const G3D::Color3& colorFromIndex8(int index);
    static const G3D::Color3 colorFromInt(unsigned int i);
    static const G3D::Color3 colorFromString(const std::string& s);
    static const G3D::Color3 colorFromPointer(void* pointer);
    static const G3D::Color3 colorFromTemperature(float temperature); // 0=cold .. 1=hot
    static const G3D::Color3 colorFromError(double value);            // 0=unimportant..10=very important
private:
    G3D::Color3 rgb;
    Color();                                        // unconstructible
    Color(unsigned char r, unsigned char g, unsigned char b);
    const G3D::Color3& color3();
};
```

Palette RGB values are listed in the header comment (Black 0,0,0 … White 255,255,255).

## Gotchas
- Class is non-instantiable; use the statics.
- `getColorByIndex`/`colorFromIndex8` return **references** to static storage — safe to hold but never invalidates.
- `colorFromPointer` hashes a pointer to pick a stable-ish debug color (typical for visualizing object identity).
- Out-of-range indices: behavior unspecified in header (UNKNOWN clamping/assert).
- `colorFromString` semantics undocumented here (UNKNOWN accepted format — likely hash-based, not parsing hex).

## UNKNOWN
- Exact implementations/ramps for `colorFromTemperature`, `colorFromError`, `colorFromString` (.cpp outside App/include).
