# util/IndexArray.h

## Purpose
Intrusive pointer array: each item stores its own array index (via a member-function-pointer template parameter `&Item::getIndex`), enabling O(1) `fastAppend`/`fastRemove`/`fastContains`. Header includes a full USAGE example. Noncopyable because stored indices can't be shared between arrays.

## Declared API
```cpp
template <class Item, int& (Item::*getIndex)()>
class IndexArray : public boost::noncopyable {
public:
    typedef Item** Iterator;
    typedef const Item** ConstIterator;

    void fastAppend(Item* item);      // asserts item && indexOf(item)==-1; O(1)
    void fastRemove(Item* item);      // swap-with-last, O(1), unordered
    void remove(Item* item);          // order-preserving shift-down, O(n)
    bool fastContains(Item* item) const;   // index >= 0 check
    G3D::Array<Item*>& underlyingArray();
    const G3D::Array<Item*>& underlyingArray() const;
    Item* operator[](int n);          // asserts index consistency
    Item* operator[](unsigned int n);
    Item* const operator[](int n) const;
    Item* const operator[](unsigned int n) const;
    int size() const;
private:
    G3D::Array<Item*> array;
    int& indexOf(Item* item) const;   // invokes item->*getIndex()
};
```
Required item protocol (from the header's USAGE comment): an `int index` member initialized to **-1**, reset to -1 on destruction (`RBXASSERT(index == -1)`), exposed via `int& getIndex()`.

## Gotchas
- Items may live in only ONE IndexArray at a time — the stored index is the coupling.
- Item dtors must assert/reset index == -1 or removal bookkeeping silently rots.
- `fastRemove` reorders; use `remove` when order matters.
- `operator[]` returns the pointer by value and asserts consistency only.
- Validation-mode asserts double-check membership by linear find (`RBXASSERT_IF_VALIDATING`) — debug cost O(n).

## UNKNOWN
- Primary users (likely physics broadphase/contact lists).
