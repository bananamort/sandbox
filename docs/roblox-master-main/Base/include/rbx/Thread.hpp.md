# rbx/Thread.hpp

## Purpose
Thread naming plus a simple low-priority background worker. Declares `RBX::thread_wrapper`/`set_thread_name`/`get_thread_name` and `RBX::worker_thread`: runs a supplied `boost::function0<work_result>` repeatedly in its own boost::thread, sleeping between invocations until woken.

## API
```cpp
namespace RBX {
boost::function0<void> thread_wrapper(const boost::function0<void>& threadfunc, const char* name);
void set_thread_name(const char* name);
const char* get_thread_name();   // valid only for named-created threads

class worker_thread : public boost::noncopyable {
    enum work_result { done, more };
    explicit worker_thread(const boost::function0<work_result>& work_function, const char* name);
    ~worker_thread();
    void wake();  // run work_function again if sleeping
    void join();  // request stop + join
    // work_function invoked: once after construction; after returning 'more'; after wake()
};
}
```
Implementation is UNKNOWN from this header alone — no matching .cpp exists under Base/ in this snapshot (grep of CMakeLists/vcxproj would confirm where it links from).

## Usage
Background jobs that poll or process streams at low priority while remaining wakeable (e.g. network/asset workers).

## Gotchas
- Lifetime contract documented in-header: the function may still be executing AFTER worker_thread destruction — caller must keep captured data alive independently.
- `wake()` only helps if the thread was sleeping; it does not queue multiple pending runs.
- Header includes boost/thread.hpp wholesale (heavy).
