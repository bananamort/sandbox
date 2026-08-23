# xmime4.h

Source: `roblox-sandbox/RCCService/gSOAP/import/xmime4.h` (63 lines)

## Purpose

gSOAP *import* stub binding the prefix `xmime4` to the **XML MIME 2004/11** schema namespace `http://www.w3.org/2004/11/xmlmime` so specs can attach a MIME `contentType` attribute (`@char *xmime4__contentType`) to binary fields. Vendored toolchain material; not referenced by RCCService's WSDL.

## API

No types or functions. Functional payload is one directive (line 63):

```
//gsoap xmime4 schema import: http://www.w3.org/2004/11/xmlmime
```

Documented idiom (lines 11–16):

```cpp
#import "xmime4.h"
struct ns__myBinaryData
{ unsigned char *__ptr;
  int __size;
  @char *xmime4__contentType;
};
```

## Usage

```
#import "xmime4.h"
soapcpp2 -Iimport ...
```

## Gotchas

- Same target namespace as the deprecated `xmlmime.h` (2004/11) but with a different generated C prefix — importing both would create two prefixes for one namespace; pick one.
- The header comment (line 5) still says "Use #import \"xmlmime.h\"" — a copy-paste artifact from the older stub; the actual directive uses `xmime4`.
- Not used anywhere in RCCService.

UNKNOWN: none beyond the above; directive-only file.

