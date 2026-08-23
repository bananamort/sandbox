# ds2.h

Source: `roblox-sandbox/RCCService/gSOAP/import/ds2.h` (373 lines)

## Purpose

Byte-for-byte clone of `ds.h` (XML-DSIG `http://www.w3.org/2000/09/xmldsig#` type tree) with exactly **one** line changed — verified by diff: `ds__KeyInfoType`'s WS-Security cross-reference member is `_wsse2__SecurityTokenReference* wsse2__SecurityTokenReference;` (line 88) instead of the `wsse__` spelling, so this copy pairs with `wsse2.h` (the 2002/12 secext draft stub). Vendored toolchain material; not used by RCCService.

## API

Identical to `ds.h`: `ds__SignatureType`, `ds__SignedInfoType`, `ds__CanonicalizationMethodType`, `ds__SignatureMethodType`, `ds__ReferenceType`, `ds__TransformsType` / `ds__TransformType` (with `#import "c14n.h"` at line 72), `ds__KeyInfoType`, `ds__KeyValueType`, `ds__RetrievalMethodType`, `ds__X509DataType`, `ds__X509IssuerSerialType`, `ds__DSAKeyValueType`, `ds__RSAKeyValueType`, plus blank placeholders and comment-only global element declarations. Directives at lines 33–35 (prefix `ds`).

## Usage

```
#import "ds2.h"     // only alongside wsse2.h; use ds.h otherwise
soapcpp2 -Iimport ...
```

## Gotchas

- **Never import ds.h and ds2.h in the same spec** — every type except that one member is identically named (`ds__*`), causing duplicate-definition collisions.
- Header comment still says "ds.h" throughout (it is a raw copy), so provenance must come from the filename.
- Not referenced anywhere in RCCService.

UNKNOWN: none beyond the above (single-line delta confirmed via diff).

