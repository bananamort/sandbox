# WindowsClient/Teleporter.cpp

## Purpose

Implementation of `RBX::Teleporter` (Teleporter.h) — the bridge between engine-side `TeleportService` and the Windows shell's game-teardown/join machinery. This is the in-session teleport half of the join flow: a running client does not spawn a new process to change places; it tears the current Document/View down and rejoins in-process.

## API

Real signatures:

- `void Teleporter::initialize(Application* app, FunctionMarshaller* marshaller)` — stores both raw pointers, then performs two global registrations:
  - `TeleportService::SetCallback(this)` — this object becomes THE TeleportCallback for the process (engine calls `doTeleport` on it).
  - `TeleportService::SetBaseUrl(GetBaseURL().c_str())` — hands the engine the same `BaseUrl` parsed from AppSettings.xml (see AppSettings.xml.md), so the TeleportService can build its own request URLs.
- `void Teleporter::doTeleport(const std::string& url, const std::string& ticket, const std::string& script)` (virtual override) — single statement: `marshaller->Submit(boost::bind(&Application::Teleport, app, url, ticket, script))`. The teleport request arrives on an engine/Lua thread; the marshaller hops it onto the main UI thread before any teardown runs.
- `bool Teleporter::isTeleportEnabled() const` (virtual override) — inline `return true;` (header). Teleporting is always enabled in this client.
- File-scope `static boost::thread releaseGameThread;` — declared at line 11 but **never referenced again in this file**. Dead global.

## Usage

Join flow (precision pair with View.cpp): `Application::Teleport(url, ticket, scriptUrl)` (Application.cpp:1427) executes on the UI thread and does: `currentDocument->PrepareShutdown()` → `mainView->Stop()` → `shutdownVerbs()` → `currentDocument->Shutdown()` → reset document → (if `FFlag::ReloadSettingsOnTeleport`) purge invalid GlobalBasic/Advanced settings children → `renewLoginAsync(authenticationUrl, ticket)` + `fetchJoinScriptAsync(scriptUrl)` → `StartNewGame(mainWindow, joinScriptResult, /*isTeleport=*/true)` → `authenticationResult.wait()`. `StartNewGame` with `isTeleport=true` skips the fresh-window path and submits `Document::Start(scriptResult, launchMode, isTeleport, ...)` onto the existing DataModel. First-join counterpart: `Application::InitializeNewGame` creates `new Document()` + `new View(hWnd)` + `mainView->Start(...)` + GuiService URL-window connections + `initVerbs()`.

## Gotchas

- `doTeleport` runs on whatever thread TeleportService invokes it from; ALL teardown/join work is deferred through FunctionMarshaller to the UI thread — do not call `Application::Teleport` directly from engine threads.
- The `url` parameter is the authentication/login URL and `script` the join-script URL; both are consumed by the async HTTP futures inside `Application::Teleport`, not by this file.
- `releaseGameThread` dead global suggests a removed background-release design; nothing joins or detaches it here.
- Teleporter lifetime: registered as a global callback via `SetCallback(this)`; if Application tears down without re-registering, a stale pointer remains in TeleportService (no unregister call exists in this module).
