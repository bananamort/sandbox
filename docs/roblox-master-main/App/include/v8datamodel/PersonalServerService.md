# App/include/v8datamodel/PersonalServerService.h

## Purpose

`PersonalServerService` — non-creatable service for personal-server (privately-owned place) role management: configurable get/set/roleSets URLs, async rank queries against the web, rank promote/demote/move helpers over `Network::Player`, and a local `roleSets` string cache.

## Declared API

`class PersonalServerService : public DescribedNonCreatable<PersonalServerService, Instance, sPersonalServerService>, public Service`

- `enum PrivilegeType { PRIVILEGE_OWNER=255, PRIVILEGE_ADMIN=240, PRIVILEGE_MEMBER=128, PRIVILEGE_VISITOR=10, PRIVILEGE_BANNED=0 }`
- URL setters: `void setPersonalServerGetRankUrl(std::string)`, `setPersonalServerSetRankUrl(std::string)`, `setPersonalServerRoleSetsUrl(std::string)`.
- Async web calls (resume/error boost::functions):
  - `void getWebRoleSets(int placeId, resume(std::string), error(std::string))`
  - `void getRank(Network::Player* player, int placeId, resume(std::string), error(std::string))`
  - `void setRank(Network::Player* player, int PlaceId, int newRank, resume(bool), error(std::string))` — note capitalized parameter `PlaceId`.
- Rank math: `int nextRankUp(int currentRank)`, `int nextRankDown(int currentRank)`, `int getCurrentPrivilege(int rank)`.
- Player ops: `void promote(shared_ptr<Instance> instance)`, `void demote(shared_ptr<Instance>)`, `void moveToRank(Network::Player* player, int rank)`; private `void setPrivilege(Network::Player*, PrivilegeType)`.
- Role-set cache: `std::string getRoleSets() const` / `setRoleSets(std::string)` (inline).
- Private: template `void dispatchRequest<ResultType>(url, resume(ResultType), error(std::string))`; three stored URL strings + `roleSets`.

## Gotchas

- promote/demote take a generic `shared_ptr<Instance>` — presumably casts to Network::Player internally; wrong instance type behavior is out-of-line.
- All HTTP endpoints are runtime-settable strings — no validation in header; the service is only as trustworthy as its configured URLs.
- Privilege ladder is coarse ints (255/240/128/10/0); getCurrentPrivilege maps rank→privilege by rules not visible here.

## UNKNOWN

- Exact rank→privilege mapping and nextRankUp/Down step sizes (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PersonalServerService.md](../../v8datamodel/PersonalServerService.md).
- Related services: [TeleportService.md](TeleportService.md), [Game.md](Game.md) (personal-server flag lives on DataModel/Game settings).
