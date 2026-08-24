# ServerSocialScript.lua

Source: `roblox-sandbox/content/scripts/ServerCoreScripts/ServerSocialScript.lua` (216 lines)

## Purpose

Server-side follow-relationship service (header mislabeled "PlayerlistModule.lua", by jmargh): builds a per-player follow graph via the multi-follow API on join, keeps it updated from client-fired NewFollower events, and serves it to clients through RemoteEvent/RemoteFunction in RobloxReplicatedStorage.

## API / Behavior

- Remotes created: `FollowRelationshipChanged` (RemoteEvent, delta+full pushes), `NewFollower` (RemoteEvent — same name as the legacy one ServerStarterScript creates; this script REPLACES that path when loaded), `GetFollowRelationships` (RemoteFunction → cached map or {}).
- Helpers: pcall-wrapped `decodeJSON`, `rbxApiPostAsync(path, params, useHttps, throttlePriority, contentType)` (note: builds an error `label` string then discards it).
- `getFollowRelationshipsAsync(uid)` — skips in Studio; POSTs `{userId, otherUserIds[]}` (all players uid>0) to `user/multi-following-exists`; response documented as FollowingDetails array of {UserId1, UserId2, User1FollowsUser2, User2FollowsUser1}.
- Relationship object: `{IsFollower = user2→user1?, IsFollowing = user1→user2?, IsMutual}`.
- `updateAndNotifyClients(resultTable, newUserIdStr, newPlayer)` — merges new player's rows into map, mirrors INVERSE rows onto others, FireClient delta to each affected other + FULL table to the newcomer.
- OnServerInvoke returns cached per-user table.
- `NewFollower.OnServerEvent(player1, player2, player1FollowsPlayer2)` — nil-guarded toggle: updates both directions' IsFollowing/IsFollower/IsMutual, sends deltas to both, and (comment: NotificationScript listens to this) fires legacy NewFollower to player2 when following begins.
- PlayerAdded (incl. existing players) triggers async fetch; PlayerRemoving clears the leaver's row only (stale inverse entries remain in OTHERS' maps).

## Usage

Loaded conditionally by ServerStarterScript when FFlag UserServerFollowers is set. Clients: notification/playerlist scripts read FollowRelationshipChanged.

## Gotchas
- Header filename comment is WRONG (copy-paste from PlayerlistModule).
- No validation that player1/player2 args are actual Players — exploit client can pass arbitrary Instance/userId pairs to mutate map keys.
- Leaver's rows removed but their mirrored entries elsewhere are never cleaned.
- getFollowRelationshipsAsync result NOT awaited sequentially — join storms can interleave updates.
