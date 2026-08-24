# util/Region3Int16.h

## Purpose
Integer (Vector3int16) axis-aligned 3D region: min/max corner pair with containment test. This is the type behind the Lua `Region3int16` datatype used for terrain APIs.

## Declared API
```cpp
class Region3int16 {
public:
    Region3int16();                                        // uninitialized members!
    Region3int16(const Vector3int16& min, const Vector3int16& max);

    const Vector3int16& getMinPos() const;
    const Vector3int16& getMaxPos() const;

    bool operator==(const Region3int16&) const;
    bool operator!=(const Region3int16&) const;

    bool contains(const Vector3int16& p) const;   // inclusive; unsigned-trick compare
    bool empty() const;                           // any min > max componentwise
private:
    Vector3int16 minPos, maxPos;
};
```

## Gotchas
- Default ctor leaves minPos/maxPos **uninitialized** — always construct with explicit corners.
- `contains` uses the classic `(unsigned)(p-min) <= (unsigned)(max-min)` trick: valid here because after subtraction the intermediate fits in the wider int range before the cast; relies on two's-complement wrap.
- Vector3int16 components are 16-bit: ±32767 coordinate limits.

## UNKNOWN
- Nothing significant beyond .cpp-free inline definitions visible here.
