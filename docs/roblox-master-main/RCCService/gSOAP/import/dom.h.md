# dom.h

Source: `roblox-sandbox/RCCService/gSOAP/import/dom.h` (640 lines)

## Purpose

gSOAP **level-2 DOM parser** interface. Importing it makes the special types `xsd__anyType` (DOM element node sets) and `xsd__anyAttribute` (DOM attribute node sets) available to gSOAP specs so arbitrary/mixed XML content can be captured inside otherwise strongly-typed messages. Per its own docs, the DOM parser is also "an essential component of the wsse plugin to verify digital signatures." Vendored toolchain material; not referenced by RCCService's WSDL.

## API

Only two declarations are code (lines 635–639):

```cpp
extern typedef struct soap_dom_element   xsd__anyType;
extern typedef struct soap_dom_attribute xsd__anyAttribute;
```

The struct definitions themselves live in **stdsoap2.h**; the operations live in **dom.cpp / dom.c** (`#import "dom.h"` alone is not linkable — see import/README.txt line 6). Lines 51–633 are a Doxygen manual covering:

- Context flags that govern DOM behavior: `SOAP_C_UTFSTRING` (UTF-8 `data` field), `SOAP_C_MBSTRING`, `SOAP_DOM_TREE` (no deserialization), `SOAP_DOM_NODE` (deserialize matched C/C++ objects into nodes), `SOAP_DOM_ASIS` (render xmlns exactly as stored), plus `SOAP_XML_INDENT` / `SOAP_XML_CANONICAL` for output.
- `soap_dom_element` fields: `next`, `prnt`, `elts`, `atts`, `nstr`, `name`, `data`/`wide`, `type` (a `SOAP_TYPE_X` constant), `node`, `head`/`tail`, `soap`; methods `set(nstr,name)` / `set(data)` / `set(node,type)`, `add(element|attribute)`, `begin()`/`end()`, `find(nstr,name)` and `find(type)` search iterators (with `*` namespace wildcard support), `unlink()`.
- `soap_dom_attribute` fields/methods: `next`, `nstr`, `name`, `data`, `soap`; `set`, `begin/end`, `find`, `unlink`.
- C traversal helpers `soap_dom_next_element` / `soap_dom_next_attribute`; iostream `>>`/`<<` overloads; parse/emit via `soap_in_xsd__anyType` / `soap_out_xsd__anyType`.
- Placement rule: declare `xsd__anyType` members **last** in a struct (and `xsd__anyAttribute` after other attributes) because the DOM consumes everything not matched earlier.

## Usage

```
#import "dom.h"          // + link dom.cpp (not present in this repo)
// or generate with: wsdl2h -d ...
```

## Gotchas

- The implementation files (`dom.cpp`/`dom.c`) are NOT vendored in this tree — importing dom.h into a spec would generate serializer references that fail at link time.
- Field order matters (see placement rule above); putting an anyType member first silently swallows elements meant for other fields.
- Not referenced anywhere in RCCService.

UNKNOWN: none beyond the above.

