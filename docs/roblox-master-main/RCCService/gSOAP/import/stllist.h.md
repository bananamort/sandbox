# stllist.h

Source: `roblox-sandbox/RCCService/gSOAP/import/stllist.h` (53 lines)

## Purpose

gSOAP *import* stub enabling soapcpp2 to serialize `std::list<T>` as a repeating XML element. Part of the vendored gSOAP import library; functionally parallel to `stlvector.h` but for doubly-linked lists. Not directly referenced by RCCService's WSDL-generated bindings (which use vectors), but shipped as part of the standard import set.

## API

After the 50-line gSOAP dual-license block, exactly two functional lines:

```cpp
#include <list>
template <class T> class std::list;
```

- The template forward declaration exists solely for soapcpp2's type matcher.
- Any serializer code appears in generated output (`soap_out_std__list` / `soap_in_std__list` families) only if some signature actually uses `std::list`.

## Usage

```
#import "stllist.h"     // or umbrella "stl.h"
struct ns__item { std::list<int> values; };   // example spec usage
```

## Gotchas

- Same single-template-argument limitation as the other STL stubs (no custom allocator support).
- List order maps to document order of the repeated elements — there is no ordering metadata.

UNKNOWN: no RCCService-specific use of std::list was found in the generated bindings; treat this stub as unused-but-vendored unless soapStub.h says otherwise.

