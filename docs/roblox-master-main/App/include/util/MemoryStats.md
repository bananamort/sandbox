# util/MemoryStats.h

## Purpose
Namespace of utility functions for determining used/free/total system memory, memory-pool introspection, and a coarse "memory pressure level" classification used to trigger cleanup behavior.

## Declared API
```cpp
namespace RBX::MemoryStats {

enum MemoryLevel {
    MEMORYLEVEL_ALL_CRITICAL_LOW,
    MEMORYLEVEL_ONLY_PHYSICAL_CRITICAL_LOW,
    MEMORYLEVEL_ALL_LOW,
    MEMORYLEVEL_ONLY_PHYSICAL_LOW,
    MEMORYLEVEL_LIMITED,
    MEMORYLEVEL_OK
};

typedef boost::uint64_t memsize_t;

memsize_t usedMemoryBytes();
memsize_t freeMemoryBytes();
memsize_t totalMemoryBytes();

size_t slowGetMemoryPoolAllocation();     // pool stats (SLOW paths)
size_t slowGetMemoryPoolAvailability();
void releaseAllPoolMemory();
MemoryLevel slowCheckMemoryLevel(memsize_t extraMemoryUsed);

}
```

## Gotchas
- Functions prefixed `slow` are documented by convention as expensive — do not call per-frame; presumably they query OS APIs or walk pools.
- `slowCheckMemoryLevel(extraMemoryUsed)` classifies hypothetical post-allocation pressure; enum ordering suggests severity ranking but the numeric order in the enum runs critical-low → OK.
- "ALL" vs "ONLY_PHYSICAL" levels distinguish total (incl. swap/pagefile) vs physical RAM pressure.

## UNKNOWN
- Platform implementations and exact thresholds for each level (.cpp outside App/include).
