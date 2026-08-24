# App/include/v8datamodel/BadgeService.h

## Purpose

`BadgeService` (INTERNAL service) — server-side badge web API client: query/award badges per user, check badge disabled/legal state, with mutex-guarded response caches and a short-lived "hot" has-badge cache for cooldown suppression.

## Declared API

`class BadgeService : public DescribedCreatable<BadgeService, Instance, sBadgeService, Reflection::ClassDescriptor::INTERNAL>, public Service`

- Remote signal: `rbx::remote_signal<void(std::string, int, int)> badgeAwardedSignal;`
- Public async ops (each takes `resumeFunction` + `errorFunction`):
  - `void userHasBadge(int userId, int badgeId, function<void(bool)>, errorFn)`
  - `void awardBadge(int userId, int badgeId, function<void(bool)>, errorFn)`
  - `void isDisabled(int badgeId, function<void(bool)>, errorFn)`
  - `void isLegal(int badgeId, function<void(bool)>, errorFn)`
- Configuration setters: `setPlaceId(int)`, `setHasBadgeCooldown(int seconds)`, `setAwardBadgeUrl/setHasBadgeUrl/setIsBadgeDisabledUrl/setIsBadgeLegalUrl(std::string)` — private url members `awardBadgeUrl`, `hasBadgeUrl`, `isBadgeDisabledUrl`, `isBadgeLegalUrl`; `int placeId; int cooldownTime;`
- Caches: four `boost::recursive_mutex` + map pairs — `badgeAwardSync/badgeAwardCache` (`map<int, set<int>>`), `badgeQuerySync/badgeQueryCache`, `badgeIsDisabledSync/badgeIsDisabledCache` (`map<int,bool>`), `badgeIsLegalSync/badgeIsLegalCache`.
- Hot cache: `struct HotUserHasBadge { int userId; int badgeId; RBX::Time expiration; HotUserHasBadge(int,int,int cooldownTime); bool expired() const; };` stored in `std::list<HotUserHasBadge> hotBadges`, probed by `bool isHasBadgeHot(int userId, int badgeId)`.
- Private result plumbing: `hasBadgeResult(+static Helper)`, `awardBadgeResult(+Helper)`, `isDisabledResult` / static `isDiabledResultHelper` (sic), `isLegalResult(+Helper)` — each taking `(weak_ptr<BadgeService>, ids, std::string* response, std::exception* err, resume, error)`.

## Gotchas

- Result helpers take `weak_ptr<BadgeService>` — the service can die mid-request and callbacks no-op.
- `std::string* response` / `std::exception* err` raw pointers into the HTTP layer: ownership resolved in .cpp.
- Typo `isDiabledResultHelper` is verbatim in source.
- Award/query caches are keyed `map<userId/badgeId-domain, set<int>>` — exact keying convention lives in .cpp.
- INTERNAL descriptor: not script-creatable; game code reaches it as a service.

## UNKNOWN

- Cache TTLs beyond `cooldownTime` and JSON shapes of the four endpoints (.cpp — see [BadgeService.md](../../v8datamodel/BadgeService.md)).

## Cross-links

- Implementation: [App/v8datamodel/BadgeService.md](../../v8datamodel/BadgeService.md).
- Sibling web services: [AssetService.md](AssetService.md), [HttpService.md](HttpService.md), [MarketplaceService.md](MarketplaceService.md).
