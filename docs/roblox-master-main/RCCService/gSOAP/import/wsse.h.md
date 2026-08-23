# wsse.h

Source: `roblox-sandbox/RCCService/gSOAP/import/wsse.h` (198 lines)

## Purpose

gSOAP import stub for **WS-Security 1.0** (OASIS WS-SecurityCore, namespace `http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd`). Declares the `wsse:Security` SOAP header block plus username-token / binary-token / token-reference vocabulary used by the wsseapi plugin to sign and authenticate messages. Vendored toolchain material; not referenced by RCCService's WSDL (RCC authenticates jobs via the engine-side access key, not WS-Security).

## API

- `#import "wsu.h"` (line 26) and `#import "ds.h"` (line 170, mid-file right before `_wsse__Security`) — pulls in the utility timestamp types and XML-DSIG signature type.
- Directives (34–36): prefix `wsse`, qualified elements, unqualified attributes.
- Enum: `wsse__FaultcodeEnum` with 7 values — UnsupportedSecurityToken, UnsupportedAlgorithm, InvalidSecurity, InvalidSecurityToken, FailedAuthentication, FailedCheck, SecurityTokenUnavailable (95–106).
- Structs:
  - `_wsse__UsernameToken` (111–117): `Username`, `_wsse__Password*`, `Nonce`, `wsu__Created`, attribute `@wsu__Id`.
  - `_wsse__BinarySecurityToken` (122–127): simpleContent `__item` + attributes `@wsu__Id`, `@ValueType`, `@EncodingType`.
  - `_wsse__Reference` (132–135): attributes `@URI`, `@ValueType`.
  - `_wsse__Embedded` (140–144): extensible embedded-token holder.
  - `_wsse__KeyIdentifier` (149–154): simpleContent + `@wsu__Id`/`@ValueType`/`@EncodingType`.
  - `_wsse__SecurityTokenReference` (159–165): one of `Reference` / `KeyIdentifier` / `Embedded`, plus `@wsu__Id`, `@Usage`.
  - `_wsse__Security` (171–178): the header aggregate — optional `wsu__Timestamp*`, `UsernameToken*`, `BinarySecurityToken*`, `ds__SignatureType*`, with `@SOAP_ENV__actor` / `@SOAP_ENV__role`.
  - `_wsse__Password` (186–189): simpleContent password string + `@Type` (e.g. PasswordDigest vs PasswordText).
- Intentionally blank placeholders: AttributedString, PasswordString, EncodedString, UsernameTokenType, BinarySecurityTokenType, KeyIdentifierType, ReferenceType, EmbeddedType, SecurityTokenReferenceType, SecurityHeaderType, TransformationParametersType, tUsage (46–92); `_wsse__TransformationParameters`, `_wsse__Nonce`, `_wsse__Usage` (182, 192, 196).

## Usage

```
#import "wsse.h"    // link with plugin/wsseapi.c (+ OpenSSL) at build time
soapcpp2 -Iimport ...
```

## Gotchas

- The complexTypes are blank typemap placeholders; real serialization behavior for tokens comes from wsseapi plugin code, not this header.
- `ds__Signature` inside `_wsse__Security` means signing requires `ds.h` (XML-DSIG) types to be generated as well.
- Not used anywhere in RCCService.

UNKNOWN: whether any internal Roblox deployment layered WS-Security in front of RCCService (no evidence in this tree).

