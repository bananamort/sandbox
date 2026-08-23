# xop.h

Source: `roblox-sandbox/RCCService/gSOAP/import/xop.h` (62 lines)

## Purpose

gSOAP *import* stub enabling **MTOM (Message Transmission Optimization Mechanism)** attachments by declaring the XML-binary Optimized Packaging (XOP) `Include` element, namespace `http://www.w3.org/2004/08/xop/include`. Vendored toolchain material; not referenced by RCCService's WSDL (job payloads are plain strings), but part of the standard import set.

## API

Directive (line 52) plus one struct (lines 54–60):

```
//gsoap xop schema import: http://www.w3.org/2004/08/xop/include
```

```cpp
struct _xop__Include
{ unsigned char *__ptr;
  int __size;
  char *id;
  char *type;
  char *options;
};
typedef struct _xop__Include _xop__Include;
```

- `__ptr` / `__size`: gSOAP's transparent binary buffer convention — the referenced attachment bytes.
- `id`, `type`, `options`: serialized as attributes of the `<xop:Include>` element.
- Header comment (line 7): MTOM is switched on at runtime with the **`SOAP_ENC_MTOM`** context flag, not at compile time.

## Usage

```
#import "xop.h"          // in a gSOAP .h spec that carries binary parts
soapcpp2 -Iimport ...
// runtime: soap.mode |= SOAP_ENC_MTOM (per header docs)
```

## Gotchas

- MTOM only engages if the application sets `SOAP_ENC_MTOM`; importing xop.h alone does nothing to the wire format.
- `_xop__Include` uses raw `char*` members — memory management follows gSOAP's owned-string rules (freed with the context unless `SOAP_WITH_NOID` style ownership changes apply).

UNKNOWN: whether any RCCService endpoint ever negotiated MTOM (no evidence in WSDL or service code).

