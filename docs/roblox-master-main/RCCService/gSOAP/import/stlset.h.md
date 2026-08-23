# stlset.h

Source: `roblox-sandbox/RCCService/gSOAP/import/stlset.h` (53 lines)

## Purpose

gSOAP *import* stub enabling soapcpp2 to serialize `std::set<T>` as a repeated XML element. Vendored gSOAP toolchain material, aggregated by `stl.h` alongside vector/list/deque. Not referenced by RCCService's WSDL-generated bindings; shipped as part of the standard import set.

## API

After the 50-line gSOAP dual-license block, exactly two functional lines:

```cpp
#include <set>
template <class T> class std::set;
```

- Consumed by soapcpp2 only; generated serializer routines appear in the generated sources solely when a signature uses `std::set`.

## Usage

```
#import "stlset.h"      // or umbrella "stl.h"
struct ns__tags { std::set<std::string> names; };   // example spec usage
```

## Gotchas

- Single template argument, default comparator/allocator — this vintage of the import set has no customization hooks.
- Because sets are ordered, serialization order follows the set's own ordering, not insertion order.

UNKNOWN: none beyond the above; no logic in the file.

