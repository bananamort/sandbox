# util/LuaWebService.h

## Purpose
Datamodel service backing Lua's web-facing APIs (e.g. `HttpService:GetAsync`-family and paginated queries): async URL requests with two JSON/raw LRU caches, resume/error callback dispatch back onto the DataModel thread, API-access gating, plus the `Pages`/`StandardPages`/`FriendPages` paged-result Instance types.

## Declared API
```cpp
extern const char* const sPages;
class Pages : public DescribedNonCreatable<Pages, Instance, sPages,
                       Reflection::ClassDescriptor::RUNTIME_LOCAL> {
public:
    Pages();
    virtual void fetchNextChunk(boost::function<void()> resumeFunction,
                                boost::function<void(std::string)> errorFunction) {} // base: no-op
    shared_ptr<const Reflection::ValueArray> getCurrentPage();
    bool isFinished() const;
    void advanceToNextPageAsync(boost::function<void()> resumeFunction,
                                boost::function<void(std::string)> errorFunction);
protected:
    bool finished;
    shared_ptr<const Reflection::ValueArray> currentPage;
};

extern const char* const sStandardPages;
class StandardPages : public DescribedNonCreatable<StandardPages, Pages, sStandardPages, RUNTIME_LOCAL> {
public:
    StandardPages(weak_ptr<DataModel> weakDM, const std::string& requestUrl, const std::string& fieldName);
    virtual void fetchNextChunk(resumeFn, errorFn);
private:
    std::string fieldName, requestUrl; int pageNumber; weak_ptr<DataModel> weakDM;
    processFetchSuccess/processFetchError/processFetch(...);
};

extern const char* const sFriendPages;
class FriendPages : public DescribedNonCreatable<FriendPages, Pages, sFriendPages, RUNTIME_LOCAL> {
public:
    FriendPages(weak_ptr<DataModel> weakDM, const std::string& requestUrl);
    virtual void fetchNextChunk(resumeFn, errorFn);   // keeps a prefetched nextPage + firstTime flag
private:
    /* same fields as StandardPages plus */ shared_ptr<const Reflection::ValueArray> nextPage; bool firstTime;
};

extern const char* const sLuaWebService;
#define LUA_WEB_SERVICE_STANDARD_PRIORITY 50

class LuaWebService : public DescribedNonCreatable<LuaWebService, Instance, sLuaWebService>, public Service {
public:
    LuaWebService();

    void asyncRequest(const std::string& url, float priority,
        boost::function<void(shared_ptr<const Reflection::ValueArray>)> resumeFunction,
        boost::function<void(std::string)> errorFunction);
    void asyncRequest(/* ValueMap overload */);
    void asyncRequest(/* bool overload */);
    void asyncRequest(/* std::string overload */);
    void asyncRequest(/* int overload */);

    void asyncRequestNoCache(const std::string& url, float priority,
        boost::function<void(shared_ptr<const Reflection::ValueMap>)> callback,
        AsyncHttpQueue::ResultJob resultJob);          // skips caches

    bool isApiAccessEnabled();      // BLOCKS until api access request returns
    void setCheckApiAccessBecauseInStudio();

    static bool parseWebJSONResponseHelper(std::string* response, std::exception* exception,
        shared_ptr<const Reflection::ValueTable>& result, std::string& status);
private:
    struct CachedLuaWebServiceInfo { Reflection::Variant value; ... };
    struct CachedRawLuaWebServiceInfo { std::string value; ... };
    boost::shared_ptr<AsyncHttpCache<CachedLuaWebServiceInfo, true>> webCache;
    boost::shared_ptr<AsyncHttpCache<CachedRawLuaWebServiceInfo, true>> webRawCache;
    bool checkApiAccess; Time timeToRecheckApiAccess; boost::optional<bool> apiAccess;
    checkCache<>/TryDispatchRequest<>/TryRawDispatchRequest<>/Callback/RawCallback internals;
};
```

## Gotchas
- Callbacks are resume/error style and are dispatched via `weak_ptr<LuaWebService>` through AsyncHttpQueue's completion path — the service can die mid-request safely.
- Overload resolution on `asyncRequest` is by resume-function type: passing the wrong lambda type picks a surprising overload (e.g., string vs bool).
- `isApiAccessEnabled()` **blocks** the calling thread until the access check completes.
- Cached entries hold parsed `Reflection::Variant` (JSON cache) or raw strings — caches keyed by full URL.
- `asyncRequestNoCache` lets callers pick the ResultJob dispatch mode directly.
- Pages classes are RUNTIME_LOCAL Instances; pagination state (`pageNumber`, `finished`) lives per object.

## UNKNOWN
- Which Lua API surface maps to each asyncRequest overload (reflection bindings live elsewhere).
