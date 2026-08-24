# util/Exception.h

## Purpose
Placeholder header: includes `<stdexcept>` and declares an empty `RBX` namespace. Historically likely hosted RBX exception types; currently contributes nothing beyond pulling in std exception classes.

## Declared API
```cpp
namespace RBX { /* empty */ }
```

## Gotchas
- No RBX-specific exception types here — use `std::runtime_error` etc. (which this header transitively provides).

## UNKNOWN
- Whether legacy code expects RBX exception classes that were removed.
