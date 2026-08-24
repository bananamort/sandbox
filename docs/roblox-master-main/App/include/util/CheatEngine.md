# util/CheatEngine.h

## Purpose
Windows-only anti-cheat toolkit: Cheat Engine / Sandboxie / speedhack / DBVM / DLL-injection detection plus hardware-breakpoint (VEH) write-watch helpers. Declares globals consumed by the kick/reporting pipeline.

## Declared API
```cpp
bool vmProtectedDetectCheatEngineIcon();

class HwndScanner {   // window-title based detection
    struct fullWindowInfo { DWORD winWidth, winHeight, pid, active; std::string title; bool kickEarly;
                            static size_t compareByPid(fullWindowInfo lhs, fullWindowInfo rhs); };
    std::vector<fullWindowInfo> hwndScanResults;
    static BOOL CALLBACK makeHwndVector(HWND hwnd, LPARAM lParam);
public:
    HwndScanner();
    int scan();
    bool detectTitle() const;
    bool detectFakeAttach() const;  // always false on Windows 8
    bool detectEarlyKick() const;
};

class FileScanner {   // temp-folder log-update detection
public:
    FileScanner();                  // captures baseTime + tempFolder
    bool detectLogUpdate() const;
};

extern bool ceDetected;
extern bool ceHwndChecks;
static const unsigned int kCeStructKey = 0x23A7F;
static const unsigned char kCeCharKey  = 0x55;

HANDLE setupCeLogWatcher();

class VerifyConnectionJob : public RBX::TaskScheduler::Job {  // profiles/enables this detection
public:
    VerifyConnectionJob();
    /*override*/ RBX::Time::Interval sleepTime(const Stats& stats);
    /*override*/ Job::Error error(const Stats& stats);
    /*override*/ TaskScheduler::StepResult step(const Stats& stats);
    /*override*/ double getPriorityFactor();
};

bool isSandboxie();
bool isCeBadDll();

// dbvm detection + breaks certain dll injection methods
class DbvmCanary {
private:
    HANDLE canaryCage, canaryHandle;
    CONTEXT ctx;
    size_t hashValue;
    static void canary(HANDLE* mutex);
    size_t hashDbgRegs(CONTEXT& ctx);   // mixes Dr0..Dr3
public:
    DbvmCanary();
    void checkAndLocalUpdate();
    void kernelUpdate();
};

class SpeedhackDetect {
private:
    DWORD k32base, k32size;   // kernel32 module bounds
public:
    SpeedhackDetect();
    bool isSpeedhack();
};

extern HeapValue<uintptr_t> vehHookLocationHv;   // HeapValue-obscured VEH hook addresses
extern HeapValue<uintptr_t> vehStubLocationHv;
extern void* vehHookContinue;

void addWriteBreakpoint(uintptr_t addr);
void removeWriteBreakpoint(uintptr_t addr);
__declspec(align(4096)) extern int writecopyTrap[4096];   // page-aligned trap buffer
```

## Gotchas
- Entirely Windows: `HWND`, `DWORD`, `HANDLE`, `CONTEXT` (Dr0–Dr3 debug registers), `__declspec(align(4096))` — will not compile on other platforms.
- Detection state is exported as mutable globals (`ceDetected`, `ceHwndChecks`) — thread-safety is the caller's problem (UNKNOWN locking).
- `detectFakeAttach()` is documented to **always return false on Windows 8**.
- `hashDbgRegs` arithmetic has no parentheses discipline (`a*k + b*j ^ c*m - d*n`) — precedence makes XOR lowest; presumably intentional obfuscation.
- VEH hook locations are stored in `HeapValue` wrappers to resist memory scanning (see HeapValue.md).
- `writecopyTrap` is a 16 KB page-aligned array used with write breakpoints — do not relocate or copy.

## UNKNOWN
- Which of these detectors are actually wired into shipped builds (feature-flagged via VerifyConnectionJob profiling).
