# ARCHITECTURE

A sandbox script-environment logger built from the 2016 Roblox engine source (`roblox-master-main/`). A genuine Win32 engine build runs on Linux under Wine, executes modern Luau scripts, and logs at the C level so a script run can be reconstructed from outside the sandbox.

`AGENTS.md` governs agent conduct (build rules, commits, style). This file governs architecture. Decisions below are settled; changing one happens here first, with the user.

## Decisions

**1. Runtime is Wine on Linux executing genuine Win32 binaries.**
All sandbox control — VM hooks, egress interception, script injection, time control — is implemented in source we recompile; Wine only runs the artifact. Win32 semantics stay intact (SEH, CRT, registry layout, DX9 shader compilation). A native Linux port partially exists in-tree (root `CMakeLists.txt` builds `libroblox.so` including the GLES renderer) but would need new GL-context and platform glue for zero fidelity gain while Wine is available.

**2. Everything targets Win32.**
Authentic profile, and Lua cannot meaningfully probe bitness (numbers are doubles either way). x64 stays out of scope until forced; if that day comes, core libraries are already x64-proven via the Xbox One (Durango) configurations.

**3. Embedded Lua 5.1.4 is replaced by upstream Luau. No transpilation.**
The vendored VM is heavily patched Lua 5.1.4, and Luau descends from this exact lineage, so this is a migration rather than a transplant. Host-side scripts compile from text (`LuaVM::load` becomes `luau_compile`/`luau_load`). Mechanical work: ~121 `lua_pushcfunction` sites gain a debug-name argument; `lua_resume` gains the `from` parameter, contained because all resumes funnel through `resumeImpl` (`ScriptContext.cpp:3506`). Real work: `RobloxExtraSpace` (`luaconf.h:763-893`) maps onto Luau thread data; homegrown yield continuations map onto Luau native continuations; reimplement `lua_pushfunction(L, WeakFunctionRef)`, `lua_resetstack`, and the RBX debug library. RSB1 bytecode serialization serves client replication only and stays out unless replication becomes a requirement.

**4. Anti-tamper code comes out.**
Instruction decryption (`lvm.c:389-411`), string-hash checks (`lapi.c:384-405`), SEH-chain detection (`lvm.c:874`), xxhash self-checks (`ScriptContext.cpp:1436`), `ProgramMemoryChecker`, `functionHooks`, `robloxHooks`, `ApiSecurity`, CheatEngine checks, VMProtect markers. None of it is visible to scripts, and all of it fights our own hooks. Removal must not change any Lua-visible behavior — that would violate 5.

**5. Feature surface never shrinks.**
Rendering, APIs, services, and runtime data (`content/`, `shaders/`, `PlatformContent/pc/`) ship enabled and intact. A stripped feature is a probeable hole. Deleting unlinked source directories does not affect the artifact; that case is governed by 6 instead.

**6. All work happens in `roblox-sandbox/`, a git-tracked copy. `roblox-master-main/` is read-only reference.**
Prune anything with no path into `RCCService.exe`, `RobloxPlayerBetaRaw.exe`, or their runtime data. Do-not-delete set: `Win/`, `ClientBase/`, `ClientShared/` (compiled directly into targets; `CSGKernel.cpp:30` includes `../Win/LogManager.h`), `Rendering/OpenVR|LibOVR|VrApi` headers, `fmod/include`, the `Library/` core subset (boost, SDL2, zlib, curl, SDK, VMProtect, Mesa, DSBaseClasses, cpp-netlib, w3c-libwww), `PropertySheets/`, `CustomBuildRules.*`, and the runtime-data directories. Slimming `Roblox.sln` means removing each project's `Project(...)` line, all its `{GUID}.<config>` lines under `ProjectConfigurationPlatforms`, its `NestedProjects` children, and emptied solution folders — stale GUID lines make MSBuild attempt removed projects regardless.

**7. Host shell is the game client with a harness entry mode (load local place file, execute target scripts). Studio is not revived. RCCService remains available as server-side complement.**
Targets are live-game scripts and several branch on `RunService:IsStudio()`; measured under Studio they behave differently, corrupting the observation. Studio's UI shell is Qt 4.8.5 + QtWebKit + QTitanRibbon — dead upstream and used by nothing else in our build graph, while engine-side modifications are host-independent anyway (`App/script/` is shared by both shells). Studio's elevated command-bar privilege is replicable in the client through the identity system (`RobloxExtraSpace.identity`): the harness chooses the tier at `startScript`. All engine and script egress flows through the local logging proxy (`<BaseUrl>` in `AppSettings.xml` points at it): every request is recorded, then forwarded to the live endpoint, and the response passes back unmodified. No hosts-file editing. Accepted consequences: retired `.ashx` paths return whatever modern upstream returns today (the harness loads places from disk, so the join path goes unused); upstream variance makes runs non-deterministic — accepted by operator. Correction to earlier docs: the engine contains no `s3.amazonaws.com` references.

