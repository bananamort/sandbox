# DeveloperConsole.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/DeveloperConsole.lua` (1433 lines)

## Purpose

Two-generation toggle shim for the in-game dev console (F9): if FFlag `NewInGameDevConsole`, delegates to DeveloperConsoleModule (lazy require, duplicate-rebuild support); else contains the FULL LEGACY console implementation — Local/Server log tabs with filters + word wrap, Server Stats bar charts, command bar (`LogService:ExecuteScript`) gated to creator.

## API / Behavior

### New-console path (lines 1–39)
- Creates BindableFunction `ToggleDevConsole` under ControlFrame (or script.Parent) — this is the bindable Help.lua/SettingsHub wait for.
- OnInvoke(duplicate): debounce-guarded; first call requires module, fetches `GetPermissions()` + `GetMessagesAndStats(permissions)`, constructs instance; later calls toggle Visible (duplicate=true forces rebuild).

### Legacy path (inside else, ~1390 lines)
- GUI: draggable/resizable DevConsoleContainer (min 350×180) w/ titlebar Modal button (first-person mouse unlock), custom scrollbar (handle drag math incl. ratio conversion), smoothstep gear animation for filter options bar.
- Tabs: LOCAL_CONSOLE/SERVER_CONSOLE/SERVER_STATS — button styling swaps; Server tab one-shot `LogService:RequestServerOutput()`; Stats tab spins NetworkClient child's RequestServerStats(true) + StatsReceived → 40-bar charts per stat name (min/max/current labels, bar heights normalized to max).
- Messages: localMessageList/serverMessageList capped at MAX_LIST_SIZE=1000 {Message,Time,Type}; ConvertTimeStamp maps server timestamps to local H:M:S via os.time offset; refresh debounced 0.1 s (comment: avoid lag under output storms); per-type color coding (error red/info blue/warning orange); toggles for Error/Warning/Info/Output/WordWrap re-render.
- Command bar: visible on Server tab iff `ConsoleCodeExecutionEnabled` flag AND isCreator (CreatorId match or CanManage flag); Enter → `LogService:ExecuteScript(code)`.
- Scrolling: offsets per console clamped to textHolderSize−viewport; wheel ±10 inside container; hold-repeat buttons after 0.6 s delay w/ reentrancy counter.
- Mouse.Move handler drives drag/resize/scroll while container visible; global functions throughout (initializeDeveloperConsole, AddLocalMessage, refreshTextHolderForReal, etc.).

## Usage

Engine binds F9 → ToggleDevConsole:Invoke. SettingsHub/Help also Invoke the ControlFrame bindable.

## Gotchas
- Legacy path uses capital-G globals? No — but uses `Delay(` capital-D (line 972) and `LoadLibrary("RbxUtility").Create`.
- refreshTextHolderForReal temporarily reparents labels to Dev_Container to measure TextBounds — ZIndex flicker hazard.
- initStatsListener assumes NetworkClient:GetChildren()[1] is the NetworkConnection — fragile.
- Command bar executes code client-side only via LogService; server execution not wired here.
