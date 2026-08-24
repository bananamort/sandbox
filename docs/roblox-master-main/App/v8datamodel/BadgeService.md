# BadgeService.cpp

## Purpose

Implements `BadgeService` ("BadgeService") — server-side badge awarding/querying against injected web URLs with per-session caches: UserHasBadge (with negative-result cooldown list), AwardBadge (once per user+badge per session + BadgeAwarded replication), IsDisabled and IsLegal (both cached; parse failures treated as true).

## Key types and API

Descriptors:
- Yield funcs (**Security::None**): `UserHasBadge(userId, badgeId)`, `AwardBadge(userId, badgeId)`, `IsDisabled(badgeId)`, `IsLegal(badgeId)` — all bool.
- LocalUser-only configurators: `SetHasBadgeCooldown(seconds)`, `SetPlaceId(placeId)`, `SetAwardBadgeUrl(url)`, `SetHasBadgeUrl(url)`, `SetIsBadgeDisabledUrl(url)`, `SetIsBadgeLegalUrl(url)`.
- Remote event: `event_BadgeAwarded("BadgeAwarded", "message", "userId", "badgeId")` — **Security::RobloxScript**, SCRIPTING, BROADCAST.

State: `placeId(-1)`, `cooldownTime(60)`, empty URL strings by default; four mutex-guarded caches (`badgeQueryCache` positive set, `hotBadges` cooldown list, `badgeIsDisabledCache`, `badgeIsLegalCache`, `badgeAwardCache`).

Behavior:
- `userHasBadge` — server-only (else false); player must be IN the server; cache hit → true; hot (recently answered no) → false without web call; else GET hasBadgeUrl. Response "Success" → cache + true; anything else → push HotUserHasBadge(cooldown) + false.
- `isHasBadgeHot` — linear scan; on FIRST expired entry erases from there to end and returns false (lazy cleanup).
- `isDisabled`/`isLegal` — placeId -1 → assume OK(true)/legal(true); "1"→true, "0"→false, other/none → **true** ("Really bad failure?").
- `awardBadge` — server-only, player-present check, session-cache dedupe; POSTs (comment: "switch get to post to fix exploit in badge service"); response "" → false, "0" → cache-as-awarded + false (already had it), else cache + submit DataModel Write task firing BadgeAwarded(message=response text, userId, badgeId) + true.

## Usage / reflection touchpoints

Web layer via raw Http util; BadgeAwarded rides the standard remote-event replicator ([Network](../../Network/)); DebrisService include is vestigial in this TU.

## Gotchas

- AwardBadge treats HTTP failure (null response) as plain false WITHOUT caching, but "0" CACHES the badge as awarded — a web hiccup can permanently block re-award for the session only after a definitive no.
- IsDisabled/IsLegal default TRUE on any unrecognized response — fail-open.
- The four Set*Url injectors are Security::LocalUser; unset URLs make printf format garbage at first query.
- userHasBadge's hot-list erase-on-first-expiry can leave later expired entries behind (scan stops at first expiry).
