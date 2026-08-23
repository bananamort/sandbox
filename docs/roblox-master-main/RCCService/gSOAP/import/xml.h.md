# xml.h

Source: `roblox-sandbox/RCCService/gSOAP/import/xml.h` (68 lines)

## Purpose

gSOAP *import* stub that defines the **literal XML string** type `XML` — a `char*` whose payload is raw XML content that gSOAP emits verbatim (and parses as mixed content) instead of escaping. Vendored toolchain material; not referenced by RCCService's WSDL-generated bindings.

## API

One typedef after the documentation/license block (line 68):

```cpp
typedef char *XML;
```

Documented semantics from the header comment:

- A literal XML string contains XML content; the serializer writes it unescaped into the message.
- The string holds **UTF-8** content when the **`SOAP_C_UTFSTRING`** flag is set on the context.
- Field name `__any` in a struct is special: it is not a tag and allows parsing of mixed content (example struct `ns__Mixed`, lines 19–22).
- Header note: "the built-in `_XML` type provides the same functionality" — so this import is a compatibility convenience.

## Usage

```
#import "xml.h"
struct ns__MyData
{ int num;
  XML str; // has XML content
};
```

## Gotchas

- Because content is emitted verbatim, malformed XML assigned to an `XML` field produces invalid messages — no validation at serialization time.
- Ownership follows normal gSOAP string rules (context-owned unless overridden).
- `XML` vs `_XML`: both exist; mixing them across generated headers can cause duplicate-type confusion if specs import inconsistently.

UNKNOWN: none beyond the above; single-typedef file.

