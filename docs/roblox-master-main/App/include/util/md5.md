# util/md5.h

## Purpose
Public-domain OpenSSL-compatible implementation of the RSA Data Security MD5 Message-Digest Algorithm (RFC 1321), by Alexander Peslyak (Solar Designer, 2001). Provides the raw C-level MD5 context type and streaming API.

## Declared API
```c
#ifdef HAVE_OPENSSL
#include <openssl/md5.h>            // use system OpenSSL instead when defined
#else
typedef unsigned int MD5_u32plus;   // "any 32-bit or wider unsigned integer" suffices

typedef struct {
    MD5_u32plus lo, hi;             // byte counters
    MD5_u32plus a, b, c, d;         // working state
    unsigned char buffer[64];
    MD5_u32plus block[16];
} MD5_CTX;

extern void MD5_Init(MD5_CTX *ctx);
extern void MD5_Update(MD5_CTX *ctx, void *data, unsigned long size);
extern void MD5_Final(unsigned char *result /*16 bytes*/, MD5_CTX *ctx);
#endif
```
All three functions are declared `extern "C"` when compiled as C++.

## Gotchas
- If `HAVE_OPENSSL` is defined this header becomes a thin pass-through to `<openssl/md5.h>`; callers must not assume the local struct layout in that build.
- Include guard `_MD5_H` guards against double definition vs. system headers.
- Implementation lives in `md5.c` (referenced by header comment; not present in App/include — see UNKNOWN).
- MD5 is not collision-resistant; suitable here for content addressing/integrity, not security.

## UNKNOWN
- Location of `md5.c` in the tree (header says "See md5.c for more information"; not under App/include).
- Which Roblox code paths include this directly vs. go through `MD5Hasher.h`.
