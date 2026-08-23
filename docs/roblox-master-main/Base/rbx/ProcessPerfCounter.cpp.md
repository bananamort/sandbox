# ProcessPerfCounter.cpp

## Purpose
Implements the PDH wrappers: CProcessPerfCounter::init enumerates all "Process" PDH instances (PdhEnumObjectItems into a 100 KB buffer), matches one whose "ID Process" counter equals the target pid, then adds counters for % Processor Time, Elapsed Time, Private Bytes, Page Faults/sec, Page File Bytes, Virtual Bytes, Working Set - Private (fallback: Working Set), plus machine-wide "\Processor(_Total)\% Processor Time".

## API
Per ProcessPerfCounter.h. The ENTIRE implementation lives inside one outer `#ifdef _WIN32`: on other platforms this TU defines nothing (linker errors if the class is referenced), and the `#warning "MACPORT"` branches seen in the source are dead code inside the Windows build (the inner `#ifdef _WIN32` there is always true).

## Usage
CProcessPerfCounter is a ScopedSingleton — fetch via ScopedSingleton accessors; CollectData() must be called before reading formatted values (PDH two-sample requirement for rate counters like % Processor Time and Page Faults/sec).

## Gotchas
- init() writes `RBX::RbxDbgInfo::s_instance.NumCores` — a global debug-info side effect from a stats constructor.
- Instance matching breaks at the FIRST instance whose ID equals pid but never records WHICH instance index matched for later PdhMakeCounterPath calls... actually it reuses `instanceName` pointer position — if pid is not found, instanceName points one past the last entry (empty string) and subsequent counter paths silently bind to a malformed instance.
- PdhAddCounter results are RBXASSERTed only — release builds continue with dead counters on failure.
- 100000-TCHAR heap buffer + manual MULTI_SZ walk (`instanceName += strlen+1`) — classic fragile PDH enumeration.
