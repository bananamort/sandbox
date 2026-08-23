# INDEX — App/Lua-5.1.4/src

## Module purpose

This directory is a **Roblox-modified copy of the Lua 5.1.4 virtual machine** — the complete C core that executes every script in the 2016 engine working copy: the object model (`lobject*`), states and stacks (`lstate`, `ldo`), the obfuscated bytecode interpreter (`lvm` + `lopcodes*`), parser/codegen for trusted compile contexts (`llex/lparser/lcode`), the incremental GC (`lgc`), tables/strings/functions internals (`ltable/lstring/lfunc`), the C API surface Roblox bridges call into (`lapi/lauxlib`), stdlibs selectively opened per security identity (`lbaselib/lstrlib/ltablib/lmathlib/liolib/loslib/ldblib/loadlib/linit`), binary chunk dump/load (`ldump/lundump`), and standalone tools (`lua/luac/print`). The execution pipeline is: ScriptContext creates one `global_State` per `Security::Identity` VM slot → assigns the per-VM opcode key `global_State::ckey` (LuaVMValue-wrapped, keys from App/include/script/LuaVM.h: internal-core encode 641 / decode 6700417, dummy 1, invalid 0) → text compiles only on internal-core VMs (whole parser guarded `LUAVM_COMPILER`; client `luaY_parser` stubbed to throw) → compiled protos ship through the ENGINE serializer (`LuaSerializer.inl` + `rbxDaxEncode`); the in-tree `ldump.c`/`lundump.c` pair compiles only under non-secure builds, `lua_load` dispatches to `luaY_parser` unconditionally (no binary sniff anywhere), so neither dump nor undump is on any runtime path → `luaV_execute` partial-decodes each fetch with `rbxDecodeOpPartial` then fully decodes operands with `rbxDecodeOp`/`rbxDecodeOpFast` under the thread's `ckey`. Security hardening is layered throughout: `LUAVM_SECURE` strips disassembly/dump/load tooling and enables lineinfo encoding (`finalize()` at compile time, `getline` decode at runtime); readonly-table enforcement guards lapi.c/lvm.c write paths; `lua_tolstringsecure` detects tampered string hashes; `lua_chk_ptr_rblx`/TEB checks detect hooked VMs; pattern-matcher depth limiting defuses regex-style DoS; tail calls are disabled at the parser; and the entire debug library is compiled out.

## File roster

