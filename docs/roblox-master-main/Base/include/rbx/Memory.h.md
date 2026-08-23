# rbx/Memory.h

## Purpose
Roblox's allocation layer for STL/boost collections: `RBX::roblox_allocator` (static malloc/free/realloc facade), `RBX::Allocator<T>` (per-type custom `operator new/delete` optionally backed by `boost::singleton_pool`, with pool bookkeeping registries), and `RBX::AutoMemPool` (a boost::pool wrapper whose objects remember their owning pool). Compile-time knobs: `RBX_ALLOCATOR_COUNTS` + `RBX_POOL_ALLOCATION_STATS` (debug only), `RBX_ALLOCATOR_SINGLETON_POOL` (release only), `RBX_MEMORY_SCALABLE_MALLOC` (off).

## API
```cpp
namespace RBX {
typedef bool (*releaseFunc)();
extern std::vector<size_t*> poolAvailabilityList;      // live in Memory.cpp
extern std::vector<releaseFunc> poolReleaseMemoryFuncList;
extern std::vector<size_t*> poolAllocationList;        // stats builds only
inline void addToPool(size_t* allocatedSize, size_t* availableSize, size_t size);
inline void removeFromPool(size_t* availableSize, size_t size);

class roblox_allocator {
    static bool crashOnAllocationFailure;
    typedef std::size_t size_type; typedef std::ptrdiff_t difference_type;
    static char* malloc(const size_type bytes);
    static void free(char* const block);
    static char* realloc(char* ptr, size_t nsize);
};

template<class T> class Allocator {           // custom new/delete; singleton_pool in release
    static rbx::atomic<int> count;            // RBX_ALLOCATOR_COUNTS
    static size_t allocatedSize, availableSize; static bool initialized;
    void* operator new(size_t nSize);         // asserts nSize==sizeof(T); bad_alloc/RBXCRASH on fail
    void* operator new(size_t, void* p);      // placement
    static bool releaseMemory(); static bool purgeMemory();
#ifdef RBX_ALLOCATOR_COUNTS
    static long getCount(); static long getHeapSize();
#endif
};

class AutoMemPool {
    class Object { /* new(size, AutoMemPool*) hides a back-pointer to the pool */ };
    explicit AutoMemPool(int requested_size);
    void* malloc(); void free(void* p); int getRequestedSize();
};
}
```

## Usage
Collections/objects that need per-type heap accounting derive or parametrize on `Allocator<T>`; `poolAvailabilityList`/`poolReleaseMemoryFuncList` let memory-pressure code walk every instantiated allocator type and ask it to return pooled chunks (`releaseMemory`). `AutoMemPool::Object` subclasses allocate via `new (pool) Obj(...)` and can be deleted through the plain global delete because the pool pointer is stashed in an extra leading word.

## Gotchas
- Release builds use `boost::singleton_pool<T, sizeof(T)>`; that pool is NOT thread-safe by default — any multithreaded use of an Allocator<T> type needs external synchronization.
- `crashOnAllocationFailure` defaults to true (Memory.cpp): OOM is a deliberate "nice fat crash" via `RBXCRASH()` before `std::bad_alloc` would be thrown.
- `operator new` asserts exact-size allocation (`nSize==sizeof(T)`): deriving from an `Allocator<T>` class and allocating the derived size will assert/fail.
- `Allocator<T>::initialized` lazy-registration is not thread-safe (first construction of T must precede concurrent constructions elsewhere).
- `purge_memory` on a singleton pool invalidates ALL outstanding allocations of that type — inline comment: "Be very careful".
