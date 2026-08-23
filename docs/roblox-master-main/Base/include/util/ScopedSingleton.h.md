# ScopedSingleton.h

## Purpose
CRTP-free lazy singleton template whose instance lifetime is scoped by shared_ptr holders: getInstance() creates T on demand under a spin mutex and caches a weak_ptr; when the last consumer drops its shared_ptr, T is destroyed and a later getInstance() constructs a fresh one. getInitCount tracks how many times construction has happened (usage validation).

## API
```cpp
template<class T> class RBX::ScopedSingleton {
protected:
    static int getInitCount();                       // validate usage patterns
    SAFE_STATIC(rbx::spin_mutex, sync);              // lazily-created statics via threadsafe.h macros
    SAFE_STATIC(boost::weak_ptr<T>, s_instance);
public:
    static boost::shared_ptr<T> getInstance();       // lock; re-create if weak expired
    static boost::shared_ptr<T> getInstanceOptional(); // null when no live holders
};
```

## Usage
CProcessPerfCounter : PerfCounter, ScopedSingleton<CProcessPerfCounter> — PDH query exists only while someone holds it.

## Gotchas
- T must be default-constructible and constructible as `new T()` — no ctor args.
- initCount is a plain function-static int incremented under spin lock but read via getInitCount WITHOUT the lock.
- If T's destructor itself calls getInstanceOptional/getInstance → recursion/deadlock on the spin mutex.
- SAFE_STATIC machinery means these statics are destroyed in reverse-safe order at shutdown (see rbx/threadsafe.h).
