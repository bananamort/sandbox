# App/script/LuaMemory.cpp

## Purpose

Implements `LuaAllocator`, the custom `lua_newstate` allocator used by every Roblox VM: it tracks heap size/count/high-water marks (surfaced through GetHeapStats), optionally serves small allocations from boost::pools sized to multiples of 4 bytes over `sizeof(Udata)`, enforces a heap limit that applies ONLY to game-script identities, and feeds the "memory/lua/heap" profiler counter.

## API

- Constants: `#define MEM_POOL_INCREMENT 4`, `#define MAX_NUM_MEM_POOLS 16`; `LOGGROUP(LuaMemoryPool)`; `FASTINTVARIABLE(LuaMemoryBonus, 0)`.
- `static int getMemPoolIndex(int size)` — only sizes that are multiples of 4 AND yield index `(size - sizeof(Udata))/4 - 1` in [0,16) map to a pool; anything else yields a non-pool result (the guard only tests `index < MAX_NUM_MEM_POOLS`, so sub-`sizeof(Udata)` sizes can produce values below -1 — callers therefore test `index > -1`).
- `static size_t LuaAllocator::heapLimit` — process-wide static limit (0 = unlimited); set elsewhere (header/consumers outside this file).
- `LuaAllocator::LuaAllocator(bool usePool)` — when pooled, creates 16 `boost::pool<>` of sizes `sizeof(Udata) + i*4`.
- `~LuaAllocator()` — deletes pools.
- `void clearHeapMax()`, `void getHeapStats(size_t& heapSize, size_t& heapCount) const`, `void getHeapStats(size_t&, size_t&, size_t& maxHeapSize, size_t& maxHeapCount) const`.
- `static void* LuaAllocator::alloc(void *ud, void *ptr, size_t osize, size_t nsize)` — the lua_newstate realloc shim; casts ud to allocator and delegates.
- `bool LuaAllocator::hasSpace(const long diff)` — refuses growth (`return false`) when `heapLimit > 0 && diff > 0 && diff + heapSize > heapLimit` AND the current identity is `GameScript_` or `RobloxGameScript_`; returning NULL from alloc makes Lua raise "not enough memory".
- `void* LuaAllocator::alloc(void*, size_t osize, size_t nsize)` — pool-aware realloc: frees into the matching pool on nsize==0; allocates from pool + memcpy when both old/new fit pools or only old did (pool→malloc, malloc→realloc transitions handled explicitly with min(nsize,osize) copies); plain realloc otherwise. Non-pooled mode: `realloc(ptr, nsize + FInt::LuaMemoryBonus)` — note bonus applied to non-pool allocations only. Then bookkeeping: `heapSize += diff`, heapCount in/decremented at osize/nsize==0 boundaries, maxima updated, `RBXPROFILER_COUNTER_ADD("memory/lua/heap", diff)`.

## Usage

Instantiated once per ScriptContext (`allocator.reset(new RBX::LuaAllocator(FLog::UseLuaMemoryPool != 0))` in openState), passed as `lua_newstate(LuaAllocator::alloc, allocator.get())`; stats read by `ScriptContext::getHeapStats`/closeStates leak check; hasSpace is evaluated inside every Lua allocation, so identity of the currently running script determines whether an allocation fails.

## Gotchas

- The memory limit discriminates by security identity at allocation time: GameScript_/RobloxGameScript_ hit the ceiling while Plugin/Studio/LocalUser identities allocate freely even past heapLimit — a sandbox-escape-relevant asymmetry.
- Pool eligibility depends on sizeof(Udata): pool sizes shift if the VM's Udata layout changes (e.g., under a Luau graft where userdata headers differ), silently changing which sizes are pooled.
- FInt::LuaMemoryBonus inflates ONLY non-pooled reallocations; pooled paths ignore it.
- getMemPoolIndex returns -1 for oversizes rather than clamping; the assert-balanced RBXASSERTs verify requested size matches pool granularity in debug.
- heap accounting counts bytes requested by Lua, not pool slack — GetHeapStats numbers will diverge from actual RSS when pooling is on.
