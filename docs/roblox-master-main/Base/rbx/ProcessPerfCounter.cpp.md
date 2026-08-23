# ProcessPerfCounter.cpp

## Purpose
Implements the PDH wrappers: CProcessPerfCounter::init enumerates all "Process" PDH instances (PdhEnumObjectItems into a 100 KB buffer), matches one whose "ID Process" counter equals the target pid, then adds counters for % Processor Time, Elapsed Time, Private Bytes, Page Faults/sec, Page File Bytes, Virtual Bytes, Working Set - Private (fallback: Working Set), plus machine-wide "\Processor(_Total)\% Processor Time".

## API
Per ProcessPerfCounter.h. Non-Windows builds compile the #warning "MACPORT" stubs (functions with no bodies' contents — the #warning path leaves methods EMPTY).

## Usage
CProcessPerfCounter is a ScopedSingleton — fetch via ScopedSingleton accessors; CollectData() must be called before reading formatted values (PDH two-sample requirement for rate counters like % Processor Time and Page Faults/sec).

## Gotchas
- init() writes `RBX::RbxDbgInfo::s_instance.NumCores` — a global debug-info side effect from a stats constructor.
- Instance matching breaks at the FIRST instance whose ID equals pid but never records WHICH instance index matched for later PdhMakeCounterPath calls... actually it reuses `instanceName` pointer position — if pid is not found, instanceName points one past the last entry (empty string) and subsequent counter paths silently bind to a malformed instance.
- PdhAddCounter results are RBXASSERTed only — release builds continue with dead counters on failure.
- The whole file body sits inside `#ifdef _WIN32` EXCEPT it also declares non-Windows ctor stubs via #warning — compiling on Mac spews warnings and links empty methods.
- 100000-TCHAR stack-adjacent heap buffer + manual MULTI_SZ walk (`instanceName += strlen+1`) — classic fragile PDH enumeration.
