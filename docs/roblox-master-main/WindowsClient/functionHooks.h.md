# WindowsClient/functionHooks.h

## Purpose

Declares the generic Microsoft "hot-patch" hooking primitives used by robloxHooks.cpp: patch a Win32 API at its prolog trampoline and restore it. No Roblox policy here — pure byte mechanics.

## API

Real declarations:

```cpp
namespace RBX {
    void* hotpatchHook(void* origFunction, void* hookFunction);  // Returns the new entry point
    void* hotpatchUnhook(void* pfn);
    bool hookingApiHooked();
}
```

- `hotpatchHook` returns the address to call for original behavior (entry + 2), or 0 on any failure.
- `hotpatchUnhook` takes that same returned pointer.
- See functionHooks.cpp.md for semantics.

## Gotchas

- x86-only design (rel32 jumps, 2-byte prolog NOP).
