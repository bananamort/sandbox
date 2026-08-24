# util/Lcmrand.h

## Purpose
Minimal linear-congruential PRNG (the classic MSVC `rand()` constants a=214013, c=2531011), returning 15-bit values like C `rand()`. Header is missing its `#pragma once` include guard.

## Declared API
```cpp
class LcmRand {
public:
    LcmRand();                        // seed = 1337
    uint32_t value();                 // advances state; returns (seed>>16) & 0x7FFF
    void setSeed(uint32_t newSeed);
private:
    uint32_t seed;
};
```

## Gotchas
- **No include guard / #pragma once** — double inclusion redefines the class (compile error). Also includes "stdafx.h", which may not resolve outside precompiled-header builds.
- Deterministic and tiny state: default seed 1337 always yields the same sequence; not for security.
- Output range is 0..32767 (15 bits), mirroring MSVC rand().
- Global-namespace class (not in namespace RBX).

## UNKNOWN
- Call sites (2014-era; likely terrain or test code).
