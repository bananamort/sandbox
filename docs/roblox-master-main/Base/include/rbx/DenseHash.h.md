# rbx/DenseHash.h

## Purpose
Open-addressing hash containers: `RBX::DenseHashSet<Key,Hash,Eq>` and `RBX::DenseHashMap<Key,Value,Hash,Eq>`, built on `detail::DenseHashTable` (flat `std::vector` of items, quadratic probing, power-of-two bucket count). Commented in-file as "a faster alternative of boost::unordered_set/map" at the cost of a reduced interface.

## API
```cpp
template <typename Key, typename Hash = boost::hash<Key>, typename Eq = std::equal_to<Key>>
class DenseHashSet {
    DenseHashSet(const Key& empty_key, size_t buckets = 0);  // buckets must be power of two (RBXASSERT)
    void clear();
    void insert(const Key& key);
    bool contains(const Key& key) const;                     // no find() on the set
    size_t size() const; bool empty() const; size_t bucket_count() const;
    const_iterator begin()/end();                            // *it -> const Key&
};

template <typename Key, typename Value, typename Hash = boost::hash<Key>, typename Eq = std::equal_to<Key>>
class DenseHashMap {
    DenseHashMap(const Key& empty_key, size_t buckets = 0);
    void clear();
    Value& operator[](const Key& key);                       // default-constructs on miss
    const Value* find(const Key& key) const;
    Value* find(const Key& key);
    bool contains(const Key& key) const;
    size_t size()/empty()/bucket_count();
    const_iterator begin()/end();
};
```

## Usage
Hot-path lookups (reflection tables, VM registries) where erase is never needed and cache locality beats node-based unordered containers.

## Gotchas
- NO ERASE. The sentinel `empty_key` marks "no entry"; you must choose a key value that never occurs in real data (constructor takes it explicitly).
- Inserting the `empty_key` itself is an assert violation.
- Any `operator[]`/insert invalidates previously returned references/pointers (documented inline) — rehash moves items.
- Load factor threshold is 75% (`count >= size*3/4`) before doubling rehash.
- Iteration order is bucket order — unstable across rehashes.
