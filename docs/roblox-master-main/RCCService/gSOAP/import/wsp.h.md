# wsp.h

Source: `roblox-sandbox/RCCService/gSOAP/import/wsp.h` (182 lines)

## Purpose

gSOAP import stub for **WS-Policy 2004/09** (`http://schemas.xmlsoap.org/ws/2004/09/policy`). Generated from `WS-Policy.xsd` and hand-modified by Robert van Engelen to interoperate with WS-Security: unions extended with wsse elements, `wsu` namespace re-imported, `wsse.h` pulled in. Lets generated headers carry policy attachments (e.g. confidentiality assertions) alongside bindings. Vendored toolchain material; not used by RCCService's WSDL.

## API

- `#import "wsse.h"` (line 34); directives re-importing `wsu` (42) and importing `wsp` (44–46).
- Helper struct (56): `struct xsd__base64Binary_ { unsigned char *__ptr; int __size; };` for the Digest attribute.
- Typedef (60): `_wsp__PolicyURIs` — whitespace-separated URI list as `char*`.
- Choice machinery:
  - `union wsp__union_1` (63–80): Policy / All / ExactlyOne / PolicyReference **plus added** `wsse__Confidentiality`, `wsse__SecurityHeader`, `wsse__SecurityToken` members.
  - `struct __wsp__union_1` (83–87): gSOAP tagged-union wrapper — selector `int __union_1` set to `SOAP_UNION_wsp__union_1_<field>` or 0, plus pointer `union_1`.
  - `union wsp__union_2` / `struct __wsp__union_2` (121–134): Policy | PolicyReference choice.
- Structs:
  - `wsp__OperatorContentType` (90–94): dynamic array of union_1.
  - `_wsp__PolicyReference` (97–109): optional attributes `@URI`, `@Digest` (base64), `@DigestAlgorithm`.
  - `_wsp__UsingPolicy` (112–118): empty extensible holder.
  - `_wsp__PolicyAttachment` (137–152): required `AppliesTo` + unbounded union_2 choice.
  - `_wsp__AppliesTo` (155–165): empty extensible holder.
  - `_wsp__Policy` (168–180): extends OperatorContentType; optional attributes `@TargetNamespace` and `@wsu__Id_`.

## Usage

```
#import "wsp.h"     // usually transitively via WSDLs that embed policy
soapcpp2 -Iimport ...
```

## Gotchas

- The added union members reference `wsse__Confidentiality` / `wsse__SecurityHeader` / `wsse__SecurityToken` struct names that are **not declared in this import set** — forward references only; compiling a spec that actually instantiates them requires additional declarations (the wsseapi plugin's extended types).
- Occurrence digits after field names (`Policy 1;`) are soapcpp2 markers, stripped before C++ compilation.
- Not referenced anywhere in RCCService.

UNKNOWN: none beyond the above.

