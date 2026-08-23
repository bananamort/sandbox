# stldeque.h

Source: `roblox-sandbox/RCCService/gSOAP/import/stldeque.h` (53 lines)

## Purpose

gSOAP *import* stub enabling soapcpp2 to serialize `std::deque<T>` as a repeating XML element. Vendored gSOAP toolchain material, part of the STL import family (`stl.h` aggregates it with vector/list/set). Not referenced by RCCService's WSDL-generated bindings; present because the import directory ships the full standard set.

## API

After the 50-line gSOAP dual-license block, exactly two functional lines:

```cpp
#include <deque>
template <class T> class std::deque;
```

- The declaration is consumed by soapcpp2 only; generated serializer families (`soap_out_std__deque`, `soap_in_std__deque`) appear in generated sources solely when a service signature uses the container.

## Usage

```
#import "stldeque.h"    // or umbrella "stl.h"
struct ns__queue { std::deque<std::string> pending; };   // example spec usage
```

## Gotchas

- Identical constraints to the other STL stubs: single template argument, default allocator only.
- No RCCService code or generated binding references deque types — dead weight for this project but harmless.

UNKNOWN: none beyond the above; the file contains no logic.

