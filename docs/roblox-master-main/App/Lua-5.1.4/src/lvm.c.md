# App/Lua-5.1.4/src/lvm.c

## Purpose
The bytecode interpreter ($Id: lvm.c,v 2.63.1.3): coercions (`luaV_tonumber/tostring`), metamethod dispatch helpers (`callTM/callTMres/call_binTM/get_compTM/call_orderTM`), `__index`/`__newindex` chain walkers with MAXTAGLOOP guard (`luaV_gettable/settable`), equality/ordering (`luaV_equalval/lessthan/lessequal`), string concat engine (`luaV_concat`), arithmetic fallback (`Arith`), and `luaV_execute` — the fetch-decode-execute main loop over all 38 opcodes including calls, tailcalls, coroutine yield points, for-loops, closures, and varargs.

## API
```c
const TValue *luaV_tonumber (const TValue*, TValue*);
int   luaV_tostring (lua_State*, StkId);
void  luaV_gettable (lua_State*, const TValue *t, TValue *key, StkId val);
void  luaV_settable (lua_State*, const TValue *t, TValue *key, StkId val);
int   luaV_lessthan/equalval (...);
void  luaV_concat   (lua_State*, int total, int last);
void  luaV_execute  (lua_State*, int nexeccalls);

/* ROBLOX internal */
static FORCEINLINE void lua_rbx_encoding_check(lua_State* L, Instruction i);
```

## Usage
- Entered from `luaD_call`/`resume`; runs until RETURN of the outermost exec call or a yield. Every script instruction executed by the engine passes through the obfuscated dispatch described below — this file is THE reference for how `ckey`, `InstructionV`/`InstructionP`, and `rbxDecodeOp*` interlock (macros defined in lopcodes.h.md).

## Roblox modifications (vs stock Lua 5.1.4)
1. **Engine includes**: `"security/ApiSecurity.h"`, `"v8datamodel/HackDefines.h"`.
2. **NEW `lua_rbx_encoding_check`** (comment `/* roblox: ... detect injected bytecode */`): after OP_MOVE, in non-studio/non-RCC/non-test builds, executes `L->top = GETARG_C(i) ? L->top : L->base;` — weaponizes the normally-unused C operand of MOVE so tampered bytecode collapses the stack instead of running cleanly.
3. **Main-loop fetch fully reworked**: locals `const InstructionV *pc; unsigned int ckey = L->l_G->ckey; InstructionV* pcBase = cl->p->code;`. Each iteration computes `pcRel = pc - pcBase`, partial-decodes `iOp = rbxDecodeOpPartial(*pc++, ckey)` (opcode field only), then each case fully decodes `rbxDecodeOp(iOp, pcRel, ckey)`. Stock fetched plain `Instruction i = *pc++` with no keying.
4. **Win32-optimized kill-switch** (guarded `_WIN32 && !_DEBUG && !_NOOPT && !RBX_TEST_BUILD && !RBX_RCC_SECURITY && !RBX_STUDIO_BUILD && !LOVE_ALL_ACCESS && !RBX_PLATFORM_DURANGO`): `if (ckey+2 < 4) break;` — invalid (0) or dummy (1) keys abort interpretation mid-loop.
5. **Jump-target decoding**: EQ/LT/LE/TEST/TESTSET and TFORLOOP's back-jump read the NEXT instruction through `rbxDecodeOpFast(*pc, ckey)`; SETLIST's overflow count through `rbxDecodeFakeOp(*pc++, ckey)`; OP_RETURN's debug assert decodes `(ci)->savedpc - 1` — i.e. pseudo-instructions following comparison ops are also encoded.
6. **`luaV_settable` readonly enforcement** (`// ROBLOX`): raises `"Attempt to modify a readonly table"` when `h->readonly` — but AFTER `luaH_set(L,h,key)` has already run (see Gotchas).
7. **End-of-interpreter tripwire**: after loop exit (incl. the kill-switch break), Win32 optimized builds run `RBX::detectDllByExceptionChainTeb<2>(RBX::Security::kCheckDefault)` and on hit call `RBX::Security::setHackFlagVs<0>(RBX::Security::hackFlag8, HATE_SEH_CHECK)` (comment `// added to counter an exploit.`).
8. `traceexec` signature changed to take `const InstructionV*`; `L->savedpc` is encoded throughout.
9. Opcode semantics otherwise identical to stock 5.1.4 (same register windows, same result placement, same PCRYIELD returns from CALL/TAILCALL).

## Gotchas
- **Readonly settable mutates before erroring**: `luaH_set` inserts the key slot (value nil) BEFORE the readonly check throws — repeated violations grow the table's hash part even though no value is ever written.
- A wrong `ckey` does not trap immediately: partial decode selects the opcode case first; wrong keys usually land in `default:` (silent skip, infinite loops possible) or fault later on garbage operands — debugging requires decoding with the true key.
- The interpreter caches `ckey` at function entry (`reentry`); ScriptContext's re-keying between loads must not race an executing thread or stale-key execution results.
- Hooks can YIELD inside `traceexec` (`L->status == LUA_YIELD` return path) — the DebuggerManager pause machinery depends on this exact window; do not "optimize" it away during graft review.

