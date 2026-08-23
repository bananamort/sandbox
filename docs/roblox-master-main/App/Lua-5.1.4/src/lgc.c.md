# App/Lua-5.1.4/src/lgc.c

## Purpose
Incremental tri-color garbage collector ($Id: lgc.c,v 2.38.1.1): marking (`reallymarkobject`, root set = mainthread + globals + registry + type metatables), gray-list propagation per type (tables with weak-mode handling, closures, threads/stacks, protos), the atomic step (remark upvalues of dead threads, re-mark barriers, weak-table clearing, white flip), string/root sweeping, finalizer separation and execution (`luaC_separateudata`, `GCTM`, `luaC_callGCTM`), incremental stepping with pause/stepmul debt accounting (`luaC_step`), full collection (`luaC_fullgc`), write barriers (`luaC_barrierf/barrierback`), object linking, and state teardown (`luaC_freeall`).

## API
```c
size_t luaC_separateudata (lua_State *L, int all);
void   luaC_callGCTM (lua_State *L);     /* drain tmudata, run __gc */
void   luaC_freeall  (lua_State *L);     /* close-state sweep */
void   luaC_step     (lua_State *L);
void   luaC_fullgc   (lua_State *L);
void   luaC_link     (lua_State *L, GCObject *o, lu_byte tt);
void   luaC_linkupval(lua_State *L, UpVal *uv);
void   luaC_barrierf (lua_State *L, GCObject *o, GCObject *v);
void   luaC_barrierback (lua_State *L, Table *t);
/* internals: markroot/atomic/singlestep/sweeplist/freeobj/traverse*/
```

## Usage
- Driven by `luaC_checkGC` sprinkled through VM/API allocation paths; Roblox's LuaMemory module observes totals via `lua_gc(COUNT)` which reads the same `global_State` fields this file maintains.
- Finalizers (`__gc`) run from `luaC_callGCTM` between normal VM steps — Roblox bridge userdata rely on ordering here.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`GCTM` honors a NEW `Udata::may_gc` flag** (`// ROBLOX:`): if false, returns before invoking the `__gc` metamethod (the udata has already been relinked/whitened, so it just skips finalization). Lets the engine pin bridge objects (e.g. during shutdown or script-held instances) from being finalized. Setters RESOLVED via repo-wide grep: `may_gc` is set true only at creation (lstring.c:107) and false in exactly one place — `luaB_newproxy` (lbaselib.c:437); engine code relies on that default.
2. Everything else is byte-for-byte stock 5.1.4 collector logic.

## Gotchas
- `__gc` runs with hooks disabled and GCthreshold doubled — errors inside finalizers are UNPROTECTED in stock flow (they propagate via luaD_throw into whatever protected frame ran the step); Roblox's may_gc bypass exists partly to avoid this class of crash.
- Sweeping assumes single-threaded mutator; ScriptContext must hold its VM lock across any step.
- Weak tables clear keys/values only at atomic time — resurrection races (finalizer storing into weak table) are stock hazards.

