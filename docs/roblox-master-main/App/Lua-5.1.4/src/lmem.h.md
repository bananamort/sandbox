# App/Lua-5.1.4/src/lmem.h

## Purpose
Memory-manager macro layer for the Lua core (`$Id: lmem.h,v 1.31.1.1`): every allocation in the VM goes through these wrappers, which funnel into `luaM_realloc_` and the `lua_Alloc` function stored in `global_State`.

## API
- `#define MEMERRMSG "not enough memory"`
- `luaM_reallocv(L,b,on,n,e)` — overflow-checked bulk realloc (`n+1 <= MAX_SIZET/e`, else `luaM_toobig`)
- `luaM_freemem(L,b,s)`, `luaM_free(L,b)`, `luaM_freearray(L,b,n,t)`
- `luaM_malloc(L,t)`, `luaM_new(L,t)`, `luaM_newvector(L,n,t)`
- `luaM_growvector(L,v,nelems,size,t,limit,e)` — doubling growth via `luaM_growaux_`
- `luaM_reallocvector(L,v,oldn,n,t)`
- Prototypes: `void *luaM_realloc_(lua_State*, void* block, size_t oldsize, size_t size)`, `void *luaM_toobig(lua_State*)`, `void *luaM_growaux_(lua_State*, void* block, int *size, size_t size_elem, int limit, const char *errormsg)`

## Usage
Used by literally every VM subsystem that allocates: `lstring.c` (`luaM_malloc` for TString/Udata), `ltable.c`, `lstate.c`, `lparser.c`/`lcode.c` (compiler grow vectors), `lgc.c`, engine's `LuaSerializer.inl` (`luaM_newvector(L, p->sizecode, InstructionV)`).

## Roblox modifications (vs stock Lua 5.1.4)
None detected — byte-for-byte stock 5.1.4. (Behavioral delta only via `luaconf.h`: `lua_assert` → `RBXASSERT` in debug builds affects nothing here since no asserts appear; allocations ultimately hit the engine allocator passed to `lua_newstate`.)

## Gotchas
- `luaM_growvector`'s `limit` is a hard cap; exceeding it raises the `errormsg` as a Lua error (e.g. `"function or expression needs too many..."` messages from `lparser.c`).
- All macros expand `luaM_realloc_` which throws `LUA_ERRMEM` on failure — no NULL returns inside the VM.
