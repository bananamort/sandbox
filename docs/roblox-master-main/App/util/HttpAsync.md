# HttpAsync.cpp

**Source**: `App/util/HttpAsync.cpp` (113 lines) — implements `RBX::HttpAsync` (declared in `App/include/util/HttpAsync.h`), a thin promise/future wrapper over `RBX::Http`.

## Purpose
Fire-and-forget GET/POST that returns `HttpFuture` (`boost::shared_future<std::string>`); work still executes on the `Http` 16-thread pool. Adds an exponential-backoff retry variant.

## API
```cpp
typedef boost::shared_future<std::string> HttpFuture;

class HttpOptions {                       // header bag + flags
    void addHeader(const std::string& key, const std::string& value);
    void setExternal(bool value);
    void setDoNotUseCachedResponse();
};
class HttpPostData {
    HttpPostData(const std::string& contents, const std::string& contentType, bool compress);
    HttpPostData(const boost::shared_ptr<std::istream>& contents, const std::string& contentType, bool compress);
};
class HttpAsync {
    static HttpFuture get(const std::string& url, const HttpOptions& options = HttpOptions());
    static HttpFuture getWithRetries(const std::string& url, int retryCount, const HttpOptions& options = HttpOptions());
    static HttpFuture post(const std::string& url, const HttpPostData& postData, const HttpOptions& options = HttpOptions());
};
```

## Usage
- `get`/`post` construct a stack `Http http(url)`, copy `options.headers` into `http.additionalHeaders`, set `doNotUseCachedResponse`, then call the async overload with a handler that fulfills a `boost::promise<std::string>`.
- `responseHandlerRetry` on failure sleeps `retrySleep` ms (initial `kInitialRetryDelayMs = 200`) and re-issues via `http.get(...)` doubling the delay each attempt; comment warns *"This takes out a thread in the thread pool :( use sparingly."*
- Exceptions surface through the future: `promise->set_exception(boost::copy_exception(*error))`.

## Gotchas
- Retry holds a pool thread while sleeping — many concurrent retries can starve the 16-thread HTTP pool.
- The retried request reuses one `Http` instance captured by value into the bind; per-attempt state like `shouldRetry` persists across retries.
- No timeout on waiting the future; caller must use `timed_wait` if bounded waits are needed.
