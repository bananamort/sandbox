# util/LRUCache.h

## Purpose
Family of LRU caches built on a `std::list` (recency order) + `boost::unordered_map` (index): plain unbounded `LRUCache`, count-capped `SizeEnforcedLRUCache`, memory-capped `MemEnforcedLRUCache` (entries carry a caller-supplied byte size), and mutex-wrapped `ConcurrentLRUCache`.

## Declared API
```cpp
template<class Key, class Data>
class LRUCache {
public:
    typedef std::list< std::pair<Key, std::pair<unsigned long, Data>> > List; // front = MRU
    typedef boost::unordered_map<Key, List_Iter> Map;

    LRUCache();                       // ~LRUCache() clears
    void printContentNames();         // dumps keys via StandardOut
    unsigned long size();             // element count
    unsigned long memSize();          // sum of stored dataSize values
    void clear();
    bool exists(const Key& key) const;
    bool empty() const;
    bool remove(const Key& key);

    bool fetch(const Key& key, Data* result, unsigned long* size, bool touch = true);
    bool fetch(const Key& key, Data* result, bool touch = true);
    virtual void resize(unsigned long newSize);      // evict from LRU end while over
    void removeLeastRecentlyUsed();
    virtual void insert(const Key& key, const Data& data, const unsigned long dataSize = 0);
        // replaces existing entry; new/refreshed entry goes to MRU front
    void insert(List_cIter iter, List_cIter iterEnd);   // bulk insert from another cache's list
    List_Iter begin();  List_Iter end();
};

template<class Key, class Data>
class SizeEnforcedLRUCache : public LRUCache<Key, Data> {
public:
    SizeEnforcedLRUCache(const unsigned long maxSize);
    void resize(unsigned long newSize);   // updates cap then shrinks
    void insert(...);                     // inserts then evicts LRU while size > maxSize
};

template<class Key, class Data>
class MemEnforcedLRUCache : public LRUCache<Key, Data> {
public:
    MemEnforcedLRUCache(const unsigned long maxSize);     // maxSize in MEMORY units
    virtual void resize(unsigned long newSize);           // evicts while totalMemory > cap
    void insert(..., const unsigned long dataSize);       // evicts while over budget
};

template<class Key, class Data>
class ConcurrentLRUCache {
public:
    RBX::LRUCache<Key, Data> cache;      // public member!
    boost::mutex mutex;                  // public member!
    ConcurrentLRUCache(int size);
    bool fetch(const Key& id, Data* result);   // locked
    void insert(const Key& id, const Data& data); // locked
};
```

## Gotchas
- Recency: list **front** is most-recently-used; eviction takes the back.
- `fetch(key, result)` copies Data into `*result` — for big payloads prefer storing shared_ptr as Data.
- `touch=true` on fetch refreshes recency (splice to front).
- `insert` on an existing key removes then re-inserts (fresh MRU position).
- `dataSize=0` default means memory accounting silently undercounts unless callers pass real sizes.
- `ConcurrentLRUCache` exposes its cache and mutex publicly and locks only fetch/insert — other ops (remove/clear) are unguarded.
- Not exception-safe around Data copy operations.

## UNKNOWN
- Nothing major; behavior fully visible in header. Used by ControlledLRUCache.md and AsyncHttpCache.md.
