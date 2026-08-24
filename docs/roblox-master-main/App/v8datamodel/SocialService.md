# SocialService.cpp

## Purpose

Implements `SocialService`, the legacy web-social query service: configurable endpoint URLs (friend/bestFriend/group/groupRank/groupRole/stuff/packageContents) settable at LocalUser security, with internal async queries dispatched through LuaWebService. Hosts the `Stuff` enum of avatar catalog categories.

## Key types and API

Descriptors:
- URL setters, all **Security::LocalUser**: "SetFriendUrl", "SetBestFriendUrl", "SetGroupUrl", "SetGroupRankUrl", "SetGroupRoleUrl", "SetStuffUrl"; PLUS "SetPackageContentsUrl" whose Lua ARG is named "stuffUrl" but writes packageContentsUrl (naming mismatch preserved from source).
- No reflected QUERY functions — getRankInGroup/getRoleInGroup/isFriendsWith/isBestFriendsWith/isInGroup/getListOfStuff/getPackageContents are C++-internal (called via other services/bridges).

Enum `Stuff` (StuffType): Heads, Faces, Hats, TShirts, Shirts, Pants, Gears, Torsos, LeftArms, RightArms, LeftLegs, RightLegs, Bodies, Costumes (+ Variant/StringConverter plumbing).

Queries: each checks its URL non-empty ("No X set") then printf-formats (playerId, groupId|userId|page/category|assetId) and dispatches via shared `dispatchRequest<ResultType>` template → LuaWebService::asyncRequest at standard priority; base_exception → error("Error during dispatch"); missing service → error("Shutting down").

Flags: FASTFLAGVARIABLE EnableLuaFollowers(true); DYNAMIC_FASTFLAGVARIABLE UserServerFollowers(false) — neither read in this TU body.

## Usage / reflection touchpoints

Only the seven LocalUser URL setters are reflection-exposed; queries serve engine code (e.g., group rank checks). Pairs with PersonalServerService.md (same dispatch pattern), BadgeService.md/MarketplaceService.md in this folder.

## Gotchas

- SetPackageContentsUrl's documented parameter name lies (stuffUrl).
- All URLs are printf FORMAT strings — malformed % sequences crash format() on call, not at set time.
- getListOfStuff passes the ENUM value as a format int argument — URL template must consume it numerically.
- The two follower flags are declared here but consumed elsewhere (UNKNOWN where).
