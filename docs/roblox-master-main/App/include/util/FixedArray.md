# util/FixedArray.h

## Purpose
Fixed-capacity, grow-once array: `boost::array<T,N>` storage plus a live count `num`. Like a stack-allocated vector with hard cap N; no allocation after construction.

## Declared API
```cpp
template<class T, std::size_t N>
class FixedArray {
public:
    FixedArray();                          // num = 0 (elements uninitialized)

    void push_back(const T& x);            // asserts num < N (VERY_FAST assert)
    void fastRemove(size_t i);             // swap-with-last, O(1), unordered
    void replace(size_t i, const T& x);
    void fastClear();                      // num = 0 only (no dtors called)
    T        operator[](size_t i);         // BY VALUE! asserts i < num
    const T  operator[](size_t i) const;   // BY VALUE!
    size_t size() const;
    size_t capacity() const;               // == N
private:
    boost::array<T, N> data;
    size_t num;
};
```

## Gotchas
- **`operator[]` returns by value**, not reference — `arr[i].mutate()` or `&arr[i]` patterns silently operate on a temporary. This is the big trap of this class.
- Overflow/underflow guarded only by `RBXASSERT_VERY_FAST`, which may be compiled out in release — pushing past N is memory corruption in ship builds.
- `fastClear` doesn't destruct elements (POD-oriented design).
- `fastRemove(i)` moves the last element into slot i — ordering not preserved.

## UNKNOWN
- Call sites (likely small physics scratch lists).
