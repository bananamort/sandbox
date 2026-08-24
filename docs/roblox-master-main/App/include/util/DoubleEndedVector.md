# util/DoubleEndedVector.h

## Purpose
Ring-buffer-on-`std::vector` deque: O(1) amortized push/pop at both front and back with power-of-two capacity and bitmask indexing. "This container never attempts to reduce the amount of memory it uses, so it may not be suitable for queues that do not have a reasonable upper bound in size."

## Declared API
```cpp
template<class T>
struct DoubleEndedVector {
    DoubleEndedVector();

    size_t size() const;
    bool push_back(const T& inputData);   // always returns true
    bool push_front(const T& inputData);  // always returns true
    void pop_front(T* out);               // asserts non-empty; copies front into *out
    T&       operator[](const unsigned int& idx);        // logical index 0 = front
    const T& operator[](const unsigned int& idx) const;
private:
    size_t head, internalSize;
    std::vector<T> data;                  // capacity is power of two (min 32)
    size_t dataSizeMask;                  // data.size()-1
    void grow();                          // doubles when full; re-linearizes to head=0
};
```

## Gotchas
- Memory never shrinks — high-water mark capacity is retained forever.
- `pop_back` does not exist despite the name; only `pop_front(T*)`.
- Pushes return `bool` but are always `true` (no failure mode).
- No iterators, no erase/insert-middle; index access wraps via mask — out-of-range indices silently alias instead of throwing/asserting.
- Requires default-constructible + copy-assignable T (assignment into slots, not placement).

## UNKNOWN
- Primary consumers (likely task queues in scheduler code outside this slice).
