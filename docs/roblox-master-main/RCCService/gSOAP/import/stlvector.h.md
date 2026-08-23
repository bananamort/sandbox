# stlvector.h

Source: `roblox-sandbox/RCCService/gSOAP/import/stlvector.h` (53 lines)

## Purpose

gSOAP *import* stub that teaches soapcpp2 how to serialize `std::vector<T>` as a repeating XML element. This is the concrete container support that the RCCService WSDL relies on for any `maxOccurs="unbounded"` element — e.g. arrays of job IDs or status strings in responses. The generated bindings in `gSOAP/generated/soapH.h` / `soapC.cpp` contain the actual `(de)serialization` templates instantiated from declarations enabled by this stub.

## API

After 50 lines of gSOAP dual-license text, exactly two functional lines:

```cpp
#include <vector>
template <class T> class std::vector;
```

- The forward template declaration is what soapcpp2 pattern-matches; it is not valid standalone C++ usage and must only be seen by the soapcpp2 compiler.
- No explicit serializers live here — soapcpp2 generates `soap_out_std__vector` / `soap_in_std__vector` style routines into the generated files when a service signature uses the container.

## Usage

```
#import "stlvector.h"          // or umbrella "stl.h"
// then, in the spec file:
struct ns__response { std::vector<std::string> ids; };
```

## Gotchas

- Only single-template-argument `std::vector<T>` is supported; allocators default silently.
- Element name for each item defaults to the schema element of `T`; nesting vectors produces nested repeats.
- This vintage (2005-era license header) predates move semantics — generated copy code copies by value.

UNKNOWN: which concrete vector instantiations RCCService's WSDL actually generates (determinable from `generated/soapStub.h`; documented there).

