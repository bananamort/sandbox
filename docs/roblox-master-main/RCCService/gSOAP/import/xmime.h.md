# xmime.h

Source: `roblox-sandbox/RCCService/gSOAP/import/xmime.h` (62 lines)

## Purpose

gSOAP *import* stub declaring the **XML MIME (2004/06)** schema namespace `http://www.w3.org/2004/06/xmlmime`. It lets a gSOAP spec attach a MIME content-type attribute to binary fields (MTOM-style typing). Vendored toolchain material; not referenced by RCCService's WSDL.

## API

No types or functions of its own. The header's functional payload is one directive plus a documented idiom (lines 7–15, 62):

```
//gsoap xmime schema import: http://www.w3.org/2004/06/xmlmime
```

Documented usage pattern from the file itself:

```cpp
#import "xmime.h"
struct ns__myBinaryData
{ unsigned char *__ptr;
  int __size;
  @char *xmime__contentType;
};
```

- `__ptr` / `__size` are gSOAP's convention for transparent binary content; `@` marks `xmime__contentType` as an XML attribute.

## Usage

```
#import "xmime.h"       // in a gSOAP .h spec that carries typed binary
soapcpp2 -Iimport ...
```

## Gotchas

- This is the **2004/06** draft namespace; the directory also contains `xmlmime.h` (2004/01?), `xmlmime5.h` and `xmime4.h`/`xmime5.h` covering other revisions — importing the wrong revision changes the generated attribute namespace.
- The struct in the comment is illustrative documentation, not a declaration emitted into soapStub.h unless actually imported and referenced.

UNKNOWN: none beyond the above; the file declares only the namespace binding.

