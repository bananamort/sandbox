# RbxStringTable.cpp

**Source**: `App/util/RbxStringTable.cpp` (27 lines).

## Purpose
A tiny obfuscated string pool: internal strings (mostly Studio/script-execution messages and paths) stored in one static array indexed by enum-like ids.

## API
```cpp
const char* getStringById(int id);
```

## Usage
Table entries include `"loadfile('%s/game/studio.ashx')()"`, `"Studio.ashx"`, `"Execute script in new thread, name: %s, identity: %u"`, `"Unable to create trusted sandbox thread"`, `"rocky"`, game-pass Lua warning text, `"fonts/LoadingScript.lua"` etc. Callers pass ids from the matching header (`RbxStringTable.h`).

## Gotchas
- `getStringById` does `volatile int realId = id+1; realId -= 1;` — an anti-optimizer trick so the +1/-1 isn't folded (defeats naive binary string searches); no bounds checking whatsoever: any out-of-range id reads out of bounds.
- Strings are plain ASCII literals compiled into the binary; treat ids as ABI-stable.