| File | Doc | One-line role |
|---|---|---|
| lua.h | lua.h.md | Public C API declarations (+ Roblox hook/error-mask additions) |
| luaconf.h | luaconf.h.md | Build config: RobloxExtraSpace, LUAVM_SHUFFLE*, LuaVMValue, decode macros |
| lualib.h | lualib.h.md | Stdlib opener declarations |
| llimits.h | llimits.h.md | Type limits, LUAI_MAX* bounds |
| lobject.h | lobject.h.md | TValue/GCObject/Proto/Closure/Udata(+may_gc,readonly)/Table structs |
| lopcodes.h | lopcodes.h.md | Opcode enum, InstructionV container, rbxDecodeOp* macro family |
| lstate.h | lstate.h.md | lua_State/global_State incl. ckey, CallInfo w/ InstructionV savedpc |
| lapi.h / lapi.c | …md | Core-internal push helper / full C API impl + setreadonly/tolstringsecure/hook tripwires |
| ldo.h / ldo.c | …md | Call-stack machinery; lua_exception C++ bridge; resume() keyed asserts + C-call bail |
| lvm.h / lvm.c | …md | Interpreter header / obfuscated dispatch loop, encoding check kill-switch |
| lgc.h / lgc.c | …md | GC header / collector; GCTM honors Udata::may_gc |
| lmem.c/.h | …md | Allocation wrappers over frealloc |
| lstring.c/.h | …md | String interning + newudata |
| ltable.h / ltable.c | …md | Table header / array+hash implementation, luaH_new zeroes readonly |
| ltm.c/.h | …md | Metamethod cache + fasttm |
| lfunc.h / lfunc.c | …md | Closure/upvalue/proto lifecycle |
| lzio.c/.h | …md | Buffered input streams |
| llex.h / llex.c | …md | Lexer header / scanner (getlocaledecpoint) |
| lparser.h / lparser.c | …md | Parser structures / grammar; LUAVM_COMPILER-gated, tail calls off, finalize() encodes lines |
| lcode.h / lcode.c | …md | Codegen header (.v backpatching) / emitter, also compiler-only |
| lopcodes.c | lopcodes.c.md | Opname/opmode tables; SHUFFLE-wrapped, names stripped when secure |
| ldebug.h / ldebug.c | …md | Debug header (DECODELINE getline, checkcode+ckey) / hooks, symbexec verifier, LUA_HOOKERROR |
| lauxlib.h / lauxlib.c | …md | Aux header (RBX fwd decl) / luaL_* incl. roblox_typename anti-spoof |
| lundump.h / lundump.c | …md | Chunk-format decls / loader reading InstructionV, checkcode(f,0), secure-stripped |
| ldump.c | ldump.c.md | Chunk serializer (secure builds emit header only) |
| print.c | print.c.md | Disassembler (secure-stripped, reads code[pc].v) |
| linit.c | linit.c.md | luaL_openlibs aggregator (unused by engine) |
| lbaselib.c | lbaselib.c.md | Base/coroutine libs; collectgarbage count-only, newproxy may_gc=false + arg-restricted |
| lstrlib.c | lstrlib.c.md | String lib; matchdepth-limited pattern engine behind DFFlag |
| ltablib.c | ltablib.c.md | table.* — stock |
| lmathlib.c | lmathlib.c.md | math.* — stock |
| liolib.c | liolib.c.md | io.* — stock, not opened in engine |
| loslib.c | loslib.c.md | os.* — stock, not opened in engine |
| ldblib.c | ldblib.c.md | debug library fully #if 0'd; luaopen_debug registers nothing |
| loadlib.c | loadlib.c.md | package/require native loader — stock, not opened in engine |
| lua.c | lua.c.md | Standalone interpreter main() |
| luac.c | luac.c.md | Compiler CLI; combine() uses plain Instruction |

(REMAINING: none — all 55 sources have docs.)

## Ranked Roblox-vs-stock delta list

Highest-impact modifications for graft review (Luau upstream comparison), ranked by blast radius:

1. **Per-VM opcode keying (`ckey` + `InstructionV`)** — lstate.h (new `global_State::ckey`), lopcodes.h (`rbxDecodeOp/rbxDecodeOpPartial/rbxDecodeOpFast/rbxDecodeFakeOp`), lvm.c (fetch loop rework, win32 kill-switch `ckey+2<4`), ldebug.c (symbexec/checkcode take key), lundump.c (loads `InstructionV`), ldump.c, lparser.c/lcode.c (`.v` member access). Every instruction read/write in the tree flows through this.
2. **Encoded lineinfo** — lparser.c `finalize()` (`LUAVM_ENCODELINE`) under LUAVM_SECURE + ldebug.h `getline` (`LUAVM_DECODELINE`). Stack traces and activelines depend on paired encode/decode.
3. **Parser gated off runtime clients** — lparser.c & lcode.c wholly inside `#ifdef LUAVM_COMPILER`; client text compilation impossible by construction.
4. **Tail calls disabled** — lparser.c retstat `&& false` (comment "ROBLOX: disable tail calls"); recursion semantics differ from stock.
5. **Readonly tables** — new `Table::readonly`; enforcement in lapi.c (`setreadonly`, rawset/rawseti/setmetatable errors) and lvm.c `luaV_settable` (which mutates before erroring — latent quirk).
6. **C++ exception interop** — ldo.c `lua_exception` class (copy-commit semantics, un-commits swallowed errors); pairs with luaconf.h LUAI_TRY/THROW definitions; RAII now runs during error unwinding.
7. **Udata::may_gc finalizer suppression** — lobject.h field; lgc.c GCTM early-return; lbaselib.c newproxy sets false on every user proxy (user __gc never runs).
8. **Security telemetry/tripwires** — lapi.c `lua_tolstringsecure` hash verification + HATE_LUA_HASH_CHANGED stat; `lua_chk_ptr_rblx` on pushcclosure/f_call/f_Ccall return addresses; lvm.c TEB exception-chain DLL detection setting hackFlag8/HATE_SEH_CHECK; `lua_rbx_encoding_check` weaponizing OP_MOVE's C operand.
9. **New hook event LUA_HOOKERROR/LUA_MASKERROR** — ldebug.c errormsg fires error hooks before errfunc (DebuggerManager dependency).
10. **Library neutering by omission** — ldblib.c entirely `#if 0`; collectgarbage restricted to "count"; newproxy restricted to nil/true; io/os/package simply never opened into script VMs (caller-side policy).
11. **Pattern-matcher depth limit** — lstrlib.c matchdepth threading + DFFlag `LuaStrlibLimitMatchDepth` (default true), fixes stock's unbounded recursion DoS.
12. **Build-shuffle obfuscation of static data** — lopcodes.c SHUFFLE blocks; struct-field shuffles via luaconf.h LUAVM_SHUFFLE* (see lstate.h.md).
13. **Engine coupling includes** — FastLog/V8DataModel/HackDefines/ApiSecurity/ProtectedString pulled into core files (lapi.c, lvm.c, ldo.c, lbaselib.c, lstrlib.c, lauxlib.*, llex.c getlocaledecpoint).
14. **resume() C-call bail-out** — ldo.c early-return when resuming a thread whose only frame is a C call (stock would enter luaV_execute).
15. **Tool stripping under LUAVM_SECURE** — ldump.c dumps header only, lundump.c loader absent, print.c absent, opnames absent; luac.c combine() type mismatch (plain Instruction vs InstructionV).

