# util/ProtectedGeneric.h

## Purpose
Tamper-evidence wrapper: stores a value alongside a `boost::hash` of it; `getValue` re-hashes and reports whether the stored value still matches. Integrity check, not encryption (value itself is stored in the clear).

## Declared API
```cpp
template<class Type>
class ProtectedGeneric {
public:
    explicit ProtectedGeneric(Type _value);

    const Type& peekValue() const;          // no verification!
    bool getValue(Type& _value) const;      // copies value; returns hash==rehash (integrity OK)
    void setValue(Type _value);             // stores value + recomputes hash
private:
    Type value;
    std::size_t hash;
    ProtectedGeneric(const ProtectedGeneric& other);   // declared but empty body (see Gotchas)
};
```

## Gotchas
- `peekValue()` bypasses verification entirely — use `getValue` when integrity matters.
- Hash is boost::hash of the value — not keyed, so an attacker can fix up both fields; deters casual memory pokes only.
- The private copy ctor has an **empty body**: copying produces a default-constructed-ish object with uninitialized `hash`, silently broken. Never copy one.
- No default ctor.

## UNKNOWN
- Which values are protected this way in practice (call sites outside this slice).
