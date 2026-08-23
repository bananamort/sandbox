# App/Lua-5.1.4/src/lstrlib.c

## Purpose
String library ($Id: lstrlib.c,v 1.132.1.4): basic ops (`len/sub/reverse/lower/upper/rep/byte/char`), `string.dump` (via lua_dump into a buffer), the classic Lua pattern-matching engine (`MatchState`, class/bracket/balanced/frontier matching, captures up to LUA_MAXCAPTURES, backtracking `match` core with goto-tail-recursion), find/match/gmatch/gsub drivers (with plain-text fast path via strpbrk check, replacement by string/table/function), `format` (sprintf subset with %q quoting, int-length fixups via LUA_INTFRMLEN, long-string bypass for %.less %s), string metatable whose `__index` is the library itself, and compat stubs (gfind error alias).

## API
```c
LUALIB_API int luaopen_string (lua_State *L);
/* registered: byte char dump find format gfind gmatch gsub len lower
   match rep reverse sub upper */
/* ROBLOX internal: */
DYNAMIC_FASTFLAGVARIABLE(LuaStrlibLimitMatchDepth, true)
static const char *match(int matchdepth, MatchState *ms, const char *s, const char *p);
```

## Usage
- Fully script-facing in Roblox VMs; patterns run user-supplied code only through gsub's function replacement.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Pattern-matcher recursion depth limit** (marked `// ROBLOX CHANGES: matchdepth parameter` / `// BEGIN/END ROBLOX CHANGES`): `match()` gains an explicit `matchdepth` argument threaded through every recursive helper (max_expand/min_expand/start_capture/end_capture); entry points call `match(0, ...)`. When dynamic flag `LuaStrlibLimitMatchDepth` (default true) is set and depth exceeds LUAI_MAXCCALLS → `"pattern too complex"` error. Stock 5.1.4 recurses unbounded — C-stack exhaustion DoS from crafted patterns; this is Roblox's server-side hardening.
2. `#include "FastLog.h"` for the DFFlag machinery above.
3. Everything else byte-for-byte stock.

## Gotchas
- Depth counter starts at 0 per top-level match call and increments per nested match — legitimate deep patterns near LUAI_MAXCCALLS (~200) now fail with "pattern too complex" where stock would succeed slowly.
- The guard is toggleable at runtime via the FastFlag — behavior can differ between builds/sessions if flipped.
- `%f[set]` frontier uses previous byte even at position 0 ('\0'); embedded-NUL strings interact oddly with %z class (stock quirks retained).

