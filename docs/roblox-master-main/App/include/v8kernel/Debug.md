# App/include/v8kernel/Debug.h

## Purpose

Engine-local assertion gate. Wraps `RBXASSERT` in `RBX_ENGINE_ASSERT`, which is a no-op unless `RBX_DEBUGENGINE` is defined.

## Declared API

- Includes `RBX/Debug.h`.
- `#define RBX_ENGINE_ASSERT(expr)` → `RBXASSERT(expr)` when `RBX_DEBUGENGINE` defined, else `((void)0)`.
- `RBX_DEBUGENGINE` is **commented out** with the header's own rationale: "Engine assertions often cause the game to stop running. Until we can fix these, turn them off."

## Gotchas

- Every engine-side assert routed through this macro is compiled out by default — do not assume asserts fire when debugging physics.
- Note the include is `"RBX/Debug.h"` while KernelIndex.h uses lowercase `"rbx/Debug.h"` — case-insensitive filesystems accept both; keep per-file convention on case-sensitive builds.
