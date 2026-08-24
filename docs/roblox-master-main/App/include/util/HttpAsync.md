# util/HttpAsync.h

## Purpose
Fire-and-forget async HTTP built on boost futures: static `get`/`getWithRetries`/`post` returning `HttpFuture` (`boost::shared_future<std::string>`), with an options object for extra headers, external-request flag, and cache bypass; POST bodies from string or istream with optional compression.

## Declared API
```cpp
typedef boost::shared_future<std::string> HttpFuture;

class HttpOptions {                       // friend class HttpAsync
public:
    HttpOptions();                        // external=false, doNotUseCachedResponse=false
    void addHeader(const std::string& key, const std::string& value);
    void setExternal(bool value);
    void setDoNotUseCachedResponse();
private:
    HttpAux::AdditionalHeaders headers;
    bool external;
    bool doNotUseCachedResponse;
};

class HttpPostData {                      // friend class HttpAsync
public:
    HttpPostData(const std::string& contents, const std::string& contentType, bool compress);
    HttpPostData(const boost::shared_ptr<std::istream>& contents, const std::string& contentType, bool compress);
private:
    boost::shared_ptr<std::istream> data;
    std::string contentType;
    bool compress;
};

class HttpAsync {
public:
    static HttpFuture get(const std::string& url, const HttpOptions& options = HttpOptions());
    static HttpFuture getWithRetries(const std::string& url, int retryCount, const HttpOptions& options = HttpOptions());
    static HttpFuture post(const std::string& url, const HttpPostData& postData, const HttpOptions& options = HttpOptions());
};
```

## Gotchas
- Returns body as `std::string` via shared_future — whole response buffered in memory; not for large downloads.
- `shared_future` is copyable: multiple waiters OK.
- `setExternal(true)` presumably marks cross-origin/external requests for policy handling (exact effect implementation-side).
- No timeout parameter on this interface.
- Exceptions surface when `.get()` is called on the future (boost future semantics).

## UNKNOWN
- Thread pool / dispatch mechanism backing these futures (.cpp outside App/include).
