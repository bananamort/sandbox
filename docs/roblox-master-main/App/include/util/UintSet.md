# util/UintSet.h

## Purpose
Bitset-backed set of unsigned ints meant to outperform `std::set<unsigned int>` when values are densely packed (header: wins roughly when average spacing < 24 * sizeof(void*)). Backed by a `DoubleEndedVector<uint32>` of bit groups with a sliding min/max group window.

## Declared API
```cpp
struct UintSet {
    typedef boost::uint32_t BitGroup;

    // public for testing:
    static const unsigned int kShiftForGroup;   // log2(bits per group)
    static const BitGroup   kBitInGroupMask;

    UintSet();
    size_t size() const;                        // number of set bits (tracked)
    bool insert(const unsigned int intVal);     // false if already present
    bool contains(const unsigned int intVal);
    void pop_smallest(unsigned int* out);       // remove+return min element
private:
    struct UpdateBitInfo { const BitGroup bitGroup, bitPosition, mask; UpdateBitInfo(unsigned int); };
    unsigned int minBitGroup;                   // group offset of bitSet[0]
    unsigned int maxBitGroup;                   // inclusive max valid index
    size_t internalSize;                        // groups stored
    bool isEmpty;
    DoubleEndedVector<BitGroup> bitSet;
};
```

## Gotchas
- Memory scales with the RANGE of stored values, not the count — storing 0 and 2^31 allocates ~256 MB of groups. Only for dense sets.
- `pop_smallest` on an empty set behavior unspecified here (UNKNOWN/assert).
- `contains`/`insert` are O(1) amortized via DEQ indexing.
- Not thread-safe.

## UNKNOWN
- Consumers (likely replication ack tracking / id allocation).
