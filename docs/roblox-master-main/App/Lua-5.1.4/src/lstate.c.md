# App/Lua-5.1.4/src/lstate.c

## Purpose
State lifecycle (`$Id: lstate.c,v 2.36.1.2`): `lua_newstate` (allocates the `LG {lua_State, global_State}` block), thread create/free (`luaE_newthread`/`luaE_freethread`), `lua_close`, stack init/teardown, and `f_luaopen` bootstrap (globals table, registry, string table, tag methods, lexer reserved words).

## API
- Internals: `state_size(x) = sizeof(x) + LUAI_EXTRASPACE`; `fromstate(l)` / `tosate(l)…` (`tostate`) pointer arithmetic across `RobloxExtraSpace`.
- `static void stack_init(lua_State *L1, lua_State *L)` — BASIC_CI_SIZE CallInfos; BASIC_STACK_SIZE+EXTRA_STACK TValues; first dummy frame.
- `static void f_luaopen(lua_State*, void*)` — globals+registry tables, `luaS_resize(MINSTRTABSIZE)`, `luaT_init`, `luaX_init` (lexer reserved words), fixes `MEMERRMSG`, sets `GCthreshold = 4*totalbytes`.
- `static void preinit_state(lua_State*, global_State*)`
- `static void close_state(lua_State*)`
- `LUA_API lua_State *lua_newstate(lua_Alloc f, void *ud)` — allocates via `f`, initializes every GC field, **`g->ckey = 0;`** then runs `f_luaopen` under `luaD_rawrunprotected`, finally `luai_userstateopen(L)` (constructs `RobloxExtraSpace`).
- `LUA_API void lua_close(lua_State *L)` — main-thread only: close upvalues, separate udata with `__gc`, loop `callall_gcTM` under rawrunprotected until clean, `luai_userstateclose`, `close_state`.
- `lua_State *luaE_newthread(lua_State *L)` — `tostate(luaM_malloc(...))`, `luaC_link(LUA_TTHREAD)`, shares `gt` (globals table) and inherits hook settings.
- `void luaE_freethread(lua_State *L, lua_State *L1)` — `luaF_close`, `luai_userstatefree`, freestack, free memory.

## Usage
- `lua_newstate` is invoked by the script layer per Security identity (`ScriptContext.cpp` builds `globalStates[Security::VM_Default]` etc.); each resulting VM gets its own `ckey` assigned afterwards by engine code.
- `luaE_newthread` backs `lua_newthread` — every Roblox coroutine/thread carries a child `RobloxExtraSpace`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **NEW `g->ckey = 0;`** in `lua_newstate` (line 181) — initializes the Roblox per-VM opcode key to invalid; stock has no such field.
2. All other text matches stock 5.1.4; the EXTRASPACE plumbing (`state_size/fromstate/tostate`) is stock but becomes load-bearing because `LUAI_EXTRASPACE = sizeof(RobloxExtraSpace)` and `luai_userstateopen/close/free` construct/destroy it.

## Gotchas
- If `f_luaopen` fails partway, `close_state` runs while `RobloxExtraSpace` was never constructed — safe only because `luai_userstateopen` runs strictly after success.
- `lua_close` asserts `g->totalbytes == sizeof(LG)` at teardown; leaks through engine-held refs (e.g. `RobloxExtraSpace` nodes not erased) will trip this assert in debug.
- Threads share the globals table object with the parent — Roblox's sandboxing therefore relies on read-only globals (`lua_setreadonly`) rather than table isolation.
