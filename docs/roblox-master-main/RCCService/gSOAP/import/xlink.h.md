# xlink.h

Source: `roblox-sandbox/RCCService/gSOAP/import/xlink.h` (49 lines)

## Purpose

gSOAP *import* stub declaring the **XML Linking (XLink) 1999** namespace `http://www.w3.org/1999/xlink` for the soapcpp2 schema importer. Like the rest of `gSOAP/import/`, it is vendored toolchain material: it exists so that a gSOAP header spec can `#import "xlink.h"` and have XLink attributes recognized when serializing schemas that embed XLink references. RCCService's own WSDL does not use XLink.

## API

No types, no functions. The entire payload after the license block is one directive (line 49):

```
//gsoap xlink schema import: http://www.w3.org/1999/xlink
```

This registers the namespace prefix binding only; soapcpp2 emits no code unless some imported type actually uses the namespace.

## Usage

Toolchain-only:

```
#import "xlink.h"       // inside a gSOAP .h spec file
soapcpp2 -Iimport ...   // import path resolution
```

## Gotchas

- 48 of the 49 lines are the gSOAP dual license text (gSOAP public license / GPLv2+ with OpenSSL exemption); the functional content is the single final line.
- Copyright Robert A. van Engelen, Genivia Inc., 2000–2005 — this pins the vendored gSOAP release to an early-2000s vintage.
- Declaring the namespace without using it is harmless; soapcpp2 ignores unused imports.

UNKNOWN: nothing beyond the above — the file has no hidden logic.

