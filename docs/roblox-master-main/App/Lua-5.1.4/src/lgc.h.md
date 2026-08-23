# App/Lua-5.1.4/src/lgc.h

## Purpose
Header for the incremental tri-color garbage collector ($Id: lgc.h,v 2.15.1.1). Defines GC phase constants (GCSpause → GCSpropagate → GCSsweepstring → GCSsweep → GCSfinalize), the `marked`-field bit layout (two whites for flip-flop, black, finalized, weak-key/value table flags, fixed/super-fixed), color test/flip macros, the write-barrier macros (`luaC_barrier*`), and the public GC entry points.

## API
```c
#define GCSpause 0 / GCSpropagate 1 / GCSsweepstring 2 / GCSsweep 3 / GCSfinalize 4

/* marked bits */ WHITE0BIT 0, WHITE1BIT 1, BLACKBIT 2, FINALIZEDBIT 3,
KEYWEAKBIT 3, VALUEWEAKBIT 4, FIXEDBIT 5, SFIXEDBIT 6

#define iswhite/isblack/isgray(x), otherwhite(g), isdead(g,v),
        changewhite(x), gray2black(x), valiswhite(x), luaC_white(g)

#define luaC_checkGC(L)  /* step GC when totalbytes >= GCthreshold */
#define luaC_barrier(L,p,v)      /* forward barrier: black p points to white v */
#define luaC_barriert(L,t,v)     /* backward barrier for tables */
#define luaC_objbarrier(L,p,o)   /* object-to-object forward */
#define luaC_objbarriert(L,t,o)  /* object-to-object backward */

LUAI_FUNC size_t luaC_separateudata (lua_State *L, int all);
LUAI_FUNC void   luaC_callGCTM (lua_State *L);      /* run __gc finalizers */
LUAI_FUNC void   luaC_freeall (lua_State *L);       /* close-state teardown */
LUAI_FUNC void   luaC_step (lua_State *L);          /* incremental step */
LUAI_FUNC void   luaC_fullgc (lua_State *L);
LUAI_FUNC void   luaC_link (lua_State *L, GCObject *o, lu_byte tt);
LUAI_FUNC void   luaC_linkupval (lua_State *L, UpVal *uv);
LUAI_FUNC void   luaC_barrierf (lua_State *L, GCObject *o, GCObject *v);
LUAI_FUNC void   luaC_barrierback (lua_State *L, Table *t);
```

## Usage
- `luaC_checkGC` fires from allocation-heavy VM paths and every `lua_new*`; Roblox bridge code that creates thousands of objects per frame (LuaAtomicClasses value bridges) inherits these triggers.
- `DebuggerManager.cpp`'s `traverseGlobals` walks `rootgc` chains directly — it depends on this header's object-graph layout staying stock-shaped.
- `luaC_freeall` is invoked from `lua_close` in ScriptContext's VM shutdown path.

## Roblox modifications (vs stock Lua 5.1.4)
1. Header content is stock 5.1.4 — no added colors, no generational mode.
2. Interaction notes: `InstructionV` protos and `ckey` are ordinary heap objects to the collector; nothing here decodes instructions. UNKNOWN: whether lgc.c gained Roblox hooks (e.g. memory accounting for LuaMemory module) — see lgc.c.md.
3. The `SFIXEDBIT` "main thread only" semantics matter because Roblox runs many `global_State`s, each with its own super-fixed mainthread.

## Gotchas
- Bit 3 is dual-purpose: FINALIZEDBIT for userdata vs KEYWEAKBIT for tables — tests must be type-scoped.
- Missing a write barrier after storing a white pointer into a black object silently frees live data; all Roblox bridge C code that mutates tables must use `luaC_barriert` via `lua_settable`-style APIs rather than raw writes.
- `luaC_step` cost is proportional to `GCthreshold - totalbytes` bookkeeping; setting `GCthreshold` huge (as some Roblox settings paths do via collectgarbage("setpause"-style tweaks)) effectively disables incremental collection until fullgc.

