# AssetService.cpp

## Purpose

Implements `AssetService` ("AssetService") — server-side place/asset management web API surface: create places (optionally into a player's inventory with a consent dialog), save the current place, revert assets, query/set place permissions and versions, resolve creation→creator id, and list universe places via pagination.

## Key types and API

Descriptors:
- LocalUser-only URL injectors: `func_SetPlaceAccessUrl("SetPlaceAccessUrl", Security::LocalUser)`, `func_SetAssetRevertUrl("SetAssetRevertUrl", Security::LocalUser)`, `func_setAssetVersionsUrl("SetAssetVersionsUrl", Security::LocalUser)` — store printf-format URL templates used by the getters below.
- Yield funcs (**Security::None**): `RevertAsset(placeId, versionNumber)`, `SetPlacePermissions(placeId, accessType[EVERYONE], inviteList)`, `GetPlacePermissions(placeId)`, `GetAssetVersions(placeId, pageNum[1])`, `GetCreatorAssetID(creationID)`, `CreatePlaceAsync(placeName, templatePlaceID, description[""])`, `CreatePlaceInPlayerInventoryAsync(player, placeName, templatePlaceID, description[""])`, `SavePlaceAsync()`, `GetGamePlacesAsync()`.

Enum `AccessType` registered as "AccessType": ME/"Me", FRIENDS/"Friends", EVERYONE/"Everyone", INVITEONLY/"InviteOnly" (+ Variant/StringConverter plumbing).

Throttles: DFInt CreatePlacePerMinute(5), CreatePlacePerPlayerPerMinute(1), SavePlacePerMinute(10).

Behavior:
- `checkCreatePlaceAccess` — requires backendProcessing ("server script"), non-empty name, positive template id, current placeID > 0 ("place should be opened with Edit button"), throttle pass, and LuaWebService `isApiAccessEnabled`.
- `createPlaceAsyncInternal` — POSTs `<apiBaseUrl>universes/new-place?currentPlaceId=…&placeName=<urlencoded>&templatePlaceId=…[&playerId=…]` via HttpRbxApiService PRIORITY_SERVER_ELEVATED; response parsed by `boost::lexical_cast<int>` (≤0 → error); GA events sent once per process (`boost::call_once`). Player-inventory variant first shows a MarketplaceService `launchClientLuaDialog` consent dialog; decline resumes with **-1**, not an error.
- `savePlaceAsync` — rejects frontendProcessing, requires placeID>0 + throttle + API access, then `DataModel::uploadPlace(<baseUrl>ide/publish/UploadExistingAsset?assetId=…&isAppCreation=true, SAVE_ALL, …)`.
- Permissions/versions/revert use the injected URL templates through raw `Http::get/post`; `httpPostHelper` maps empty/no response to resume(false).
- `getGamePlacesAsync` builds `<apiBaseUrl>universes/get-universe-places?placeid=…` and returns a `StandardPages` ("Places") after fetching the first chunk.

## Usage / reflection touchpoints

Web endpoints ride [HttpRbxApiService](HttpRbxApiService.md)/Http util; consent dialog via [MarketplaceService](MarketplaceService.md); pagination objects like other Pages consumers.

## Gotchas

- The three Set*Url injectors are Security::LocalUser — game scripts cannot repoint them, but defaults are EMPTY strings: RevertAsset/GetPlacePermissions/GetAssetVersions are no-ops that format garbage unless the client shell injected URLs.
- Declined consent resolves SUCCESS with -1 (resumeFunction(-1)) — scripts must check for -1, no error is raised.
- httpPostHelper dereferences `*response` when non-null but ALSO calls resume(false) without return when response is null — then falls through to compare `*response` again (latent double-resume path in source).
- CreatePlace stats are once-per-process, not per-call.
