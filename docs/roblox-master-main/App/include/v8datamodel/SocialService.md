# App/include/v8datamodel/SocialService.h

## Purpose

`SocialService` — non-creatable service for web social queries (friends/best-friends/group membership/rank/role) plus catalog "stuff" listings and package contents; all endpoints are runtime-settable URL strings and all calls are async resume/error pairs via a shared `dispatchRequest<ResultType>` template.

## Declared API

`class SocialService : public DescribedNonCreatable<SocialService, Instance, sSocialService>, public Service`

- `enum StuffType { HEADS_STUFF=0, FACES_STUFF=1, HATS_STUFF=2, T_SHIRTS_STUFF=3, SHIRTS_STUFF=4, PANTS_STUFF=5, GEARS_STUFF=6, TORSOS_STUFF=7, LEFT_ARMS_STUFF=8, RIGHT_ARMS_STUFF=9, LEFT_LEGS_STUFF=10, RIGHT_LEGS_STUFF=11, BODIES_STUFF=12, COSTUMES_STUFF=13 }`.
- URL setters: `setFriendUrl`, `setBestFriendUrl`, `setGroupUrl`, `setGroupRankUrl`, `setGroupRoleUrl`, `setStuffUrl`, `setPackageContentsUrl` (each `void(std::string)`).
- Async queries:
  - `isFriendsWith(int playerId, int userId, resume(bool), error(std::string))`
  - `isBestFriendsWith(int playerId, int userId, resume(bool), error)`
  - `isInGroup(int playerId, int groupId, resume(bool), error)`
  - `getRankInGroup(int playerId, int groupId, resume(int), error)`
  - `getRoleInGroup(int playerId, int groupId, resume(std::string), error)`
  - `getListOfStuff(int playerId, StuffType category, int page, resume(shared_ptr<const Reflection::ValueMap>), error)`
  - `getPackageContents(int assetId, resume(shared_ptr<const Reflection::ValueArray>), error)`
- Private: template `dispatchRequest<ResultType>(url, resume(ResultType), error(std::string))`; seven stored URL strings.

## Gotchas

- Calls take BOTH playerId (the asker) and target ids — server-side permission context baked into the query.
- No caching layer declared in-header; every call is a web round trip.
- getListOfStuff is paginated (page int) and returns ValueMap.

## UNKNOWN

- Response JSON shapes / error string conventions (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/SocialService.md](../../v8datamodel/SocialService.md).
- Sibling web services: [FriendService.md](FriendService.md), [PersonalServerService.md](PersonalServerService.md), [GamePassService.md](GamePassService.md).
