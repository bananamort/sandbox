# CheckDbg.h

Source: `roblox-sandbox/Win/CheckDbg.h` (5 lines)

## Purpose

Declares the three anti-debug entry points (`isDbg1/2/3`), each marked `__declspec(noinline)` to keep the check a call target that can't be folded into its caller — baseline anti-tamper surface of the Win32 platform layer. NOTE: this is the pristine 2016 baseline exactly as shipped; per campaign plan this file is slated for removal/modification once docs are certified, so treat this document as the record of what exists today.

## API

```cpp
__declspec(noinline) bool isDbg1();
__declspec(noinline) bool isDbg2();
__declspec(noinline) bool isDbg3();
```

## Usage

Implemented in the sibling CheckDbg.cpp via inline-asm TEB walks (see that doc). Verified by tree-wide grep: **no TU anywhere in roblox-sandbox includes CheckDbg.h or calls isDbg1/2/3** — the checks are dead code at baseline, kept as a ready-made tamper-detection primitive. Any sandbox-logger instrumentation that wants debugger detection would have to wire these calls itself.

## Gotchas

- 32-bit only by construction: `fs:[0x18]` addressing and DWORD-sized TEB pointer math have no x64 equivalent here (would need `gs:[0x30]`); the v143/x64 posture work must replace, not port, these routines.
- No export guards or obfuscation beyond noinline — trivially patchable to `return false`.
