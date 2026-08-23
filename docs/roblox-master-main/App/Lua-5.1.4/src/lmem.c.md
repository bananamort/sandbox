# App/Lua-5.1.4/src/lmem.c

## Purpose
Implementation of the VM memory manager (`$Id: lmem.c,v 1.70.1.1`): growth policy for arrays and the central `luaM_realloc_` that dispatches to the state's `frealloc` allocator while maintaining `global_State::totalbytes`.

## API
- `void *luaM_growaux_(lua_State *L, void *block, int *size, size_t size_elems, int limit, const char *errormsg)` — doubling growth from `MINSIZEARRAY 4`, snapping to `limit`; raises `errormsg` via `luaG_runerror` when capped.
- `void *luaM_toobig(lua_State *L)` — raises `"memory allocation error: block too big"`, returns NULL (unreachable).
- `void *luaM_realloc_(lua_State *L, void *block, size_t osize, size_t nsize)` — calls `g->frealloc(g->ud, block, osize, nsize)`; NULL with nsize>0 → `luaD_throw(L, LUA_ERRMEM)`; updates `g->totalbytes = totalbytes - osize + nsize`.

Contract documented in header comment: `(ptr == NULL) iff (osize == 0)`; realloc to equal/smaller size never fails.

## Usage
Called through the `lmem.h` macros by all core files; the `frealloc` function pointer is supplied by whoever calls `lua_newstate` — in Roblox this is the script layer's allocator (see `ScriptContext.cpp` / `LuaVM.cpp`), so all Lua memory is engine-accounted via `totalbytes`.

## Roblox modifications (vs stock Lua 5.1.4)
None in this file — stock 5.1.4 verbatim. Integration happens indirectly:
- `totalbytes` bookkeeping feeds Roblox GC-pressure decisions elsewhere (`lgc.c` step sizing).
- Failure path goes through `luaD_throw` → C++ `lua_exception` (per `luaconf.h` `LUAI_THROW`), so an OOM unwinds as a catchable C++ exception across engine frames.

## Gotchas
- `totalbytes` update is not atomic; it assumes single-threaded access per `global_State` — Roblox keeps one `lua_State` root per `Security::VM_*` slot precisely for this class of invariant.
- `osize`/`nsize` are byte counts of the *element type times count* computed by callers; passing wrong element size corrupts accounting silently.
