# util/NamedMutex.h

## Purpose
Windows-only RAII wrapper over a Win32 named mutex (`CreateMutex`/cross-process synchronization). Constructor acquires, destructor releases.

## Declared API
```cpp
#ifdef _WIN32
namespace RBX {
class ScopedNamedMutex {
public:
    ScopedNamedMutex(const char* name);   // creates/opens + acquires the named mutex
    ~ScopedNamedMutex();                  // releases handle
private:
    HANDLE hMutex;
};
}
#endif
```

## Gotchas
- Compiles to nothing on non-Windows (`#ifdef _WIN32`) — cross-platform code must not depend on its existence.
- RAII acquisition: hold as a local; holding across threads requires external coordination.
- Wait behavior on contention (INFINITE vs timeout) and error handling if creation fails are .cpp-side (UNKNOWN).
- Typical use: single-instance guards / shared cache file locking between processes.

## UNKNOWN
- Exact wait semantics and which names are used by callers.
