# util/UDim.h

## Purpose
GUI sizing types: `UDim` = relative scale + absolute pixel offset ("Universal Dimensions"), `UDim2` = per-axis (X,Y) pair. These back the Lua UDim/UDim2 datatypes used by every GUI element.

## Declared API
```cpp
class UDim {
public:
    float      scale;    // public
    G3D::int16 offset;   // public — NOTE: 16-bit!

    UDim(float scale, G3D::int16 offset);
    UDim();              // 0, 0

    float     transform(const float value) const;    // scale*value + offset
    G3D::int16 transform(G3D::int16 value) const;

    UDim& operator=(const UDim&);
    bool operator==(const UDim&) const;
    bool operator!=(const UDim&) const;
    UDim operator*(const G3D::int16 rhs) const;
    UDim operator*(const float rhs) const;
    UDim operator+(const UDim& v) const;
    UDim operator-(const UDim& v) const;
    UDim operator-() const;
};

class UDim2 {
public:
    UDim x, y;           // public

    UDim2();
    UDim2(UDim x, UDim y);
    UDim2(float scaleX, int offsetX, float scaleY, int offsetY);

    UDim2& operator=(const UDim2&);
    bool operator==(const UDim2&) const;
    bool operator!=(const UDim2&) const;

    G3D::Vector2int16 operator*(const G3D::Vector2int16 rhs) const;
    G3D::Vector2     operator*(const G3D::Vector2 rhs) const;
    UDim2 operator*(float v) const;
    UDim2 operator+(const UDim2&) const;
    UDim2 operator-(const UDim2&) const;
    UDim2 operator-() const;

    const UDim& operator[](int i) const;   // 0/default->x, 1->y
    UDim&       operator[](int i);
};
```

## Gotchas
- `offset` is a **16-bit int** (`G3D::int16`, ±32k pixels): larger offsets silently truncate at the ctor boundary (`UDim(float, G3D::int16)`), while the UDim2 convenience ctor takes plain `int` and narrows implicitly.
- `transform(int16)` returns int16 — intermediate float result truncates.
- No multiplication of two UDims (scale×scale semantics undefined by design).
- `operator[]` accepts anything ≤0 as x (default branch).

## UNKNOWN
- Rounding mode in transform (.cpp-side).
