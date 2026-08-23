# xmime5.h

Source: `roblox-sandbox/RCCService/gSOAP/import/xmime5.h` (63 lines)

## Purpose

gSOAP *import* stub binding prefix `xmime5` to the **XML MIME 2005/05** schema namespace `http://www.w3.org/2005/05/xmlmime` — the current (non-deprecated) revision of the MIME content-type attribute family in this import set. Lets specs attach `@char *xmime5__contentType` to binary fields. Vendored toolchain material; not referenced by RCCService's WSDL.

## API

No types or functions. Functional payload is one directive (line 63):

```
//gsoap xmime5 schema import: http://www.w3.org/2005/05/xmlmime
```

Documented idiom (lines 11–16):

```cpp
#import "xmime5.h"
struct ns__myBinaryData
{ unsigned char *__ptr;
  int __size;
  @char *xmime5__contentType;
};
```

## Usage

```
#import "xmime5.h"      // preferred over xmlmime.h / xmlmime5.h / xmime4.h
soapcpp2 -Iimport ...
```

## Gotchas

- Four MIME stubs coexist in this directory (xmlmime, xmime/xmime4/xmlmime5 variants); they target different namespace revisions — importing more than one revision in one spec risks attribute-namespace mismatches.
- Not used anywhere in RCCService.

UNKNOWN: none beyond the above; directive-only file.

