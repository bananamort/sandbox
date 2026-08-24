# util/BiMultiMap.h

## Purpose
"Poor man's" bidirectional multimap over a single `std::multimap<Left, Right>`: many-to-many association with the restriction that each (left, right) pair appears at most once. Header itself notes it should eventually be re-written with a dual-indexed structure.

## Declared API
```cpp
template <typename Left, typename Right>
class BiMultiMap {
public:
    typedef std::multimap<Left, Right> InternalMap;
    typedef typename InternalMap::iterator InternalMapIt;
    InternalMap internalMap;                       // public member

    bool pairInMap(const Left& left, const Right& right);   // linear scan of left's range
    void insertPair(const Left& left, const Right& right);  // RBXASSERT_SLOW(no dup)
    void removePair(const Left& left, const Right& right);  // asserts if absent
    bool empty() const;
    bool emptyLeft(const Left& left) const;                 // no entries for this left key
    template<class Func> void visitEachLeft(const Left& left, const Func& func) const;
};
```

## Gotchas
- Reverse lookup (by `Right`) is O(n) full scan — only forward direction is indexed.
- Duplicate-pair prevention is enforced by slow-path asserts (`RBXASSERT_SLOW`), which are compiled out in release; inserting duplicates silently corrupts assumptions.
- `removePair` on an absent pair hits `RBXASSERT(0)` and silently does nothing in release.
- `internalMap` is public — callers can break the one-pair invariant directly.
- Requires `Left` to be less-than-comparable (multimap) and both types equality-comparable.

## UNKNOWN
- Call sites (likely constraint/joint bookkeeping; not visible from this slice).
