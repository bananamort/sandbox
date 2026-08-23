# RbxBase.h

## Purpose
Smallest common denominator header: includes `<stdint.h>` and enforces two MSVC build invariants — under `_DEBUG`, warning C4702 (unreachable code) is promoted to error to catch some "really nasty bugs"; in release, `_SECURE_SCL` must be 0 or compilation fails (STL checked-iterators off for speed).

## API
No functions; preprocessor policy only (`#pragma warning(error: 4702)` under _DEBUG; `#error` if `_SECURE_SCL != 0` in non-debug).

## Usage
Included at the top of nearly every other Base header (`RbxFormat.h`, `RbxPlatform.h`, `RbxAssert.h`) and transitively by the whole engine.

## Gotchas
- `_SECURE_SCL` is an old MSVC macro (pre-/d1STL); on modern toolchains the check is inert but harmless. Any new build config targeting release MUST still define `_SECURE_SCL=0` to pass this guard.
