# NotificationScript2.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/NotificationScript2.lua` (629 lines)

## Purpose

In-game toast/popup notification center (jmargh v1.1): badge awarded, player points, friend requests/new friends, new followers, graphics-quality change, teleport/`CreatePlaceInPlayerInventoryAsync` popups, plus the `SendNotification` SetCore API surface and gamepad notification browsing.

## API / Behavior

- Queue model: max 3 visible (MAX_NOTIFICATIONS), OverflowQueue spill, per-notification {Frame, Duration, IsActive, IsFriend(taller 1.5× slot for buttons)}; insert/remove tween Sine 0.35 s from right edge; spacing throttle via tick loop; isPaused flag freezes tweens while gamepad-browsing.
- `sendNotifcation(title,text,image,duration,callback,btn1,btn2)` [sic] — optional two-button rows invoking callback as function OR BindableFunction:Invoke(buttonText).
- Public bindable `RobloxGui.SendNotification` (BindableFunction) → same path — consumed by PlayerDropDown follow toasts.
- Sources wired (non-ten-foot only): Players.FriendRequestEvent (accept→"New Friend", issue→Accept/Decline card with 8 s duration + decline blacklist), PointsService.PointsAwarded (±points text), BadgeService.BadgeAwarded, RemoteEvent NewFollower.OnClientEvent, game.GraphicsQualityChangeRequest (+1/−1 clamped 1..10, "Increased/Decreased to (n)").
- `GuiService.SendCoreUiNotification` override — big centered banner, wait(5), destroy.
- Marketplace popup: ClientLuaDialogRequested → DropShadow PopupFrame with Accept/Decline → SignalServerLuaDialogClosed(bool); AddCenterDialog QuitDialog w/ pcall fallback plain-visible.
- SetCore registration: SendNotification (gated FFlag SetCoreSendNotifications), Points/BadgesNotificationsActive get+set (set gated by SetCoreDisableNotifications else no-op stubs).
- Gamepad browse (via GamepadMenu's GamepadNotifications bindable): pauses queue, focuses first visible button, B exits ("LeaveNotificationSelection"); none → ShowAlert "You have no notifications" (references UNDEFINED global settingsHub).
- XboxOne: ControllerStateManager module init + retro disconnect check.

## Usage

Loaded always by StarterScript. The notification queue is the visual backbone for social/economy feedback.

## Gotchas
- removeNotification: table.remove(NotificationQueue, index) without nil-checking findNotification result → error if already removed twice (double-delay race).
- settingsHub global nil in the no-notifications alert path → runtime error on consoles-less pads... actually guarded by non-ten-foot only; still latent.
- SendCoreUiNotification yields (wait(5)) inside GuiService callback — callers beware.
