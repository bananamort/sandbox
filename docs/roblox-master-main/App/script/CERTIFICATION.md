# App/script/ Documentation Certification

Independent reviewer certification of the 26 source-file docs in this directory (+ INDEX.md).
Sources: `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/script/` (24 .cpp + 2 .inl, 40,814 lines).
Method: every source file read in full via tool calls; every concrete claim in each .md checked against the source (symbols, signatures, behaviors, quoted strings, cited line ranges); cross-file claims traced into the referencing TU; mechanical fixes applied directly to the .md files. Writes were made ONLY under this docs folder.

## Verdict summary

| File | Source | Verdict | Notes |
|---|---|---|---|
| CoreScript | CoreScript.cpp (116) | **PASS** | All symbols/messages/policies match; .cse reporting, fetchSource modes, RobloxLocked verified. |
| DebuggerManager | DebuggerManager.cpp (2201) | **PASS** | Reflection surface, hook machinery, eval-thread watches, deprecation throws, shouldBreak-without-frame-env nuance all correct. |
| LuaArguments | LuaArguments.cpp (586) | **FIXED** | Bridge-chain scope corrected (thread/lightuserdata skip bridges); cycle-detection gotcha rewritten (mark-on-entry is common code; only map branch unmarks → repeated array-shaped refs spuriously throw). |
| LuaAtomicClasses | LuaAtomicClasses.cpp (3060) | **FIXED** | Added verified BrickColor.new 0-arg fallthrough bug (missing else → returns closest(black), defaultColor discarded). |
| LuaBridge | LuaBridge.cpp (147) | **PASS** | Both instantiation lists match 1:1 (15 on_tostring, 23 registerClass); metatable layout exact. |
| LuaEnum | LuaEnum.cpp (156) | **PASS** | Class names, error strings, getValue-first-in-chain (confirmed in LuaArguments), declareAllEnums order verified. |
| LuaGenCS | LuaGenCS.inl (22022) | **PASS** | Verified programmatically + full structural reads: 37 arrays, 37 entries, all sizes reconcile exactly with declared dataSize, names rot13-decode correctly, no dupes/unreferenced arrays; line ranges in doc exact. |
| LuaInstanceBridge | LuaInstanceBridge.cpp (1222) | **FIXED** | LUA_ENVIRONINDEX gotcha corrected (stock Lua 5.1 pseudo-index, not a Roblox patch); everything else incl. dead duplicate Instance block verified. |
| LuaLibrary | LuaLibrary.cpp (275) | **FIXED** | Pre-completion index failure corrected: deterministic Lua error from lua_gettable-on-nil, not "undefined behavior". |
| LuaMemory | LuaMemory.cpp (189) | **FIXED** | getMemPoolIndex return contract corrected (guard tests only `< MAX`; callers use `> -1`); speculative LuaSecureDouble rationale deleted. |
| LuaSerializer | LuaSerializer.inl (547) | **FIXED** | Container gotcha corrected: XOR keystream covers offset 0 INCLUDING the RSB1 magic (that is how the client recovers the hash). |
| LuaSettings | LuaSettings.cpp (29) | **PASS** | Properties/defaults exact; consumer claims (SETSTEPMUL/SETPAUSE, budget/60.0, cleanTimeout, areScriptStartsReported) verified in ScriptContext. |
| LuaSignalBridge | LuaSignalBridge.cpp (438) | **FIXED** | Purpose line corrected: disconnect belongs to SignalConnectionBridge, not EventBridge; slots/caching/reentrancy all verified. |
| LuaSourceContainer | LuaSourceContainer.cpp (328) | **FIXED** | linkedSourceLoadedHandler/updateScriptInstancesUnderWriteLock are STATIC (header-confirmed); bind `_1` fills the DataModel* arg, not an object. |
| LuaVM | LuaVM.cpp (60) | **PASS** | Handler, secure-double mask retry condition, .text bounds all exact; GcLimit/GcFrequency/smallestWaitTime dead-in-module confirmed by grep. |
| LuaVMClient | LuaVMClient.cpp (119) | **FIXED** | luaY_parser relabeled: external-linkage global (referenced by Lua sources), not "file-local". |
| LuaVMDummy | LuaVMDummy.cpp (174) | **PASS** | finalize/DAX encoder/opcode set/(pc|1)/studio-identity all exact. |
| LuaVMServer | LuaVMServer.cpp (204) | **FIXED** | Key-scramble wording refined to InstructionV.code[i].v (type confirmed in LuaSerializer.inl; original "InstructionV" was right, an intermediate correction was re-refined). |
| LuaCoreFunctions | LuaCoreFunctions.cpp (222) | **PASS** | os registry contents, Perlin table/helpers, loslib copy comments exact; printCallStack delegation claims verified in ScriptContext. |
| ModuleScript | ModuleScript.cpp (195) | **PASS** | State machine, asymmetric node lifetime, first-global-state retention, lua_unref usage verified; hot-reload tie-in confirmed in ScriptContext. |
| Script | Script.cpp (253) | **PASS** | All descriptors/migration paths/hashes exact; honest UNKNOWN about getHash/isCodeEmbedded bodies confirmed true (grep). |
| ScriptAnalyzer | ScriptAnalyzer.cpp (4059) | **FIXED** | Added verified latent bug: pass loop bound `sizeof(passes)/sizeof(passes[0])` on a vector ⇒ evaluates to 1, so only WarnGlobalLocal runs with default flags. |
| ScriptContext | ScriptContext.cpp (3525) | **FIXED** | Job registration attributed to openState (not onServiceProvider directly); all other ~90 claims incl. SECURITY block, sandbox chain, ckey/modkey, anti-tamper constants verified. |
| ScriptEvent | ScriptEvent.cpp (129) | **PASS** | Loop bound verbatim, throttle semantics, tostring specializations, FixYieldThrottling analysis all exact. |
| ScriptStats | ScriptStats.cpp (79) | **PASS** | Meter types, stack attribution, LuaStatsItem items exact; SetCollectScriptStats/getScriptStats*/parenting verified in ScriptContext. |
| ThreadRef | ThreadRef.cpp (479) | **PASS** | Intrusive list, LiveThreadRef pins, global-state registry refs, async yield pattern, TODOs verified; eraseAllRefs call sites confirmed (direct + via eraseRefsFromAllNodes). |
| INDEX.md | — | **PASS** | 26/26 roster rows present, per-file line counts match wc exactly, pipeline narrative consistent with certified facts. |

