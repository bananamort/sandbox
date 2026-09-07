# PROGRESS

Workstream numbers follow execution order per docs/ARCHITECTURE.md (Pipeline section).

| # | Workstream | Status | Gate evidence |
|---|---|---|---|
| 1 | Prune | DONE | `verify_prune.py` VERIFY_OK (63 absent / 45 required); `slim_sln.py` CHECK_OK (37 projects removed, 19 kept); idempotent rerun removes zero |
| 2 | Documentation campaign | DONE | Writing 100% (`reconcile_docs.py` → RECONCILE_OK) + Review 100% (26 module groups, 0 FAILs, ~1540 docs); aggregate PASS/FIXED 1000+/250+ |
| 3 | Build enablement | DONE | Run 32996010878 green — build-rcc 19m + build-client 24m + validate 3m31s; RCC 60s SMOKE_OK + two-sided proxy 7 reqs TWO_SIDED_SMOKE_OK; release build-20260826-181402 with both exes; Pre-Luau empty commit d02f00c2b |
| 4 | Luau graft | DONE | Run 34061457156 green on `main` — both exes link; 60s SMOKE_OK; two-sided proxy/RCC/client handshake OK; release published. Zero shims/stubs: real ref freelist, hook engine, typed continuations, unique_ptr throughout |
| 5 | Instrumentation | NOT STARTED | — |
| 6 | Wine runtime | NOT STARTED | — |
| 7 | End-to-end validation | NOT STARTED | — |

## Current

**Workstream 4 DONE — `main` is the Luau tree, fully validated.**

- Branches: `main` = Luau graft (green); `lua-5.1.4-baseline` @ 29562f5f2 = pre-graft safety net; `ws4-luau` = graft working branch (kept for history).
- What the graft is: Luau 0.735 vendored in-place at App/Lua-5.1.4/src; engine bridge (ScriptContext, ThreadRef, bridges, debugger) ported to Luau's public API; per-thread state (identity/context/ckey/hooks) in a side-table keyed by `lua_getthreaddata`.
- Deliberate divergences from 2016 (approved option-1): no RSB1 bytecode crypto (`compile()` is identity), source-only replication (`useSecureReplication()` false), core scripts from `content/scripts/*.lua` on disk (`getBytecodeCore` returns `""`). None is script-observable; the observable language is modern Luau, which is the point — Roblox no longer runs 5.1.4.
- Crash chain closed during validation (each diagnosed via CI minidump stacks): frozen-globals readonly error, hollow coroutine side-table entries (parent-threading fix), Yield result underflow ("vector too long"), unrooted-coroutine UAF (`luaL_ref` stored the wrong value), unbalanced `luaL_unref` reconstruction.
- CI carries failure-gated crash diagnostics (cdb stack via `_NT_SYMBOL_PATH`, crash-logs upload, PDBs in `rcc-exe` artifact) — invisible on green runs.
- Next: WS5 instrumentation against the final Luau contract (T1), then WS6 Wine runtime (T2), then WS7 end-to-end (T3).
