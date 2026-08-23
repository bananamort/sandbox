# ds.h

Source: `roblox-sandbox/RCCService/gSOAP/import/ds.h` (373 lines)

## Purpose

gSOAP import stub for **XML-DSIG** (W3C XML Signature, namespace `http://www.w3.org/2000/09/xmldsig#`). Declares the full `ds__Signature` type tree — SignedInfo, Reference/Transform chain, KeyInfo with X509/DSA/RSA key material — that WS-Security signatures embed. Generated from `WS/ds.xsd` (`wsdl2h -cuxy`) and adjusted to import the namespace. Vendored toolchain material; not used by RCCService's WSDL.

## API

Directives (33–35): prefix `ds`, qualified elements, unqualified attributes. `#import "c14n.h"` at line 72 supplies the InclusiveNamespaces transform.

Core structs:

```cpp
typedef struct ds__SignatureType
{	struct ds__SignedInfoType*		SignedInfo;
	char*					SignatureValue;   // base64
	struct ds__KeyInfoType*			KeyInfo;
	@char*					Id;
} ds__SignatureType;
```

- `ds__TransformType` (73–77): optional `_c14n__InclusiveNamespaces*`, wildcard `_XML __any`, required attribute `@Algorithm`.
- `ds__KeyInfoType` (83–90): `KeyName`, `KeyValue*`, `RetrievalMethod*`, `X509Data*`, **`_wsse__SecurityTokenReference*`** (WS-Security cross-type), `@Id`.
- `ds__SignedInfoType` (138–150): required `CanonicalizationMethod*`, `SignatureMethod*`, unbounded `Reference**` array, `@Id`.
- `ds__CanonicalizationMethodType` (153–163): required `@Algorithm` + added `c14n__InclusiveNamespaces*`.
- `ds__SignatureMethodType` (166–176): optional `int* HMACOutputLength`, required `@Algorithm`.
- `ds__ReferenceType` (179–193): optional `Transforms*`; required `DigestMethod*` and base64 `DigestValue`; attributes `@Id`, `@URI`, `@Type`.
- `ds__TransformsType` (196–202): unbounded `ds__TransformType* Transform`.
- `ds__DigestMethodType` (205–213): required `@Algorithm`.
- `ds__KeyValueType` (216–229): DSAKeyValue | RSAKeyValue choice.
- `ds__RetrievalMethodType` (232–240): optional Transforms + `@URI`/`@Type`.
- `ds__X509DataType` (243–262): choice of IssuerSerial / SKI / SubjectName / Certificate / CRL.
- `ds__X509IssuerSerialType` (265–271), `ds__DSAKeyValueType` (274–290: G,Y,J,P,Q,Seed,PgenCounter as base64), `ds__RSAKeyValueType` (293–299: Modulus + Exponent).
- Lines 301–371 are comment-only global element declarations ("use wsdl2h option -g to generate...").

## Usage

```
#import "ds.h"      // normally via wsse.h
soapcpp2 -Iimport ...
```

## Gotchas

- `ds__KeyInfoType` forward-references `_wsse__SecurityTokenReference` — declared only when wsse.h is imported in the same spec; importing ds.h alone leaves it an incomplete type.
- Blank placeholders for PGPData/SPKIData/Object/Manifest/SignatureProperties types.
- Not referenced anywhere in RCCService.

UNKNOWN: none beyond the above.

