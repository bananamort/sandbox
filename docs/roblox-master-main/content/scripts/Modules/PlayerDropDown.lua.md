# PlayerDropDown.lua

Source: `roblox-sandbox/content/scripts/Modules/PlayerDropDown.lua` (632 lines)

## Purpose

Module behind the per-player context menu used by Playerlist + Chat (TheGamer101): friend request lifecycle, follow/unfollow, block/unblock, mute, report, and PBS rank buttons; also exports a blocking/muting utility.

## API / Behavior

- Module API: `CreatePlayerDropDown()` → popup object; `CreateBlockingUtility()` → {Block/Unblock/Mute/Unmute/IsBlockedByUserId/GetBlockedStatusChangedEvent/IsMutedByUserId}; `FollowerStatusChanged` signal (custom BindableEvent-based `createSignal` with cached args — the classic TweenSize threadref assert).
- Flags: EnableLuaFollowers, UserServerFollowers. Async spawns resolve SettingsHub, SendNotification bindable, RobloxReplicatedStorage.NewFollower remote.
- PBS detection via workspace PSVariable (+ChildAdded); PRIVILEGE_LEVEL {OWNER 255, ADMIN 240, MEMBER 128, VISITOR 10, BANNED 0}; `onPrivilegeLevelSelect` loops Promote/Demote until target rank.
- Block list fetched once async from `userblock/getblockedusers`; block/unblock updates local table + fires BlockStatusChanged + PlayersService:BlockUser/UnblockUser (pcall). Mute is LOCAL-only map (no server sync).
- Popup construction (`CreatePopup(Player)`): friend button text by FriendStatus (Unfriend / Send Request / Revoke / Accept + separate Decline when received); hidden entirely when target blocked; follower row (Follow/Unfollow) when follower flags on — synchronous `isFollowing` HTTP call inside CreatePopup!; Block/Report always; PBS rank buttons (Ban/Visitor/Member/Admin) for admins over the target.
- Actions: friend ops via core-only RequestFriendship/RevokeFriendship (max-friend check pre-request via `user/get-friendship-count`, fail→assume full); follow/unfollow POST `user/follow`|`user/unfollow` then FireServer(NewFollower, true/false) + notification w/ avatar thumb; report → settingsHub:ReportPlayer.
- Hide() tweens to offscreen (custom PopupFrameOffScreenPosition honored) or instant destroy; HiddenSignal fired; PlayerRemoving auto-hides matching popup.

## Usage

Chat.lua and PlayerlistModule.lua each hold a dropdown instance per player entry.

## Gotchas
- `TWEEN_TIME` is an UNDEFINED global in Hide() → error on animated hide path (works only if some host env defines it) — latent bug.
- `isFollowing` yields inside CreatePopup — caller UI stalls per popup creation when followers enabled.
- canSendFriendRequestAsync treats web failure as "at limit" (blocks requests offline).
- MutedList never persisted nor synced; Unmute works even if never muted.
