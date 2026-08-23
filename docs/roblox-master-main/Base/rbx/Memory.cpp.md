# rbx/Memory.cpp

## Purpose
Implements `RBX::roblox_allocator` and defines the global pool bookkeeping lists. Also contains the complete set of *global* `operator new/delete` overrides used only when `RBX_MEMORY_SCALABLE_MALLOC` is defined (currently off) routing all process allocations to TBB's scalable_malloc.

## API
```cpp
bool RBX::roblox_allocator::crashOnAllocationFailure = true;
std::vector<size_t*> RBX::poolAvailabilityList;
std::vector<releaseFunc> RBX::poolReleaseMemoryFuncList;
std::vector<size_t*> RBX::poolAllocationList;

char* roblox_allocator::malloc(const size_type size);   // std::malloc(size>0?size:1); RBXCRASH() on NULL when crashOnAllocationFailure
void  roblox_allocator::free(char* const block);
char* roblox_allocator::realloc(char* ptr, size_t nsize);
// RBX_MEMORY_SCALABLE_MALLOC only:
void* operator new(size_t); void* operator new[](size_t);
void* operator new(size_t, const std::nothrow_t&) throw();
void* operator new[](size_t, const std::nothrow_t&) throw();
void operator delete(void*) throw(); ... // matching deletes -> scalable_free
```

## Usage
Included once per binary; the file defines `_WINSOCKAPI_` before including rbx/Memory.h specifically so that windows.h (pulled later via boost.hpp etc.) does not drag winsock.h first and cause redefinition errors with winsock2.h.

## Gotchas
- The malloc path deliberately maps `0`-byte requests to `1` byte.
- Global new/delete overrides are compiled out unless `RBX_MEMORY_SCALABLE_MALLOC` is defined — today the engine runs on plain `std::malloc`.
- Comment documents why no `std::new_handler`: cannot be done portably and thread-safely.
