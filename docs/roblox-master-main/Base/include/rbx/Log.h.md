# rbx/Log.h

## Purpose
Legacy per-instance file logger: `RBX::Log` wraps an `std::ofstream` named at construction, tracks worst-severity per instance and globally, and resolves the active instance through an injectable `RBX::ILogProvider` (multithreaded apps should hand out one Log per thread so `Entry` scopes don't interleave).

## API
```cpp
namespace RBX {
class RBXInterface ILogProvider { virtual Log* provideLog() = 0; };

class Log {
    enum Severity { Information=0, Warning=1, Error=2 };
    static Severity aggregateWorstSeverity;  // global worst
    Severity worstSeverity;                  // this-log worst
    static std::string formatMem(unsigned int bytes);
    static std::string formatTime(double time);
    void writeEntry(Severity, const char* message);
    void writeEntry(Severity, const wchar_t* message);
    void timeStamp(bool includeDate);
    static void setLogProvider(ILogProvider* provider);
    Log(const char* logFile, const char* name);
    virtual ~Log();
    const std::string logFile;
    static Log* current();                   // provider ? provider->provideLog() : NULL
    static void timeStamp(std::ofstream& stream, bool includeDate);
private:
    std::ofstream stream;
    static ILogProvider* provider;
    static std::ofstream& currentStream();   // asserts provider non-null
};
}
```
Implementation: util/Log.cpp. `Entry` is a friend class declared but defined elsewhere.

## Usage
Older subsystems write structured entries via writeEntry; newer code uses FastLog. current()/currentStream() let the friend Entry RAII type append scoped messages to the thread's active log.

## Gotchas
- `currentStream()` asserts then dereferences provider — calling any Entry-based logging before setLogProvider crashes on the assert path in debug and dereferences NULL in release.
- wchar_t overload exists but encoding into ofstream is implementation-defined.
