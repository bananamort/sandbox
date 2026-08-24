# FriendService.cpp

## Purpose

Implements `FriendService` ("FriendService") — the in-server friend graph: request/accept/deny state machine over a canonicalized (min,max) status table replicated via Roblox-security remote signals, web fire-and-forget mirroring to configurable URL templates, bulk friend-status fetch on player join, and GetFriendsOnline JSON query.

## Key types and API

Descriptors:
- LocalUser-only URL injectors (validated by %d count, throwing on mismatch): `SetCreateFriendRequestUrl`/`SetDeleteFriendRequestUrl`/`SetMakeFriendUrl`/`SetBreakFriendUrl` (2 params), `SetGetFriendsUrl` (1), `SetFriendsOnlineUrl`; `func_SetEnabled("SetEnabled", LocalUser)` — default OFF.
- Remote events: `desc_friendEventReplicating("RemoteFriendEventSignal", "userId","userId","event", **Security::Roblox**, REPLICATE_ONLY, BROADCAST)`; `desc_friendStatusReplicating("RemoteFriendStatusSignal", …"status", **Security::Roblox**, REPLICATE_ONLY, CLIENT_SERVER)`.
- FString FriendsOnlineUrl default "/my/friendsonline".

Enums registered: "FriendStatus" {Unknown, NotFriend, Friend, FriendRequestSent, FriendRequestReceived}; "FriendRequestEvent" {Issue, Revoke, Accept, Deny} (+ Variant/StringConverter plumbing).

Behavior:
- `issueFriendRequestOrMakeFriendship(a,b)` — self/already-friends no-ops; guests (negative ids) skip WEB calls only; pending reverse request → ACCEPT event + FRIEND status + makeFriendUrl post; else insert pending (once), ISSUE event, status REQUEST_SENT.
- `rejectFriendRequestOrBreakFriendship` — posts break+delete URLs; removes pending either direction with REVOKE/DENY events; forces NOT_FRIEND.
- Canonical storage: getFriendStatus/storeAndReplicate swap so userId<otherUserId and invert SENT↔RECEIVED; self→FRIEND; unknown→UNKNOWN.
- Replication receive path (`friendStatusReplicationChanged`) — clients store locally AND notify Players::friendStatusChanged both directions.
- Join flow: server fetches `getBulkFriendsUrl?…&otherUserIds=` for the new player vs present players (guest-only sets short-circuit NOT_FRIEND), response parsed as a comma-int stream ("1,2,3"), results stored under DataModel Write task.
- `getFriendsOnline(maxFriends)` — GETs FriendsOnlineUrl JSON array, truncates to maxFriends.
- playerRemoving purges request set + status rows.

## Usage / reflection touchpoints

Signals feed Players::friend* hooks ([Network](../../Network/)); HTTP mirrors like [BadgeService](BadgeService.md)/[AssetService](AssetService.md) URL-template pattern.

## Gotchas

- The whole friend graph is per-SERVER memory — a player's friends list differs between servers until bulk fetch completes; UNKNOWN statuses are common early.
- Web posts are fire-and-forget with DontCareResponse — website failure never surfaces in-game.
- SetEnabled defaults false: unless the shell enabled it, all of this machinery is dormant.
- Error messages double the %% ("requires 2 %%d parameters") — cosmetic printf-escape bug in thrown strings.
