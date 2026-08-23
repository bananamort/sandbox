# WindowsClient — INDEX

Documentation for `roblox-sandbox/WindowsClient/` — the 2016 Windows game client shell (`RobloxPlayerBeta.exe`). One `.md` per first-party source file, including the standalone RobloxGoldenHashPatcher subproject and the two local HTML assets. Build plumbing (.vcxproj/.filters/.sln, .rc, resource.h, ReadMe.txt, icons/cursors) is intentionally undocumented.

## Lifecycle paragraph

`_tWinMain` (main.cpp) gates on SSE2, stacks an `Application`, parses sibling AppSettings.xml for BaseUrl before any window exists, applies the command line (boost::program_options; magic `-w <0x0BADC0DE-congruent key>` routes to protectVmpSections + Security::patchMain and exits — the golden-hash patch mode), fetches ClientAppSettings over HTTP while still windowless, creates an always-hidden 800×600 window, and calls `Application::Initialize`. Initialize installs the anti-tamper layer (`hookApi`: FindWindowA hot-patch + ntdll KiUserExceptionDispatcher call-site patch from robloxHooks.cpp), initializes the crash reporter, probes cheat engines, then joins: `InitializeNewGame` builds Document → View (graphics backend fallback chain lives in the View ctor) → GuiService wiring → verbs. A join is driven by Document/Application over HTTP (PlaceLauncher → auth ticket → join script); in-session place switches come back through Teleporter::doTeleport marshalled onto the UI thread into `Application::Teleport`, which tears down Document+View and rejoins in-process. Once a game runs, RenderJob steps every frame under the TaskScheduler (marshalling renderPrepare/renderPerform to the view thread via the per-thread FunctionMarshaller window), UserInput pumps DirectInput + Win32 messages through the accelerator whitelist into UserInputService, and the hidden main window stays hidden until post-join gating calls `View::ShowWindow` (persisted geometry, foreground steal, optional fullscreen via changeResolution). Shutdown reverses the chain — LeaveGameVerb posts WM_CLOSE, WndProc does AboutToShutdown → PostQuitMessage, the pump exits, main.cpp re-enables RWX on the VMProtect sections whose bounds ReleasePatcher filled, and `Application::Shutdown` runs.

## Roster

| Source | Doc | One-line role |
|---|---|---|
| main.cpp | main.cpp.md | `_tWinMain`, WndProc, startup order, message pump |
| Application.cpp | Application.cpp.md | Application lifecycle, settings/args, join + Teleport, verbs init |
| Application.h | Application.h.md | Application class surface |
| AppSettings.xml | AppSettings.xml.md | Bootstrap XML: BaseUrl / ContentFolder / SilentCrashReport / HideChatWindow |
| Document.cpp | Document.cpp.md | Document/game-session construction around the DataModel |
| Document.h | Document.h.md | Document class surface |
| View.cpp | View.cpp.md | Graphics-backend fallback, fullscreen/resolution, Start/Stop wiring, deferred ShowWindow |
| View.h | View.h.md | View class surface |
| Teleporter.cpp | Teleporter.cpp.md | In-session teleports: TeleportService callback → marshalled Application::Teleport |
| Teleporter.h | Teleporter.h.md | Teleporter class surface |
| GameVerbs.cpp | GameVerbs.cpp.md | Exit/screenshot/video/fullscreen verbs incl. upload endpoints |
| GameVerbs.h | GameVerbs.h.md | Verb class declarations |
| UserInput.cpp | UserInput.cpp.md | DirectInput8 pipeline, accelerator whitelist, mouse wrap/acquire |
| UserInput.h | UserInput.h.md | UserInput class surface |
| RenderJob.cpp | RenderJob.cpp.md | Per-frame render job; speedhack/debugger probes; IMetric stats |
| RenderJob.h | RenderJob.h.md | RenderJob class surface |
| FunctionMarshaller.cpp | FunctionMarshaller.cpp.md | Per-thread ATL window: sync Execute / coalesced async Submit |
| FunctionMarshaller.h | FunctionMarshaller.h.md | FunctionMarshaller class surface |
| WebBrowserAxDialog.cpp | WebBrowserAxDialog.cpp.md | IE ActiveX upload dialogs; YouTube GData POST w/ embedded key |
| WebBrowserAxDialog.h | WebBrowserAxDialog.h.md | Dialog + event sink declarations |
| RbxWebView.cpp | RbxWebView.cpp.md | In-game URL window; session UA override; GuiService close signal |
| RbxWebView.h | RbxWebView.h.md | RbxWebView + WebBrowserEvents declarations |
| robloxHooks.cpp | robloxHooks.cpp.md | Anti-tamper baseline: FindWindowA hot-patch, ntdll KiUserExceptionDispatcher rel32 patch |
| RobloxHooks.h | RobloxHooks.h.md | Hook-layer public surface |
| functionHooks.cpp | functionHooks.cpp.md | Generic hotpatchHook/Unhook primitives + environment sanity check |
| functionHooks.h | functionHooks.h.md | Primitive declarations |
| ReleasePatcher.cpp | ReleasePatcher.cpp.md | Golden-hash patcher v2 (in-process PE rewriter, `.zero` section) |
| ReleasePatcher.h | ReleasePatcher.h.md | patchMain() declaration |
| Crypt.cpp | Crypt.cpp.md | Authenticode verification + cert pinning (serial/issuer/subject) |
| Crypt.h | Crypt.h.md | VerifyCryptSignature declaration |
| RandomPadding.cpp | RandomPadding.cpp.md | Weekly binary-layout jitter via junk-code template expansion |
| stdafx.cpp | stdafx.cpp.md | PCH generator TU |
| stdafx.h | stdafx.h.md | Win32/ATL/Boost umbrella + shdocvw #import |
| InitializationError.h | InitializationError.h.md | RBX::initialization_error exception |
| RobloxGoldenHashPatcher/main.cpp | RobloxGoldenHashPatcher/main.cpp.md | Golden-hash patcher v1 (external tool; `-w 195936478` dump-mode driver) |
| html_can.htm | html_can.htm.md | "Unable to connect" fallback page |
| html_con.htm | html_con.htm.md | "Contacting the server..." placeholder page |

REMAINING: none.
