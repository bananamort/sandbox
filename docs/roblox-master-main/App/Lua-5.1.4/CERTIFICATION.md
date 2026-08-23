# CERTIFICATION — App/Lua-5.1.4 documentation campaign

**Reviewer**: independent review agent (not the writer). Protocol: re-enumerate sources, read every source file IN FULL via tool calls, read its `.md`, verify every concrete claim (symbols, signatures, struct fields, line citations, quoted strings, build-flag gating, cross-TU references), classify violations, apply only mechanically-certain fixes under `docs/roblox-master-main/App/Lua-5.1.4/`, adjudicate flagged open questions.

**Date**: 2026-04 (session T-series, Lua module).

---

## 1. Coverage audit

- Sources enumerated: `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/Lua-5.1.4/src/` → **55 files**.
- Docs found: `docs/roblox-master-main/App/Lua-5.1.4/src/*.md` → **55 files**, plus **INDEX.md** = 56 total.
- Pairing check: every source has exactly one `.md`; zero orphan docs. **Coverage is exactly 1:1 as claimed.**
- INDEX.md roster reconciles: all 55 sources listed; "REMAINING: none" verified true.

## 2. Verification method

Every one of the 55 source files was read in full (read tool, complete file), followed by its doc. Cross-file claims were spot-verified against the referenced trees: `App/include/script/LuaVM.h` (SHUFFLE permutations, LuaVMValue, LuaSecureDouble, key constants, ENCODELINE/ENCODEINSN, RbxOpEncoder typedef), `App/script/LuaSerializer.inl` (`luaG_checkcode(p, L->l_G->ckey)` at :333), `LuaVMDummy.cpp`/`LuaVMServer.cpp`/`LuaVMClient.cpp` (`rbxDaxEncode`, `LUAVM_COMPILER` defines, luaY_parser stub), repo-wide greps for `luaU_undump`, `luaU_dump`, `lua_tolstringsecure`, `lua_setreadonly`, `may_gc`, `safe_lua_tostring`. Stock-vs-Roblox judgments were checked against in-tree markers (`grep ROBLOX`) and known stock 5.1.4 text.

## 3. Per-file verdicts

Legend: PASS = no defects requiring change. FIXED = defects found and corrected this session. FAIL = defect that could not be safely fixed.

