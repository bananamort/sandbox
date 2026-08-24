# util/ConcurrencyValidator.h

## Purpose
Debug-only single-writer/multi-reader discipline checker: RAII guards (`WriteValidator`, `ReadOnlyValidator`) assert at runtime that no readers overlap a writer on a guarded object. Compiles to no-ops (`(void)0`) outside `__RBX_NOT_RELEASE` builds.

## Declared API
```cpp
#ifdef __RBX_NOT_RELEASE
    #define RBX_USE_CONCURRENCY_VALIDATOR(expr) (expr)
#else
    #define RBX_USE_CONCURRENCY_VALIDATOR(expr) ((void)0)
#endif

class ConcurrencyValidator {
public:
    ConcurrencyValidator();               // writing=0, reading=0
    ~ConcurrencyValidator();              // asserts both are 0
private:
    rbx::atomic<int> writing;
    std::string writeLocation;            // set by preWrite(where)
    mutable rbx::atomic<int> reading;
    bool preRead() const;  bool postRead() const;
    bool preWrite();       bool postWrite();
    bool preWrite(const std::string& writeWhere);
    friend class WriteValidator; friend class ReadOnlyValidator;
};

class ReadOnlyValidator {   // ctor: preRead(), dtor: postRead()
public:
    ReadOnlyValidator(const ConcurrencyValidator& c);
    ~ReadOnlyValidator();
};

class WriteValidator {      // ctor: preWrite([where]), dtor: postWrite()
public:
    WriteValidator(ConcurrencyValidator& c);
    WriteValidator(ConcurrencyValidator& c, const std::string& writeWhere);
    WriteValidator(ConcurrencyValidator& c, const char* writeWhere);
    ~WriteValidator();
};
```

## Gotchas
- This is an ASSERTION tool, not a lock — it does not block anyone; it detects (in debug builds) concurrent read/write or write/write misuse via atomics + RBXASSERT.
- Checks happen at entry AND exit of each guard, so a reader that starts while a writer is inside will be caught at the reader's `preRead`/`postRead` or the writer's `postWrite`.
- The `preWrite`/`postWrite` checks read `writing`/`reading` non-atomically as pairs — races between the paired reads can produce false negatives/positives in actual racy runs (acceptable for a debug heuristic).
- Typo'd comments reference "InterlocedIncrement" (InterlockedIncrement); asserts fire if increment result != expected.
- `writeLocation` is only populated when using the string-tagged `WriteValidator` ctor — helpful for diagnosing who was writing.
- Release builds: zero cost, all state still exists but unused.

## UNKNOWN
- Which data model objects embed ConcurrencyValidator members (call sites outside this slice).
