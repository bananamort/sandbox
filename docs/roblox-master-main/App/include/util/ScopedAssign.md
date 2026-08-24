# util/ScopedAssign.h

## Purpose
RAII save/restore for any assignable value: constructor captures the old value and writes a new one; destructor restores. Header self-deprecates: "TODO: This probably exists in some other library somewhere..."

## Declared API
```cpp
template <typename V>
class ScopedAssign {
public:
    ScopedAssign();                                  // inert (value = NULL)
    ScopedAssign(V& value, const V& newValue);       // save + assign
    ~ScopedAssign();                                 // restore if active

    void assign(V& value, const V& newValue);        // (re)arm on another variable
private:
    V* value;
    V oldValue;
};
```

## Gotchas
- Requires V to be copy-constructible and copy-assignable; stores the old value by copy.
- The default ctor creates an inert guard — destructor is then a no-op.
- `assign()` re-targets without restoring the previous target first (the old variable keeps the modified value).
- Dangling pointer risk if the guarded variable dies before the ScopedAssign.

## UNKNOWN
- Nothing notable.
