# OperationalSecurity.h

Source: `roblox-sandbox/RCCService/OperationalSecurity.h` (9 lines)

## Purpose

Public header for the RCC-only anti-tamper module implemented in `OperationalSecurity.cpp`. Declares four process-hardening entry points in namespace `RBX`:

## API

```cpp
namespace RBX
{
    void initAntiMemDump();   // install guard-page canary VEH (see .cpp for scheme)
    void initLuaReadOnly();   // mark .lua PE section PAGE_READONLY + reflection-write VEH
    void clearLuaReadOnly();  // undo initLuaReadOnly (exit-time cleanup)
    void initHwbpVeh();       // install hardware-breakpoint (SINGLE_STEP) sentinel VEH
}
```

`#pragma once` guard; no other includes — callers must have Windows types available only via the .cpp (header itself needs nothing).

## Usage

Included by engine code that sequences the schemes at startup and by `RCCService.cpp`, which calls `RBX::clearLuaReadOnly()` as the last statement of `_tmain` (RCCService.cpp:782).

## Gotchas

- All four functions are no-ops unless their FastFlag gates are enabled (see `OperationalSecurity.cpp.md`).
- `initLuaReadOnly`/`clearLuaReadOnly` are stateful (cached `.lua` range in file-statics); calling `clear` without a prior successful `init` is safe (checks `luaBase && luaSize`).
- Called from the `CWebService` constructor (`RCCServiceSoapServiceImpl.cpp:1348–1353`): `initAntiMemDump()` behind `DFFlag::US30476`, then `initLuaReadOnly()` and `initHwbpVeh()` unconditionally.
