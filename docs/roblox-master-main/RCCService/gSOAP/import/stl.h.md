# stl.h

Source: `roblox-sandbox/RCCService/gSOAP/import/stl.h` (56 lines)

## Purpose

gSOAP *import* umbrella header that enables SOAP serialization for the four common STL sequence containers. Importing it pulls in the per-container stubs so soapcpp2 knows how to map templated STL types onto repeating XML elements. It is vendored gSOAP toolchain material; RCCService's WSDL-generated code uses vectors for repeated elements (see `soapStub.h`), and this header is how that support is declared to the compiler frontend.

## API

No functions or structs of its own — it is a pure aggregator (lines 53–56):

```
#import "stldeque.h"
#import "stllist.h"
#import "stlvector.h"
#import "stlset.h"
```

Each child stub contributes one template declaration, e.g. `template <class T> class std::vector;` plus the matching `#include <vector>`, which is all soapcpp2 needs to generate serializers for `std::vector<T>` members.

## Usage

```
#import "stl.h"         // in a gSOAP .h spec file before struct definitions
soapcpp2 -Iimport ...   // -I must point at this import directory
```

## Gotchas

- 52 of 56 lines are license text; the functional content is only the 4 `#import` lines.
- Importing `stl.h` is equivalent to importing all four container stubs individually; there is no map/unordered_map support in this vintage of the import set.
- The GPL block carries the standard OpenSSL linking exemption typical of Genivia distributions of that era.

UNKNOWN: nothing beyond the above; the file is a fixed aggregation list.

