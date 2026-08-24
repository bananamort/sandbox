# App/include/lua Documentation Certification — Independent Review

**Reviewer**: independent review subagent (ox-alpha).
**Scope**: all sources in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/lua/` vs docs in `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/lua/`.

## Method

- Every source file read **in full via tool calls** (lua.hpp 73 lines, LuaBridge.h 264 lines; all ten luaStubsN.h read/structurally verified — luaStubs0.h fully read line-by-line, the other nine verified by strict definition-line extraction plus endpoint/middle-ID checks against each doc's claimed IDs).
- Machine-checked claims: per-file stub counts (`grep -c '^RBX::Lua::LuaStubGen'`), cross-file ID uniqueness (`sort -u | wc -l` = 1000), doc-claimed first/second/last IDs vs headers, `__eq` metamethod gating in App/script/LuaBridge.cpp:94.
- Severity tags WRONG / UNSUPPORTED / MISSING-GOTCHA / STYLE; mechanically-certain fixes applied in docs only.

## Coverage arithmetic

- Sources: **12 files** (lua.hpp + LuaBridge.h + luaStubs0–9.h). Docs: **12 module `.md` + `INDEX.md` = 13**. 1:1 confirmed. (Note: `lua.hpp` is matched by its `lua.md`; the task brief's "13 docs" figure includes INDEX.)

## Per-file certification

| # | Source | Doc | Verdict | Notes |
|---|--------|-----|---------|-------|
| 1 | lua.hpp | lua.md | PASS | All RBX::Lua helpers, ScopedPopper (+=/-=), ScopedState conversion operator exact. |
| 2 | LuaBridge.h | LuaBridge.md | PASS | Bridge pushNewObject×3/getObject/getValue, client-hook list with _WIN32-only protected wart + quoted GCC error, SharedPtrBridge weak "v"-table reuse (Matt Campbell/Serotek comment verbatim), SingletonBridge strong table + TODO, getPtr overloads; "__eq only registered when __eq==true" confirmed at LuaBridge.cpp:94. |
| 3–12 | luaStubs0.h … luaStubs9.h | luaStubs0.md … luaStubs9.md | FIXED (WRONG ×10) | Every doc claimed **99** stub globals per file and (luaStubs9.md) **990 unique IDs total**. Grep-verified: **100 definition lines per file, 1000 total, 1000 unique names** (`stub0` lives in file 9 as documented). All ten docs corrected with FIXED annotations; every claimed ID endpoint (e.g. stub609…stub620, stub339/stub510/stub463, stub925/stub311/stub485, stub290/stub734/stub758, stub614/stub481/stub145, stub641/stub200/stub521, stub144/stub44/stub440, stub525/stub980/stub80, stub355/stub411/stub141, stub137/stub966/stub673+stub0) re-verified against headers — all correct. |
| 13 | INDEX.md | — | FIXED (WRONG ×2) | Roster repeated the 99-per-file / 990-total figures → corrected to 100 / 1000. |

## Totals

- **PASS**: 2
- **FIXED**: 11 files (all WRONG-class count errors, one root cause: off-by-one per-file stub census propagated through ten docs + INDEX)
- **FAIL**: 0

## Cross-task note for the orchestrator

The previously certified fact "luaStubs0–9 = 990 decoy globals" (project memory / App-Lua-5.1.4-era recon) inherits this same error; true figure is **1000 unique decoys (100 per unit)**. Recommend promoting the correction.
