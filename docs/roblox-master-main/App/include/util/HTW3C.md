# util/HTW3C.h

## Purpose
Conflict-shield wrapper around the libwww URL-parsing headers (`HTParse.h`, plus `wwwsys.h` on non-Windows). Exists to `#undef PARSE_ANCHOR` after inclusion because libwww's macro collides with urlmon.h's `_tagPARSEACTION::PARSE_ANCHOR` enumerator and shreds urlmon.h (C2143) when both appear in one TU.

## Declared API
```cpp
extern "C" {
#ifndef _WIN32
#include <wwwsys.h>
#endif
#include <HTParse.h>
}
// then:
#undef PARSE_ANCHOR
```
No RBX declarations of its own.

## Gotchas
- The long header comment is the documentation: nothing in this tree uses libwww's `PARSE_ANCHOR`/`PARSE_VIEW`/`PARSE_FRAGMENT` flags — call sites only use `PARSE_ACCESS`/`PARSE_HOST`/`PARSE_PATH` with `HParse`.
- Include THIS wrapper instead of `<HTParse.h>` directly whenever a TU also reaches `<atlutil.h>`/urlmon; include order no longer matters.
- If you ever need libwww's anchor-parse flags, this wrapper has removed them deliberately.

## UNKNOWN
- Which TUs consume HParse via this wrapper (URL handling code).
