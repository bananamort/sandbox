# util/StlExtra.h

## Purpose
Two STL vector helpers for O(1) unordered removal from short vectors: `fastRemoveIndex` (swap-with-last by index) and `fastRemoveShort` (find + swap-with-last, returns old index). Both are documented as "only fast for very short vectors - should do no allocation".

## Declared API
```cpp
namespace RBX {
// only fast for very short vectors; removes by swapping last element into the hole.
template<class T>
void fastRemoveIndex(std::vector<T>& vec, size_t index);
    // asserts: index valid, vec non-empty, vec.size() < 32

// find + swap-remove; returns index where item was found:
template<class T>
size_t fastRemoveShort(std::vector<T>& vec, const T& item);
    // asserts: found, size < 32; debug builds verify capacity unchanged (no realloc)
}
```

## Gotchas
- Order is NOT preserved — the last element moves into the removed slot.
- Requires `T` assignable and equality-comparable (for fastRemoveShort).
- The `< 32` size guard is an assert only — release builds happily do O(n) finds on big vectors.
- `fastRemoveShort` computes `answer = it - begin` BEFORE checking `it != end`; on a miss this yields garbage index (asserts fire in debug).
- Comment says "returns index of the item removed" for both — true only for fastRemoveShort.

## UNKNOWN
- Nothing notable beyond what's in-header.
