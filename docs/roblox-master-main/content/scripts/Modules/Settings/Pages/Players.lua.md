# Players.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/Players.lua` (307 lines)

## Purpose

Escape-menu player roster page (Stickmasterluke): sorted name+avatar list with per-row friend-status buttons (core-script-only `GetFriendStatus` / `RequestFriendship`); small-touch variant also hosts Reset/Leave/Resume buttons.

## API / Behavior

- Constants: frame transparency .85 default /.65 selected.
- `getFriendStatus(selectedPlayer)` — pcall around the CORE-ONLY `localPlayer:GetFriendStatus`; self or failure → NotFriend.
- `friendStatusCreate(playerLabel, player)` — destroys prior FriendStatus child; builds one of: plain label (''), 'Friend', styled "Add Friend" button (Unknown/NotFriend/FriendRequestReceived → onClick clears itself + `RequestFriendship(player)`), 'Request Sent'; attaches SelectionGained/Lost highlight; first gamepad selection auto-focuses a friend button and sizes the shared fake-selection image to that row.
- Small-touch extras: Reset Character / Leave Game (+ Resume when RobloxGui width ≥ 720) route via HubRef pages.
- Displayed handler rebuilds roster:
  - Sort players by Name; reuse-or-create 60px rows at y=(i−1)×80+offset with dialog_white 9-slice bg, 36px avatar thumb (`Thumbs/Avatar.ashx?x=100&y=100&userId=`), name TextLabel; MouseEnter/Leave transparency; friendStatusCreate per row.
  - Reverse pass destroys surplus labels — **BUG: `table.remove(existingPlayerLabels, i)` uses undefined global `i`, not `index`** → runtime error inside event whenever players leave between opens.
  - Page height recomputed from count.
- LocalPlayer.FriendStatusChanged re-runs friendStatusCreate for the named row.

## Usage

SettingsHub registers as Players tab.

## Gotchas
- The `i` vs `index` typo is a live crash bug in the shrink-roster path.
- Avatar URL uses legacy Thumbs endpoint; userId clamped to ≥1 (guest-safe).
- GetFriendStatus is core-script privileged — this file can't be reused as normal game code.
- Row reuse assumes sorted-stable index alignment between opens.
