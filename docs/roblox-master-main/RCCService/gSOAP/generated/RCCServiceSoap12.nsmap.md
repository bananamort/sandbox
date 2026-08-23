# RCCServiceSoap12.nsmap

Source: `roblox-sandbox/RCCService/gSOAP/generated/RCCServiceSoap12.nsmap` (13 lines)

## Purpose

Generated namespace-binding table nominally for the **SOAP 1.2** binding (`RCCServiceSoap12`) of RCCService — the companion of `RCCServiceSoap.nsmap`. In practice the two files are byte-identical: the core envelope/encoding/schema rows use wildcard URI patterns (`http://www.w3.org/*/soap-envelope`), so this one table matches SOAP 1.2 envelopes as well as 1.1.

## API

```cpp
#include "soapH.h"
SOAP_NMAC struct Namespace namespaces[] =
{
	{"SOAP-ENV", "http://schemas.xmlsoap.org/soap/envelope/", "http://www.w3.org/*/soap-envelope", NULL},
	{"SOAP-ENC", "http://schemas.xmlsoap.org/soap/encoding/", "http://www.w3.org/*/soap-encoding", NULL},
	{"xsi", "http://www.w3.org/2001/XMLSchema-instance", "http://www.w3.org/*/XMLSchema-instance", NULL},
	{"xsd", "http://www.w3.org/2001/XMLSchema", "http://www.w3.org/*/XMLSchema", NULL},
	{"ns2", "http://roblox.com/RCCServiceSoap", NULL, NULL},
	{"ns1", "http://roblox.com/", NULL, NULL},
	{"ns3", "http://roblox.com/RCCServiceSoap12", NULL, NULL},
	{NULL, NULL, NULL, NULL}
};
```

Note `SOAP-ENV`'s primary URI is the **SOAP 1.1** envelope even in the Soap12 table — matching of the 1.2 envelope happens through the third-column wildcard, not the second column.

## Usage

Pulled in by generated SOAP 1.2 service sources (`soapRCCServiceSoap12Service.*`) and usable directly via `soap.namespaces = namespaces;`.

## Gotchas

- Identical content to `RCCServiceSoap.nsmap` — do not "fix" one without the other; regeneration from generate.bat rewrites both.
- The `ns3` row is what makes emitted SOAP-1.2-binding elements carry the `http://roblox.com/RCCServiceSoap12` namespace.
- Sentinel row required at end of table.

UNKNOWN: none beyond the above.

