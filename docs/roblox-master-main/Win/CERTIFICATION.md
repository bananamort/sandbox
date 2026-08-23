# CERTIFICATION.md — Win

Independent review of `docs/roblox-master-main/Win/` against `roblox-sandbox/Win/`.
Method: all 28 sources re-enumerated; every documented source read in full and every concrete claim verified (including the anti-tamper baseline, checked instruction-by-instruction); cross-directory consumer claims resolved by tree-wide grep. The 9 missing source docs and the missing INDEX.md were authored during this review.

## Coverage

Source-ext files: **28** (.cpp/.h). Before review: 18 docs + no INDEX (9 sources undocumented — AuthenticationMarshallar.{cpp,h}, dinput.h, DSVideoCaptureEngine.{cpp,h}, SharedLauncher.{cpp,h}, sitelock.h, VistaTools.cpp). After review: **COMPLETE 1:1** (all 28 documented) + INDEX.md created.

## Per-file verdicts (pre-existing docs)

| Doc | Verdict | Findings |
|---|---|---|
| CheckDbg.cpp.md | FIXED | **WRONG (critical baseline error)**: doc claimed TEB+0x30 → "process heap flags" testing FLG_HEAP_ENABLE_TAIL_CHECK ("debug heap" tell). Actual: `GetFlag` reads the FIRST DWORD OF THE PEB via *(DWORD*)(*(DWORD*)(TEB+0x30)); bit 0x00010000 = byte offset 2 low bit = **PEB->BeingDebugged** — hand-rolled IsDebuggerPresent. Purpose/API comment/Usage/gotchas rewritten to the exact mechanism; stale "heap flags moved on later Windows" UNKNOWN removed (BeingDebugged layout is version-stable); g_counter mixing, 32-bit-only fs: asm, and zero-callers claims verified correct. Baseline is now exact. |
| CheckDbg.h.md | PASS | noinline trio mirror exact; dead-code claim grep-verified. |
| DumpErrorUploader.cpp.md | FIXED | WRONG ×2: LogFilter is NOT static; failed uploads are popped but their archive-move is SKIPPED (not "moved to archive"). Mutex-leak gotcha de-garbled + ownership path clarified. crashEventData exhaustion upgraded from UNKNOWN: shared Http::post never rewinds non-external streams. RCCService consumer added; Application.cpp construction lines verified. |
| DumpErrorUploader.h.md | PASS | Statics/preallocation claims verbatim-verified. |
| ErrorUploader.cpp.md | PASS | MoveRelative semantics incl. destructive delete-on-failure verified. |
| ErrorUploader.h.md | FIXED | UNSUPPORTED claim removed: NOTHING calls Cancel()/IsUploading() (grep-verified dead API); `_FindFirst.h` UNKNOWN resolved (exists at Network/raknet/Source/_FindFirst.h). |
| LogManager.cpp.md | FIXED | WRONG ×2: `hasErrorLogs()` listed as implemented here — declared in header, defined NOWHERE in tree; ctor extensions claimed ".dmp"/".crashevent" for WindowsClient — actual `("Roblox", ".Client.dmp", ".Client.crashevent")` (RCC uses ".dmp"/".crashevent"). VideoControl removed from consumer list. MAX_CONSOLE_LINES semicolon, /30 normalization quirk, 9-char prefix assumption all verified. |
| LogManager.h.md | FIXED | WRONG: ctor shown explicit (not in source); consumers VideoControl/DSVideoCaptureEngine removed (grep-verified absent), real set listed (incl. CSG/CSGKernel.cpp ✓); hasErrorLogs dead-declaration note added. |
| ProcessInformation.h.md | FIXED | Resolved UNKNOWN: only includers are Win/SharedLauncher.{h,cpp}. Copy-hazard and STILL_ACTIVE gotchas verified. |
| ScriptErrorUploader.cpp.md | FIXED | WRONG: "Called once per client startup from WindowsClient/Application.cpp" — ZERO callers anywhere (dead code). Failed-open behavior corrected (posts "Empty!!!" placeholder rather than failing). |
| ScriptErrorUploader.h.md | FIXED | WRONG: Application.cpp instantiation claim removed — no consumers exist. Mutex-leak shape and missing urlEncode vs DumpErrorUploader verified accurate. |
| Tracer.cpp.md | PASS | Empty-TU description exact. |
| UserInputUtil.cpp.md | FIXED | STYLE: static-table thread-safety wording corrected (explicit flag pattern, not magic statics). DIK_LMENU double-check bug, SDLK_BACKSLASH double assignment, KANJI/PREVTRACK mappings, VK_PRINT non-standard claim all independently verified. Call-site line refs spot-checked ✓. |
| UserInputUtil.h.md | PASS | Sole consumer + vcxproj listing + vendored dinput.h resolution verified. |
| VersionInfo.cpp.md | PASS | All getters, "Productname" typo key, short-path truncation, declared-only GetFileVersion/ProductVersion verified; consumer counts exact (Application ×3 @512/1021/1315). |
| VersionInfo.h.md | PASS | Header mirror faithful; link-error gotcha confirmed against .cpp. |
| VideoControl.cpp.md | PASS | Lifecycle/callback/failure-path gotchas verified line-by-line. |
| VideoControl.h.md | PASS | Interface mirror exact; GameVerbs wiring verified. |
| VistaTools.h.md | FIXED | Usage corrected: elevation gate is Win/SharedLauncher.cpp:37 (not WindowsClient installer paths); VistaAPIs consumer is Application.cpp logsCleanUpHelper (~line 119, FOLDERID_LocalAppDataLow\RbxLogs, E_NOTIMPL tolerated). All implementation claims verified against VistaTools.cpp (FAILED(Open) inversion, throwing semantics, assert-vanish). |

