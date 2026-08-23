# App/include/script/LuaMemory.h

## Purpose

Declares `RBX::Lua::LuaAllocator`, the custom allocator handed to the Lua VM (`lua_newstate`-style realloc function). It tracks heap size/count against a static limit, optionally services allocations from Boost object pools, and exposes stats used by script memory reporting.

## Declared API

- `class RBX::LuaAllocator`
  - Private state: `size_t heapSize, heapCount, maxHeapSize, maxHeapCount;` `std::vector<boost::pool<>* > memPools;`
  - `LuaAllocator(bool usePool = false);`
  - `~LuaAllocator();`
  - `static size_t heapLimit;` — "maximum heap size allowed. 0 == no limit" (static, so shared across VMs).
  - `void clearHeapMax();`
  - `void getHeapStats(size_t& heapSize, size_t& heapCount, size_t& maxHeapSize, size_t& maxHeapCount) const;`
  - `void getHeapStats(size_t& heapSize, size_t& heapCount) const;` (two-arg overload)
  - `bool hasSpace(const long diff);`
  - `virtual void* alloc(void* ptr, size_t osize, size_t nsize);` — instance-level realloc entry point.
  - `static void* alloc(void* ud, void* ptr, size_t osize, size_t nsize);` — lua_State-facing shim; `ud` must be the LuaAllocator instance.

## Usage notes

- Includes `Util/Memory.h`, `boost/pool/object_pool.hpp`, and `boost/iostreams/filter/gzip.hpp` (the gzip include is for other translation-unit users of this header, not the allocator itself).
- Paired implementation documented under certified App/script module.

## Gotchas

- `hasSpace` takes `long` (signed) while sizes are `size_t` — negative diffs are how frees shrink accounting.
- The two overloads of `getHeapStats` differ only in parameter count; calling with fewer than four out-params leaves max stats unqueried.
- `alloc(void*)` is virtual but `alloc(static)` is not dispatching virtually through Lua's userdata — the static form casts `ud` directly to `LuaAllocator*`.
