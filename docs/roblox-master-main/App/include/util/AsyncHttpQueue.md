# util/AsyncHttpQueue.h

## Purpose
Priority-thread-pool HTTP request queue driven from heartbeat: batches async URL fetches with per-request callbacks, retry scheduling, bad-URL blacklisting, and running-average latency stats. Base class of `AsyncHttpCache`.

## Declared API
```cpp
class AsyncHttpQueue
   : public boost::enable_shared_from_this<AsyncHttpQueue>
   , public boost::noncopyable
{
public:
    typedef enum { Waiting, Succeeded, Failed } RequestResult;
    typedef enum { AsyncInline, AsyncNone, AsyncRead, AsyncWrite } ResultJob;

    typedef boost::function<void(RequestResult, std::istream*,
                                 shared_ptr<const std::string> response,
                                 shared_ptr<std::exception> exception)> RequestCallback;

    struct CallbackWrapper { RequestCallback callback; ResultJob jobType; };

    void setThreadPool(int count);
    void setCachePolicy(const HttpCache::Policy policy);
    bool isRequestQueueEmpty();
    bool isUrlBad(const std::string& id);
    void asyncRequest(const std::string& id, float priority, RequestCallback* callback,
                      ResultJob jobType, bool ignoreBadRequests=false, const std::string& expectedType="");
    bool syncRequest(const std::string& id, const std::string& expectedType = "");

    static void dispatchGenericCallback(boost::function<void(DataModel*)>, Instance*, ResultJob);
    static void dispatchCallback(RequestCallback, Instance*, RequestResult,
                                 shared_ptr<const std::string> data, ResultJob, shared_ptr<std::exception>);

    AsyncHttpQueue(Instance* owner, boost::function<bool(const std::string& url, std::string* result)> getLocalFile, int threadCount);
    virtual ~AsyncHttpQueue();
    void onHeartbeat(const Heartbeat& heartbeatEvent);

    int getRequestQueueSize() const;
    shared_ptr<const Reflection::ValueArray> getFailedUrls();
    shared_ptr<const Reflection::ValueArray> getRequestQueueUrls();
    void resetStatsItem(ServiceProvider* provider);
    double getAvgTimeInQueue();          // msec running average
    double getAvgRequestCompleteTime();  // msec running average
    int getNumSlowRequests();

protected:
    virtual void registerContent(const std::string& url,
        shared_ptr<const std::string> response, shared_ptr<const std::string> filename) {} // hook for caches

    struct Request {
        std::string url;
        std::vector<CallbackWrapper> callbacks;
        float priority;
        std::string expectedType;       // used in header
        boost::shared_ptr<Http> http;   // kept for cancellation
        RBX::Time startTime;
        bool operator==(const std::string& url) const;
    };

    RunningAverage<double> avgTimeInQueue, avgRequestCompleteTime;
    int numSlowRequests;

    struct FailedUrl { std::string url; RBX::Time expiration; FailedUrl(const char* url); bool expired() const; };

    typedef std::list<Request> RequestList;
    typedef RequestList::iterator RequestHandle;

    struct AsyncRetryTask { double retryTime; RequestHandle request; };

    mutable boost::recursive_mutex requestSync; // guards requestQueue, failedUrls, threadPool, http ptr
    RequestList requestQueue;
    std::list<FailedUrl> failedUrls;
    boost::scoped_ptr<PriorityThreadPool> threadPool;
    boost::recursive_mutex asyncRetrySync;
    std::queue<AsyncRetryTask> asyncRetryTasks;
    double currentWallTime;

    static void processRequests(boost::weak_ptr<AsyncHttpQueue> httpQueue, RequestHandle request,
                                boost::shared_ptr<rbx::spin_mutex> lock);
    void addAsyncRetryTask(RequestHandle request);
    Instance* owner;
    boost::function<bool(const std::string& url, std::string* result)> getLocalFile;
    HttpCache::Policy cachePolicy;
};
```

## Gotchas
- Callbacks receive raw `std::istream*` plus ownership-bearing shared_ptrs for response body / exception; `RequestResult::Failed` pairs with non-null exception pointer.
- `asyncRequest` takes `RequestCallback*` (pointer!) — semantics of ownership/nullness unspecified here (UNKNOWN).
- Failed URLs are blacklisted with an expiration time; `ignoreBadRequests=true` bypasses the blacklist check.
- `processRequests` holds a `weak_ptr` to the queue so worker threads survive singleton destruction; also passes a spin_mutex lock handle.
- `requestSync` is recursive and guards multiple structures; long-held sections block heartbeat processing.
- `ResultJob` selects how completion work is dispatched (inline vs none vs read vs write thread).

## UNKNOWN
- Retry policy constants (how many retries, backoff curve) — implementation-side.
- Which service owns the canonical instance in production.
