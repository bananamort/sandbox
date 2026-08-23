# rbx/threadsafe.h

## Purpose
The engine's pre-C++11 concurrency toolkit. `RBX::mutex` (CRITICAL_SECTION on Windows, pthread_mutex elsewhere) with `scoped_lock`; `rbx::spin_mutex` (CAS spinlock over `rbx::atomic<int>`); lock-free-ish containers `safe_queue<T>`, `timestamped_safe_queue<T>` (items carry `RBX::Time::now<Fast>` stamps; supports age-based pops), `safe_heap<T>`; thread-local wrappers `thread_specific_reference<T>` / `thread_specific_shared_ptr<T>`; and `SAFE_STATIC`/`SAFE_HEAP_STATIC` macros for boost::call_once-guarded function-local singletons. Also declares three DataModel-contention detectors (`concurrency_catcher`, `reentrant_concurrency_catcher`, `readwrite_concurrency_catcher`) that call RBXCRASH() when contention is detected.

## API
```cpp
namespace RBX {
class mutex {                       // non-recursive
    class scoped_lock : boost::noncopyable { scoped_lock(mutex&); };
};
class concurrency_catcher : boost::noncopyable {            // crash-on-contention flag
    rbx::atomic<int> value;
    class scoped_lock { scoped_lock(concurrency_catcher&); ~scoped_lock(); };
};
struct reentrant_concurrency_catcher : boost::noncopyable { // + volatile unsigned long threadId
    class scoped_lock { /* isChild tracks reentry */ };
};
class readwrite_concurrency_catcher : boost::noncopyable {
    rbx::atomic<int> write_requested, read_requested;
    class scoped_write_request { scoped_write_request(readwrite_concurrency_catcher&); };
    class scoped_read_request  { scoped_read_request(readwrite_concurrency_catcher&); };
};
}
namespace rbx {
class spin_mutex { bool try_lock(); void lock(); void unlock();
                   class scoped_lock : boost::noncopyable; };

template<typename T> class safe_queue : boost::noncopyable {
    void clear(); void push(const T&);
    bool pop_if_present(T&); bool pop_if_present();
    bool peek_if_present(T&);      // WARNING: side effects if T has copy ctor/dtor
    size_t size() const; bool empty() const;   // LOCK-FREE reads (racy snapshot)
};

template<typename T> class timestamped_safe_queue : protected safe_queue<...item...> {
    void clear(); void push(const T&); bool pop_if_present(T&);
    bool pop_if_waited(RBX::Time::Interval waitTime, T& value); // pop head only after waitTime elapsed
    double head_waittime_sec(const RBX::Time& timeNow) const;
    size_t size() const; bool empty() const;
};

template<typename T> class safe_heap : boost::noncopyless { // sic: noncopyable
    void clear(); void push_heap(const T&); bool pop_heap_if_present(T&); ...
};

#define SAFE_STATIC(TYPE,NAME)     // NAME() -> TYPE&, boost::call_once lazy init of function-local static
#define SAFE_HEAP_STATIC(TYPE,NAME)// heap-allocated variant (never freed)

template<typename T> class thread_specific_reference { T* get(); void reset(T*); };
template<typename T> class thread_specific_shared_ptr : boost::noncopyable { operator shared_ptr<T>() const; void reset(shared_ptr<T>); };
}
```
Implementations for the catcher classes live in rbx/ThreadSafe.cpp.

## Usage
Task scheduler queues, signal dispatch buffers, per-thread DataModel context. `SAFE_STATIC(Foo, foo)` replaces raw function-local statics where MSVC's pre-C++11 thread-unsafe static init would race.

## Gotchas
- `spin_mutex::unlock` uses CAS not plain store — benign but unusual; a spurious failed unlock CAS leaves it locked.
- `safe_queue::size()/empty()` are deliberately unsynchronized ("Lock and spin-free calls") — approximate under contention.
- `timestamped_safe_queue` redeclares `typedef spin_mutex mutex` under GCC because GCC won't inherit it from the protected base (in-file "Yuck!").
- Catcher classes are DEBUG instruments: they CRASH the process on first contention (see ThreadSafe.cpp) — never ship them around genuinely concurrent paths.
- `SAFE_STATIC` double-checked via call_once each access — small per-call overhead vs plain static.
- Header pulls `FastLog.h` (LOGGROUP(MutexLifetime)) — mutex init/destroy is fastlogged.
