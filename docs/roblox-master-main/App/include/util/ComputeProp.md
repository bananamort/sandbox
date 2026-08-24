# util/ComputeProp.h

## Purpose
"A property that computes and caches its value": lazily evaluates a member-function getter on an owning object once, then returns the cached result until marked dirty. Memoization mixin for derived/computed properties.

## Declared API
```cpp
template <class Type, class O>
class ComputeProp {
public:
    ComputeProp(O* object, Type (O::*getFunc)());  // starts dirty

    Type getValue();                    // computes if dirty, caches, returns
    Type getLastComputedValue() const;  // asserts !dirty
    operator Type();                    // = getValue()
    Type* getValuePointer();            // refreshes then returns &val
    Type& getValueRef();                // refreshes then returns val&
    bool setDirty();                    // marks dirty; returns true if state changed
    bool getDirty() const;
private:
    Type val;
    bool dirty;
    O* object;
    typedef Type (O::*GetFunc)();
    GetFunc getFunc;
};
```

## Gotchas
- `getValue()` is non-const and mutates the cache — a const context will not compile; `getLastComputedValue` is const but asserts the value was already computed.
- Raw `O* object` pointer: the owner must outlive the ComputeProp or you get dangling-member calls.
- `getValuePointer()`/`getValueRef()` expose the cache — external mutation of that memory does NOT re-dirty the property; stale reads possible.
- Getter signature is fixed at `Type (O::*)()` — no const getters, no parameters.
- Not thread-safe.

## UNKNOWN
- Widespread usage expected across datamodel classes; specific call sites outside this slice.
