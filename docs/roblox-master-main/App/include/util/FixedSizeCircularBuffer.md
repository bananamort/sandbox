# util/FixedSizeCircularBuffer.h

## Purpose
Tiny fixed-capacity (default 8) circular buffer of most-recent values: push overwrites oldest; supports linear scan find and index-from-newest access. No dynamic allocation.

## Declared API
```cpp
template<class ElementType, int size = 8>
struct FixedSizeCircularBuffer {
    FixedSizeCircularBuffer();                    // head=0, pushed=0

    void push(const ElementType& newData);        // overwrites oldest when full
    bool find(const ElementType& key, unsigned int* outIndex); // 0=newest; needs operator==
    const ElementType& operator[](const unsigned int& index) const; // 0 = newest
private:
    ElementType data[size];
    unsigned int head;      // index of newest element
    unsigned int pushed;    // count of valid elements (<= size)
};
```

## Gotchas
- Indexing semantics: `operator[](0)` is the **most recently pushed** element; older entries at higher indices.
- `find`/`operator[]` require `ElementType::operator==` only for find.
- Before any push, all reads return uninitialized memory (`pushed` is not consulted by `operator[]` — it wraps regardless).
- Capacity fixed at template instantiation: stack-size implications for large ElementType.
- Not thread-safe.

## UNKNOWN
- Consumers (likely input-history or movement history — cf. MovementHistory.h).
