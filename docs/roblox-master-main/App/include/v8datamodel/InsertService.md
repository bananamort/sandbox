# App/include/v8datamodel/InsertService.h

## Purpose

`InsertService` (PERSISTENT_HIDDEN service) — asset insertion pipeline: search free decals/models and set collections, load assets by id/version, perform backend-approved "safe inserts" with callback bookkeeping, and replicate insert requests/results between server and clients.

## Declared API

`class InsertService : public DescribedCreatable<InsertService, Instance, sInsertService, ClassDescriptor::PERSISTENT_HIDDEN>, public Service`

- Remote signals: `insertRequestSignal<void(std::string key, ContentId)>`, `insertRequestAssetSignal<void(key, int assetId, int userId)>`, `insertRequestAssetVersionSignal`, `insertReadySignal<void(key, shared_ptr<Instance>)>`, `insertErrorSignal<void(key, std::string)>`, `internalDeleteSignal<void(shared_ptr<Instance>)>`.
- URL config setters: trustLevel (float), freeModel/freeDecal/baseSets/userSets/collection/asset/assetVersion URLs; `setAdvancedResults(bool advancedResults, bool userMode)`.
- Catalog queries (async, resume(ValueArray)/error): getFreeDecals(searchText, pageNum), getFreeModels(...), getBaseSets(), getUserSets(userId), getCollection(collectionId).
- Asset loading: `loadAsset(int id, resume(shared_ptr<Instance>), error)` / `loadAssetVersion(id, ...)` / `getLatestAssetVersion(id, resume(int), error)`; `void insert(shared_ptr<Instance>)`; `void internalDelete(shared_ptr<Instance>)`; backend approvals `void backendApproveAssetId(int assetId); void backendApproveAssetVersionId(int assetVersionId);`
- Safe insert: `enum InsertRequestType { ASSET, ASSET_VERSION };` `void safeInsert(ContentId asset, bool clientInsert, callback(shared_ptr<Instance>, AsyncHttpQueue::RequestResult, shared_ptr<std::exception>));` + typed-id overload.
- Policy: `bool getAllowInsertFreeModels()/setAllowInsertFreeModels(bool)`.
- Private machinery: dispatchRequest; privateLoadAsset(id, isAssetVersion, ...); URL builders addBaseUrl/addBaseUrlAndId/addBaseUrlAndQuery + populateExtraInsertUrlParams(url, clientInsert); backend request handlers ×4 + connections incl. scoped internal-delete; latest-version success/error handlers; ready plumbing `backendInsertReady` + static Helper with weak_ptr; remote-load completion `remoteInsertItemsLoaded(weak_ptr<ContentProvider>, result, instances, error, resultFunction)` + static Helper; frontend result handlers insertResultsReady/Error keyed by string; callback store: recursive_mutex-guarded `CallbackLibrary` (`map<std::string, Callback>` of resume/error pairs), atomic `loadCount` for unique keys, `shared_ptr<Instance> holder` ("items are initially loaded into this Folder"); flag allowInsertFreeModels.

## Gotchas

- Insert flow is two-phase (request → ready/error keyed by generated id); callbacks looked up under a recursive mutex.
- Loaded items land in an internal holder Folder before being handed to callers.
- Static helpers take weak_ptr — service death mid-load silently drops results.
- Trust level is a float setter without visible getter.

## UNKNOWN

- Meaning/trust semantics of trustLevel values (.cpp — see [InsertService.md](../../v8datamodel/InsertService.md)).

## Cross-links

- Implementation: [App/v8datamodel/InsertService.md](../../v8datamodel/InsertService.md).
- Kin: [AssetService.md](AssetService.md), [ContentProvider.md](ContentProvider.md), [ServerStorage.md] (S–Z half).
