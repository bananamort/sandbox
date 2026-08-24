# DataStoreService.cpp

## Purpose

Implements `DataStoreService` ("DataStoreService") — the DataStore family container and throttling engine: creates/caches Global/legacy/Ordered stores, runs a Write-duty DataStoreJob that refills per-category budgets every second and executes queued requests, plus analytics (GA events + EphemeralCounter latency averages).

## Key types and API

Descriptors:
- `getGlobalStoreFunction("GetGlobalDataStore", Security::None)` — singleton legacy store (name "", scope "u").
- `getDataStoreFunction("GetDataStore", "name","scope"["global"], Security::None)`.
- `getOrderedDataStore("GetOrderedDataStore", "name","scope"["global"], Security::None)`.
- `prop_disableUrlEncoding("LegacyNamingScheme", category_Behavior, STANDARD, **Security::LocalUser**)` — toggles legacy naming/no-url-encoding mode.

Tunables: DataStoreJobFrequencyInSeconds(1), DataStoreFetchFrequenceInSeconds(30); budget knobs FixedRequestLimit 60 / PerPlayer 10 / InitialBudget 100 (standard), OrderedSet 30/5/50, Refetch 30/5, Sorted 5/2/10; MaxBudgetMultiplier(100), MaxThrottledQueue(30). Flags: GetGlobalDataStorePcallFix(false), UseNewDataStoreLogging(true), UseNewDataStoreRequestSetTimestampBehaviour(true), DataStoreAnalyticsReportEveryNSeconds(60).

Behavior:
- `getDataStoreInternal` — placeId==0 → error ("Place has to be opened with Edit button…"; THROWS instead of returning nil under pcall-fix flag); non-backend throws "DataStore can't be accessed from client". Legacy store is a single locked child; named/ordered stores cached by (name,scope) pair, parent-locked. checkNameAndScope enforces non-empty + ≤ DataStoreKeyLengthLimit for both.
- `DataStoreJob` (Write duty, cyclic, 0.01 s interval): addThrottlingBudgets(jobFrequency/60 minutes) using formula `perPlayer·numPlayers + fixed`; executeThrottledRequests drains four queues; every 30 s calls refetchCachedKeys with shared budget; reports analytics under new-logging flag.
- Budgets cap at MaxBudgetMultiplier × perPlayerBudget. Queued beyond MaxThrottledQueue → request FAILS (queueOrExecute returns false → "Request limit exceeded").
- `HttpRequest::execute` — stamps key set timestamp (new behavior: only SET/INCREMENT/UPDATE types), posts with Cache-Control no-cache/doNotUseCachedResponse, empty postData replaced by a single space; wraps handler with analytics when new logging on.
- onRequestFinishReport tracks msError/read/update/write/batch averages + GA "DataStoreError"; reportAnalytics flushes counters every N seconds.
- Shutdown path unlocks all store children and removes the job blocking-only when backendProcessing.

## Usage / reflection touchpoints

Parent of [DataStore](DataStore.md)/[DataStorePages](DataStore.md) instances; job machinery mirrors [DataModelJob](DataModelJob.md)/[BaseRenderJob](BaseRenderJob.md).

## Gotchas

- GetGlobalDataStore returns the LEGACY-naming store — mixing it with GetDataStore data requires understanding the two URL schemas.
- With GetGlobalDataStorePcallFix OFF, placeId==0 yields nil + console error rather than an exception (silent failure mode for scripts not checking).
- Throttled queues are per-service FIFOs without priority — one hot key's queue entries still consume global slots until key-throttle expires.
