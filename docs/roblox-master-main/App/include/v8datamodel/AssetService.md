# App/include/v8datamodel/AssetService.h

## Purpose

`AssetService` (non-creatable engine service) — web-API client for place/asset management: create places, save the current place, revert assets, list versions, and query/set place permissions. All calls are async with `resumeFunction`/`errorFunction` callback pairs.

## Declared API

`class AssetService : public DescribedNonCreatable<AssetService, Instance, sAssetService>, public Service`

- `enum AccessType { ME = 0, FRIENDS = 1, EVERYONE = 2, INVITEONLY = 3 };`
- URL configuration: `void setPlaceAccessUrl(std::string)`, `setAssetRevertUrl(std::string)`, `setAssetVersionsUrl(std::string)`; private members `placeAccessUrl`, `assetRevertUrl`, `assetVersionsUrl`.
- Asset ops: `void revertAsset(int assetId, int versionNumber, function<void(bool)>, function<void(std::string)>)`; `void getAssetVersions(int assetId, int pageNum, function<void(shared_ptr<const Reflection::ValueTable>)>, errorFn)`; `void getCreatorAssetID(int creationID, function<void(int)>, errorFn)`.
- Permissions: `void getPlacePermissions(int placeId, function<void(ValueTable)>, errorFn)`; `void setPlacePermissions(int placeId, AccessType type, shared_ptr<const Reflection::ValueArray> inviteList, function<void(bool)>, errorFn)`.
- Places: `void createPlaceAsync(std::string placeName, int templatePlaceId, std::string desc, function<void(int)>, errorFn)`; `void createPlaceInPlayerInventoryAsync(shared_ptr<Instance> player, ...same...)`; `void savePlaceAsync(function<void()>, errorFn)`; `void getGamePlacesAsync(function<void(shared_ptr<Instance>)>, errorFn)`.
- Private plumbing: `httpPostHelper(...)`, `processServiceResults(...)`, `getCreatorAssetIDSuccessHelper/ErrorHelper(...)`, `createPlaceAsyncInternal(bool check, ..., shared_ptr<Instance> player, ...)`, `bool checkCreatePlaceAccess(const std::string& placeName, int templatePlaceId, std::string& message)`.
- Throttles: `ThrottlingHelper createPlaceThrottle, savePlaceThrottle;`

## Gotchas

- Every network op takes raw boost callbacks — no signals; error strings come straight from HTTP layer.
- Endpoint URLs are runtime-settable (server-injected), not constants.
- `AccessType::INVITEONLY` uses a separate invite-list ValueArray on setPlacePermissions.

## UNKNOWN

- JSON response schema for versions/permissions tables (.cpp parsing — see [AssetService.md](../../v8datamodel/AssetService.md)).

## Cross-links

- Implementation: [App/v8datamodel/AssetService.md](../../v8datamodel/AssetService.md).
- Related: [DataStoreService.md](DataStoreService.md), [HttpService.md](HttpService.md).
