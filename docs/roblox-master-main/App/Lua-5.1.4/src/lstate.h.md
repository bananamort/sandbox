# App/Lua-5.1.4/src/lstate.h

## Purpose
Defines `lua_State` (per-thread), `global_State` (shared per VM), `CallInfo`, `stringtable`, the `GCObject` union and cast macros (`$Id: lstate.h,v 2.24.1.2`). **Roblox hotspot**: this is where the per-VM bytecode key lives (`global_State::ckey`) and where `InstructionV` replaces `Instruction` throughout call-state bookkeeping. Roblox instantiates multiple `global_State`s — one per `Security::Identity` VM slot — each with its own `ckey`.

## API
Constants: `EXTRA_STACK 5`, `BASIC_CI_SIZE 8`, `BASIC_STACK_SIZE (2*LUA_MINSTACK)`; helpers `gt(L)`, `registry(L)`, `curr_func/ci_func/f_isLua/isLua`.

```c
typedef struct stringtable { LUAVM_SHUFFLE3(;, GCObject **hash, lu_int32 nuse, int size); } stringtable;

typedef struct CallInfo { LUAVM_SHUFFLE6(;,
  StkId base, func, top,
  const InstructionV *savedpc,     /* ROBLOX: was const Instruction* */
  int nresults, tailcalls); } CallInfo;

typedef struct global_State {
  stringtable strt;
  LUAVM_SHUFFLE2(;, lua_Alloc frealloc, void *ud);
  LUAVM_SHUFFLE2(;, lu_byte currentwhite, gcstate);
  LUAVM_SHUFFLE8(;,
    LuaVMValue<unsigned int> ckey,   /* ROBLOX NEW: per-VM opcode decode key */
    int sweepstrgc, GCObject *rootgc, *sweepgc, *gray, *grayagain, *weak, *tmudata);
  Mbuffer buff;
  LUAVM_SHUFFLE7(;, lu_mem GCthreshold, totalbytes, estimate, gcdept;
                    int gcpause, gcstepmul; LuaVMValue<lua_CFunction> panic);
  LUAVM_SHUFFLE5(;, TValue l_registry, lua_State *mainthread, UpVal uvhead,
                    Table *mt[NUM_TAGS], LuaVMValue<TString *> tmname[TM_N]);
} global_State;

struct lua_State {
  CommonHeader; lu_byte status;
  LUAVM_SHUFFLE7(;, StkId top, base; LuaVMValue<global_State*> l_G; CallInfo *ci;
                    LuaVMValue<const InstructionV*> savedpc; StkId stack_last, stack);
  LUAVM_SHUFFLE4(;, CallInfo *end_ci, *base_ci; int stacksize, size_ci);
  LUAVM_SHUFFLE2(;, unsigned short nCcalls, baseCcalls);
  LUAVM_SHUFFLE2(;, lu_byte hookmask, allowhook);
  LUAVM_SHUFFLE9(;, int basehookcount, hookcount; lua_Hook hook;
                    TValue l_gt, env; GCObject *openupval, *gclist;
                    struct lua_longjmp *errorJmp; ptrdiff_t errfunc);
};
```
`G(L) (L->l_G)` (decodes through `LuaVMValue`). `union GCObject { GCheader gch; TString ts; Udata u; Closure cl; Table h; Proto p; UpVal uv; lua_State th; }` + casts `gco2ts/u/cl/h/p/uv/th`, `rawgco2ts/u`, `ngcotouv`, `obj2gco`. Functions: `lua_State *luaE_newthread(lua_State*)`, `void luaE_freethread(lua_State*, lua_State*)`.

## Usage
- `ScriptContext.cpp` reaches directly into these fields: `state->l_G->ckey = scriptKey;` (line ~931), `itr->state->l_G->ckey = LUAVM_KEY_DUMMY;`, `... = LuaVM::getKeyCore();` — i.e., the engine re-keys a whole VM by assigning `ckey`.
- `LuaSerializer.inl` reads `L->l_G->ckey` for `luaG_checkcode(p, L->l_G->ckey)`.
- Keys defined in `App/include/script/LuaVM.h`: `LUAVM_INTERNAL_CORE_ENCODE_KEY 641`, `LUAVM_INTERNAL_CORE_DECODE_KEY 6700417`, `LUAVM_KEY_DUMMY 1`, `LUAVM_KEY_INVALID 0`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **NEW `global_State::ckey`** (`LuaVMValue<unsigned int>`, SHUFFLE8 block) — the multiplicative opcode key used by `rbxDecodeOp`/`luaG_checkcode`; zero-initialized in `lua_newstate` (= `LUAVM_KEY_INVALID`).
2. `CallInfo::savedpc` type changed `const Instruction*` → **`const InstructionV*`**; `lua_State::savedpc` likewise wrapped as `LuaVMValue<const InstructionV*>` — every PC save/restore in the VM now carries obfuscated instructions.
3. `panic`, `l_G`, `tmname[]`, `strt`, `CallInfo`, `lua_State` field groups all wrapped in `LUAVM_SHUFFLE*` (build-specific layout).
4. Everything else (GC lists, uvhead ring, LG layout, EXTRASPACE mechanics) matches stock 5.1.4 semantics.

## Gotchas
- A thread created under one `global_State` can never migrate to another: `l_G` is set at birth and `ckey` differs per state, so bytecode decoded for one VM faults in another.
- `g->ckey == 0` means "no valid key" (`LUAVM_KEY_INVALID`); 1 is `LUAVM_KEY_DUMMY`. On Win32 optimized builds `luaV_execute` refuses such states outright — `if (ckey+2 < 4) break;` exits the dispatch loop after the first fetch (falling into the end-of-loop SEH tripwire and returning), so execution silently stops rather than corrupting dispatch; other configurations only have a debug `lua_assert(ckey)`. Roblox sets real keys only after ProtectedString load decisions.
- Because `savedpc` points into `Proto::code` (obfuscated), stack dumps must decode via the same `ckey` before printing opcodes (`print.c`/`luac.c` are build tools operating on plaintext assumptions).
