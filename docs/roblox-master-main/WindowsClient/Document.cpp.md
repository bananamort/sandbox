# WindowsClient/Document.cpp

## Purpose

Implementation of `RBX::Document`: creates the `SecurePlayerGame` bound to BaseUrl, configures DataModel services, and — on the DataModel thread — consumes the join-script HTTP future and either hands a JSON payload to `Game::configurePlayer` or executes the Lua join script in a new thread. This is the final hop between "HTTP response received" and "place code running".

## API

- `void Document::Initialize(HWND hWnd, bool useChat)` — `marshaller = FunctionMarshaller::GetWindow();` then **`game.reset(new RBX::SecurePlayerGame(NULL, GetBaseURL().c_str()))`** (the join target comes from AppSettings BaseUrl); `configureDataModelServices(useChat, ...)` sets UserInputService keyboard/mouse enabled; under a Write lock: if `FLog::PlayerShutdownLuaTimeoutSeconds > 0`, eagerly creates ScriptContext; connects `gameLoadedSignal → gameIsLoaded` (`MainLogManager::setGameLoaded()`).
- `void Document::Start(HttpFuture& scriptResult, const SharedLauncher::LaunchMode launchMode, bool isTeleport, const char* vrDevice)` — fires `startedSignal(isTeleport)` first (Application reports ClientLaunch influx), clears the UI message via SetUiMessage(""), calls `executeScript(...)`, and emits GA timing "Join script executed" for non-teleports. Runs as a DataModel Write task.
- `void Document::executeScript(HttpFuture&, LaunchMode, const char* vrDevice) const` — the join core:
  1. Release-only: `VMProtectIsDebuggerPresent(true)` (user + kernel debuggers) OR'd into `HATE_DEBUGGER` hack flag, checked before *and* after fetching data.
  2. `data = scriptResult.get()` under `Security::Impersonator(COM)`; exception ⇒ event-log error + GuiService message "Unable to join game. Please try again later." + return (no retry).
  3. `ProtectedString verifiedSource = ProtectedString::fromTrustedSource(data); ContentProvider::verifyScriptSignature(verifiedSource, true);` — signature failure throws ⇒ caught ⇒ return.
  4. If `dataModel->isClosed()`, bail.
  5. Protocol split: `firstNewLineIndex = data.find("\r\n")`; **if `data[firstNewLineIndex+2] == '{'`** → `game->configurePlayer(Security::COM, data.substr(firstNewLineIndex+2), launchMode, vrDevice)` (modern JSON config after a first script line); else → create ScriptContext and `context->executeInNewThread(Security::COM, verifiedSource, "Start Game")` (classic Lua join script).
- `static void setUiMessageImpl(shared_ptr<DataModel>, const std::string&)` — dm->setUiMessage/clearUiMessage plus GuiService::setUiMessage(UIMESSAGE_INFO,...) creating GuiService if absent.
- `void Document::SetUiMessage(const std::string&)` — submitTask(Write) wrapper around the above.
- `void Document::PrepareShutdown()` — gives scripts a deadline: `scriptContext->setTimeout(FLog::PlayerShutdownLuaTimeoutSeconds)` when >0 ("this will kill all misbehaving (hanging) scripts").
- `void Document::Shutdown()` — FunctionMarshaller::ReleaseWindow(marshaller); `game->shutdown(); game.reset();`.
- `std::string Document::GetSEOStr() const` — screenshot SEO info from DataModel, else IDS_DEFAULT_IMAGE_INFO string resource.
- `void Document::configureDataModelServices(bool useChat, RBX::DataModel*)` — currently only UserInputService keyboard/mouse enable; `useChat` itself unused here (UNKNOWN consumer elsewhere).

## Usage

Harness interception: replace/observe `scriptResult` content to control what the client executes; the `'{'` sniff decides configurePlayer-vs-Lua path, so a harness can serve either protocol from one endpoint.

## Gotchas

- If the fetched script contains no `"\r\n"` at all, `data[npos+2]` wraps to index 1 — out-of-bounds read on tiny payloads (latent UB).
- `startedSignal(isTeleport)` fires before the script is fetched/validated: "JoinScriptTaskStarted" analytics ≠ successful join.
- executeScript swallows most errors with an early `return`; only bad_alloc rethrows.
- The TODO comment "VMProtect this section" confirms this function was considered sensitive and left unprotected in this snapshot.
