# INDEX.md — Win

Directory: `roblox-sandbox/Win/` (28 first-party/vendored source files; no subdirectories)

Win is the Win32 platform layer: crash/error upload plumbing (`LogManager`, `ErrorUploader`, `DumpErrorUploader`, `ScriptErrorUploader`), browser-plugin launch contract (`SharedLauncher`), input translation for the DirectInput mouse/keyboard path (`UserInputUtil` plus a vendored `dinput.h`), the SDL-independent pieces of gamepad/video features (`VideoControl`, `DSVideoCaptureEngine`), OS/UAC interrogation (`VistaTools`), auth re-negotiation (`AuthenticationMarshallar`), and a small preserved anti-debug primitive (`CheckDbg`). Everything here compiles only into Windows targets; several files are dead code at baseline and are documented as such.

**Anti-tamper note**: `CheckDbg.cpp/.h` are the pristine baseline of the slated-for-removal anti-tamper code — their docs record exactly what exists today (`fs:[0x18]` TEB walk → PEB → `BeingDebugged` test via bit `0x00010000`; no callers anywhere in the tree).

| File | One-liner |
|---|---|
| AuthenticationMarshallar.h | Declares ticket re-negotiation class ("keeps auth cookies in sync between IE hosts") |
| AuthenticationMarshallar.cpp | GET `url?suggest=<ticket>` w/ auth domain attached; new ticket = response body; errors → "" |
| CheckDbg.h | Declares `__declspec(noinline)` anti-debug entry points `isDbg1/2/3` (no callers — dead) |
| CheckDbg.cpp | Inline-asm TEB walk (`fs:[0x18]`) → PEB first DWORD → tests `BeingDebugged` bit 0x00010000 |
| dinput.h | Vendored Microsoft DirectInput SDK header (1996-2000, unmodified) |
| DSVideoCaptureEngine.h | Declares DirectShow `IVideoCapture` backend (custom video/audio push filters, WMASF writer) |
| DSVideoCaptureEngine.cpp | Filter graph building, FMOD DSP audio tap, framebuffer download + 16:9 letterbox, `.wmv` output; 30-min cap |
| DumpErrorUploader.cpp | Crash-dump/log upload pump under `RobloxCrashDumpUploaderMutex`; "Too many dmp files"/"Empty!!!" placeholder posts |
| DumpErrorUploader.h | Declares dump uploader subclass + pre-allocated statics for the `.crashevent` post |
| ErrorUploader.cpp | `MoveRelative`: archive-or-delete file relocation helper for the uploader family |
| ErrorUploader.h | Base class: queue + recursive mutex + worker thread blob (`Cancel`/`IsUploading` are dead public API) |
| LogManager.cpp | Logs dir resolution, session-id naming, FastLog fan-out, minidump config, assert/failure hooks, COM error reporting |
| LogManager.h | Declares LogManager/MainLogManager/ThreadLogManager + RobloxCrashReporter hierarchy |
| ProcessInformation.h | Header-only RAII wrapper around Win32 `PROCESS_INFORMATION` (closes both handles) |
| ScriptErrorUploader.cpp | `.cse` core-script-error upload pump — fully implemented but never instantiated (dead) |
| ScriptErrorUploader.h | Declares the `.cse` uploader subclass (no consumers in tree) |
| SharedLauncher.cpp | Registry-driven launch pipeline for the browser plugin: path discovery, ticket auth, CreateProcess, version/update/is-up-to-date |
| SharedLauncher.h | Launch argument names, `LaunchMode` enum, EditArgs marshaling, exported StartGame family |
| sitelock.h | Verbatim Microsoft SiteLock 1.14 ATL sample (ActiveX activation restriction) — unused vendored copy |
| Tracer.cpp | Empty compilation-unit placeholder (copyright + two includes + empty namespace RBX) |
| UserInputUtil.cpp | DIK↔KeyCode↔VK tables, WM_ message mapping, mod codes, cursor-wrap strategies (border ratchet/fullscreen/hybrid) |
| UserInputUtil.h | Declares the static-only Windows input toolkit + `DIRECTINPUT_VERSION 0x0800` |
| VersionInfo.cpp | CVersionInfo implementation: VS_VERSIONINFO blob queries, string table, dot-version reformatter |
| VersionInfo.h | PJ Naughter's version-resource wrapper, refactored to std::string (`GetFileVersion/GetProductVersion` declared but never defined) |
| VideoControl.cpp | Recording lifecycle: SoundState/FMOD binds, frame callback install, FPS auto-adjust pause/resume |
| VideoControl.h | Declares IVideoCapture/SoundState/VideoControl (pause UI is a no-op stub) |
| VistaTools.cpp | IsVistaPlus/Is64BitWindows/elevation/UAC query implementations (throws instead of HRESULTs) |
| VistaTools.h | Query declarations + header-inline `VistaAPIs` LoadLibrary shim for SHGetKnownFolderPath + FOLDERID defines |

Cross-directory notes: WindowsClient/Application.cpp is the hub consumer (MachineConfiguration, RenderSettingsItem, DumpErrorUploader, MainLogManager `("Roblox", ".Client.dmp", ".Client.crashevent")`, VistaAPIs log cleanup); Win/LogManager.h also reaches RCCService and CSG/CSGKernel; Network/GameConfigurer uses `SharedLauncher::LaunchMode`. Dead-in-tree files: CheckDbg (anti-tamper baseline), ScriptErrorUploader, sitelock.h, Tracer.cpp.
