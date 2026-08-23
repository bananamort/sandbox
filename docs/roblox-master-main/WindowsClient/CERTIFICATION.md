# WindowsClient Documentation — Independent Certification

Reviewer: ox-alpha (independent review subagent). Date of pass: this campaign cycle.

## Method

Sources were re-enumerated from the filesystem (not trusted from writer output): the tree
`roblox-sandbox/WindowsClient/` contains **47 files**. 10 are intentionally undocumented build
plumbing / binary assets (`WindowsClient.vcxproj`, `WindowsClient.vcxproj.filters`,
`WindowsClient.rc`, `resource.h`, `ReadMe.txt`, `InvisibleCursor.cur`, `Roblox.ico`,
`RobloxGoldenHashPatcher.sln`, `.vcxproj`, `.vcxproj.filters`) — exactly as INDEX.md declares.
The remaining **37 first-party sources** map 1:1 to **37 `.md` files + `INDEX.md` = 38 docs** here.
Coverage is exact: no source without a doc, no doc without a source, no extras.

Every one of the 37 sources was read IN FULL via tool calls, then its `.md` read and every
concrete claim checked against it (byte patterns, constants, line citations, call sites,
cross-file references verified by grep/read across the tree). Anti-tamper baseline files
(robloxHooks, functionHooks, ReleasePatcher, RobloxGoldenHashPatcher, Crypt) got line-level
verification including recomputation of the Application.cpp:1053 congruence arithmetic.

## Per-file certification

| Doc | Verdict | Note |
|---|---|---|
| robloxHooks.cpp.md | PASS | ntdll rel32 patch math, prolog bytes {8B 4C 24 04 | 8B 1C 24 | 51 | 53 | E8}, ±8MB FindWindowA heuristic (kHalf=1<<23/kFull=1<<24), VEH tokens, CheatEngine.cpp:36 — all exact; cross-refs (Application.cpp:646/642, rbxTextBase fill at ReleasePatcher.cpp:558) verified |
| RobloxHooks.h.md | PASS | declarations verbatim; vehHookContinue relocation note correct |
| functionHooks.cpp.md | FIXED | EB F9 jump direction was WRONG (goes back into the cave → E9 hook vector, not "into the real body"); hotpatchUnhook return value (entry=pfn−2, not pfn) and write locations corrected; unhook-order wording fixed |
| functionHooks.h.md | PASS | matches header exactly |
| ReleasePatcher.cpp.md | FIXED | MAJOR: "-w 10558381 satisfies same gate … recursively" was WRONG — 10558381=0x00A11BAD fails both 0x0BADC0DE congruences and hits the no-op second gate (Application.cpp:1060); child-lifetime gotcha rewritten; isStartOfSection heuristic description corrected (checks bytes at −32/−64, not "pages") |
| ReleasePatcher.h.md | PASS | Application.cpp:1057 citation and congruence description correct |
| Crypt.cpp.md | FIXED | Usage claimed patch/update flow calls VerifyCryptSignature via ReleasePatcher.cpp — WRONG; sole caller is Application::setWindowFrame (Application.cpp:1108). Byte patterns (serial 1B 81 59 FA F8 22 8B 39 AB C0 0E 31 BB AD 43 09), return-mapping quirks, string-fragment obfuscation all verified correct |
| Crypt.h.md | FIXED | same wrong-consumer claim corrected |
| Application.cpp.md | FIXED | PlaceLauncher URL query fixed to request=RequestGame; everything else (gate at :1046–1059 incl. :1053 congruences, Initialize steps 1–16, flags table, -w 195936478 gotcha) verified correct |
| Application.h.md | PASS | getversionNumber() confirmed declaration-only; lifecycle order matches main.cpp |
| main.cpp.md | PASS | startup order, SW_HIDE, VirtualProtect(rbxVmpBase…), WM_COMMAND IDs 33042/40002 (rc lines 110–111) all verified |
| AppSettings.xml.md | PASS | values exact; LoadAppSettings semantics match |
| Document.h.md | PASS | isTelport misspelling real (header only); dead declarations confirmed by grep |
| Document.cpp.md | PASS | protocol split, HATE_DEBUGGER double-check, npos+2 wraparound gotcha all correct |
| View.h.md | PASS | matches header verbatim incl. comments |
| View.cpp.md | FIXED | NoGraphics pushes NO mode (doc implied otherwise); findBestMonitorMatch keep-condition direction inverted in doc (source keeps when current ≤ desired) |
| Teleporter.h.md | PASS | matches header |
| Teleporter.cpp.md | FIXED(minor) | line-range nit for releaseGameThread; rest exact incl. Application.cpp:1427 citation |
| GameVerbs.h.md | PASS | verb name strings confirmed ("Exit"/"Screenshot"/"RecordToggle"/"ToggleFullScreen") |
| GameVerbs.cpp.md | PASS | URLs, DE3515, helper-thread loop, dialog ctors all exact |
| UserInput.h.md | FIXED(minor) | SDLGameController.h location guess corrected to ClientShared/; declarations all match |
| UserInput.cpp.md | FIXED(minor) | DIDEVICEOBJECTDATA stack-math corrected (~20 B ⇒ ~41 KB); whitelist F1/F8/F11/SNAPSHOT + Alt-F4 verified against rc (only F1 & Shift+F8 accelerators exist) |
| RenderJob.h.md | PASS | header comment + members verbatim |
| RenderJob.cpp.md | PASS | VMProtect("34"), richard/suzanne stats, low-latency vs legacy paths, dead remoteCheatHelper all exact |
| FunctionMarshaller.h.md | PASS | verbatim incl. TODOs |
| FunctionMarshaller.cpp.md | FIXED | Usage wrongly said "RenderJob additionally calls ProcessMessages()" — only View::RemoveJobs calls it (twice); mechanics descriptions otherwise exact (closure.errorMessage never set, coalescing swap(1)==0) |
| WebBrowserAxDialog.h.md | FIXED | Usage claimed Document/Application reference it — GameVerbs.cpp is the sole consumer; line-77 STDMETHOD paren quirk verified verbatim |
| WebBrowserAxDialog.cpp.md | PASS | five window.external names/DISPIDs, reversed rgvarg, tile/titelString typos, boundary f93dcbA3, hardcoded GData key byte-for-byte, AddRef=1/Release=0 sink — all exact |
| RbxWebView.h.md | FIXED(minor) | quirk line-number misattributed (77 in WebBrowserAxDialog.h, 74 here); declarations otherwise exact |
| RbxWebView.cpp.md | PASS | UA override, Raymond-Chen comment, OnSize metric quirk, WindowClosing chain all exact |
| RandomPadding.cpp.md | PASS | 2^N−1=511 instantiations, /export keep-alive, zero callers confirmed |
| stdafx.cpp.md | PASS | trivially accurate |
| stdafx.h.md | FIXED(minor) | wintrust/wincrypt attribution moved to Crypt.cpp (was "release-patching plumbing"); include list + duplicate boost/bind verified |
| InitializationError.h.md | PASS | throw site View.cpp:229, catch main.cpp:142 confirmed |
| RobloxGoldenHashPatcher/main.cpp.md | FIXED | gotcha claiming -w 10558381 is same-congruence-family was WRONG (same root error as ReleasePatcher); system() run count corrected to 4–6; unsupported retarget_v143 claim removed; writeFile ifstream::binary quirk reworded cleanly; six-step algorithm otherwise exact |
| html_can.htm.md | FIXED | doc asserted browser-plumbing consumption — UNSUPPORTED: file is referenced NOWHERE (no .rc entry, not in vcxproj, no code ref); recertified as orphan asset with verbatim text preserved |
| html_con.htm.md | FIXED | added real wiring (WindowsClient.rc:143 IDR_HTML_CONTACTINGSERVER id 114) replacing false "paired … loaded by same plumbing" claim; messy "?No:" gotcha rewritten |
| INDEX.md | PASS | roster = exactly 37 rows ↔ 37 docs ↔ 37 sources; exclusions list matches the 10 undocumented files; lifecycle paragraph consistent with verified facts |

