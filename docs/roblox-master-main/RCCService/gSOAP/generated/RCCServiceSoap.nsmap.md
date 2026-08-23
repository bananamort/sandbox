# RCCServiceSoap.nsmap

Source: `roblox-sandbox/RCCService/gSOAP/generated/RCCServiceSoap.nsmap` (13 lines)

## Purpose

Generated namespace-binding table for the **SOAP 1.1** binding (`RCCServiceSoap`) of RCCService. Defines the global `struct Namespace namespaces[]` that a soap context uses to map XML namespace prefixes ↔ URIs when (de)serializing messages. The server code links this table by assigning `soap.namespaces = namespaces` (gSOAP does this automatically in the generated service classes).

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

Column layout: `{prefix, uri, wildcard-pattern, unused}`. Row-by-row:
- Core SOAP/XML rows use **wildcard third-column patterns** (`http://www.w3.org/*/...`) so both SOAP 1.1 and 1.2 / old and new schema URIs match one row.
- Service rows: `ns2` → target namespace of the SOAP 1.1 binding; `ns1` → shared `http://roblox.com/` element namespace used by the job types; `ns3` → SOAP 1.2 binding namespace (present here too because soapH.h carries types for both bindings).

## Usage

Included by the generated service sources; applications embedding gSOAP directly can do:

```cpp
soap.namespaces = namespaces;   // or #include "RCCServiceSoap.nsmap"
```

## Gotchas

- This file and `RCCServiceSoap12.nsmap` are **byte-identical**: because the core rows carry wildcards, a single table serves both bindings.
- The trailing `{NULL,NULL,NULL,NULL}` sentinel is mandatory — iteration over the table stops there.
- Prefix names (`ns1`/`ns2`/`ns3`) are wsdl2h-assigned; changing them changes emitted wire prefixes (harmless semantically but breaks naive string-matching clients).

UNKNOWN: none beyond the above.

