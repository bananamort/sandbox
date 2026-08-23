# boost.cpp

## Purpose
Boost-glue implementations: RBX::isFinite (delegates to boost::math::isfinite), cross-platform thread naming (Win32 0x406D1388 exception trick / pthread_setname_np), and `worker_thread` — a self-parking worker that repeatedly runs a work function until it reports `done`, then sleeps on a condition variable until woken or destroyed.

## API
```cpp
namespace RBX {
bool isFinite(double); bool isFinite(int);
void set_thread_name(const char*);            // TLS string + OS name
const char* get_thread_name();                // "unnamed thread" default
boost::function0<void> thread_wrapper(const boost::function0<void>& func, const char* name);
class worker_thread {                         // declared in rbx/Thread.hpp
    worker_thread(const boost::function0<work_result>& work_function, const char* name);
    ~worker_thread();                         // sets endRequest + notify (no join!)
    void join();                              // endRequest + notify + t.join()
    void wake();
    static void threadProc(shared_ptr<data>, const function0<work_result>&);
};
}
```

## Usage
thread_wrapper is the standard way boost::threads get spawned in the engine so debuggers/profilers show names. worker_thread backs long-lived polling threads.

## Gotchas
- SetThreadName raises exception 0x406D1388 with __except(EXCEPTION_CONTINUE_EXECUTION) — a crash handler that filters exceptions must whitelist this code or every named-thread spawn looks like a crash.
- ~worker_thread does NOT join: it signals shutdown and leaks responsibility for `_data` collection to threadProc exit — destroy without join only if the work function can observe endRequest.
- threadProc loop: `while(work_function()==more)` — the work functor itself decides when to yield; a functor returning `more` forever starves the wake/sleep path.
- Thread-name TLS uses a heap `thread_specific_ptr<std::string>`; get_thread_name returns "unnamed thread" static when unset.
- MAC_OS_X_VERSION_MIN_REQUIRED > 10.5 guard around pthread_setname_np.
