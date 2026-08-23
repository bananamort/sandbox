# AGENTS.md

Instructions for AI coding agents working in this workspace.

## Project overview

This space turns the 2016 Roblox engine (`roblox-master-main/`) into a **sandbox script-environment logger**: a full-fidelity engine build running on Linux under Wine, upgraded to modern Luau, that executes untrusted scripts and reconstructs their behavior via C-level instrumentation. `docs/ARCHITECTURE.md` is the canonical source of truth — read it before making architectural changes. When this file and ARCHITECTURE.md conflict, ARCHITECTURE.md wins; when both are silent, ask.

## Hard constraints (never violate)

1. **`roblox-master-main/` is read-only reference.** All mutation happens in `roblox-sandbox/` (the git-tracked working copy). Never edit, move, or delete anything in the original tree.
2. **Never strip feature surfaces** — rendering, API surface, services, or runtime data (`content/`, `shaders/`, `PlatformContent/pc/`). Anything removed from the artifact is a script-probeable detection vector. This rule has no exceptions.
3. **VM-internal anti-tamper MAY be removed**: instruction encryption (`ckey` path in `lvm.c`), string-hash checks (`lapi.c`), SEH/xxhash self-checks, and the security guts (`ProgramMemoryChecker`, `functionHooks`, `robloxHooks`, `ApiSecurity`, `CheatEngine` checks, VMProtect markers). These are script-invisible; removing them is required for instrumentation.
4. **Stay 32-bit (Win32).** Toolchain target is VS2022/v143.
5. **One commit per feature**, not per phase. Phases span many features; every landed feature is its own commit so it is independently revertable and reviewable.
6. **No corners at the cost of correctness. Never write fallbacks.** If a fallback seems required, the initial implementation is wrong and the core issue went unaddressed — stop and fix the design instead. Forbidden patterns: silent catches, degraded-mode continuations, compatibility shims, heuristic fallbacks.
7. **Never compile, build, or test the sandbox locally.** All compilation and testing runs through GitHub Actions (`windows-latest` for MSVC builds; Linux + Wine jobs once runtime phases begin). Local work is limited to source analysis, scripted pruning, solution surgery, and manifest verification.
8. **Never guess dependency versions.** Identify FMOD/TBB/etc. versions from in-tree headers first (`fmod/include/fmod*.h`, linker inputs in `.vcxproj`s), then source matching-era binaries.
9. **Do not delete the trap set** in `roblox-sandbox/`: `Win/`, `ClientBase/`, `ClientShared/`, `Rendering/OpenVR|LibOVR|VrApi`, `fmod/include`, the `Library/` core subset (boost, SDL2, zlib, curl, SDK, VMProtect, Mesa, DSBaseClasses, cpp-netlib, w3c-libwww), `PropertySheets/`, `CustomBuildRules.*`.

## Directory map

- `roblox-master-main/` — pristine 2016 source drop. Reference only.
- `roblox-sandbox/` — pruned, modernized working copy. All edits happen here.
- `docs/ARCHITECTURE.md` — architecture + locked decisions.
- Key engine anchors: `App/script/ScriptContext.cpp` (`openState` ~602-927, `sandboxThread()` ~1249, `resumeImpl` ~3506), `App/Lua-5.1.4/src/` (VM being replaced by Luau), `App/util/ContentId.cpp`, `Network/GameConfigurer.cpp`.

## Build commands

macOS side (analysis, prune, solution surgery):

```sh
# verify prune manifest (workstream 1)
python3 tools/verify_prune.py roblox-sandbox/
# slim solution (idempotent)
python3 tools/slim_sln.py roblox-sandbox/Roblox.sln
```

CI — GitHub Actions (the ONLY place the sandbox ever compiles or runs):

```yaml
# .github/workflows/build.yml at repo root (workstream 2)
# runs-on: windows-latest        # VS2022 / v143 / Win SDK preinstalled
# steps: rebuild Boost (msvc-14.3, address-model 32)
#     -> msbuild Roblox.sln /p:Configuration=ReleaseRcc /p:Platform=Win32
#     -> msbuild Roblox.sln /p:Configuration=Release    /p:Platform=Win32
#     -> smoke-run RCCService.exe -Console
#     -> upload binaries as artifacts
```

Linux/Wine runtime (later phases): a second `ubuntu-latest` job adds wine prefix init, winetricks era CRT, one Xvfb per instance, and starts the logging proxy before any sandbox run.

## Verification gates

A phase is not done until its gate passes — link/run gates execute **in CI, never locally**; never report partial gates as complete:

- **1 Prune**: manifest diff clean; slimmed `.sln` opens in VS2022 with zero unavailable-project dialogs.
- **2 Build enablement**: `ReleaseRcc|Win32` and `Release|Win32` link successfully → `RCCService.exe` + `RobloxPlayerBetaRaw.exe`; `-Console` smoke-run OK.
- **3 Luau graft / 4 instrumentation**: globals-inventory dump identical pre/post graft; environment parity checklist passes; hooks emit logs on known-good test scripts.
- **6 End-to-end validation**: real obfuscated targets reconstruct meaningfully; anti-probe smoke tests pass under Wine.

## Code style

- Match surrounding legacy code (2016-era MSVC C++). Do not introduce modern syntax into engine sources except inside the Luau subtree, which owns its own standards.
- Comments sparse and why-only. No narration of tasks, fixes, or callers in code.
- Modifications stay additive and localized to mapped hot-spots. No drive-by refactors, no new abstractions, no speculative error handling.
- New tooling (prune/slim/harness scripts) lives in `tools/`, Python 3 stdlib only.

## Reading before writing

Tool-call read a file IN FULL before editing it or writing anything derived from it — documentation, summaries, edits, all of it. No exceptions, including files touched earlier in the same session.

## Documentation (workstream 7)

- Docs are written by SUBAGENTS only: one writer per module, never the orchestrator (context rot). Writers read every source file completely via tool calls BEFORE emitting any `.md`.
- Every claim in a doc must be grounded in the source text; anything undetermined is marked `UNKNOWN:` — speculation is deleted on sight.
- An INDEPENDENT reviewer subagent re-reads the sources and checks each doc claim-by-claim. Any doc that cannot be certified as read-grounded gets redone. Writer output is never trusted unread.
- Layout mirrors the source tree under `docs/roblox-master-main/` (+ `INDEX.md` per module directory).

## Security considerations

This workspace performs authorized local analysis of scripts the operator possesses. All sandbox egress — engine and script-initiated alike — flows through the local logging proxy, which records every request and response and forwards to the live endpoints unmodified. Responses are never fabricated; the operator accepts live forwarding of script-initiated requests as an operational choice. Never disable logging to make a run "pass"; if a probe detects the sandbox, record it as a fidelity finding, not an obstacle.
