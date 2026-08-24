# App/include/v8datamodel/DataStore.h

## Purpose

Data-store key/value client: `DataStore` (descriptor "GlobalDataStore", RUNTIME_LOCAL) implements get/set/increment/update-async against the web persistence API with per-key caching, throttling, and update subscriptions; `OrderedDataStore` adds sorted paging; `DataStorePages` walks result pages.

## Declared API

`class DataStore : public DescribedNonCreatable<DataStore, Instance, sGlobalDataStore, ClassDescriptor::RUNTIME_LOCAL>`

- Script surface: `void getAsync(std::string key, resume(Variant), error)`; `void updateAsync(key, Lua::WeakFunctionRef transformFunc, resume(Tuple), error)`; `void setAsync(key, Variant value, resume(), error)`; `void incrementAsync(key, int delta, resume(Variant), error)`; `rbx::signals::connection onUpdate(std::string key, Lua::WeakFunctionRef callback);`
- Maintenance: `void refetchCachedKeys(int* budget); void resetRefetch(); bool isKeyThrottled(const std::string& key, Time timestamp); void setKeySetTimestamp(...)`; `DataStoreService* getParentDataStoreService();`
- Statics: `static const char* urlApiPath() { return "persistence"; }`; variant codec `serializeVariant(variant, bool* hasNonJsonType)` / `deserializeVariant(webValue, result)`.
- Constructor: `DataStore(const std::string& name, const std::string& scope, bool legacy);`
- Protected extension points: `virtual bool checkValueIsAllowed(const Reflection::Variant&) { return true; }`, `virtual const char* getDataStoreTypeString() { return "standard"; }`, `virtual bool queueOrExecuteSet(DataStoreService::HttpRequest& request)`; members `serviceUrl, name, scope, scopeUrlEncodedIfNeeded, nameUrlEncodedIfNeeded`; helper `urlEncodeIfNeeded`.
- Private machinery: `CachedKeys cachedKeys` (`map<string, CachedRecord>` with variant+serialized+timestamp and touch-on-read), `OnUpdateKeys onUpdateKeys` (map of signals), `KeyTimestamps lastSetByKey`; refetch state machine `{RefetchOnUpdateKeys, RefetchCachedKeys, RefetchDone}` + `nextKeyToRefetch`; URL builders (`constructPostDataForKey`, construct Get/Set/SetIf/Increment URLs); HTTP processors `processSet/processFetchSingleKey/processFetchCachedKeys` each paired with a `lockAcquired...` variant; SetIf path runs a Lua transform via `runTransformFunction` (comment: WeakFunctionRef must not be copied on the http threadpool — needs Lua state); access checks `checkAccess/checkStudioApiAccess`; batch-get accumulation; `EventSlot { Lua::WeakFunctionRef callback; fire(Variant); }`; flags `isLegacy, backendProcessing`.

`class OrderedDataStore : public DescribedNonCreatable<OrderedDataStore, DataStore, sOrderedDataStore, RUNTIME_LOCAL>`

- `OrderedDataStore(name, scope);` overrides: allowed values restricted (`checkValueIsAllowed`), type string "sorted", own queueOrExecuteSet.
- `void getSortedAsync(bool isAscending, int pagesize, Variant minValue, Variant maxValue, resume(shared_ptr<Instance>) [Pages], error);`
- Private: `constructGetSortedUrl(bool isAscending, int pagesize, const double* minValue, const double* maxValue);`

`class DataStorePages : public DescribedNonCreatable<DataStorePages, Pages, sDataStorePages, RUNTIME_LOCAL>`

- `DataStorePages(weak_ptr<OrderedDataStore> ds, const std::string& requestUrl);` `void fetchNextChunk(resume(), error);` state `exclusiveStartKey`, private fetch processors (+lockAcquired twin).

## Gotchas

- Note the OrderedDataStore typedef bug in source: `typedef DescribedNonCreatable<DataStore, DataStore, sOrderedDataStore, ...> Super;` — first template arg says `DataStore` where the class derives from the correctly-typed declaration above it; Super is mis-typed.
- updateAsync transform functions must run under the DataModel lock (`lockAcquiredProcessSetIf`) — never copied into http threads.
- Per-key write throttling via lastSetByKey timestamps; refetch is budgeted by caller (`int* budget`).
- CachedRecord touches timestamps on read for LRU-style eviction.

## UNKNOWN

- Exact server JSON envelope for values/errors (.cpp — see [DataStore.md](../../v8datamodel/DataStore.md)).

## Cross-links

- Implementation: [App/v8datamodel/DataStore.md](../../v8datamodel/DataStore.md).
- Service owner: [DataStoreService.md](DataStoreService.md).
