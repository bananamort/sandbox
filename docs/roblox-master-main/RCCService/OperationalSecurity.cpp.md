# OperationalSecurity.cpp

Source: `roblox-sandbox/RCCService/OperationalSecurity.cpp` (222 lines)

## Purpose

RCC-only anti-tamper measures ("additional security measures that only exist inside RCC", line 1). Three independent schemes live here:

1. **Guard-page tripwire** (`initAntiMemDump`) — detects memory scanners/dumpers touching a canary code page.
2. **Hardware-breakpoint sentinel** (`initHwbpVeh`) — tags `EXCEPTION_SINGLE_STEP` crashes as special.
3. **`.lua` section read-only watch** (`initLuaReadOnly` / `clearLuaReadOnly`) — catches out-of-section writes into the Lua VM code section ("reflection" tampering).

Everything is FastFlag/FastInt gated so schemes can be enabled/disabled server-side without redeploys.

## API

### FastFlag configuration (lines 10–14)

| Variable | Type / default | Meaning (per source comments, lines 7–9) |
| --- | --- | --- |
| `FFlag::US30484p1` | flag, `false` | If true: **crash** when the reflection area is written to. If false (default): log, make writable, continue. |
| `FInt::US30484p2` | int, `0` | Analytics logging probability = p2 / 100 (0 = never report). |
| `FFlag::US30484p3` | flag, `false` | Master enable for the whole `.lua` read-only scheme. |
| `FFlag::US31006` | consumed via `FASTFLAG` | Gate for `initHwbpVeh`. |

Namespace-level entry points (declared in `OperationalSecurity.h`):

- `void RBX::initAntiMemDump()` (line 158)
- `void RBX::initHwbpVeh()` (line 176)
- `void RBX::initLuaReadOnly()` (line 185)
- `void RBX::clearLuaReadOnly()` (line 205)
- Externs referenced: `RBX::gCrashIsSpecial`, `RBX::specialCrashType` (set, not owned).

### Guard-page scheme baseline (precision target)

**Canary construction**: `template<int N> rccBigFunc()` recursively `__forceinline`s itself, each level emitting an inline-asm block of nine `RBX_NOP6` plus one `RBX_NOP3` (macro-expanded multi-byte NOPs from `security/JunkCode.h`; source comment notes the last emits "4 bytes"). `rccBigFuncStorage()` instantiates `rccBigFunc<128>` in release builds only (`#if !defined(_NOOPT) && !defined(_DEBUG)`), producing ≈128×58 = 7424 bytes of NOP sled. The comment at line 40 records why: `__declspec(align(4096))` did not work, so the storage was padded (nominally 8192 bytes) to guarantee it fully covers at least one page — the ≈7424-byte sled exceeds one 4096-byte page even if it falls short of the nominal target.

**Placement**: `getGuardPageBase()` (line 50) rounds `&rccBigFuncStorage` up to the next `kPageSize` (hardcoded 4096) boundary — the first full page inside the function body.

**Arming sequence** in `initAntiMemDump()`:
1. `AddVectoredExceptionHandler(1, &rccBigFuncExceptionHandler)` — registered *first* in the VEH chain.
2. `VirtualProtect(&rccBigFuncStorage, 2*kPageSize, PAGE_EXECUTE_READWRITE)`; then `memcpy` 8192 bytes from `(image base + 0x1000)` over the sled — i.e., the canary is overwritten with a copy of real code from the start of `.text`, so a naive pattern scan finds plausible instructions instead of a suspicious repeating NOP pattern (rationale in comment at lines 164–168).
3. Re-protect to `PAGE_EXECUTE_READ`.
4. `VirtualProtect(getGuardPageBase(), kPageSize, PAGE_GUARD | PAGE_EXECUTE_READ)` — arms the one-shot guard.

**Handler** `rccBigFuncExceptionHandler` (line 134): on `EXCEPTION_GUARD_PAGE` whose faulting data address (`ExceptionInformation[1]`) lies within `[guardPageBase, guardPageBase+4096)` it sets `gCrashIsSpecial = true` and `specialCrashType = "page"`, then always returns `EXCEPTION_CONTINUE_SEARCH` — the process still dies, but the crash is *classified* so upstream telemetry can distinguish scanner-triggered deaths.

