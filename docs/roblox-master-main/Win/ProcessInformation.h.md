# ProcessInformation.h

Source: `roblox-sandbox/Win/ProcessInformation.h` (36 lines)

## Purpose

Header-only RAII wrapper `CProcessInformation` around the Win32 `PROCESS_INFORMATION` struct returned by CreateProcess: implicit conversion operators let it be passed where `PROCESS_INFORMATION&`/`*` are expected, and the destructor closes both handles so spawned-process handles never leak.

## API

```cpp
class CProcessInformation {
public:
    PROCESS_INFORMATION pi;
    CProcessInformation();                       // zeroes hThread/hProcess
    operator PROCESS_INFORMATION&();
    operator PROCESS_INFORMATION*();
    ~CProcessInformation();                      // CloseProcess()
    DWORD WaitForSingleObject(DWORD timeout);    // ::WaitForSingleObject(pi.hProcess, timeout)
    bool GetExitCode(DWORD& exitCode) const;     // ::GetExitCodeProcess
    void CloseProcess();                         // CloseHandle thread+process if InUse()
    bool InUse();
};
```

## Usage

Used by launcher-style code that spawns the game client or helpers and waits for exit — verified: the only includers in this tree are `Win/SharedLauncher.h` and `Win/SharedLauncher.cpp` (the shared bootstrapper that launches/relaunches the client). Typical call shape is `CreateProcess(..., static_cast<PROCESS_INFORMATION*>(&cpi))` then `WaitForSingleObject(INFINITE)` + `GetExitCode`.

## Gotchas

- No copy protection: copying a CProcessInformation duplicates raw HANDLE values → double CloseHandle on destruction. Must be passed/held by reference or pointer.
- `GetExitCode` returns false only on API failure; STILL_ACTIVE (259) is indistinguishable from a real exit code 259 through this interface.
- Zero-init covers only hThread/hProcess; dwProcessId/dwThreadId left uninitialized until a successful CreateProcess fills them.
