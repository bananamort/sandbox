# PROGRESS

Workstream numbers follow execution order per docs/ARCHITECTURE.md (Pipeline section).

| # | Workstream | Status | Gate evidence |
|---|---|---|---|
| 1 | Prune | DONE | `verify_prune.py` VERIFY_OK (63 absent / 45 required); `slim_sln.py` CHECK_OK (37 projects removed, 19 kept); idempotent rerun removes zero |
| 2 | Documentation campaign | DONE | Writing 100% (`reconcile_docs.py` → RECONCILE_OK) + Review 100% (26 module groups, 0 FAILs, ~1540 docs); aggregate PASS/FIXED 1000+/250+ |
| 3 | Build enablement | DONE | Run 32996010878 green — build-rcc 19m + build-client 24m + validate 3m31s; RCC 60s SMOKE_OK + two-sided proxy 7 reqs TWO_SIDED_SMOKE_OK; release build-20260826-181402 with both exes; Pre-Luau empty commit d02f00c2b |
| 4 | Luau graft | IN PROGRESS | Luau 0.735 vendored in-place at App/Lua-5.1.4/src (VM/Compiler/Ast/Common mirror at vendor/luau); shim lua.h/luaconf.h/lualib.h for compat; awaiting build wire (WS4-C2) |
| 5 | Instrumentation | NOT STARTED | — |
| 6 | Wine runtime | NOT STARTED | — |
| 7 | End-to-end validation | NOT STARTED | — |

## Current

**Workstream 4 (Luau graft) — C1 vendor in progress (strictly before WS5).**

- WS3 DONE — two-sided Client↔RCC via logging_proxy proved 7-request handshake (run 32996010878).
- WS4-C1: Luau 0.735 (2026-08-22) vendored — src replaced (55 Lua 5.1.4 files → 25-entry Luau tree with VM/Compiler/Ast/Common), vendor/luau full mirror for diffing, shim headers for lua.h compat. Next: WS4-C2 build wiring (App.vcxproj/CMake, v143, LUAI_EXTRASPACE) — CI will link.
- Docs as resource: every edit cites docs/roblox-master-main (luaconf.h:763-925 RobloxExtraSpace, ScriptContext.md openState/sandboxThread/resumeImpl, LuaVMServer/Client) — CERTIFICATION.md gate enforced.
- Sequencing per plan correction: WS4 strictly before WS5 (no parallel branches) — instrumentation will target final Luau contract.
