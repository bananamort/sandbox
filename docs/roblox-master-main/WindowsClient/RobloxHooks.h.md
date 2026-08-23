# WindowsClient/RobloxHooks.h

## Purpose

Public surface of the client's anti-tamper hook layer: API patching (`hookApi`/`unhookApi`) and the ntdll KiUserExceptionDispatcher call-site patch (`hookPreVeh`) that routes exception dispatch through a naked stub. Companion to functionHooks.h (generic hot-patch primitives) — RobloxHooks.h declares only the Roblox-specific policy.

## API

Real declarations:

```cpp
namespace RBX {
    typedef BOOLEAN (NTAPI *RtlDispatchExceptionPfn)(PEXCEPTION_RECORD exRec, PCONTEXT ctx);
    // extern RtlDispatchExceptionPfn vehHookContinue; // moved to App because this needs to be checked.
    extern DWORD* vehHookLocation;
    BOOLEAN RtlDispatchExceptionHook(PEXCEPTION_RECORD exRec, PCONTEXT ctx);
    void hookApi();
    void unhookApi();
    bool hookPreVeh();
}
```

- `vehHookLocation` — after a successful `hookPreVeh()`, points at the 4-byte rel32 operand of the `call RtlDispatchException` instruction inside ntdll's `KiUserExceptionDispatcher`.
- The commented-out typedef for `vehHookContinue` documents a relocation: the variable now lives in App/util/Win/CheatEngine.cpp (declared `void*` in App/include/util/CheatEngine.h:101), typed as raw pointer rather than `RtlDispatchExceptionPfn`.

## Usage

Called from `Application::Initialize` (Application.cpp:646) under `#if !defined(RBX_STUDIO_BUILD)`: `hookApi()` then `RBX::vehHookLocationHv/vehStubLocationHv` are recorded (uintptr_t of the patch site and stub address, consumed elsewhere for verification) and `setupCeLogWatcher()`. See robloxHooks.cpp.md.

## Gotchas

- `RtlDispatchExceptionPfn` is declared but unused in this snapshot (the one place it would be used was moved to App).
- Everything here is x86-only (naked asm, DWORD pointer arithmetic) — no x64 port exists in this tree.
