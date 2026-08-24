# util/Vector6.h

## Purpose
Minimal fixed-size 6-element array template (global namespace, not in RBX): no math ops, just fill-ctor and indexing. Presumably used for 6-DOF data (e.g., spatial vectors / joint DOF storage).

## Declared API
```cpp
template<class T>
class Vector6 {
public:
    Vector6();                       // NO initialization of elements
    explicit-ish Vector6(const T& setAll);   // fills all 6 (implicit from T)
    const T& operator[](int i) const;    // no bounds check
    T&       operator[](int i);
private:
    T data[6];
};
```

## Gotchas
- Default ctor leaves all 6 elements uninitialized — always use `Vector6<T>(value)` or assign immediately.
- Copy ctor/assignment are the implicit bit-copies (commented-out declarations confirm intent).
- No bounds checking on `operator[]`.
- Implicit conversion from a single `T` — `Vector6<float> v = 0.0f;` compiles.
- Lives in the GLOBAL namespace (no `namespace RBX`).

## UNKNOWN
- Consumers (physics 6-vector code outside this slice).
