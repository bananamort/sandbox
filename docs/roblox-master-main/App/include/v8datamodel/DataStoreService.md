# App/include/v8datamodel/DataStoreService.h

## Purpose

`DataStoreService` (INTERNAL_LOCAL service) — factory + request scheduler for data stores: hands out Global/Ordered stores by (name, scope), queues and executes throttled HTTP requests per category, and reports latency analytics.

## Declared API

Free helper: `struct UnsignedIntegerCountAverage { unsigned int count, average; void incrementValueAverage(unsigned int value); }` — note the incremental average math divides by the *old* count on both subtract and add.

Class: `class DataStoreService : public DescribedCreatable<DataStoreService, Instance, sDataStoreService, ClassDescriptor::INTERNAL_LOCAL>, public Service`

- Nested `struct HttpRequest { std::string key, url, postData; function<void(std::string*, std::exception*)> handler; shared_ptr<DataStore> owner; void execute(DataStoreService*); bool isKeyThrottled(Time timestamp); enum RequestType { GET_ASYNC=5, UPDATE_ASYNC=6, SET_ASYNC=7, INCREMENT_ASYNC=8, GET_SORTED_ASYNC_PAGE=9 }; RequestType requestType; boost::posix_time::ptime requestStartTime; };`
- Store lookup: `shared_ptr<Instance> getGlobalDataStore(); getDataStore(name, scope); getOrderedDataStore(name, scope);` private `getDataStoreInternal(name, scope, legacy, ordered)` over maps `dataStores`, `orderedDataStores` keyed by StringPair; cached `legacyDataStore`.
- Throttling: `BudgetedThrottlingHelper throttleCounterGets/GetSorteds/Sets/OrderedSets` with queues `throttledGets/throttledGetSorteds/throttledSets/throttledOrderedSets` ("New requests go to back, executes from the front"); `queueOrExecuteRequest(request, queue, helper)`; static per-type entry points `queueOrExecuteGet/GetSorted/Set/OrderedSet(DataStore* source, HttpRequest&)`; pump `executeThrottledRequests()` + budget refill `addThrottlingBudgets(float timeDeltaMinutes)`.
- Cache refresh: `void refetchCachedKeys();`
- Analytics: mutex-guarded averages (read-success/error/write/update/batch ms) + `readSuccessCachedCount`, `lastAnalyticsReportTime`; `reportCachedRequestGet()`, `reportAnalytics()`, `onRequestFinishReport(HttpRequest*, bool isError, std::string errorMessage)`.
- Config: `bool isUrlEncodingDisabled()/setUrlEncodingDisabled(bool)`; flags `disableUrlEncoding`, `backendProcessing`; job handle `shared_ptr<DataStoreJob> dataStoreJob`; `int getPlayerNum();`
- Override: `onServiceProvider(old,new)`.

## Gotchas

- HttpRequest::execute takes raw `std::string*`/`std::exception*` out-params — lifetime managed by the caller chain.
- RequestType values start at 5 — likely aligned to an external enum/web contract.
- Four independent throttle buckets: gets, sorted gets, sets, ordered sets.

## UNKNOWN

- Budget sizes/refill curve in addThrottlingBudgets (.cpp — see [DataStoreService.md](../../v8datamodel/DataStoreService.md)).

## Cross-links

- Implementation: [App/v8datamodel/DataStoreService.md](../../v8datamodel/DataStoreService.md).
- Stores: [DataStore.md](DataStore.md).
