# App/Lua-5.1.4/src/ldo.c

## Purpose
Stack and call structure ($Id: ldo.c,v 2.38.1.3): error-recovery (longjmp chain `lua_longjmp`, `luaD_throw/rawrunprotected/pcall/seterrorobj`), stack/CallInfo growth with pointer fixup (`reallocstack/reallocCI/growstack/correctstack`), call hooks, vararg adjustment, `__call` fallback (`tryfuncTM`), the call core (`luaD_precall` returning PCRLUA/PCRC/PCRYIELD, `luaD_poscall` result placement, `luaD_call` with C-stack depth guard), coroutine primitives (`lua_resume/lua_yield`, static `resume`), and the protected parser wrapper.

## API
```c
void luaD_seterrorobj (lua_State *L, int errcode, StkId oldtop);
void luaD_reallocstack/LuaD_reallocCI/growstack (...);
void luaD_callhook (lua_State *L, int event, int line);
int  luaD_precall (lua_State *L, StkId func, int nresults);   /* PCRLUA/PCRC/PCRYIELD */
int  luaD_poscall (lua_State *L, StkId firstResult);
void luaD_call    (lua_State *L, StkId func, int nResults);
int  luaD_pcall   (lua_State *L, Pfunc f, void *u, ptrdiff_t old_top, ptrdiff_t ef);
void luaD_throw   (lua_State *L, int errcode);
int  luaD_rawrunprotected (lua_State *L, Pfunc f, void *ud);
int  lua_resume   (lua_State *L, int nargs);   /* LUA_API */
int  lua_yield    (lua_State *L, int nresults);/* LUA_API, returns -1 */
int  luaD_protectedparser (lua_State *L, ZIO *z, const char *name);
```

## Usage
- `ScriptContext::resumeImpl` → `lua_resume` → `resume()` → `luaV_execute`; every bridge pcall funnels through `luaD_pcall`. Yield rules: `lua_yield` errors across C-call boundaries (`nCcalls > baseCcalls`) — the constraint Continuations/DebuggerManager work around by yielding from hooks.
- `luaD_precall` C-branch returns PCRYIELD when a CFunc returns negative — how `wait()`-style yields suspend exactly one frame.
- Parser entry: `f_parser` here ALWAYS calls `luaY_parser` (no binary sniff); binary-chunk dispatch happens upstream in this tree (see lapi.c.md / LuaVMServer.cpp text-path notes).

## Roblox modifications (vs stock Lua 5.1.4)
1. **`#include "FastLog.h"`** — engine logging dependency added.
2. **NEW `class lua_exception : public std::exception`** (marked `// ROBLOX`): friends of `luaD_throw`/`luaD_rawrunprotected`; carries `(L, errorJmp)` with copy-commit semantics — `what()` reads `lua_tostring(L,-1)`, destructor un-commits (reverts `errorJmp->status=0`, pops message) if a C++ handler swallowed it before Lua saw it. This is the bridge that lets engine C++ catch script errors as real exceptions (paired with Roblox's `LUAI_TRY/LUAI_THROW` definitions — see luaconf.h.md).
3. **`resume()` decodes instructions in its assert**: `GET_OPCODE(rbxDecodeOpPartial(*((ci-1)->savedpc - 1), L->l_G->ckey).p) == OP_CALL || OP_TAILCALL` — stock asserts raw `GET_OPCODE`. Proves savedpc under Roblox holds ENCODED InstructionV even mid-call.
4. **`resume()` early-bail (comment `// ROBLOX`)**: when resuming a thread whose only frame was a C call (`isFirstCall`), return after `poscall` instead of entering `luaV_execute` — stock would call execute unconditionally.
5. **`f_parser` drops the binary/text branch**: calls `luaZ_lookahead` but discards the result (`// TODO: This line can probably be removed safely`) and always invokes `luaY_parser`; stock selects `luaU_undump` vs `luaY_parser` on the sniffed byte.
6. Vararg `arg`-table compat block retained behind `LUA_COMPAT_VARARG`.

## Gotchas
- With the C++-exception path, a script error unwinds through engine frames like any C++ exception — RAII in bridge code runs during error propagation (unlike longjmp builds); code assuming no-unwind semantics breaks.
- `lua_resume` marks the thread dead on ANY nonzero status; Roblox's sandboxThread cloning exists partly because dead threads are unusable afterwards.
- `luaD_pcall` restores `savedpc` from restored `ci` — under Roblox that value is encoded, so post-error traces must decode with current `ckey`.
- `tryfuncTM` opens a stack hole and can trigger GC via metamethod lookup — callers cache `funcr` offsets for this reason.

