# util/ControlledLRUCache.h

## Purpose
Two-tier LRU cache: a **pinned** cache (items pending processing/use, never evicted) plus an **evictable** cache (processed items, evictable under pressure). Items enter pinned and are explicitly promoted via `markEvictable`/`fetch(..., makeEvictable=true)`. Size enforced by object count or by reported memory size. Also provides `ConcurrentControlledLRUCache`, a mutex-wrapped variant with heartbeat-driven full eviction.

## Declared API
```cpp
enum CacheSizeEnforceMethod { CACHE_ENFORCE_MEMORY_SIZE, CACHE_ENFORCE_OBJECT_COUNT };

template<class Key, class Data>
class ControlledLRUCache {
public:
    ControlledLRUCache(const unsigned long maxSize,
                       CacheSizeEnforceMethod method = CACHE_ENFORCE_OBJECT_COUNT);

    const unsigned long size();      // evictable + pinned counts
    const unsigned long memSize();   // sum of stored dataSizes
    void clear();
    bool exists(const Key& key) const;
    bool remove(const Key& key);     // from either tier

    void markEvictable(const Key& key);            // pinned -> evictable
    bool fetch(const Key& key, Data* result, bool makeEvictable);
    void resize(unsigned long newSize);            // shrinks by evicting LRU evictables
    void insert(const Key& key, const Data& data, unsigned long dataSize = 0);  // inserts PINNED
    bool isFull();
    bool evictAll();                               // demotes all pinned to evictable; true if any moved
private:
    unsigned long maxSize;
    CacheSizeEnforceMethod enforceMethod;
    boost::scoped_ptr< LRUCache<Key,Data> > evictableCache;  // actually Size/MemEnforced subclass
    boost::scoped_ptr< LRUCache<Key,Data> > pinnedCache;
    void internalMakeEvictable(const Key&, const Data&, unsigned long dataSize);
};

template<class Key, class Data>
class ConcurrentControlledLRUCache {
public:
    ConcurrentControlledLRUCache(unsigned long size, unsigned long resetCounter,
                                 CacheSizeEnforceMethod enforceMethod = CACHE_ENFORCE_OBJECT_COUNT);
    bool fetch(const Key&, Data*, bool makeEvictable);
    void resize(unsigned long newSize);
    void insert(const Key&, const Data&, unsigned long dataSize = 0);
    bool remove(const Key&);
    void markEvictable(const Key&);
    bool isFull();
    bool evictAll();
    void onHeartbeat();   // every resetCounter calls -> evictAll()
private:
    RBX::ControlledLRUCache<Key, Data> cache;
    boost::mutex mutex;
    unsigned long resetCounter, heartbeatCounter;
};
```
Builds on `SizeEnforcedLRUCache` / `MemEnforcedLRUCache` / `LRUCache` — see LRUCache.md.

## Gotchas
- `insert()` always lands in the **pinned** tier; forgetting `markEvictable` means entries are never evicted and the cache "leaks" up to maxSize.
- When full and nothing is evictable, `insert` still inserts into pinned (over-limit growth of pinned tier possible) — eviction only kicks LRU from the evictable tier.
- `isFull()` only considers `pinnedCache->size() >= maxSize`, not total size.
- `resize` asserts final size ≤ newSize; can only shrink via evictable entries.
- `evictAll()` moves pinned→evictable (does NOT delete data).
- `ConcurrentControlledLRUCache::onHeartbeat()` is NOT internally locked against its own counters but mutates them without the mutex (heartbeat counter updates race-free only if single-threaded callers).

## UNKNOWN
- Typical `dataSize` accounting units for CACHE_ENFORCE_MEMORY_SIZE users.
