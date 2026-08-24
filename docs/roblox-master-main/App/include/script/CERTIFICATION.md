# App/include/script Documentation Certification — Independent Review

**Reviewer**: independent review subagent (ox-alpha).
**Scope**: all sources in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/script/` vs docs in `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/script/`.

## Method

- Every source header was **read in full via tool calls** — no sampling. Every .md was read in full immediately after its source.
- Every concrete claim checked against the source text: declared signatures, defaults, inline bodies, enum values/orders, verbatim comments/[sic] spellings, descriptor macros, security flags.
- Cross-TU behavioral claims machine-checked by grep/read at target: `hasCoreScriptReplacements` gating (App/script/Script.cpp, CoreScript.cpp), `LuaCoreFunctions` registry merge points (ScriptContext.cpp:582–598), `LuaAllocator::alloc` static cast (LuaMemory.cpp:82), `getContext` implementation (ScriptContext.cpp + luaconf.h RobloxExtraSpace), `ComputeBubbleLifetime` (gui/ChatOutput.cpp), ActivityMeter location (rbx/RunningAverage.h), single-arg `lua_tofunction` non-existence.
- Severity tags: WRONG / UNSUPPORTED / MISSING-GOTCHA / STYLE. Mechanically-certain fixes applied in place (docs tree only; `roblox-sandbox/` untouched).

## Coverage arithmetic

- Sources: **22 `.h` files**. Docs: **22 module `.md` + `INDEX.md` = 23**. Coverage 1:1 confirmed by re-enumeration.
- INDEX roster re-checked: all 22 entries present and linking correctly.

## Per-file certification

| # | Source | Doc | Verdict | Notes |
|---|--------|-----|---------|-------|
| 1 | script.h | script.md | PASS | Full hierarchy/descriptors/inline bodies verbatim-verified incl. Slot TODO and LocalScript security comment. |
| 2 | CoreScript.h | CoreScript.md | PASS | fetchSource empty-optional behavior confirmed in .cpp; requestCode ignores provider confirmed. |
| 3 | DebuggerManager.h | DebuggerManager.md | PASS | 400-line header fully matched; enums, signals, PausedThreadData, withPausedThread TODO, getCondition/expression mismatch all correct. |
| 4 | ExitHandlers.h | ExitHandlers.md | PASS | Both Continuations types + adapter exact. |
| 5 | IScriptFilter.h | IScriptFilter.md | PASS | friend-only invocation, weak_ptr sets, no virtual dtor all mechanically true. |
| 6 | LuaArguments.h | LuaArguments.md | PASS | withVariantValue dispatch order re-derived line-by-line; RBX::Vector2→G3D::Vector2 aliasing noted correctly; fall-through f() gotcha correct. |
| 7 | LuaAtomicClasses.h | LuaAtomicClasses.md | PASS | All 18 bridges + push-helper absences + "arithmatic" [sic] ×3 + six registerClass specializations verified. |
| 8 | LuaCoreFunctions.h | LuaCoreFunctions.md | PASS | os/debug/math merge points grep-verified at ScriptContext.cpp:582/590/598. |
| 9 | LuaEnum.h | LuaEnum.md | PASS | Tripled copy-paste comment confirmed; raw-pointer bridges confirmed. |
| 10 | LuaInstanceBridge.h | LuaInstanceBridge.md | PASS | lua-l pop-comment URL verbatim; setreadonly immutability correct. |
| 11 | LuaLibrary.h | LuaLibrary.md | PASS | Stale EnumDescriptor-item comment correctly flagged historical. |
| 12 | LuaMemory.h | LuaMemory.md | PASS | Static alloc reinterpret_cast verified at LuaMemory.cpp:82; gzip-include hedge acceptable. |
| 13 | LuaSettings.h | LuaSettings.md | FIXED (STYLE) | Quote fidelity: header says "maunal" [sic]; doc had silently normalized to "manual". Restored with [sic]. |
| 14 | LuaSignalBridge.h | LuaSignalBridge.md | PASS | operator== lock-fails-both logic re-derived from inline body. |
| 15 | LuaSourceContainer.h | LuaSourceContainer.md | PASS | All statics/signals/private machinery exact. |
| 16 | LuaVM.h | LuaVM.md | PASS | Macro matrix, key constants 641/6700417, LuaVMValue address-relative decode, secure-double SSE2 path all verbatim-verified. |
| 17 | ModuleScript.h | ModuleScript.md | PASS | ScriptSetupState values, both reset-path comments verbatim. |
| 18 | ScriptAnalyzer.h | ScriptAnalyzer.md | PASS | WarningCode values 0–11 + sentinel; sizeof(vector) defect cross-ref matches known backlog. |
| 19 | ScriptContext.h | ScriptContext.md | FIXED (WRONG) | Gotcha claimed getContext(thread) "walks up from coroutine to its root state" — false: it reads a stored `ScriptContext*` from RobloxExtraSpace::Shared (luaconf.h:787; no walk-up). Corrected in place. All other claims (SecurityAnchor Feistel mixing, timeout block typos, Result contract, StackBalanceCheck macros, full private C-function list) verified. |
| 20 | ScriptEvent.h | ScriptEvent.md | PASS | Inverted priority_queue comparator reasoning correct; four on_tostring specializations exact. |
| 21 | ScriptStats.h | ScriptStats.md | PASS | ActivityMeter<2>/InvocationMeter<2> located in rbx/RunningAverage.h as claimed. |
| 22 | ThreadRef.h | ThreadRef.md | FIXED (MISSING) | API list omitted protected inline `lua_State* thread()` accessor on WeakThreadRef (ThreadRef.h:114–116). Added. ThreadRef::empty() polarity inversion and never-defined friend `lua_tofunction(L)` overloads grep-verified. |
| 23 | INDEX.md | — | FIXED (STYLE) | Broken link `[LuaCoreFunctions.md](LuaOsExtension/LuaMathExtension/LuaDebugExtension registries)` repaired to real target; stale "(pending)" marker on lua/ subdirectory removed (now certified). |

## Totals

- **PASS**: 19
- **FIXED**: 4 (1 WRONG, 1 MISSING-GOTCHA, 2 STYLE)
- **FAIL**: 0
