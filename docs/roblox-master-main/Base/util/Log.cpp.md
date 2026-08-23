# Log.cpp

## Purpose
Implements RBX::Log (header documented previously): a text log file with timestamped severity-prefixed entries, the static ILogProvider hook, memory/time human-format helpers, and definitions of Base's shared LOGVARIABLE channels (Crash, HangDetection, TaskScheduler*, Asserts, ...). initBaseLog() exists but is empty.

## API
```cpp
ILogProvider* Log::provider;                       // global sink override
static Severity aggregateWorstSeverity;
static void timeStamp(std::ofstream&, bool includeDate);  // boost local_time + Time::nowFastSec()
Log(const char* logFile, const char* name);        // opens file, writes header
~Log();                                            // "End Log"
static void setLogProvider(ILogProvider*);
void writeEntry(Severity, const wchar_t*);         // converts via wcstombs(_s)
void writeEntry(Severity, const char*);            // "HH:MM:SS.mmm (fastsec) Severity: msg\n", flush
static std::string formatMem(unsigned int bytes);  // B/KB/MB/GB with decimal units
static std::string formatTime(double time);        // %.3gs or ms below 0.1s
LOGVARIABLE(Crash,1) + HangDetection/ContentProviderCleanup/ISteppedLifetime/MutexLifetime/
    TaskScheduler/TaskSchedulerInit/TaskSchedulerRun/TaskSchedulerFindJob/TaskSchedulerSteps/
    Asserts/FWLifetime/FWUpdate/KernelStats   // channel DEFINITIONS live here
void initBaseLog();                                // empty
```

## Usage
Every subsystem writes through FLog channels defined here or locally; TaskScheduler/boost.cpp pass FLog group ids around. FLog::Init(nowFastSec) (called from Time.cpp on Windows) wires the fast clock into FastLog.

## Gotchas
- formatTime: `time==0.0` case has NO break — falls into `<0.0` check then else-if chain; for exactly 0 it prints "0s" AND continues to `%.3gs` branch? No — first snprintf executes, then the if-chain still runs: 0.0 is not <0.0, not >=0.1 → prints "%.3gms" of 0 OVERWRITING buffer... actually second snprintf overwrites the same buffer so output is "0ms" not "0s". Subtle formatting bug.
- writeEntry(wchar_t) conversion math: newsize=origsize+100 but wcstombs_s told to convert only origsize chars; convertedChars>=origsize-1 guard then force-NULs.
- formatMem's GB threshold branch is _WIN32-only because "100000000000 too big for uint" — non-Windows skips the .1fGB tier.
- Timestamps use LOCAL time + fast-clock seconds; correlating logs across machines needs timezone care.