**8. Toolchain is VS2022/v143, retargeted from v140_xp; Boost rebuilt (msvc-14.3, x86); `WindowsTargetPlatformVersion` bumped to the installed SDK.**
Replace DirectShow `strmbase.lib` and rebuild zlib/curl from bundled sources only if linkage demands it. A conformance-fix wall goes to the user as a toolchain decision, never worked around silently (see 11).

**9. Missing dependencies are sourced header-first. No version guessing.**
FMOD version is read from `fmod/include/fmod*.h`; the matching win32 `fmod_vc.lib` + `fmod.dll` land in `fmod/win32/lib/`. TBB library names come from the linker inputs of both targets; Intel TBB 4.1 lands in `TBB_4_1/`. `Log/` and `RobloxInstall/` are absent yet tolerated by include paths — touch them only on compiler evidence. Mesa is present, x86.

**10. Builds and tests run only on GitHub Actions. Never locally.**
`windows-latest` (VS2022/v143 and SDK preinstalled) for MSVC builds; `ubuntu-latest` + Wine + Xvfb jobs join when runtime phases start. Local machines do analysis, prune scripts, solution surgery, and manifest checks — nothing that compiles.

**11. No fallbacks. If a fallback looks necessary, the implementation is wrong; fix the root cause.**
Forbidden: silent catches, degraded-mode continuations, compatibility shims, heuristic fallbacks. Changing strategy after demonstrated failure (e.g., abandoning v143) is allowed — as an explicit user decision whose replacement clears the same gates with nothing masked.

**12. One commit per feature. Phases are milestones, not commit units.**

## Layout after pruning

- Core libraries: `App/`, `Base/`, `Network/`
- Renderer (intact): `Rendering/GfxCore/`, `Rendering/GfxRender/`; shader packs in `shaders/`
- Scripting VM: `App/Lua-5.1.4/` replaced by Luau (see 3); bridge in `App/script/` — `ScriptContext.cpp` carries `openState` (:602-927), `sandboxThread()` (:1249), `resumeImpl` (:3506); third-party registration hook is `registerClassLibrary` (`LuaLibrary.{h,cpp}`)
- Client shell + harness: `WindowsClient/main.cpp:91`; `ClientBase/`, `Win/`
- Server complement: `RCCService/RCCService.cpp:632`, gSOAP job host, `-Console` flag
- Logging proxy: local process under workspace `tools/`, selected via `<BaseUrl>`; records all traffic, forwards live
- Instrumentation: hooks inside shared engine code (next section)

## Instrumentation

Hooks live in shared engine code and are indistinguishable from the implementation itself:

- `openState` / globals setup — inventory of the exposed environment
- `startScript` / `LuaVM::load` — chunk sources, chunknames, nested `loadstring` payloads
- VM loop and bridge layer — function enter/exit, global get/set, constant access
- `RBX::Http` layer — every egress: URL, method, payload
- Scheduler and yield paths — thread lifecycles, timing behavior

Logging cannot be disabled from inside the sandboxed environment.

## Pipeline and gates

Workstreams are numbered by execution order. Gates are pass/fail; link and run gates execute in CI only.

- **1 Prune**: manifest diff clean; slimmed `.sln` parses with zero unavailable projects
- **2 Build enablement**: CI links `ReleaseRcc|Win32` and `Release|Win32` into `RCCService.exe` + `RobloxPlayerBetaRaw.exe`; `RCCService -Console` smoke-runs
- **3 Luau graft**: globals-inventory dump identical before and after; era test corpus compiles and runs under Luau
- **4 Instrumentation**: hooks emit expected event streams on known-good scripts; parity checklist shows no behavioral delta
- **5 Wine runtime**: harness runs headless under Xvfb; proxy intercepts all egress
- **6 End-to-end validation**: real obfuscated targets reconstruct; anti-probe suite passes; probes that detect the sandbox are logged as fidelity findings

Order: **1 → 2 → (3 ∥ 4) → 5 → 6**, with **7 Documentation** running as a parallel track: every kept first-party file gets a verbatim-grounded `.md` under `docs/roblox-master-main/` before surgery touches its area. Writer subagents read sources in full via tool calls before writing anything; independent reviewer subagents verify every claim against the sources, and any doc that fails certification is redone.