### Hardware-breakpoint sentinel

`rccHwbpExceptionHandler` (line 149): marks `gCrashIsSpecial = true` on any `EXCEPTION_SINGLE_STEP` (the exception hardware breakpoints raise) and continues search. `initHwbpVeh` installs it (first in chain) only when `FFlag::US31006` is set.

### `.lua` read-only scheme

- PE parsing helpers (anonymous namespace): `getSections(void* imageBase, SectionPtrVector&)` walks DOS/NT headers (validates `IMAGE_DOS_SIGNATURE`, `IMAGE_NT_SIGNATURE`; reads 32-bit header layout) collecting section headers; `getSectionInfo(sections, name, base&, size&)` matches by `strncmp` limited to 8 chars (+NUL = `kPeSectionNameLimit` 9) and computes VA = `section.VirtualAddress + GetModuleHandle(NULL)` with `Misc.VirtualSize`.
- `initLuaReadOnly()` (line 185): no-op unless `FFlag::US30484p3`. Finds the `.lua` section, caches `luaBase`/`luaSize` statics, registers `rccReflectionModifiedVeh` with `AddVectoredExceptionHandler(0, ...)` (**last** in chain), then `VirtualProtect(luaBase, luaSize, PAGE_READONLY)`.
- `rccReflectionModifiedVeh` (line 105): fires on `EXCEPTION_ACCESS_VIOLATION` when the accessed **data** address falls inside `[luaBase, luaBase+luaSize)` while the faulting **code** address lies outside it — i.e., non-Lua code wrote into the Lua machine-code section. It builds an InfluxDB analytics point (`"code"` / `"data"` offsets relative to image base, `RBX::Analytics::InfluxDb::Points`) and reports under event `"RccReflectionAv"` sampled at `FInt::US30484p2`%. Unless `FFlag::US30484p1` is set, it flips the section back to `PAGE_READWRITE` and returns `EXCEPTION_CONTINUE_EXECUTION` (write retried successfully — self-healing mode). With p1 set it falls through and the AV kills the process.
- `clearLuaReadOnly()` (line 205): same master-flag gate; removes the VEH, restores `PAGE_READWRITE`, zeroes the cached range. Comment (lines 203–204) admits the crash-reporter path may skip destructors entirely, so this mainly prevents exit-time crashes in normal shutdown. Called from `_tmain` epilogue (`RCCService.cpp:782`).

## Usage

Called during RCCService startup/teardown (from the engine web layer / `_tmain`): anti-dump and hwbp sentinels early, Lua read-only before job execution, cleared at process exit. All release-build-only behavior is compiled out under `_DEBUG`/`_NOOPT`.

## Gotchas

- **Defaults are all off**: `US30484p1=false`, `US30484p2=0`, `US30484p3=false`, and `US31006` gates `initHwbpVeh` — out of the box none of these schemes alters behavior; they are remote-config experiments (US30484 / US31006 workstream numbers).
- **Guard page is one-shot**: `PAGE_GUARD` clears after first touch; nothing re-arms it, so the tripwire fires exactly once per process lifetime.
- **Self-healing mode degrades protection**: with default flags, a detected `.lua` writer gets its write completed (page left `PAGE_READWRITE` afterwards — protection is *not* restored after the continue).
- **32-bit PE assumptions**: `getSections` casts to `IMAGE_NT_HEADERS32`; fine for the Win32 build target, wrong under x64.
- **`kPageSize` hardcoded 4096** — breaks conceptually on large-page configurations.
- **VEH ordering matters**: anti-mem-dump and hwbp handlers use priority 1 (first); the reflection handler uses 0 (last) so other handlers see the AV first.
- Analytics reporting is probabilistic and silent at `US30484p2=0`.
- Includes `security/JunkCode.h`, `util/Analytics.h` — engine-tree headers outside this folder.

Caller inside this folder: the `CWebService` constructor (`RCCServiceSoapServiceImpl.cpp:1348–1353`) invokes `RBX::initAntiMemDump()` (only when `DFFlag::US30476` is set) and then `RBX::initLuaReadOnly()` / `RBX::initHwbpVeh()` unconditionally during service bootstrap. UNKNOWN: definition values shipped for the four fast flags in production config.
