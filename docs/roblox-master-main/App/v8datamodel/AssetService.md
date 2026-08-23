# App/v8datamodel/AssetService.cpp

## Purpose

Implements `AssetService` ("AssetService") — the server-side web-API bridge for place lifecycle management: creating places (in game or in a player's inventory), saving the current place, querying version history and permissions, reverting assets, mapping creation→creator asset IDs, and listing a universe's places. All heavy operations are BoundYieldFuncs that round-trip HTTP.

## API

Flags: `DFInt::CreatePlacePerMinute` (5), `CreatePlacePerPlayerPerMinute` (1), `SavePlacePerMinute` (10) — throttle budgets for the two throttler members.

Reflection:
- LocalUser-security URL setters: `"SetPlaceAccessUrl"(accessUrl)`, `"SetAssetRevertUrl"(revertUrl)`, `"SetAssetVersionsUrl"(versionsUrl)` — install printf-style format URLs used by the permission/revert/version calls.
- Yield funcs (Security::None): `"RevertAsset"(placeId, versionNumber):bool`; `"SetPlacePermissions"(placeId, accessType=EVERYONE, inviteList)`; `"GetPlacePermissions"(placeId):ValueTable`; `"GetAssetVersions"(placeId, pageNum=1):ValueTable`; `"GetCreatorAssetID"(creationID):int`; `"CreatePlaceAsync"(placeName, templatePlaceID, description=""):int`; `"CreatePlaceInPlayerInventoryAsync"(player, placeName, templatePlaceID, description=""):int`; `"SavePlaceAsync"()`; `"GetGamePlacesAsync"():Instance(Pages)`.
- Enum `AccessType`: ME/"Me", FRIENDS/"Friends", EVERYONE/"Everyone", INVITEONLY/"InviteOnly" (EnumDesc + Variant convert + StringConverter registered).

Behaviors:
- `checkCreatePlaceAccess` gates: backend processing only ("can only be called from a server script"), non-empty name, templatePlaceId > 0, current place id > 0 ("place should be opened with Edit button"), throttle `createPlaceThrottle.checkLimit(getPlayerCount)`, and `LuaWebService::isApiAccessEnabled()` ("Studio API access is not enabled...").
- `createPlaceAsyncInternal` POSTs to `<apiBaseUrl>universes/new-place?currentPlaceId=%d&placeName=<urlencoded>&templatePlaceId=%d[&playerId=%i]` via `HttpRbxApiService::postAsync(..., "CreatePlacePost", PRIORITY_SERVER_ELEVATED, TEXT_PLAIN, ...)`. Response parsed as int placeId (`boost::lexical_cast`), errors like "Game:CreatePlace response was not a valid placeId because ...". Inventory variant first shows a consent dialog via `MarketplaceService::launchClientLuaDialog("Do you allow game to create new place in your inventory?", "Yes", "No", player, ...)`; user refusal resumes with **-1**, not an error. Google Analytics events CreatePlace / CreatePlaceInPlayerInventory / SavePlace fire once each (boost::call_once).
- `savePlaceAsync` — rejects frontend callers; requires apiAccessEnabled; POSTs the place XML via `dm->uploadPlace(baseUrl + "ide/publish/UploadExistingAsset?assetId=%d&isAppCreation=true", SAVE_ALL, ...)`.
- `getAssetVersions`/`getPlacePermissions` — raw `Http::get` against the configured versions/access URLs (format-string with assetId/pageNum or placeId); results JSON-parsed via `WebParser::parseJSONTable` in `processServiceResults`.
- `revertAsset` — `Http::post` to revert URL formatted with (assetId, versionNumber); truthiness = non-empty response.
- `setPlacePermissions` — POST `<accessUrl>/update?<placeId>access=%s[&players=name...]`; inviteList only appended for INVITEONLY.
- `getCreatorAssetID` — `HttpRbxApiService::getAsync("GetCreatorAssetID?creationID=%d")`; empty response → resume(0).
- `getGamePlacesAsync` — creates a `StandardPages` instance over `<apiBaseUrl>universes/get-universe-places?placeid=%i` keyed "Places", fetches first chunk, resumes with the Pages object.

## Usage

Server scripts building in-game creation tools; Studio's publish/save flows share the upload path. Environment fidelity: sandbox must serve or stub these endpoints (`universes/new-place`, `ide/publish/UploadExistingAsset`, GetCreatorAssetID, universes/get-universe-places) plus the three configurable URLs.

## Gotchas

- CreatePlaceInPlayerInventoryAsync resolves to -1 on dialog decline — callers must treat -1 as "user declined", not error.
- Throttles are per-process DFInt-configurable; limit errors are plain strings.
- `httpPostHelper` has missing-return paths when response is null/empty (falls through after resumeFunction(false)).
- UNKNOWN: default values of awardBadgeUrl-style format strings live in AssetService.h defaults, not this TU.
