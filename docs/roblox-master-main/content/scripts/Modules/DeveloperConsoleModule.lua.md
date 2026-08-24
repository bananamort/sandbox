# DeveloperConsoleModule.lua

Source: `roblox-sandbox/content/scripts/Modules/DeveloperConsoleModule.lua` (2978 lines; `RobloxGui.Modules.DeveloperConsoleModule`; header credit "Made by Tomarty")

## Purpose

Implementation of the "new" developer console (the F9 window): a draggable/resizable tabbed window showing Local/Server log output with type filters and text search, plus creator-only Server Scripts / Server Stats / Server Jobs tabs that render live bar charts of script activity, duty cycle, steps/sec and step time. Also contains the permission gate and the LogService/stats plumbing shared by every console instance.

## API (returned table `DeveloperConsole`)

- `DeveloperConsole.GetPermissions()` → singleton permissions table: `CreatorFlagValue` (FFlag `UseCanManageApiToDetermineConsoleAccess`), `IsCreator` (`LocalPlayer.userId == game.CreatorId`, or when the flag is on an HttpRbxApiService GET `/users/<id>/canmanage/<placeId>` JSON check via HttpService:JSONDecode), `ServerCodeExecutionEnabled` (`IsCreator` and FFlag `ConsoleCodeExecutionEnabled`), `ClientCodeExecutionEnabled` (always false unless DEBUG), `MayViewClientLog = true` for everyone, `MayViewServerLog/ServerStats/ServerScripts/ServerJobs = IsCreator`. DEBUG local flips everything on.
- `DeveloperConsole.GetMessagesAndStats(permissions)` → singleton with `OutputMessageSyncLocal` (seeds from `LogService:GetLogHistory()`, then appends `LogService.MessageOut`), `OutputMessageSyncServer` (`LogService.ServerMessageOut` after `RequestServerOutput()`), `StatsSyncServer` (hooks `NetworkClient:GetChildren()[1].StatsReceived` and calls `RequestServerStats(true)`). Each message sync exposes `GetMessages()`, `MessageAdded` signal; timestamps converted to local HH:MM:SS by `ConvertTimeStamp`; known-spam warnings ("ClassDescriptor failed to learn", etc.) filtered on add.
- `DeveloperConsole.new(screenGui, permissions, messagesAndStats)` → devConsole object (metatable `Methods`). Constructor builds the whole window: drag handle, exit button (gamepad B unbound via ContextActionService `RBXDevConsoleCloseAction`), resize corner, gear options tray animation, custom scrollbar, backup mouse-cursor ImageLabel shown when `UserInputService.MouseIconEnabled` is false. Default tabs:
  - **Local Log** (all users) — output + command line only if `ClientCodeExecutionEnabled`.
  - **Server Log** (creator) — command line executes typed text via `LogService:ExecuteScript(text)` when `ServerCodeExecutionEnabled`.
  - **Server Scripts** — chart list of per-script Activity % and Rate/s charts, green-yellow-red notify stripe by activity^¼.
  - **Server Stats** — one chart per numeric server stat.
  - **Server Jobs** — Duty Cycle %, Steps Per Sec, Step Time ms charts per job.
- Methods of note: `SetVisible(visible[, animate])` (animate ignored), `AddTab(text, width, body, openCallback)`, `RefreshTabs`, `CreateOutput(messages, filter)` (label pool capped at MAX_LINES=2048, one-frame-debounced refresh), `CreateCommandLine()` (up/down input history incl. "weak" entries discarded on next submit), `CreateChartList(config)` / `CreateChart(points, title, statIndex, fmt)` (autoscaling bars with cosine-eased tweens), `CreateScrollbar`, `ConnectButtonHover/Dragging`, `ConnectSetVisible`, frame size/position bounding (min 300×200).
- Options tray: per-message-type checkboxes (Output/Info/Warning/Error), Word Wrap toggle, "Show inactive" toggle for scripts, "Contains:" search box filtering both logs and stat names.

## Usage

Loaded lazily by `CoreScripts/DeveloperConsole.lua` (the F9 shim): `require(CoreGui.RobloxGui.Modules.DeveloperConsoleModule)`, then `GetPermissions()` → `GetMessagesAndStats(permissions)` → `new(screenGui, permissions, messagesAndStats)`. The module itself depends on `LoadLibrary('RbxUtility').CreateSignal` for all internal signals.

## Gotchas

- Real bug (~line 1288): chart-button creation reads `Style.ScriptBackgroundTransparency`, but Style defines `ScriptButtonTransparency` — assigning nil to `BackgroundTransparency` errors inside the StatsReceived handler, so the first attempt to populate a Server Scripts list dies in the connection callback.
- `assert(point)` in graph `OnPointAdded` fires if a stat point is missing while the chart is visible — author's own "possible game crasher" comment sits above the adjacent bar-pruning loop.
- `CreateScrollbar` does `Primitives.FolderFrame(main, ...)` passing its own not-yet-assigned local as parent (nil at runtime); works only because the caller parents `scrollbar.Frame` afterwards.
- `SetVisible`'s `animate` parameter is silently unused; the frame always snaps and resets to default dimensions on open.
- Tab scrollbar-position save/restore (`SavedScrollbarValue`) is flagged "doesn't save correctly"/"doesn't load correctly?" in author comments.
- The intended incremental-refresh parameter of `output.RefreshMessages(startPosition)` is deliberately discarded ("Failed optimization") — every refresh re-lays out up to 2048 labels.
- Output labels never get a Font assigned (assignment commented out), so they render in the default font regardless of Style.
- `IsCreator` via `game.CreatorId` doesn't handle group-owned games (author comment defers to the canmanage API flag).
- Stats plumbing assumes `NetworkClient:GetChildren()[1]` is the ClientReplicator.
- `CreateDisconnectSignal:connect` accepts table/userdata "listeners" by overwriting the argument variable with a disconnector closure — the passed object survives only through that closure.
- Message-type checkbox count relies on `#Style.MessageColors` returning 3 for the {[0..3]} table (0-keyed entries live in the hash part) — fragile Lua length-operator dependence.
- Stray `--]]` block-comment terminator near line 2965 (leftover of removed code); cosmetic.
- Easter egg: players ReeseMcBlox (56449) and NobleDragon (6949935) get a pink console color scheme.
