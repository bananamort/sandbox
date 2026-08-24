# HttpRbxApiService.cpp

## Purpose

Implements `HttpRbxApiService` ("HttpRbxApiService") — the throttled, budgeted HTTP client for Roblox API-proxy calls only (GetAsync/PostAsync exposed to RobloxScript). Runs a dedicated [HttpRbxApiJob](../App/v8datamodel/INDEX-M-Z.md) on the TaskScheduler, classifies server/client/play-solo context to pick per-audience token buckets, queues over-budget requests, retries 503/429 with budget, and reports throttle/queue/retry telemetry to Google Analytics.

## Key types and API

Descriptors (both Security::RobloxScript yield funcs):
- `GetAsync(apiUrlPath, useHttps=true, priority=PRIORITY_DEFAULT) -> string`
- `PostAsync(apiUrlPath, data, useHttps=true, priority=PRIORITY_DEFAULT, content_type=ApplicationJson) -> string`
- Enum ThrottlingPriority {Extreme, ElevateOnServer→"ElevatedOnServer", Default} (+Variant/StringConverter templates).

Tunables (DFInts): PercentApiRequestsRecordGoogleAnalytics(1 — % of instances that record GA), HttpRbxApiClientPerMinuteRequestLimit(300), HttpRbxApiMaxBudgetMultiplier(1), HttpRbxApiRequestsPerMinuteServerLimit(300), HttpRbxApiRequestsPerMinutePerPlayerInServerLimit(100), HttpRbxApiMaxThrottledQueueSize(50), HttpRbxApiMaxRetryBudgetPerMinute(500), HttpRbxApiMaxRetryCount(10), HttpRbxApiMaxRetryQueueSize(500), HttpRbxApiMaxSyncRetries(3), HttpRbxApiSyncRetryWaitTimeMSec(500). DFFlag::UseR15Character gates setCanRequestUniverseInfo. LOGGROUP HttpRbxApiBudget. Constant HTTP_POST_COMPRESSION_LIMIT=256.

State: static StaticApiBaseUrl (apiBaseUrl with literal "https" stripped); mode flags serverPresent/clientPresent/isPlaySolo discovered via Workspace::serverIsPresent/clientIsPresent or Players::propLocalPlayer (play solo) with serviceAdded/propertyChanged fallback wiring; four BudgetedThrottlingHelpers (defaultServer/elevatedServer/client/retry) + three DoubleEndedVector<HttpApiRequest> queues + retryQueue; callback-free sync path via apiRequest.syncResponse.

Behavior:
- executeApiRequest: rejects empty URLs and URLs missing apiBaseUrl ("Non-API Proxy BaseURL used..."); DEFAULT/SERVER_ELEVATED route through tryThrottleRequest against the audience bucket (play-solo counts as BOTH server and client buckets; Extreme bypasses all budgets "should always go thru"); unknown priority errors out.
- tryThrottleRequest: no budget → queue if < MaxThrottledQueueSize else error with formatted limits message (server formula = ServerLimit + PerPlayer×numPlayers); one-shot GA events GameHasBeenAPIQueued/GameHasBeenAPIThrottled via boost::call_once.
- Retries: shouldRetryFromStatusCode accepts 503 AND 429 ("web is switching to 429"); async retries go through addToRetryQueue (cap HttpRbxApiMaxRetryQueueSize → error "could not retry due to too many current retry requests") and drain in executeRetryRequests gated by retryBudget; sync GETs retry inline via retrySyncRequest sleep-loop then throw runtime_error "Could not get a valid response...".
- postAsyncInternal: maps HttpContentType{ApplicationJson,ApplicationXml,ApplicationUrlEncoded,TextPlain,TextXml} to Http constants else "Unsupported content type"; empty data replaced by single space; compresses posts >256 bytes. checkAndUpdatePostUrl RBXASSERTs+GA-flags url paths that already contain the proxy domain and uses them verbatim.
- Lua entry points call robloxScriptModifiedCheck(security) before dispatch (anti-tamper on the descriptor security).
- addThrottlingBudgets refills per elapsed minutes; server max scales with player count.
- onServiceProvider teardown flushes GA totals (TotalHttpApiCalls*/AvgHttpApiCallsPerSec* per mode) using instanceAliveTimer.

## Usage / reflection touchpoints

Consumed by core scripts and [InsertService](InsertService.md)::getLatestAssetVersion (PRIORITY_DEFAULT getAsync of /assets/%i/versions?placeId=%i); Http object from Util/Http.h; job registered on TaskScheduler::singleton(); ContentProvider::desc_baseUrl property watch seeds StaticApiBaseUrl when not present at attach.

## Gotchas

- GetAsync/PostAsync take PATHS not full URLs — passing an absolute URL trips the assert path but still executes (RBXASSERT is dev-only); production silently tolerates it while flagging GA.
- The https-strip does `apiBaseUrl.replace(apiBaseUrl.find("https"),5,"")` without checking npos — a base URL without "https" would be UB; guarded only by upstream guarantees.
- Play-solo requests consume BOTH server and client budgets (double-charged).
- PRIORITY_EXTREME skips budget checks entirely but still requires an API-proxy URL.
- Throttled requests are dropped, not rejected, when queue full — caller's errorFunction gets the limit message but the request never executes later.
- retryCount increments even for non-retryable failures (inside shouldRetryRequest) — harmless but inflates GA RetryRequest* attribution.
- StaticApiBaseUrl is PROCESS-GLOBAL mutable state shared across DataModel instances.
