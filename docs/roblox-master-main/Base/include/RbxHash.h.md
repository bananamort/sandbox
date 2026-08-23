# RbxHash.h

## Purpose
One-glance portability shim selecting a hash-map implementation per platform: MSVC `<hash_map>`/`stdext::hash_map`, GCC-family `<ext/hash_map>`/`__gnu_cxx::hash_map`.

## API
```cpp
#ifdef _WIN32
#include <hash_map>
using stdext::hash_map;
#else
#include <ext/hash_map>
using __gnu_cxx::hash_map;
#endif
```

## Usage
`RBX::hash_map<K,V>` style code writes `hash_map<...>` after including this header.

## Gotchas
- Both selected containers are long-deprecated extensions (`stdext`/`__gnu_cxx`); new code should prefer `std::unordered_map`. Any Luau-graft or instrumentation work touching these call sites must not assume C++11 interface parity (e.g. `insert` return types differ).
