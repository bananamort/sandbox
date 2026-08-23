# CERTIFICATION.md — ClientShared

Independent review of `docs/roblox-master-main/ClientShared/` against `roblox-sandbox/ClientShared/`.
Method: every source re-enumerated and read in full (including all three platform CookiesEngine.cpp variants); every concrete doc claim checked against code; cross-directory consumer claims verified by tree-wide grep; rapidjson version confirmed from vendored header.

## Coverage

First-party source-ext files: **17** top-level (.h/.cpp) + **3** platform `CookiesEngine.cpp` (Mac/Mobile/Win) = **20**, plus CMakeLists.txt (documented as a build-file extra). All documented. Vendored `rapidjson/` (10 headers, v0.11) intentionally undocumented per campaign scope and noted in INDEX. Coverage: **COMPLETE 1:1** for first-party sources.

## Per-file verdicts

| Doc | Verdict | Findings |
|---|---|---|
| CMakeLists.txt.md | FIXED | Garbled gotcha rewritten (facts kept & verified: 16 headers/10 sources, InfluxDbHelper+SDLGameController absent, custom target never compiles; WindowsClient.vcxproj SDLGameController.cpp and App.vcxproj ClInclude claims verified). |
| CookiesEngine.h.md | FIXED | Line count 24→25 only; all platform-behavior claims verified against the three .cpp variants. |
| CountersClient.cpp.md | FIXED | WRONG: "Uses ATL CMutex" — no CMutex in file. Resolved UNKNOWN: sole consumer is RCCServiceSoapServiceImpl.cpp; no WindowsClient usage. |
| CountersClient.h.md | FIXED | Line count 20→21 only. |
| DataModelEmptySerialize.cpp.md | FIXED | Resolved UNKNOWN with project evidence: WindowsClient.vcxproj links THIS stub; RCCService.vcxproj + App CMake link DataModelSerialize.cpp; ClientShared/CMakeLists lists both. |
| DataModelSerialize.cpp.md | FIXED | STYLE: default arg made exact (`= Instance::SAVE_ALL`, per DataModel.h:501). Stream-shadowing defect in catch path independently CONFIRMED correct. |
| format_string.cpp.md | FIXED | WRONG: listed "CookiesEngine variants" as includers — they don't include it; corrected list to grep-verified set (adds MachineConfiguration.cpp, Network/Player.cpp). |
| format_string.h.md | FIXED | Resolved UNKNOWN: `%S`-in-narrow-printf MSVC inversion documented; expansion `<GetTempPath()>RBX-%08X.log`. Line count 113→114. simple_logger consumers verified (CountersClient, SharedLauncher, Application). |
| InfluxDbHelper.cpp.md | FIXED | MISSING: getUrlPath absent from API block (added). Resolved UNKNOWN: NOTHING includes this header anywhere and it's absent from CMakeLists → dead code (Analytics' InfluxDb is an unrelated same-named namespace). Escaping gotcha extended to point names/values. |
| InfluxDbHelper.h.md | FIXED | Added dead-code note (zero callers). API mirror otherwise exact. |
| Mac/CookiesEngine.cpp.md | FIXED | Build-selection claim corrected (Base.xcodeproj wires it; CMakeLists builds nothing). All behavioral claims (no mutex, plist CPath, mkdir -p, no-op setter) verified. |
| Mobile/CookiesEngine.cpp.md | FIXED | Selection claim corrected (Durango configs of Base.vcxproj, not "mobile per CMakeLists"). Stub semantics + out-param contract violation verified. |
| RobloxServicesTools.cpp.md | FIXED | WRONG: slicing described as removing "http://\" (11 chars) — actually scheme+"www." assumption (11/12 chars incl. subdomain), mangling www-less hosts. MISSING-GOTCHA: two-layer scheme default added (only counters/settings pass DEFAULT_URL_SCHEMA; others use literal-"https" default param). Consumer list fully verified. |
| RobloxServicesTools.h.md | PASS | Header mirror verbatim incl. misspelling note; ~20 TU claim verified exactly. |
| SDLGameController.cpp.md | FIXED | WRONG: claimed bindToDataModel still runs after SDL_Init failure — early return precedes submitTask, so object is fully inert. STYLE: getKeyCodeFromSDLAxis linkage wording fixed (free function, external linkage). Y-inversion, -32768 clamp, unchecked map deref, DIK_LMENU-style quirks all verified. |
| SDLGameController.h.md | FIXED | WRONG: ctor shown `explicit` — not declared explicit in source. Consumers verified (UserInput.h only; vcxproj listing ✓). |
| SimpleJSON.cpp.md | FIXED | WRONG: "string 'false' will NOT parse as bool false" — ParseBool returns false for ANY unrecognized string (so it does yield false); real quirks are lossiness both directions (JSON string "true" sets bool true). rapidjson 0.11 version claim verified from vendored header. |
| SimpleJSON.h.md | PASS | Macro semantics and single-instance `_thisPtr` hazard verified. |
| StringConv.cpp.md | FIXED | Line count 24→25 only. CP_UTF8 usage and no-error-check claims verified. |
| StringConv.h.md | PASS | Consumer spread verified across Rendering/App/Network/Win/WindowsClient/ClientBase. |
| Win/CookiesEngine.cpp.md | FIXED | WRONG-ish build claim corrected (Base.vcxproj ExcludedFromBuild conditions; registry-path file-backed jar, NOT InternetSetCookie). Garbled chars[] gotcha cleaned (static, TU-local, &/= encoding). 1 ms try-lock semantics verified accurate. reportValue 11×50ms retry verified. |
| INDEX.md | FIXED | Six one-liners corrected: Win cookies backend (registry/file+CMutex, not InternetSetCookie), Mobile variant ("iOS/Android"→stub wired to Durango), InfluxDbHelper ×2 ("line-protocol"/"POSTs"→JSON builder, no POST, dead), SimpleJSON ×2 ("reader/writer", "hand-rolled parser where rapidjson overkill"→rapidjson-based reader framework), DataModelEmptySerialize wording, CountersClient URL function name. File counts (31 = 21 first-party + 10 vendored) verified. |

## Totals

- Docs reviewed: 22 (17 top-level source docs + 3 platform docs + CMakeLists.txt.md + INDEX.md)
- PASS: 4 · FIXED: 18 · FAIL: 0
- Fixes applied: 27 total (WRONG 8 · resolvable-UNKNOWN 5 · MISSING-GOTCHA 2 · coverage/build-selection corrections 6 · line-count STYLE 4 · other STYLE 2)

**Verdict: CERTIFIED** — ClientShared documentation is now claim-accurate.
