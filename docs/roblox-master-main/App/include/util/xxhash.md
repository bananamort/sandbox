# util/xxhash.h

## Purpose
Yann Collet's xxHash (2012, BSD 2-Clause) — extremely fast non-cryptographic 32-bit hash running near RAM speed limits; passes SMHasher tests. Vendored copy exposes both one-shot and streaming APIs, plus one Roblox-specific nonce helper.

## Declared API
```cpp
extern "C" {

struct XXH_state32_t {          // opaque-ish streaming state
    unsigned int seed, v1, v2, v3, v4;
    unsigned long long total_len;
    char memory[16];
    int memsize;
};

// Simple (one-shot)
unsigned int XXH32(const void* input, int len, unsigned int seed);

// Advanced (streaming)
void*        XXH32_init(unsigned int seed);
int          XXH32_feed(void* state, const void* input, int len); // 0 == OK
unsigned int XXH32_result(void* state);        // frees the state memory
unsigned int XXH32_getIntermediateResult(void* state); // keeps state alive

// Roblox-specific
unsigned int XXH32_getRbxNonce(unsigned int base, unsigned int query);
}
```

## Gotchas
- `len` is `int`: inputs are limited to 2^31-1 per call; for larger data chunk into ~1 GB blocks (per header comment) using the streaming API.
- `XXH32_result()` **frees** the state allocated by `XXH32_init()`; use `XXH32_getIntermediateResult()` to snapshot a hash while continuing to feed data.
- `XXH32_feed()` returns an error code where 0 means OK, anything else is an error.
- This vendored version is 32-bit only (no XXH64) and dated 2012 — not the modern xxHash release layout.
- `XXH32_getRbxNonce(base, query)` inverts xxhash steps so the 4 added data bytes can be exactly determined — i.e., it solves for input bytes given a known prefix hash. Very specialized; read the comment before reuse.

## UNKNOWN
- Where the corresponding .c/.cpp implementation lives (not under App/include).
- Current call sites of `XXH32_getRbxNonce` (UNKNOWN usage sites in this slice).
