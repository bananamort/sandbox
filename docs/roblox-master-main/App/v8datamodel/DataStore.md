# DataStore.cpp

## Purpose

Implements `DataStore` ("GlobalDataStore"), `OrderedDataStore` ("OrderedDataStore", RUNTIME_LOCAL) and `DataStorePages` — the key-value persistence client: cached key records with touch timeouts, GET/SET/INCREMENT/UPDATE(CAS) web requests against the persistence API, per-key set throttling, OnUpdate subscriptions with budgeted background refetching, and sorted-value pagination.

## Key types and API

Descriptors (all **Security::None**):
- DataStore yield funcs: `GetAsync(key)` → Variant, `SetAsync(key, value)`, `UpdateAsync(key, transformFunction)` → Tuple, `IncrementAsync(key, delta[1])` → Variant; BoundFunc `OnUpdate(key, callback)` returning a connection.
- OrderedDataStore: `GetSortedAsync(ascending, pagesize, minValue[nil], maxValue[nil])` → Pages instance.
No other Security:: tiers. Classes registered via RBX_REGISTER_CLASS ×3. Flag: `UseNewPersistenceSubdomain(true)`.

Tunables (DFInt): DataStoreMaxKeysToFetch(100), DataStoreKeyLengthLimit(50), DataStoreMaxPageSize(100), DataStoreMaxValueSize(64·1024), DataStoreTouchTimeoutInSeconds(5), DataStoreSameKeyPerMinute(10).

Behavior:
- Cache: `CachedRecord{variant, serialized, accessTimeStamp}`; getAsync returns cached when touched <5 s ago (reports CachedRequestGet to service); updateCachedKey stores + fires per-key OnUpdate signal ONLY on serialized-value change.
- Validation: checkAccess (non-empty, <50 chars); values must JSON-serialize (`WebParser::writeJSON FailOnNonJSON` else "Cannot store <type> in DataStore") and be <64 KB ("Value is too large"); writes require LuaWebService isApiAccessEnabled in Studio.
- UpdateAsync CAS loop: fetch if uncached → run Lua transform via `Lua::callCallback` (nil/void result cancels) → POST setIf with `value=`+`expectedValue=`; rejection response carries currentValue → cache it and RE-RUN transform (retry loop); success updates cache + resumes Tuple(value).
- IncrementAsync posts constructIncrementUrl then processes as single-key fetch. SetAsync url-encodes value into postData.
- Legacy vs modern URL shapes differ by which field carries the key name (`target=` vs `key=`); constructGetUrl = `<serviceUrl>getV2?placeId&type&scope`; serviceUrl from BuildGenericPersistenceUrl under new-subdomain flag else apiBaseUrl+path.
- Throttle: lastSetByKey map; isKeyThrottled blocks sets within 60/DataStoreSameKeyPerMinute seconds.
- Background refetch (`refetchCachedKeys(budget)`): two-phase state machine RefetchOnUpdateKeys → RefetchCachedKeys → RefetchDone with nextKeyToRefetch cursor; batches ≤100 keys per POST (Cache-Control no-cache, doNotUseCachedResponse).
- OnUpdate subscribe triggers an immediate dummy-callback fetch for uncached keys.
- DataStorePages parses {Entries:[{Target,Value}], ExclusiveStartKey} into {key,value} tables; finished when no exclusiveStartKey; requests ride queueOrExecuteGetSorted owned by the store.

## Usage / reflection touchpoints

Owned by [DataStoreService](DataStoreService.md); HTTP plumbing via DataModel::processHttpRequestResponseOnLock ([DataModel](DataModel.md)) and Http util; pagination sibling of StandardPages consumers like [AssetService](AssetService.md).

## Gotchas

- The 5 s cache means GetAsync can return data up to 5 seconds stale even after your own SetAsync (set path doesn't force-refresh the read timestamp semantics).
- errorFunction receives generic "Request rejected" — the server's actual errorMessage is only FASTLOGged, never surfaced to scripts.
- Transform functions run while holding the DataModel write lock (via processHttpRequestResponseOnLock submit-task path) — long transforms stall everything.
- OrderedDataStore accepts only INTEGRAL floats (value == floor(value)); 1.5 silently errors "…is not allowed in DataStore".
