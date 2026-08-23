# README.txt

Source: `roblox-sandbox/RCCService/gSOAP/import/README.txt` (41 lines)

## Purpose

Upstream gSOAP readme for the `import/` directory: explains that the directory holds common `#import`-able items for the **soapcpp2** compiler and catalogs which stub provides which feature. It is the authoritative map of the vendored import set shipped alongside RCCService's SOAP tooling.

## API

Not applicable — plain text catalog. The catalog (lines 6–20):

| File | Feature |
| --- | --- |
| `dom.h` | DOM for xs:anyType / xs:any / xs:anyAttribute (link with dom.c/pp) |
| `stldeque.h` | std::deque serializer |
| `stllist.h` | std::list serializer |
| `stlset.h` | std::set serializer |
| `stlvector.h` | std::vector serializer |
| `stl.h` | all four STL serializers at once |
| `soap12.h` | SOAP 1.2 namespaces |
| `wsa.h` | WS-Addressing 2004/08 (plugin/wsaapi.c) |
| `wsa3.h` | WS-Addressing 2003/03 (plugin/wsaapi.c) |
| `wsa4.h` | WS-Addressing 2004/03 (plugin/wsaapi.c) |
| `wsa5.h` | WS-Addressing 2005/03 (plugin/wsaapi.c) |
| `wsse.h` | WS-Security (plugin/wsseapi.c) |
| `wsu.h` | Utility (WS-Utility) |
| `xmlmime.h` | XML MIME bindings |
| `xop.h` | XOP MTOM attachments |

It also documents the wsdl2h workflow that generated these stubs (lines 25–36): e.g. `wsdl2h -cgy -o wsa.h -t WS/WS-typemap.dat WS/WS-Addressing.xsd`, with `typemap.dat` mapping namespaces to prebuilt imports (`wsa = <http://schemas.xmlsoap.org/ws/2004/08/addressing>`) so wsdl2h reuses the stub instead of extracting the schema. Plain-quoted bindings (`aws = "urn:PI/DevCentral/SoapService"`) define ordinary namespace mappings.

## Usage

Reference documentation only — no build step consumes README.txt.

## Gotchas

- The catalog omits several files actually present in this directory (`c14n.h`, `ds.h`, `ds2.h`, `wsp.h`, `wsrp.h`, `wsse2.h`, `xlink.h`, `xmime*.h`, `xmlmime5.h`, `xml.h`) — the vendored set is newer than the README.
- The referenced plugins (`wsaapi.c`, `wsseapi.c`) and `typemap.dat` are **not** part of this repository; only the import headers were vendored.

UNKNOWN: exact gSOAP distribution version (README predates some included files; license headers suggest ~2.7-era, 2000–2005).

