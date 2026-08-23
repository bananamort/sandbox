# App/Lua-5.1.4/src/lfunc.h

## Purpose
Header for prototype/closure/upvalue lifecycle (`$Id: lfunc.h,v 2.4.1.1`). Declares allocation of `Proto`, C/Lua closures, upvalues (`luaF_new*`), open-upvalue linking and snapshotting at block exit (`luaF_findupval`/`luaF_close`), and the GC free functions plus debug-local-name lookup.

## API
```c
#define sizeCclosure(n) (cast(int, sizeof(CClosure)) + cast(int, sizeof(TValue)*((n)-1)))
#define sizeLclosure(n) (cast(int, sizeof(LClosure)) + cast(int, sizeof(TValue *)*((n)-1)))

LUAI_FUNC Proto   *luaF_newproto    (lua_State *L);
LUAI_FUNC Closure *luaF_newCclosure (lua_State *L, int nelems, Table *e);
LUAI_FUNC Closure *luaF_newLclosure (lua_State *L, int nelems, Table *e);
LUAI_FUNC UpVal   *luaF_newupval    (lua_State *L);
LUAI_FUNC UpVal   *luaF_findupval   (lua_State *L, StkId level);
LUAI_FUNC void     luaF_close       (lua_State *L, StkId level);
LUAI_FUNC void     luaF_freeproto   (lua_State *L, Proto *f);
LUAI_FUNC void     luaF_freeclosure (lua_State *L, Closure *c);
LUAI_FUNC void     luaF_freeupval   (lua_State *L, UpVal *uv);
LUAI_FUNC const char *luaF_getlocalname (const Proto *func, int local_number, int pc);
```

## Usage
- `luaF_newCclosure/newLclosure` are what `OP_CLOSURE` (via `luaF_newLclosure` from `lvm.c`) and `lua_pushcclosure` (via `lapi.c`) call; closures link into `L->l_G->rootgc` immediately.
- `luaF_findupval` interns an `UpVal` per stack slot so multiple closures share one cell; `luaF_close` walks `L->openupval` and copies live stack values into the `UpVal.v` union when the enclosing block returns.
- `lua_resetstack` in `App/script/LuaAtomicClasses.cpp` calls `luaF_close(L, L->top_j)` explicitly before resetting `L->top`, i.e. Roblox bridge code depends on this entry point to seal pending upvalues when abandoning a thread's stack.

## Roblox modifications (vs stock Lua 5.1.4)
1. Header body is byte-for-byte stock 5.1.4; no Roblox deltas found in this file.
2. Indirect relevance: because `InstructionV`/`ckey` obfuscation lives in `Proto::code`, everything allocated here (protos) carries Roblox-obfuscated bytecode even though the allocator API is unchanged.

## Gotchas
- `sizeCclosure/sizeLclosure` compute sizes with `(n)-1` because the structs end with a 1-element flexible array — off-by-one here corrupts the GC object header.
- `luaF_close(L, level)` closes ALL upvalues with stack index >= level, not just one; calling it with too-low a level seals unrelated slots.
- `luaF_getlocalname` answers debug queries by pc; under Roblox the caller must already have decoded `savedpc` (InstructionV) or the pc argument may be meaningless. UNKNOWN: whether any Roblox caller uses `luaF_getlocalname` (grep of App/script shows no direct use).