## Overall counts

- Sources enumerated: 26 (24 .cpp + LuaSerializer.inl + LuaGenCS.inl) — doc coverage exactly 1:1, no missing, no extra.
- **PASS: 14 · FIXED: 12 · FAIL: 0**
- Edit operations applied: 14 across 12 doc files (LuaMemory ×2, LuaArguments ×2, others ×1).
- Severity of applied fixes: 7 WRONG (LuaSerializer keystream coverage; LuaSourceContainer static-binding ×2-in-one; LuaSignalBridge symbol attribution; LuaInstanceBridge stock-Lua claim; LuaLibrary UB-vs-error; LuaArguments bridge-scope), 3 UNSUPPORTED/imprecise (LuaMemory pool-index contract + speculation deletion; LuaVMClient linkage; ScriptContext job-registration attribution), 2 MISSING-GOTCHA inserted from verified bugs (LuaAtomicClasses BrickColor fallthrough; ScriptAnalyzer sizeof-vector pass-loop bound), plus refinements to LuaVMServer wording.

## Methodology note — LuaGenCS.inl (22,022 generated lines)

The read tool caps output per call (~50 KB ≈ 200 lines of this file's wide hex rows), so completeness was established by exhaustive machine verification rather than paging every hex row through the reader: every line was pattern-classified (array opener / hex body / closer / table entry / blank) with zero unexplained lines; every array's byte count was reconciled against its declared dataSize (all 37 match exactly, after chasing one single-byte final-line formatting artifact); all 37 rot13 keys decode to valid core-script paths with no duplicates or unreferenced arrays; boundaries and tables additionally read manually. This is stricter than visual reading for generated data and is disclosed here for transparency.

## Residual risk

- Claims about headers outside App/script (e.g., typedef aliases like `Enums`, `IntellesenseResult` fields, `Scripts::Continuations`) were accepted where usage sites corroborated them; two were spot-checked directly (App/include/script/LuaSourceContainer.h staticness).
- External-knowledge statements explicitly framed as lineage/opinion in the docs (Luau ancestry remarks) were left as hedged commentary, per style rules.
