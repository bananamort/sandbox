# PersonalServerService.cpp

## Purpose

Implements `PersonalServerService`, the rank/privilege service for personal (VIP) servers. Maps numeric per-player ranks to a five-level `PrivilegeType` (Banned < Visitor < Member < Admin < Owner), exposes Studio/web URL configuration plus Promote/Demote/GetRoleSets, and dispatches HTTP requests through `LuaWebService`. Non-archivable service created per DataModel.

## Key types and API

Descriptors:
- `func_SetPersonalServerGetRankUrl` → "SetPersonalServerGetRankUrl(url)", **Security::LocalUser**.
- `func_SetPersonalServerSetRankUrl` → "SetPersonalServerSetRankUrl(url)", **Security::LocalUser**.
- `func_SetPersonalServerBuildToolsUrl` → Lua name "SetPersonalServerBuildToolsUrl" but binds `setPersonalServerRoleSetsUrl` (arg named personalServerRoleSetsUrl), **Security::LocalUser** — name/binding mismatch is in the source.
- `func_Promote` → "Promote(player:Instance)", **Security::RobloxScript**.
- `func_Demote` → "Demote(player:Instance)", **Security::RobloxScript**.
- `func_GetRoleSets` → yield func "GetRoleSets(placeId:int):string", **Security::RobloxScript**.
- `prop_roleSets("RoleSets")` — string, category_Behavior, cap SCRIPTING, **Security::RobloxScript**.

Enum `PrivilegeType`: Owner / Admin / Member / Visitor / Banned (+ Variant/StringConverter plumbing). Numeric values live header-side (UNKNOWN from this file).

Internal methods:
- Ctor blanks all URLs and calls `Instance::propArchivable.setValue(this, false)`.
- `moveToRank(player, rank)` → `player->setPersonalServerRank(rank)`; `setPrivilege` casts PrivilegeType→int through it.
- `promote/demote(shared_ptr<Instance>)`: dynamic_casts to Network::Player, applies `nextRankUp`/`nextRankDown` (ladder clamps at Owner and Banned; unknown ranks unchanged).
- `getCurrentPrivilege(rank)`: range-bucketing — rank < VISITOR ⇒ BANNED; [VISITOR,MEMBER) ⇒ VISITOR; [MEMBER,ADMIN) ⇒ MEMBER; [ADMIN,OWNER) ⇒ ADMIN; ≥OWNER ⇒ OWNER.
- `getRank/setRank(player, placeId, …)`: printf-format the configured URL with (placeId[, userId][, newRank]) then async-dispatch.
- `getWebRoleSets(placeId)`: errors "No personalServerRoleSetsUrl set" when unset; rejects non-server callers ("getWebRoleSets should only be called from gameserver") via `Network::Players::backendProcessing`.
- `dispatchRequest<ResultType>(url, resume, error)`: via `LuaWebService::asyncRequest` at `LUA_WEB_SERVICE_STANDARD_PRIORITY`; base_exception → error("Error during dispatch"); missing service → error("Shutting down").

## Usage / reflection touchpoints

All script-facing surface is gated RobloxScript except the three LocalUser URL setters (core-script/local-tool territory). Depends on [Network Players](../../Network/) for server checks and App/util's LuaWebService. Pairs with Team/Teams docs in this folder for group-style role concepts.

## Gotchas

- The third setter's Lua name says "BuildToolsUrl" while the C++ member/target is RoleSets URL — calling SetPersonalServerBuildToolsUrl actually configures GetRoleSets' endpoint.
- All four web endpoints require their URL strings pre-configured or they error out immediately; nothing sets defaults.
- `promote`/`demote` silently no-op on NULL or non-Player instances — no error function fires.
- Ranks are free-form ints on Network::Player; getCurrentPrivilege buckets anything below VISITOR (including negatives) to BANNED rather than validating.
- GetRoleSets formats the URL with a single int placeholder; getRank needs two (%d placeId, %d userId); setRank three — mismatched format strings would misrender (no validation here).
- UNKNOWN: where RoleSets property text is consumed; exact enum integer ordering (header-defined).
