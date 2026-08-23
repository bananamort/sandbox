# Time.cpp

## Purpose
Implementation of RBX::Time. Per-platform tick sources (QPC on Windows, mach_absolute_time on Apple, CLOCK_MONOTONIC on Android) plus, on Win32 desktop, a multimedia-timer thread that maintains a cheap `currentSeconds` global for the Fast clock — instrumented with two anti-cheat checks: speed-hack detection (comparing timeGetTime against wall SYSTEMTIME deltas) and debugger detection via direct TEB inspection.

## API
```cpp
long long Time::getTickCount();   // QPC / mach_absolute_time / clock_gettime(CLOCK_MONOTONIC)
long long Time::getStart();       // static-init epoch
Time Time::now<Precise>();        // (tick - start) * resolution
Time Time::now<Multimedia>();     // timeGetTime()/1000 (Win); falls back to Precise elsewhere
Time Time::now<Fast>();           // Win: lazy-starts MM timer thread; returns cached currentSeconds;
                                  //      if preciseOverride <= Fast -> now<Precise>()
Time Time::now<Benchmark>();      // preciseOverride-gated Fast/Precise
Time Time::now(SampleMethod);
void  Time::Interval::sleep();    // Sleep(ms) / usleep(us), truncates to int
static void startMMTimer();       // timeBeginPeriod(1ms clamp to TIMECAPS) + timeSetEvent periodic
```
FASTINT knobs: SpeedTestPeriodMillis(1000), MaxSpeedDeltaMillis(300), SpeedCountCap(5).

## Usage
Backs rbx/rbxTime.h. FLog::Init is handed `nowFastSec` — the Fast clock becomes the logging timestamp source on Windows.

## Gotchas
- checkDbg walks fs:[0x18] → TEB linear address, loads dword at TEB+0x30 (PEB pointer), then tests bit 16 (0x00010000) of the PEB's first dword — that byte is PEB->BeingDebugged. Inline `__asm` is x86-only; body compiles out under __RBX_NOT_RELEASE and the whole function is skipped on non-Windows.
- Speed-hack detector: |multimediaDelta − wallDelta| > MaxSpeedDeltaMillis increments violations; SpeedCountCap consecutive violations latch `cheater` forever (never resets).
- interpolatedCallback self-tunes secsPerTick but silently ignores out-of-band samples (0.95–1.05 window) — suspension of the timer thread stalls the Fast clock until next correction.
- recguard atomic guards re-entrancy of MM callbacks; currentSeconds/cheater/isDebuggedValue are plain volatile doubles/bools written cross-thread — data-race-by-todays-standards, benign-by-2016-compiler.
- Windows-only machinery (#if _WIN32 && !DURANGO): Durango/Mac/Android all just alias Fast→Precise.
