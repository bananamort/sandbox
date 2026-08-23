# rbx/intrusive_weak_ptr.h

## Purpose
A weak-reference smart pointer extending `boost::intrusive_ptr` semantics. Target classes must additionally implement `intrusive_ptr_expired`, `intrusive_ptr_try_lock`, `intrusive_ptr_add_weak_ref`, `intrusive_ptr_weak_release` (all provided by `rbx::intrusive_ptr_target`).

## API
```cpp
namespace rbx {
template<class T> class intrusive_weak_ptr {
    intrusive_weak_ptr();                                   // null
    intrusive_weak_ptr(T* p);                               // adds weak ref (NOT explicit: implicit T* conversion compiles)
    template<class U> intrusive_weak_ptr(const intrusive_weak_ptr<U>& rhs); // copies only if !expired()
    template<class U> intrusive_weak_ptr(const boost::intrusive_ptr<U>& rhs);
    intrusive_weak_ptr& operator=(T* p / const intrusive_weak_ptr<U>& / const boost::intrusive_ptr<U>&);
    ~intrusive_weak_ptr();                                  // weak_release
    void reset(); void reset(T* p);
    boost::intrusive_ptr<T> lock() const;                   // try_lock CAS; empty ptr if dead
    bool expired() const;
    T* raw() const;                                         // unchecked access (TODO: hide)
};
}
```

## Usage
Long-lived observers of engine objects keep `rbx::intrusive_weak_ptr<T>` and promote with `.lock()` right before use.

## Gotchas
- `raw()` hands out the pointer without keeping the object alive — strictly a peek; anything dereferenced from it must be revalidated through `lock()`/`expired()`.
- Copy-constructor drops the reference silently if source is expired (leaves itself null) rather than preserving a dangling raw.
- Assignment from another weak ptr calls `reset(rhs.raw())` — there is a benign TOCTOU window where rhs may expire between `raw()` and `add_weak_ref` unless callers guarantee lifetime externally.
- Not thread-safe against its own instance (like standard smart pointers); safe only for cross-thread transfer of the value.