## Per-file verdicts (docs authored this review)

| Doc | Verdict | Notes |
|---|---|---|
| AuthenticationMarshallar.cpp.md | NEW · PASS-baseline | Written from full read; consumers (Application.cpp ~396/~405) grep-verified. |
| AuthenticationMarshallar.h.md | NEW · PASS-baseline | Vestigial boost/function.hpp include noted. |
| DSVideoCaptureEngine.cpp.md | NEW · PASS-baseline | All 1305 lines read; constants, WMASF profiles, cancellation limits, per-frame pixel work, empty setVideoQuality, DestroyCaptureGgaph typo documented. |
| DSVideoCaptureEngine.h.md | NEW · PASS-baseline | Full member mirror from header. |
| SharedLauncher.cpp.md | NEW · PASS-baseline | All 631 lines read; registry keys, HKCU/HKLM elevation logic, authenticate() 2048-byte off-by-one, forced-Build dead conditionals, PreStartGame UNICODE/ANSI inconsistency, parse asymmetries documented. In-tree consumers limited to LaunchMode/constants (verified). |
| SharedLauncher.h.md | NEW · PASS-baseline | Argument-name contract + dllexport surface. |
| dinput.h.md | NEW · PASS-baseline | Verified unmodified Microsoft header (1996-2000), no roblox modifications. |
| sitelock.h.md | NEW · PASS-baseline | Verified verbatim Microsoft SiteLock 1.14 sample, zero Roblox references, zero includers (dead vendored copy); expiry mechanics summarized. |
| VistaTools.cpp.md | NEW · PASS-baseline | Written from full read; IsUacEnabled key/value confusion and throw-vs-HRESULT semantics recorded. |
| INDEX.md | NEW | Directory summary, anti-tamper baseline note, 28-row table, cross-directory notes, dead-code inventory. |

## Totals

- Docs reviewed pre-existing: 18 → PASS 8 · FIXED 10 · FAIL 0
- Docs created: 10 (9 missing source docs + INDEX.md)
- Coverage before: 18/28 sources + no INDEX → after: 28/28 + INDEX (**COMPLETE**)
- Fixes applied to existing docs: 24 (WRONG 9 — including the critical CheckDbg mechanism error — · resolvable-UNKNOWN 5 · UNSUPPORTED/dead-API corrections 4 · STYLE/clarity 6)

**Verdict: CERTIFIED** — Win documentation is complete and claim-accurate; CheckDbg anti-tamper baseline now records the true PEB->BeingDebugged mechanism exactly.
