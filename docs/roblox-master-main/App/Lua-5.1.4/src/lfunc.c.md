# App/Lua-5.1.4/src/lfunc.c

## Purpose
Prototype/closure/upvalue mechanics ($Id: lfunc.c,v 2.12.1.2): allocation of C/Lua closures and protos, open-upvalue interning (`luaF_findupval` — one UpVal per stack slot, kept in `L->openupval` ordered descending by stack address plus the global `uvhead` ring for GC traversal), block-exit sealing (`luaF_close` copies stack values into the UpVal body), frees, and debug local-name lookup.

## API
```c
Closure *luaF_newCclosure (lua_State *L, int nelems, Table *e);
Closure *luaF_newLclosure (lua_State *L, int nelems, Table *e);
UpVal   *luaF_newupval    (lua_State *L);              /* closed, nil */
UpVal   *luaF_findupval   (lua_State *L, StkId level); /* intern or resurrect */
void     luaF_close       (lua_State *L, StkId level); /* seal all >= level */
Proto   *luaF_newproto    (lua_State *L);              /* zeroed */
void     luaF_freeproto   (lua_State *L, Proto *f);
void     luaF_freeclosure (lua_State *L, Closure *c);
void     luaF_freeupval   (lua_State *L, UpVal *uv);
const char *luaF_getlocalname (const Proto *f, int local_number, int pc);
```

## Usage
- `OP_CLOSURE` fills a fresh `luaF_newLclosure` via `luaF_findupval` per upvalue descriptor; coroutine kills and `lua_resetstack` (Roblox helper in App/script/LuaAtomicClasses.cpp) call `luaF_close(L, ...)` so pending closures observe final values instead of freed stack memory.
- `luaF_freeproto` frees `f->code` as `Instruction` — in this tree the actual allocation is the Roblox-typed instruction array (size accounting must match how ldump/lopcodes allocated it; see lopcodes.h.md).

## Roblox modifications (vs stock Lua 5.1.4)
1. Logic is stock; version string bumped to 2.12.1.2 (same as official 5.1.4 patch level). No Roblox code added.
2. Ecosystem deltas: `Proto::code` holds `InstructionV`, so `luaF_freeproto`'s `Instruction`-typed free relies on identical element size — verify lmem allocation sites if instructions change size. UNKNOWN: whether any Roblox build asserts this (none found here).

## Gotchas
- `luaF_findupval` resurrects dead upvalues (`changewhite`) — subtle GC interaction: an "about to be collected" upvalue can become live again by closure creation.
- `luaF_close` processes the whole `>= level` prefix of the open list; passing base instead of top closes unrelated enclosing frames' upvalues.
- `nupvalues` is stored as byte — >255 upvalues silently truncate (LUAI_MAXUPVALUES guards this at parse time).

