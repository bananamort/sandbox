# wsrp.h

Source: `roblox-sandbox/RCCService/gSOAP/import/wsrp.h` (228 lines)

## Purpose

gSOAP import stub for **WS-Routing** (`http://schemas.xmlsoap.org/rp/`) — the SOAP message-routing header vocabulary (path/via/fwd/rev) that predates WS-Addressing. Generated from `WS-Routing.xsd` via `wsdl2h -cgy` and adjusted to import rather than copy the namespace. Vendored toolchain material; not used by RCCService's WSDL.

## API

- Directives (38–39): prefix `wsrp`, schema form unqualified.
- Element typedefs (71–107): `_wsrp__action`, `_wsrp__to`, `_wsrp__from`, `_wsrp__id`, `_wsrp__relatesTo`, `_wsrp__faultcode`, `_wsrp__faultreason` — all `typedef char` (note: **char, not char\***, a typemap artifact; the struct members below use plain `char*`).
- Structs:
  - `wsrp__path_USCOREt` (110–133): required `char* wsrp__action`; optional `wsrp__to`, `wsrp__fwd*`, `wsrp__rev*`, `wsrp__from`, `wsrp__id`, `wsrp__relatesTo`, `wsrp__fault*`; wildcard attribute catch-all.
  - `wsrp__fwd_USCOREt` / `wsrp__rev_USCOREt` (139–167): dynamic arrays of `wsrp__via_USCOREt*` (`int __sizevia; struct wsrp__via_USCOREt* *wsrp__via 0;`).
  - `wsrp__found_USCOREt` (173–184): array of URIs `char* *at 1;`.
  - `wsrp__fault_USCOREt` (190–211): required `wsrp__faultcode` + `wsrp__faultreason`; optional `endpoint`, `found*`, `int* maxsize/maxtime/retryAfter`.
  - `wsrp__via_USCOREt` (217–223): simpleContent `char* __item` + optional attribute `@vid`.
- Element wrappers: `_wsrp__path`, `_wsrp__fwd`, `_wsrp__rev`, `_wsrp__found`, `_wsrp__fault`, `_wsrp__via`.

## Usage

```
#import "wsrp.h"
soapcpp2 -Iimport ...
```

## Gotchas

- `_USCORE` in type names is gSOAP's encoding of underscore (`path_t` → `path_USCOREt`).
- The singleton-element typedefs (`typedef char _wsrp__to;`) are unusable as-is — they exist only so soapcpp2 registers the element names.
- Obsolete spec (WS-Routing was never finalized); present for legacy peer compatibility only. Not referenced anywhere in RCCService.

UNKNOWN: none beyond the above.

