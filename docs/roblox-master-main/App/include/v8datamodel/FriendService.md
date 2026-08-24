# App/include/v8datamodel/FriendService.h

## Purpose

`FriendService` (INTERNAL service) — server-authoritative friendship graph: stores per-pair FriendStatus in a symmetric map, replicates status/event deltas via two remote signals, exposes web endpoints for request/accept/deny/break and bulk friends-online fetch.

## Declared API

`class FriendService : public DescribedCreatable<FriendService, Instance, sFriendService, ClassDescriptor::INTERNAL>, public Service`

- Enums: `FriendEventType { ISSUE_REQUEST, REVOKE_REQUEST, ACCEPT_REQUEST, DENY_REQUEST }`; `FriendStatus { FRIEND_STATUS_UNKNOWN=0, FRIEND_STATUS_NOT_FRIEND=1, FRIEND_STATUS_FRIEND=2, FRIEND_STATUS_FRIEND_REQUEST_SENT=3, FRIEND_STATUS_FRIEND_REQUEST_RECEIVED=4 };`
- URL config: setters for create/delete friend-request, make-friend, break-friend, get-friends, friends-online; private members incl. `std::string getBulkFriendsUrl;` (member named like a getter — verbatim).
- Status query: `FriendStatus getFriendStatus(int playerId, int otherPlayerId) const;`
- Enable flag: `setEnable(bool)/getEnable()`.
- Player lifecycle: `void playerAdded(int userId); void playerRemoving(int userId);`
- Mutations: `void issueFriendRequestOrMakeFriendship(int userId, int otherUserId); rejectFriendRequestOrBreakFriendship(int userId, int otherUserId);`
- Replication ("Should be private"): `remote_signal<void(int,int,FriendEventType)> friendEventReplicatingSignal; remote_signal<void(int,int,FriendStatus)> friendStatusReplicatingSignal;`
- Async: `void getFriendsOnline(int maxFriends, resume(ValueArray), error);` private result processors + statics `ProcessBulkFriendResponse(weak_ptr<FriendService>, userId, set<int> requested, std::string* response, std::exception*)`, `StoreFriendsHelper(...)`.
- Storage: `friendStatusTable[smallUserId][bigUserId] = Status` (`map<int, map<int,FriendStatus>>` — canonical ordering by comment), `friendRequestSet` (`set<pair<int,int>>`), `std::set<int> players`; replication handlers + connections for both signals; `storeAndReplicateFriendStatus(...)`; template `dispatchRequest<ResultType>(url, resume, error)`.

## Gotchas

- Status table is normalized: callers pass ids in any order; storage sorts small/big per the comment.
- Two-signal replication (event vs status) must stay consistent — handlers in .cpp.
- INTERNAL descriptor; raw `std::string*`/exception* out-params on static HTTP helpers.

## UNKNOWN

- Bulk-response JSON schema (.cpp — see [FriendService.md](../../v8datamodel/FriendService.md)).

## Cross-links

- Implementation: [App/v8datamodel/FriendService.md](../../v8datamodel/FriendService.md).
- Social kin: [GroupService.md](GroupService.md), [SocialService.md] (S–Z half), [MarketplaceService.md](MarketplaceService.md).
