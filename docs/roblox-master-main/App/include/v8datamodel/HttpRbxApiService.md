# App/include/v8datamodel/HttpRbxApiService.h

## Purpose

`HttpRbxApiService` (INTERNAL) — the engine's Roblox-API HTTP client: priority-throttled GET/POST against the api base URL with retry queues, sync/async variants, Lua entry points, and Google-Analytics call counting. Pumped by [HttpRbxApiJob](HttpRbxApiJob.md).

## Declared API

Free: `enum ThrottlingPriority { PRIORITY_EXTREME=2 /*never throttled*/, PRIORITY_SERVER_ELEVATED=1 /*server calls only*/, PRIORITY_DEFAULT=0 };` flag `DYNAMIC_FASTINT(PercentApiRequestsRecordGoogleAnalytics)`.

Class: `HttpRbxApiService : public DescribedCreatable<..., Instance, sHttpRbxApiService, ClassDescriptor::INTERNAL>, public Service`

- Nested `struct HttpApiRequest` — private `Http http;` plus `bool isPost; std::string postData, httpContentType, syncResponse; bool async; ThrottlingPriority throttlingPriority; int retryCount; resume/error functions; void execute(HttpRbxApiService*); setHttp(Http&) (forces shouldRetry=false); getHttp() const;` ctor defaults (async true, POST false, DEFAULT priority).
- Throttling: four budgets `defaultServerThrottle, elevatedServerThrottle, clientThrottle, retryBudget`; queues `throttledDefaultServerRequests/throttledElevatedServerRequests/throttledClientRequests/retryQueue` (`DoubleEndedVector<HttpApiRequest>`; comment: bounded by HttpRbxApiMaxThrottledQueueSize, else throttle error returned); helpers `tryThrottleRequest(...)`, `executeApiRequest(request, priority, errorFn)`, `executeThrottledRequests(queue, helper)`; pump API `addThrottlingBudgets(float timeDeltaMinutes)`, `executeThrottledRequests()`, `executeRetryRequests()`, `addToRetryQueue(HttpApiRequest)`.
- Sync calls ("only use if we need to block the thread"): `void get(Http&, bool useHttps, ThrottlingPriority, std::string& response);` + urlPath overload.
- Async: `getAsync(Http&|urlPath+useHttps, priority, resume, error)` and `getAsyncLua(...)`; `postAsync(Http&|urlPath, data, useHttps, priority, HttpContentType, resume, error)` ×2, `postAsyncWithAdditionalHeaders(... RBX::HttpAux::AdditionalHeaders ...)`, `postAsyncLua(...)`.
- Statics/helpers: `isAPIHttpRequest(const Http&)`, `getApiUrlPath(const Http&)`, `retrySyncRequest(Http&, std::string& response)`, `httpHelper(weak_ptr<...>, std::string* response, std::exception*, request copy, priority, resume, error)`; `checkAndUpdatePostUrl(std::string& fullUrl, const std::string& urlPath) const`.
- Analytics: `addToApiCallCount()` (unsynchronized ++), `getRecordInGoogleAnalytics()`; member `recordInGoogleAnalytics`, counter `totalNumOfApiCalls`, `instanceAliveTimer`.
- Base URL: member `apiBaseUrl`, **static** `StaticApiBaseUrl` synced via property-change hook.
- Presence detection: flags serverPresent/clientPresent/isPlaySolo maintained through connections (serviceAdded, playersChanged, contentProviderPropertyChanged); init helpers `checkForClientAndServer`, `newServiceAdded`, `playersPropertyChanged`, `disconnectEventConnections`; `setErrorForAsync(errorString, errorFunction)`; override onServiceProvider.

## Gotchas

- PRIORITY_SERVER_ELEVATED works only for server-side calls — client misuse falls back silently.
- Throttled queues are size-capped: overflow produces a throttle *error* to the caller rather than queuing.
- The static base URL is process-global shared across DataModels.
- addToApiCallCount is a plain increment — racy under concurrency.

## UNKNOWN

- Exact budget sizes/refill curve (.cpp — see [HttpRbxApiService.md](../../v8datamodel/HttpRbxApiService.md)).

## Cross-links

- Implementation: [App/v8datamodel/HttpRbxApiService.md](../../v8datamodel/HttpRbxApiService.md).
- Job pump: [HttpRbxApiJob.md](HttpRbxApiJob.md); raw HTTP service [HttpService.md](HttpService.md).
