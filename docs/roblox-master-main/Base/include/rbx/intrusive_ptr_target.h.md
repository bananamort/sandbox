# rbx/intrusive_ptr_target.h

## Purpose
Mix-in bases making a class compatible with `boost::intrusive_ptr` (and, for the full variant, `rbx::intrusive_weak_ptr`) by embedding atomic refcounts instead of a separate control block. Provides `rbx::quick_intrusive_ptr_target<T,Count,maxRefs>` (strong refs only) and `rbx::intrusive_ptr_target<T,Count,maxStrong,maxWeak>` (strong+weak). All six `boost::intrusive_ptr_*` hook functions are specialized here.

## API
```cpp
namespace rbx {
class too_many_refs : public std::exception;   // what() == "too many refs"

template<class T, typename Count = int, Count maxRefs = 0>
class RBXBaseClass quick_intrusive_ptr_target { rbx::atomic<Count> refs; };

template<class T, typename Count = int, Count maxStrong = 0, Count maxWeak = maxStrong>
class RBXBaseClass intrusive_ptr_target {
    struct counts { rbx::atomic<Count> strong; rbx::atomic<Count> weak; }; // counts stored at head of object
    static counts* fetch(const T* t);          // reinterpret_cast((char*)t - sizeof(counts))
    void* operator new(std::size_t t);         // malloc(sizeof(counts)+t), placement-new counts, return offset ptr
    void operator delete(void* p);             // only valid if never ref'd (asserts strong==0, weak==1)
};
}
namespace boost {
template<class T,...> void intrusive_ptr_add_ref(const rbx::*target*);
template<class T,...> void intrusive_ptr_release(...);       // strong-- ; on 0: ~T(), weak--; on weak==0 free counts
template<class T,...> bool intrusive_ptr_expired(const ...);  // strong == 0
template<class T,...> bool intrusive_ptr_try_lock(const ...); // CAS loop strong->strong+1, false if 0
template<class T,...> void intrusive_ptr_add_weak_ref(...);   // weak++ (max check vs maxWeak+1)
template<class T,...> void intrusive_ptr_weak_release(...);   // weak-- ; frees counts block at 0
}
```

## Usage
Engine objects needing cheap shared ownership inherit e.g. `rbx::intrusive_ptr_target<Foo>`; clients hold `boost::intrusive_ptr<Foo>` and convert weak handles via `rbx::intrusive_weak_ptr<Foo>::lock()` (CAS-based try_lock makes weak→strong promotion race-free).

## Gotchas
- The counts block lives immediately BEFORE the object (`fetch` subtracts `sizeof(counts)`); you cannot free such objects with plain `free(p)` — release paths handle it, but raw-pointer ownership of these types is a footgun.
- `maxRefs/maxStrong/maxWeak == 0` means unlimited; enforcement of the limit throws `rbx::too_many_refs` mid-increment (count already advanced past max on failure path — the throw leaves strong temporarily > max).
- Refcount ops are non-fenced increments on `rbx::atomic<Count>`; destruction ordering relies on those atomics' semantics (see rbx/atomic.h).
- `#pragma pack(8)` around counts exists so Count=byte/short keeps objects small.
- Header includes `"rbx/declarations.h"` lowercase — fine on case-insensitive filesystems (macOS default), breaks on Linux case-sensitive checkouts.
- TODO in-file: custom allocators unsupported; make_shared.h notes shared_from_this interplay unverified.
