# rbx/object_pool.h

## Purpose
Thin extension of `boost::object_pool<T, UserAllocator>` adding iteration and a destructor-correct `clear()`: `RBX::object_pool<T,UserAllocator>::for_each(F&)` walks allocated (non-free) chunks via boost's internal PODptr free-list, and `clear()` runs every live object's destructor before purging the underlying memory.

## API
```cpp
namespace RBX {
template <typename T, typename UserAllocator>
class object_pool : public boost::object_pool<T, UserAllocator> {
    explicit object_pool(const size_type next_size = 32);  // extension param
    template<class F> void for_each(F& f);   // f(T*) for each live object, allocation order per block
    void clear();                            // destruct all, then purge_memory()
};
}
```

## Usage
Pooled construction of many small same-type objects (trie nodes use plain object_pool; this variant when you need to enumerate/destroy contents).

## Gotchas
- In-file requirement: "T must have a non-throwing destructor".
- Iteration order is memory-block order, not insertion order; mutating the pool inside for_each is unsafe.
- Non-Windows needs the re-declared `size_type` typedef ("gcc can't access typedef from base class").