## Totals

- Sources fully read: **37 / 37** (plus full reads of Application.cpp, Crypt.cpp, UserInput.cpp, View.cpp, WebBrowserAxDialog.cpp, ReleasePatcher.cpp, RGHP/main.cpp and every other listed file)
- Docs reviewed: **38 / 38**
- **PASS:** 22 · **FIXED:** 16 (5 substantive security-relevant corrections, 11 minor precision fixes) · **FAIL:** 0

## Substantive findings (anti-tamper baseline)

1. **Golden-hash gate keys**: `-w 195936478` (=0x0BADC0DE) triggers patch mode (Application.cpp:1053 congruences). `-w 10558381` (=0x00A11BAD) is a *different*, do-nothing gate (:1060) used by ReleasePatcher's resumed child so recursion terminates. Writer had merged these into one family in two docs — corrected everywhere.
2. **VerifyCryptSignature consumer**: sole caller is Application::setWindowFrame (decoy message + HATE_SIGNATURE on failure); it does NOT gate ReleasePatcher or any update swap.
3. **functionHooks trampoline direction**: EB F9 at entry jumps backward onto the E9 in the pre-entry cave (chaining entry→cave→hook); resume path is entry+2. Unhook restores mov edi,edi first, returns true entry (pfn−2).
4. **html_can.htm is an orphan** (unwired anywhere); html_con.htm is the only HTML resource actually compiled in (IDR_HTML_CONTACTINGSERVER).
5. **WebBrowserAxDialog is consumed only by GameVerbs** upload flows; RbxWebView is the Document/Application URL window.