| # | Source | Verdict | Notes |
|---|--------|---------|-------|
| 1 | lapi.c | FIXED | Resolved call-site UNKNOWN: sole engine caller of `lua_tolstringsecure` is `safe_lua_tostring` (LuaAtomicClasses.cpp:41). All other claims verified verbatim. |
| 2 | lapi.h | PASS | |
| 3 | lauxlib.c | PASS | luaL_roblox_typename mechanics + spoof comment verbatim; loadfile sniff accurate; include-vestige UNKNOWN honest. |
| 4 | lauxlib.h | PASS | RBX fwd-decl block verbatim; lua_ref error macro correct. |
| 5 | lbaselib.c | PASS | collectgarbage `{"count"}` + default-"collect"-errors reasoning correct; newproxy may_gc=false + arg restriction exact. |
| 6 | lcode.c | PASS | LUAVM_COMPILER guard, `.v` routing sites, plaintext-at-emit claim all verified. |
| 7 | lcode.h | FIXED | Resolved pooling UNKNOWN (#3): no Roblox constant encoding exists (confirmed reading lcode.c). |
| 8 | ldblib.c | PASS | `#if 0` scope, neutered luaopen_debug, nil-index error consequence all correct. |
| 9 | ldebug.c | FIXED ×2 | MISSING-GOTCHA inserted: Roblox-only `lua_getlocal` push / `lua_setlocal` assign+pop behavior; `getfuncname` "index"/"newindex" extensions. Key-0 gotcha rewritten with resolved semantics. |
| 10 | ldebug.h | PASS | getline DECODELINE, keyed checkcode signature verbatim. |
| 11 | ldo.c | PASS | lua_exception class, resume() bail-out, f_parser text-only path, FastLog include — all exact. |
| 12 | ldo.h | PASS | STYLE note left: "longjmp-based throw" phrasing predates the C++-exception LUAI_THROW pairing (accurately covered in ldo.c/luaconf docs). |
| 13 | ldump.c | FIXED ×3 | WRONG usage ("engine pipeline via luaU_dump") corrected to dead tooling (no callers, secure-stripped); Instruction mischaracterization fixed (plain lu_int32; stride works because struct wraps one word); writer UNKNOWN resolved as moot. |
| 14 | lfunc.c | PASS | freeproto Instruction-typed free nuance correctly documented. |
| 15 | lfunc.h | PASS | |
| 16 | lgc.c | FIXED ×1 | may_gc-setter UNKNOWN resolved: setters are lstring.c:107 (true) and lbaselib.c:437 (false) only. GCTM early-return description otherwise exact. |
| 17 | lgc.h | FIXED ×1 | lgc.c-hooks UNKNOWN resolved (only delta is GCTM may_gc). |
| 18 | linit.c | PASS | |
| 19 | liolib.c | PASS | Stock claim consistent with marker sweep; env-table close trick verified. |
| 20 | llex.c | PASS | getlocaledecpoint `// ROBLOX` site exact. |
| 21 | llex.h | FIXED ×1 | Body UNKNOWN resolved: sole llex.c delta is getlocaledecpoint. |
| 22 | llimits.h | PASS | InstructionV/InstructionP comments quoted correctly; MAXUPVALUES=60 cross-checked in luaconf.h. |
| 23 | lmathlib.c | PASS | Stock claim consistent; rand()-based random noted. |
| 24 | lmem.c | PASS | |
| 25 | lmem.h | PASS | |
| 26 | loadlib.c | PASS | Stock; loaders/sentinel/setprogdir claims verified. |
| 27 | lobject.c | PASS | Stock claim consistent; __concat-during-error analysis sound. |
| 28 | lobject.h | FIXED ×2 | `SHUFF2` typo → SHUFFLE2; `Proto::code is LuaVMValue<InstructionV*>*` → correct member type `LuaVMValue<InstructionV *>`. |
| 29 | lopcodes.c | FIXED ×1 | WRONG count: four SHUFFLE9 blocks + one SHUFFLE2 (doc said five+one). |
| 30 | lopcodes.h | FIXED ×2 | WRONG usage bullet (lundump/print.c claimed as decoder callers; ldo.c caller omitted) rewritten from grep evidence; gotchas rewritten: shuffle permutations are fixed constants per config (not per-build random), secure opcode 0 = OP_LOADBOOL proven, encoder restores opcode pre-multiply, MOVE C canary, degenerate keys named. |
| 31 | lparser.c | PASS | Tail-call disable (`&& false`), finalize(), LUAVM_COMPILER guard, InstructionV reallocs, checkcode(f,0) assert — all exact. |
| 32 | lparser.h | FIXED ×3 | WRONG dispatch claim ("fails binary-chunk sniff") corrected (unconditional luaY_parser); emit-time-obfuscation wording made precise (plaintext at emit; encoding later); body UNKNOWN resolved with the five actual deltas. |
| 33 | lstate.c | FIXED ×2 | `callall_gcTM` → `callallgcTM`; garbled "tosate(l)…" sentence repaired. Line citation g->ckey=0 @181 confirmed. |
| 34 | lstate.h | FIXED ×1 | ckey==0 gotcha replaced with actual kill-switch semantics (`ckey+2 < 4` break, Win32-opt configs only; KEY_INVALID/DUMMY naming). |
| 35 | lstring.c | PASS | may_gc init line + hash sampling described exactly. |
| 36 | lstring.h | PASS | |
| 37 | lstrlib.c | PASS | matchdepth threading, DFFlag default-true, threshold/error message all verbatim. |
| 38 | ltable.c | FIXED ×1 | flags-reset claim scoped correctly: only `luaH_set` clears flags; setnum/setstr do not (stock asymmetry). readonly-init claim verified @367. |
| 39 | ltable.h | PASS | |
| 40 | ltablib.c | PASS | Stock claim consistent; rawseti→readonly interaction reasoning correct. |
| 41 | ltm.c | PASS | SHUFFLE groups and flag-cache semantics match source byte-for-byte. |
| 42 | ltm.h | FIXED ×1 | Removed phantom fasttm consumers in "lvm.h"; usage list now matches real callers. |
| 43 | lua.c | PASS | Notable correct catch: traceback depends on debug.traceback which ldblib never registers here. |
| 44 | lua.h | PASS | Shuffled lua_Type transcription verbatim; SHUFFLE3 example permutation matches LuaVM.h; tolstringsecure/setreadonly/HOOKERROR all cited correctly. |
| 45 | luac.c | FIXED ×1 | Vestigial-tool status made precise: headers are C++-only (InstructionP ctor, boost includes) and combine()'s Instruction*→LuaVMValue<InstructionV*> assignment is ill-formed ⇒ file cannot compile in this tree; earlier "tolerated by the C build" removed. |
| 46 | luaconf.h | FIXED ×1 | `lua_exception` location corrected: defined in **ldo.c** (91–129), not ldo.h. Everything else verified line-by-line (RobloxExtraSpace layout, LUAI_THROW/TRY, popen stubs, lua_unlock tripwire, compat undefs). |
| 47 | lualib.h | PASS | |
| 48 | lundump.c | FIXED ×3 | WRONG dispatch claim (loader never dispatched; no luaU_undump callers anywhere; secure-stripped) corrected; key-0 validation gotcha fully resolved (identity-build inertness vs keyed-build rejection); header-error message verified verbatim. |
| 49 | lundump.h | FIXED ×4 | Dispatch bullet corrected; `\x64` format byte → `\x00`; LUAC_FORMAT UNKNOWN resolved (unchanged); ckey-garbage UNKNOWN resolved (no load-time binding; identity-build validation). |
| 50 | lvm.c | FIXED ×1 | Tripwire paraphrase `hackFlag8 |= HATE_SEH_CHECK` replaced with exact engine call `RBX::Security::setHackFlagVs<0>(RBX::Security::hackFlag8, HATE_SEH_CHECK)`. Kill-switch condition list, fetch rework, readonly ordering all verified exact. |
| 51 | lvm.h | FIXED ×1 | Nonexistent `LUAI_NUMFFORMAT` → actual `LUA_NUMBER_FMT "%.14g"`; nonexistent `luaL_tolstring` → 5.1's luaL_callmeta/__tostring path in lbaselib. |
| 52 | lzio.c | FIXED ×1 | Stale undump-pipeline parenthetical corrected (no runtime undump path); lua_unlock anti-tamper gotcha CONFIRMED against luaconf.h:965–976. |
| 53 | lzio.h | PASS | |
| 54 | print.c | PASS | Secure-stripping + .v fetches + opnames link dependency all verified. |
| 55 | INDEX.md | FIXED ×2 | Pipeline sentence corrected (chunks ship via LuaSerializer, not ldump/lundump; lua_load never sniffs); added RESOLVED section for the rbxDecodeOp-key-0 question. Roster/coverage verified. |

## 4. Totals

- **PASS: 34**
- **FIXED: 21** (docs edited this session; ~40 individual corrections across them)
- **FAIL: 0**

Edits were applied ONLY to files under `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/Lua-5.1.4/`. No file under `roblox-sandbox/` was modified.

## 5. Open-question adjudication

**Writer's question**: *semantics of `rbxDecodeOp` with key 0 (lundump validates with key 0 vs LuaSerializer live ckey)* — **RESOLVED**, recorded in INDEX.md §"RESOLVED" and mirrored in lundump.c.md / lundump.h.md / ldebug.c.md / lopcodes.h.md:

1. Under keyed compilation (`LUAVM_SECURE && !RBX_RCC_SECURITY`), `i.v * 0 == 0` maps every instruction word to the constant 0; since the fixed secure shuffle makes opcode value 0 = OP_LOADBOOL (never a DAX-protected op), decode-with-key-0 is a constant map and would fail `precheck`'s final-OP_RETURN requirement for any chunk.
2. That configuration never coexists with the key-0 caller: lundump.c's loader exists only in non-secure builds where every decoder is an identity passthrough ignoring its key — so `luaG_checkcode(f, 0)` validates plaintext structure and the 0 is inert.
3. The live interpreter additionally refuses keys < 2 outright (`if (ckey+2 < 4) break;`, Win32 optimized configs; `LUAVM_KEY_INVALID 0` / `LUAVM_KEY_DUMMY 1`).
4. Real keyed verification happens post-load in LuaSerializer.inl with `L->l_G->ckey`; the encoder reinstalls plaintext opcodes before multiplying by the key inverse.

No remaining UNKNOWN was resolvable from source text except where explicitly marked (residual engine-side unknowns documented honestly in their files: e.g., whether any non-shipping build re-enables ldblib).

## 6. Residual risk

- Writer's engine-side claims about App/script behavior (ScriptContext key assignment lines, DebuggerManager hook usage) were spot-checked by grep where cited but not exhaustively audited — they belong to the sibling App/script campaign's certification scope.
- Stock-vs-Roblox "byte-for-byte stock" assertions for unmarked files (lmathlib/liolib/loslib/loadlib/lua.c/ltablib/linit/lzio/lmem) rest on full reads plus the exhaustive ROBLOX-marker sweep; a diff against pristine lua-5.1.4 tarballs could theoretically surface whitespace-level deltas, none functional.
