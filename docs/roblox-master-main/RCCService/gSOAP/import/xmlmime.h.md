# xmlmime.h

Source: `roblox-sandbox/RCCService/gSOAP/import/xmlmime.h` (65 lines)

## Purpose

gSOAP *import* stub declaring the **XML MIME 2004/11** schema namespace `http://www.w3.org/2004/11/xmlmime`, used to attach a MIME `contentType` attribute to binary content fields. The file's own header (line 5) says: **"This file is depricated. Please use xmime.h"** — it is retained in the vendored import set for backwards compatibility with older specs.

## API

No types or functions. Functional payload is one directive (line 65):

```
//gsoap xmlmime schema import: http://www.w3.org/2004/11/xmlmime
```

Documented idiom (lines 13–18) — attribute-typed binary data:

```cpp
#import "xmlmime.h"
struct ns__myBinaryData
{ unsigned char *__ptr;
  int __size;
  @char *xmlmime__contentType;
};
```

## Usage

New code should import `xop.h`/`xmime.h` instead; this stub only matters if some legacy spec imports it by name:

```
#import "xmlmime.h"     // legacy
soapcpp2 -Iimport ...
```

## Gotchas

- Explicitly deprecated by its own header — namespace differs from the newer xmime revisions, so mixing revisions produces mismatched attribute namespaces.
- RCCService does not use it; the WSDL carries no MIME-typed binary.

UNKNOWN: none beyond the above; directive-only file.

