# rbx/CEvent.cpp

## Purpose
Implementation of `RBX::CEvent` (see CEvent.h.md). Two complete backends selected by `RBX_CEVENT_BOOST`: boost condvar emulation off-Windows, raw Win32 event handles on Windows.

## API
Implements: ctor/dtor, `Set()`, `Wait()`, `Wait(int)`, static `WaitForSingleObject`. Non-Windows defines ODR storage for `cWAIT_OBJECT_0/cWAIT_TIMEOUT/cINFINITE`.

## Usage
See header doc.

## Gotchas
- Win32 failure path throws `RBX::runtime_error("HRESULT = 0x%.8X", hr)` from local helper `RbxThrowLastWin32()` — one of the few Base spots where OS API errors surface as engine exceptions.
- Boost backend's timed wait uses `boost::get_system_time()` (wall clock, not steady).
- `Set()` is declared `throw()` but the Win32 branch can call RbxThrowLastWin32 — an exception escaping a throw() function terminates the process.
- Auto-reset consumption happens inside WaitForSingleObject under the boost path (`isSet=false` after successful wait), matching Win32 auto-reset semantics.
