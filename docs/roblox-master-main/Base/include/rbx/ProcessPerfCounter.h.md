# ProcessPerfCounter.h

## Purpose
Declares Windows PDH (Performance Data Helper) wrappers: CQuery (RAII HQUERY), PerfCounter (base with collect/format helpers), and CProcessPerfCounter — a ScopedSingleton that resolves a PID to a "Process" counter instance and exposes CPU time, memory, and page-fault counters. Win32 desktop only (excluded on Durango; whole header is empty elsewhere).

## API
```cpp
class CQuery { CQuery(HQUERY); CQuery(); HQUERY* operator&(); operator HQUERY() const; ~CQuery(); }; // PdhCloseQuery in dtor
class PerfCounter {
protected: PerfCounter(); CQuery hQuery;
    static void GetData2(HCOUNTER, long&); static void GetData2(HCOUNTER, double&);
public: void CollectData();
};
class CProcessPerfCounter : public PerfCounter, public RBX::ScopedSingleton<CProcessPerfCounter> {
    CProcessPerfCounter();            // current process
    CProcessPerfCounter(int pid);
    double GetProcessCores();         // totalCPU% * procCPU% * cores / 10000
    double GetElapsedTime();
    long GetTotalProcessorTime/GetProcessorTime/GetPrivateBytes/GetPageFaultsPerSecond/
         GetPageFileBytes/GetVirtualBytes/GetPrivateWorkingSetBytes();
};
```

## Usage
Used by diagnostics/stats reporting to log process resource usage (pairs with RbxDbgInfo — init() writes s_instance.NumCores). Requires pdh.lib.

## Gotchas
- Both base classes are inherited PUBLICLY; the getters still qualify calls as `PerfCounter::GetData2(...)` explicitly (unambiguous qualification, not a private-inheritance workaround).
- GetProcessCores multiplies two percentages then by core count — an approximation of "core-equivalents", not a real measurement.
- "Working Set - Private" falls back to "Working Set" on WinXP (see .cpp) — values differ in meaning on the fallback path.
