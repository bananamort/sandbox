# TenFootInterface.lua

Source: `roblox-sandbox/content/scripts/Modules/TenFootInterface.lua` (344 lines)

## Purpose

"Sets up some special UI for ROBLOX TV gaming": platform-gated module providing a big top-right HUD container with a vertical display stack, an oversized health bar factory, and a single-leaderstat "top stat" display for living-room consoles.

## API / Behavior

- `IsEnabled()` — true when UserInputService:GetPlatform() ∈ {XBoxOne, WiiU, PS4, AndroidTV, XBox360, PS3, Ouya, SteamOS}; FORCE_TEN_FOOT_INTERFACE=false dev override.
- Local `Util.Create'Type'{props}` builder (numeric keys = children).
- Display-stack machinery: 350×100 ImageButton "TopRightContainer" lazily parented to RobloxGui; `addToDisplayStack` appends + repositions Y after last item (+4px) and hooks each object's Changed("Visible") to auto remove/re-add; `removeFromDisplayStack` shifts subsequent items up; `addBackToDisplayStack` shifts down. NOTE: remove/add-back use GLOBAL variables moveUpFromHere/moveDownFromHere and addBack reads AbsolutePosition of the just-reshown object.
- `CreateHealthBar()` — builds HealthContainer (1,−86 × 50 @ x=92) with black .5 bg, inner holder, GREEN fill frame (#1BFC6B), "Health" label; returns `{Container, username(invisible dummy), HealthContainer, healthFill}` — the caller wires health→fill.
- `SetupTopStat()` → returns `{SetTopStatEnabled(bool)}` API:
  - OneStatFrame w/ StatName/StatValue Size36 labels (stroke grey), pushed on display stack.
  - Watches LocalPlayer leaderstats: first valid stat child (String/Int/Bool/Number/DoubleConstrained/IntConstrainedValue) becomes displayedStat; Changed updates text; unparenting clears + retries via tenFootInterfaceChanged.
  - Busy-waits for Players service + LocalPlayer.

## Usage

Required by nearly every CoreScript/settings page (`require(...TenFootInterface):IsEnabled()`) to pick big-TV sizing; Chat/Playerlist use CreateHealthBar/SetUpTopStat on consoles.

## Gotchas
- Missing-local leaks: moveDownFromHere (addBack) is global on first use.
- CreateHealthBar's username return is a bare invisible TextLabel never added anywhere — placeholder API.
- Stack reposition uses AbsolutePosition captured mid-layout — order-of-operations sensitive.
- SetupTopStat shows only the FIRST leaderstat forever (no switching).
