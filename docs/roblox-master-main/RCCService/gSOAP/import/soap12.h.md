# soap12.h

Source: `roblox-sandbox/RCCService/gSOAP/import/soap12.h` (51 lines)

## Purpose

gSOAP *import* stub that switches code generation to **SOAP 1.2** by rebinding the envelope and encoding namespaces:

- `SOAP-ENV` → `http://www.w3.org/2003/05/soap-envelope`
- `SOAP-ENC` → `http://www.w3.org/2003/05/soap-encoding`

(default SOAP 1.1 bindings use the `schemas.xmlsoap.org/soap/envelope` namespace). Vendored toolchain material. RCCService generates **both** a SOAP 1.1 and a SOAP 1.2 service class (`soapRCCServiceSoapService` / `soapRCCServiceSoap12Service`), so this stub is what made the `-2`-flavored generation possible.

## API

No types or functions; two directives (lines 50–51):

```
//gsoap SOAP-ENV schema namespace: http://www.w3.org/2003/05/soap-envelope
//gsoap SOAP-ENC schema namespace: http://www.w3.org/2003/05/soap-encoding
```

Per the header comment, importing this file is equivalent to running soapcpp2 with option **`-2`**.

## Usage

```
#import "soap12.h"      // in the gSOAP .h spec
// or: soapcpp2 -2 myservice.h
```

## Gotchas

- The generated tree contains both `RCCServiceSoap.nsmap` and `RCCServiceSoap12.nsmap`; clients must bind the matching nsmap to the matching service class or envelopes will carry the wrong envelope namespace.
- SOAP 1.2 uses different Fault markup (`env:Value` / `env:Subcode`) — error handling that greps for SOAP 1.1 fault fields will miss 1.2 faults.

UNKNOWN: which binding Roblox's job-submission clients actually used (the WSDL advertises both; usage lives outside this repo).

