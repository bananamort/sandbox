# util/AsyncHttpCache.h

## Purpose
Adds a size-enforced LRU content cache on top of `AsyncHttpQueue`: fetched URLs are stored as `CachedContent` keyed by URL/id, with lookup, invalidation, rename, and introspection of requested URLs. Template parameter selects the cached payload type; `Log=true` enables FASTLOG tracing.

## Declared API
```cpp
template<typename CachedContent, bool Log = false>
class AsyncHttpCache : public AsyncHttpQueue {
public:
    AsyncHttpCache(Instance* owner,
        boost::function<bool(const std::string&, std::string*)> getLocalFile,
        int threadCount, int cacheSize);

    shared_ptr<const Reflection::ValueArray> getRequestedUrls(); // http:// ids + failedUrls
    void setCacheSize(int count);                                // resize LRU
    bool findCacheItem(const std::string& id, CachedContent* result);
    void removeCacheItem(const std::string& id);
    void invalidateCacheItemOrFailure(const std::string& id);    // drops from cache AND failed list
    void insertCacheItem(const std::string& id, const CachedContent& result);
    void renameCacheItem(const std::string& id, const std::string& newId);
    void clearCache();                                           // cache + failedUrls
    void printContentNames();

protected:
    /*override*/ void registerContent(const std::string& url,
        shared_ptr<const std::string> response, shared_ptr<const std::string> filename);

    typedef SizeEnforcedLRUCache<std::string, CachedContent> ContentCache;
    boost::mutex contentCacheMutex;
    ContentCache contentCache;
};
```

Note: `CachedContent` must be constructible as `CachedContent(response, filename)` — that's how `registerContent` builds entries from the queue's completion hook.

## Gotchas
- Two independent locks: `contentCacheMutex` (plain mutex) for the cache and inherited `requestSync` (recursive) for `failedUrls`; `invalidateCacheItemOrFailure`/`clearCache`/`getRequestedUrls` take them **sequentially**, never nested — do not add nested locking here.
- `renameCacheItem` is fetch→remove→insert under a single `contentCacheMutex` hold — atomic w.r.t. all other cache mutators (which take the same mutex).
- `getRequestedUrls` returns only ids where `ContentId(...).isHttp()` plus every currently-failed URL (failed URLs expire over time per base class).
- Cache hit via `findCacheItem` refreshes LRU recency (`SizeEnforcedLRUCache::fetch` defaults `touch=true`, splicing the entry to the MRU front).

## UNKNOWN
- Concrete `CachedContent` types instantiated in the tree and their headers.
