# ReportAbuseMenu.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/ReportAbuseMenu.lua` (284 lines)

## Purpose

Settings-hub abuse-report page: Game-vs-Player selector, player DropDown, abuse-type DropDown (distinct lists per target), optional description TextBox, and a Submit button that calls `Players:ReportAbuse`, then shows a reason-specific thank-you alert.

## API / Behavior

- Abuse type tables: 8 player reasons (Swearing…Offsite Links), 3 game reasons; default desc placeholder text shrinks on small touch screens.
- `GetPlayerFromIndex(index)` — **BUG: returns `nameToRbxPlayer[nameToRbxPlayer]`** (table indexed by itself → always nil) instead of `[playerName]`. Player reports therefore never actually submit (currentAbusingPlayer nil) while still showing the alert.
- `UpdatePlayerDropDown()` — rebuilds names map excluding LocalPlayer and UserId ≤ 0; if NO other players, force-selects "Game" mode + game abuse list; toggles interactability of both drop-downs. Runs on every Displayed.
- `SetHub` override builds rows: GameOrPlayer Selector {Game,Player}; WhichPlayer DropDown (starts non-interactable); TypeOfAbuse DropDown (game list first); AbuseDescription TextBox row (small-screen gets repositioned Selection + cloned label).
- Submit gating: button starts inactive (ZIndex/Selectable swap helpers); activated only when a type is chosen AND (game mode OR player chosen).
- `onReportSubmitted` — picks list by mode, spawn-calls `Players:ReportAbuse(playerOrNil, reason, description)`; alert text varies for Cheating/Exploiting, Inappropriate Username, content/link reasons; cleanup resets dropdowns+description and closes hub.

## Usage

SettingsHub registers as Report tab page.

## Gotchas
- The GetPlayerFromIndex self-index bug is the headline defect — player reports silently no-op.
- Description text submitted verbatim INCLUDING the placeholder when untouched (placeholder lives in the same Text field).
- Page height from AbsolutePosition once more (build-time layout assumption).
- Small-screen path clones TypeOfAbuseLabel for its own label — ZIndex/parent juggling fragile.
