# xmlmime5.h

Source: `roblox-sandbox/RCCService/gSOAP/import/xmlmime5.h` (66 lines)

## Purpose

Deprecated gSOAP *import* stub for the **XML MIME 2005/05** schema namespace `http://www.w3.org/2005/05/xmlmime`. Header line 5: **"This file is depricated. Please use xmime5.h"**. It exists so legacy specs importing `xmlmime5.h` keep compiling; it binds the `xmlmime` prefix (not `xmlmime5`) to the namespace.

## API

No types or functions. Functional payload is one directive (line 66):

```
//gsoap xmlmime schema import: http://www.w3.org/2005/05/xmlmime
```

Documented idiom (lines 13–18):

```cpp
#import "xmlmime5.h"
struct ns__myBinaryData
{ unsigned char *__ptr;
  int __size;
  @char *xmlmime5__contentType;
};
```

## Usage

Superseded by `xmime5.h`; only relevant when a legacy spec imports this filename:

```
#import "xmlmime5.h"
soapcpp2 -Iimport ...
```

## Gotchas

- Prefix quirk: the directive registers prefix **`xmlmime`** while the documented attribute example uses `xmlmime5__contentType` — the two do not agree; with the directive as written, generated names would use the `xmlmime` prefix.
- Not used anywhere in RCCService.

UNKNOWN: none beyond the above; directive-only file.

