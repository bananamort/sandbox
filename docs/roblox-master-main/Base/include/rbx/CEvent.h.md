# rbx/CEvent.h / CEvent.cpp

## Purpose
Cross-platform Win32-event analogue `RBX::CEvent` (modeled on ATL::CEvent per in-file TODO). Windows uses a raw HANDLE from CreateEvent; non-Windows (RBX_CEVENT_BOOST) reimplements manual/auto-reset semantics with boost mutex + condition_variable + volatile bool.

## API (CEvent.h)
```cpp
class CEvent : public boost::noncopyable {
    CEvent(bool bManualReset);
    ~CEvent() throw();
    void Set() throw();
    void Wait();                                   // infinite
    bool Wait(int milliseconds);                   // true == signalled (marked TODO: Deprecate)
    bool Wait(RBX::Time::Interval interval);       // delegates to int overload
private:
    static const int cWAIT_OBJECT_0 = 0, cWAIT_TIMEOUT = 258, cINFINITE = 0xFFFFFFFF;
    static int WaitForSingleObject(CEvent& event, int milliseconds);
};
```
CEvent.cpp implements both backends; the Win32 branch throws `RBX::runtime_error("HRESULT = 0x%.8X", hr)` via local helper `RbxThrowLastWin32()` on any API failure.

## Usage
Thread hand-off signaling where a condition variable would be overkill; task scheduler wake paths on some platforms.

## Gotchas
- Auto-reset mode: Set() with a waiter wakes exactly one; without waiters the flag stays set until next Wait consumes it (matches Win32).
- Boost-backend timed Wait converts to wall-clock `boost::get_system_time()` — sensitive to system clock changes, unlike steady-clock waits elsewhere.
- In-file TODO: should be split into Manual/Automatic classes; `Wait(int)` deprecated.
- The three `static const int` constants are only ODR-defined out-of-line on non-Windows (CEvent.cpp lines 5–9); Windows relies on in-class initializers — linking patterns differ per platform.
