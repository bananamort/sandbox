# util/Debug.cpp

## Purpose
Implements the crash primitives from rbx/Debug.h: `ReleaseAssert(channel, msg)` (routes channel 255 = CRASHONASSERT to RBXCRASH, otherwise FastLog) and `RBX::Debugable::doCrash()`/`doCrash(msg)` (DebugBreak when `doCrashEnabled`).

## API
```cpp
const int CRASHONASSERT = 255;                       // magic channel
void ReleaseAssert(int channel, const char* msg);
volatile bool RBX::Debugable::doCrashEnabled = true; // "overload this in the debugger to pass by the crash"
void Debugable::doCrash();      // DebugBreak() if enabled
void Debugable::doCrash(const char* message);        // Durango: OutputDebugStringA + early-out w/o debugger
```
Only the `doCrash(const char*)` overload sits inside `#pragma optimize("", off/on)`; the parameterless `doCrash()` precedes the pragma and compiles normally.

## Usage
RBXCRASH() (RbxCrash.cpp) delegates here; RBX_LOG_ASSERT's failure path calls ReleaseAssert with FLog::Asserts.

## Gotchas
- On Durango, doCrash(message) does NOT break when no debugger is attached — asserts silently pass.
- DebugBreak is int3 on i386, plain abort() elsewhere (per Debug.h shim), so "passing by" a crash in gdb/lldb isn't possible off-Windows: abort kills the process.
- Channel 255 is reserved — passing arbitrary user channels near 255 risks accidental crashes.
