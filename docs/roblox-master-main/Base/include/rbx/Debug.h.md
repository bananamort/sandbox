# rbx/Debug.h

## Purpose
The engine's assertion system. Defines the five-tier assert macro family (`RBXASSERT`, `RBXASSERT_VERY_FAST`, `RBXASSERT_SLOW`, `RBXASSERT_IF_VALIDATING`, `RBXASSERT_FISHING`) with an in-file activation matrix per build flavor (Debug/NoOpt/ReleaseAssert/Release), the `RBXCRASH()` entry points, `ReleaseAssert(channel,msg)`, `LEGACY_ASSERT` opt-in re-enable, `rbx_static_cast` (static_cast guarded by slow dynamic_cast assert), `RBX::Debugable` (doCrash + badMemory poison pointer 0x00000003), and portability shims (`__noop`, `DebugBreak()` via int3/abort on non-Windows).

## API
```cpp
void RBXCRASH(); void RBXCRASH(const char* message);
void ReleaseAssert(int channel, const char* msg);
namespace RBX { class Debugable {
    static volatile bool doCrashEnabled;
    static void doCrash(); static void doCrash(const char*);
    static void* badMemory(); // 0x00000003 sentinel for freed-object detection
};}
template<class T, class U> T rbx_static_cast(U u); // RBXASSERT_SLOW(dynamic_cast==) + static_cast

#define STRINGIFY/TOSTRING
#define RBX_UNUSED(x) (void)(sizeof((x),0))
#define RBX_CRASH_ASSERT(expr)   // hook or doCrash
#define RBX_LOG_ASSERT(expr)     // fastlog-only, fires ReleaseAssert into crash log channel FLog::Asserts
#define LEGACY_ASSERT(expr)      // no-op unless FIRE_LEGACY_ASSERT defined
// tiers: RBXASSERT / _VERY_FAST / _SLOW / _IF_VALIDATING / _FISHING; RBXASSERT_NOT_RELEASE()
```
Build matrix (from header macros): `_DEBUG` defines `__RBX_VERY_FAST_ASSERT`, `__RBX_VALIDATE_ASSERT`, `__RBX_NOT_RELEASE`; `_NOOPT` additionally defines `__RBX_CRASH_ON_ASSERT`; Release leaves RBXASSERT mapped to RBX_LOG_ASSERT while the auxiliary tiers become no-ops. Note `__RBX_SLOW_ASSERT` and `__RBX_FISHING_ASSERT` are left commented out (`// TODO: Hire a physics guy to enable them`), contradicting the header's own overview table which claims SLOW always runs in debug.

## Usage
`RBXASSERT(cond)` everywhere in engine code; `RBXASSERT_VERY_FAST` for inner-loop invariants; `RBXCRASH("reason")` as deliberate fatal-error primitive (used by allocators, concurrency catchers, task scheduler).

## Gotchas
- In RELEASE builds RBXASSERT becomes RBX_LOG_ASSERT: it still evaluates the expression and can call ReleaseAssert — asserts are not free at release; keep them cheap.
- iOS debug maps RBXASSERT to LOG variant because "iOS has no way to step over asserts".
- Windows debug path routes through `_ASSERTE` after trying `_debugHook`.
- `__RBX_CRASH_ON_ASSERT` (NoOpt) turns every assert into a hard crash via RBX_CRASH_ASSERT.
- rbx_static_cast's guard uses dynamic_cast — requires polymorphic U. Because `__RBX_SLOW_ASSERT` is disabled, this guard is currently a no-op in ALL builds, so `rbx_static_cast` behaves exactly like `static_cast`.
- Header undefs min/max on Win32 and includes FastLog (LOGGROUP(Asserts)).
