# AsyncHttpQueue.cpp

**Source**: `App/util/AsyncHttpQueue.cpp` (516 lines) — implements `RBX::AsyncHttpQueue` (declared in `App/include/util/AsyncHttpQueue.h`), the priority content-fetch queue used by ContentProvider.

## Purpose
Queued, deduplicated, prioritized async fetching of URLs (assets) with local-file shortcut support, failed-URL blacklisting with expiry, 202-deferred retries driven by heartbeat, and per-queue stats wiring into `Stats::StatsService`.

## API
```cpp
typedef enum { Waiting, Succeeded, Failed } RequestResult;
typedef enum { AsyncInline, AsyncNone, AsyncRead, AsyncWrite } ResultJob; // where callbacks run
typedef boost::function<void(RequestResult, std::istream*, shared_ptr<const std::string> response,
                             shared_ptr<std::exception> exception)> RequestCallback;

AsyncHttpQueue(Instance* owner,
               boost::function<bool(const std::string& url, std::string* result)> getLocalFile,
               int threadCount);
void setThreadPool(int count);                 // recreates PriorityThreadPool if count differs
void setCachePolicy(HttpCache::Policy policy); // applied to each Http request it issues
bool isRequestQueueEmpty();
bool isUrlBad(const std::string& id);
void asyncRequest(const std::string& id, float priority, RequestCallback* callback,
                  ResultJob jobType, bool ignoreBadRequests=false, const std::string& expectedType = "");
bool syncRequest(const std::string& id, const std::string& expectedType = "");
static void dispatchGenericCallback(boost::function<void(DataModel*)>, Instance*, ResultJob);
static void dispatchCallback(RequestCallback, Instance*, RequestResult,
                             shared_ptr<const std::string> data, ResultJob, shared_ptr<std::exception>);
void onHeartbeat(const Heartbeat& heartbeatEvent);
int getRequestQueueSize() const;
shared_ptr<const Reflection::ValueArray> getFailedUrls();
shared_ptr<const Reflection::ValueArray> getRequestQueueUrls();
void resetStatsItem(ServiceProvider* provider);
double getAvgTimeInQueue(); double getAvgRequestCompleteTime(); int getNumSlowRequests();
protected: virtual void registerContent(const std::string& url,
              shared_ptr<const std::string> response, shared_ptr<const std::string> filename) {}
```

## Usage / flow
- `asyncRequest`: rejects (dispatches Failed "Bad request") URLs in the blacklist unless `ignoreBadRequests`; coalesces duplicates — a second request for an in-flight URL just appends another `CallbackWrapper`. New requests schedule `processRequests(weak_ptr<AsyncHttpQueue>, RequestHandle, spin_mutex)` on a `PriorityThreadPool`.
- `processRequests`: first consults `getLocalFile(url,&filename)`; file hits are slurped from disk, otherwise builds `RBX::Http(url)` with `setExpectedAssetType(request->expectedType)` and queue's `cachePolicy`, stores the Http pointer in the Request **for cancellation**, then blocking `get(*response)`. On `http_status_error` with `statusCode == 202` the request is parked in `asyncRetryTasks` and re-scheduled ~5 s later by `onHeartbeat` (`currentWallTime += heartbeatEvent.wallStep`). Other failures push the URL onto `failedUrls` (`FailedUrl`, expires after 5 min release / 10 min debug).
- Callbacks are dispatched through `DataModel::submitTask` according to `ResultJob` (`AsyncInline` runs immediately on the worker thread; None/Read/Write marshal into DataModel tasks).
- Stats: `HttpQueueStatsItem` (a `Stats::Item` named `"HttpQueue_" + owner->getName()`) publishes avg time-in-queue, avg completion time, queue size, slow-request count (>5.0 s increments `numSlowRequests` and logs `FLog::SlowHttpRequest`).

## Gotchas
- `isUrlBad` has a subtle bug: when it encounters an expired entry it erases the range `[iter, end)` and returns false immediately, so URLs listed *after* the first expired one are not checked on that call.
- The queue holds `requestSync` (recursive_mutex) while copying responses/callbacks in places; long network I/O happens outside the lock but registration/cancellation race windows depend on it.
- `syncRequest` bypasses the queue/thread pool entirely — plain synchronous `RBX::Http::get` plus blacklist bookkeeping.
- `~AsyncHttpQueue` joins workers via `setThreadPool(0)`; destroying while callbacks hold weak_ptrs is safe, but callbacks scheduled into DataModel may still fire after destruction.
