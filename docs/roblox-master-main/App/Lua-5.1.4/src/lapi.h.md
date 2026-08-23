# App/Lua-5.1.4/src/lapi.h

## Purpose
Internal header for the API module ($Id: lapi.h,v 2.2.1.1). Declares the single core-internal helper `luaA_pushobject`, used by other core files (e.g. lvm.c, ldebug.c, lbaselib) to copy a TValue onto the stack top with the `api_incr_top` invariant check.

## API
```c
LUAI_FUNC void luaA_pushobject (lua_State *L, const TValue *o);
```

## Usage
- Called from within the core wherever an existing TValue must be pushed (error objects, metamethod results); not part of the public API and not used by App/script bridge code.

## Roblox modifications (vs stock Lua 5.1.4)
1. Byte-for-byte stock — no deltas.

## Gotchas
- Pushes assume stack headroom (`api_incr_top` asserts `L->top < L->ci->top` in debug builds); callers must `luaD_checkstack` first.