Cross-cutting stock-behavior notes worth keeping during any Luau graft: `luaO_pushvfstring` format subset, locale decimal-point lexing, weak-table clearing only at atomic GC time, string hashing shared across VMs, `lua_resume` marking threads dead on error, and pairs/next iteration order guarantees.

## RESOLVED: semantics of `rbxDecodeOp` with key 0 (was writer's open question)

Resolved against source text (lopcodes.h + lundump.c + ldebug.c + lvm.c + LuaVM.h):

1. **Keyed configuration** (`LUAVM_SECURE && !RBX_RCC_SECURITY`, lopcodes.h:301): `rbxDecodeOp(InstructionV i, pcRel, ckey) = rbxDecodeArgs(i.v * ckey, pcRel)`. With **ckey == 0**, `i.v * 0 == 0` for every input, so every instruction word decodes to the constant 0. Under the fixed secure shuffle (LuaVM.h SHUFFLE9 emits `a2,a6,a4,a7,a1,a8,a0,a3,a5`), opcode value 0 is OP_LOADBOOL — never one of the four DAX-protected opcodes — so `rbxDecodeArgs` returns 0 unchanged. Decode-with-key-0 is therefore a constant map that validates nothing; `ldebug.c precheck`'s last-instruction-must-be-OP_RETURN test fails for ANY chunk.
2. **Why `lundump.c` can still pass key 0**: its entire loader is wrapped in `#ifndef LUAVM_SECURE` (lundump.c:23–211), i.e. it exists ONLY where lopcodes.h compiles the identity-passthrough decoder branch (`#else`: all rbxDecode* ignore their arguments and return the raw word). In those builds the `0` in `IF (!luaG_checkcode(f, 0), "bad code")` (lundump.c:178) is inert and validation runs on plaintext structure. The two configurations never coexist, so key-0 keyed decoding is unreachable dead behavior. (`LUAC_TRUST_BINARIES` additionally strips the checks entirely when defined.)
3. **Live interpreter guard**: `luaV_execute` refuses degenerate keys outright on Win32 optimized configs — `if (ckey+2 < 4) break;` (lvm.c:411) stops dispatch for `LUAVM_KEY_INVALID 0` and `LUAVM_KEY_DUMMY 1`; other builds only have `lua_assert(ckey)`.
4. **Contrast**: real chunk verification with live keys happens engine-side in `App/script/LuaSerializer.inl:333` — `luaG_checkcode(p, L->l_G->ckey)` — after deserialization, and the encoder restores plaintext opcodes BEFORE multiplying by the key inverse (see `rbxDaxEncode` in LuaVMDummy.cpp), which is why `rbxDecodeOpPartial` already yields a readable opcode field.

Bottom line: "lundump validates with key 0" vs "LuaSerializer uses the live ckey" is not a conflict — they run in mutually exclusive build configurations; key 0 is meaningful only as an inert placeholder in identity-decode builds and would reject everything if ever used under keyed decoding.
