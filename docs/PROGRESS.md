# PROGRESS

Workstream numbers follow execution order per docs/ARCHITECTURE.md (Pipeline section).

| # | Workstream | Status | Gate evidence |
|---|---|---|---|
| 1 | Prune | DONE | `verify_prune.py` VERIFY_OK (63 absent / 45 required); `slim_sln.py` CHECK_OK (37 projects removed, 19 kept); idempotent rerun removes zero |
| 2 | Documentation campaign | DONE | Writing 100% (`reconcile_docs.py` → RECONCILE_OK) + Review 100% (26 module groups, 0 FAILs, ~1540 docs); aggregate PASS/FIXED 1000+/250+ |
| 3 | Build enablement | DONE | Run 32996010878 green — build-rcc 19m + build-client 24m + validate 3m31s; RCC 60s SMOKE_OK + two-sided proxy 7 reqs TWO_SIDED_SMOKE_OK; release build-20260826-181402 with both exes; Pre-Luau empty commit d02f00c2b |
| 4 | Luau graft | DONE | Run 34061457156 green on `main` — both exes link; 60s SMOKE_OK; two-sided proxy/RCC/client handshake OK; release published. Zero shims/stubs: real ref freelist, hook engine, typed continuations, unique_ptr throughout |
| 5 | Instrumentation | DONE | Run 34096800415 green on `ws5-inst` (merged c39809283) — capture gate CAPTURE_OK: 428 records, all 14 hooks (openState/load/resume/bridges/signals/http/scheduler/forced); connects == fires; merged to `main` |
| 6 | Wine runtime | DEFERRED | Wine-on-Linux plan retired per ARCHITECTURE.md decision 1 (Windows headless + WARP covers CI needs); revives only for interactive runs, beyond-WARP fidelity, or quota pressure. Remaining scope if revived: headless client launch vs local proxy |
| 7 | End-to-end validation | NOT STARTED | — |

## Current

**Workstream 6 DEFERRED — proceeding to WS7 end-to-end (T3) on Windows CI.**

- Sink: `ScriptCapture.{h,cpp}` JSONL (`seq/ts_ms/tid/hook/detail`), env-gated (`RBX_CAPTURE_PATH`), per-line flush, thread-safe.
- Spine hooks: openState inventory, LuaVM load (all 3 flavors), resume enter/exit, bridge get/set, signal connect/fire, HTTP egress, scheduler queue/resume.
- Forced pump: connect registry + globals census with budget-hook-bounded pcalls, fired post-quiesce (15s quiet / 40s unconditional, `RBX_FORCED_COVERAGE` opt-in).
- Gate: CI capture step + `tools/assert_capture.py` (required hooks, connect==fire, seq integrity).
- Supporting fixes the instrumentation effort exposed: userthread-driven thread-entry cleanup (was leaking dead coroutines), xmove census of sandboxed closures onto root mains, hook save/restore around census pcalls.
- Reconstruction pass (gate v2, run 34154762356): full chunk source at `load` (+identity), shared value serializers (Lua stack values, Variants, Tuples) with operands on bridgeGetValue/bridgeSet/resumeEnter+Exit/signalFire+Connect/HTTP-xxhash; inline executed-offset coverage bitmap in the dispatch loop with per-chunk dump; lock-free 20B-record instruction ring (1M, 200k drain cap) resolved to chunk/line/op at pump end; entry-set locking for GC-destroy races.
- Next: WS7 end-to-end (T3).

**Workstream 4 DONE — `main` is the Luau tree, fully validated.**

- Branches: `main` = Luau graft (green); `lua-5.1.4-baseline` @ 29562f5f2 = pre-graft safety net; `ws4-luau` = graft working branch (kept for history).
- What the graft is: Luau 0.735 vendored in-place at App/Lua-5.1.4/src; engine bridge (ScriptContext, ThreadRef, bridges, debugger) ported to Luau's public API; per-thread state (identity/context/ckey/hooks) in a side-table keyed by `lua_getthreaddata`.
- Deliberate divergences from 2016 (approved option-1): no RSB1 bytecode crypto (`compile()` is identity), source-only replication (`useSecureReplication()` false), core scripts from `content/scripts/*.lua` on disk (`getBytecodeCore` returns `""`). None is script-observable; the observable language is modern Luau, which is the point — Roblox no longer runs 5.1.4.
- Crash chain closed during validation (each diagnosed via CI minidump stacks): frozen-globals readonly error, hollow coroutine side-table entries (parent-threading fix), Yield result underflow ("vector too long"), unrooted-coroutine UAF (`luaL_ref` stored the wrong value), unbalanced `luaL_unref` reconstruction.
- CI carries failure-gated crash diagnostics (cdb stack via `_NT_SYMBOL_PATH`, crash-logs upload, PDBs in `rcc-exe` artifact) — invisible on green runs.
- Next: WS5 instrumentation against the final Luau contract (T1), then WS7 end-to-end (T3) — WS6 deferred.
