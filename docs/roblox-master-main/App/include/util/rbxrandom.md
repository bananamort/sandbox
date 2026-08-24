# util/rbxrandom.h

## Purpose
One-function utility header: obtains a random seed for seeding PRNGs elsewhere in the engine.

## Declared API
```cpp
namespace RBX {
    unsigned int randomSeed();
}
```

## Gotchas
- Declaration only — the seeding source (time, entropy API, etc.) is decided by the implementation TU (UNKNOWN location; not under App/include).
- Returns `unsigned int` (32 bits of entropy at most); not suitable where cryptographic randomness is required.

## UNKNOWN
- Implementation .cpp and whether it differs per platform.
