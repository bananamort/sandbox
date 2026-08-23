# Boost.hpp

## Purpose
Boost umbrella + portability shims for the engine: pulls the pinned boost headers (shared/scoped/weak_ptr, bind, type_traits, noncopyable...) and enforces `ROBLOX_BOOST_CONFIGS` from boost/config/user.hpp (#error if a partial boost tree was dropped in). On non-Windows it fakes two Win32 idioms (`GetCurrentThreadId`, `SwitchToThread`) and also hosts `rbx::placement_any` — a heap-free reworking of boost::any with inline storage.

## API
```cpp
using boost::shared_ptr / scoped_ptr / weak_ptr;      // global using — engine-wide convention
namespace RBX {
    template<class T> void del_fun(T* t);             // delete helper for mem_fun-style use
    bool isFinite(double value);                      // implemented in boost.cpp
    bool isFinite(int value);
}
namespace rbx {
    class placement_any<SizeType> {                   // value embedded in char data[sizeof(SizeType)]
        placement_any(); placement_any(const placement_any&);
        template<class V> explicit placement_any(const V&);   // static-asserts sizeof(V) <= sizeof(SizeType)
        ~placement_any(); swap(); operator=(const V&); operator=(const placement_any&);
        bool empty() const; const char*/char* getData();
    };
}
```

## Usage
The canonical first include for any TU touching boost smart pointers. signal.h, threadsafe.h and most of Base include it. `placement_any` is used where events/queues must carry values without allocation jitter.

## Gotchas
- Non-Windows `GetCurrentThreadId()` truncates pthread_self to unsigned — ids may collide; diagnostics only.
- placement_any never zero-initializes its data buffer; reading getData() while empty returns NULL but the buffer itself is indeterminate.
- typed_holder's private constructor is accessed via its own static singleton — a Meyers-singleton per ValueType; construction is not thread-safe pre-C++11 magic statics (relies on compiler support).
- Copy ctor assigns holder AFTER construct to give basic exception safety (comment-documented pattern).
- BOOST_STATIC_ASSERT failure message literally says "make ValueType the new SizeType" — grow SizeType when storing bigger values.
