# rbx/atomic.h

## Purpose
Pre-C++11 atomic integer primitive `rbx::atomic<T>` used engine-wide (refcounts, task scheduler state). Two backends: GCC/Clang (`__sync_*` builtins) for Apple/Android, Win32 Interlocked via boost for `_WIN32`. Storage is a plain T with compiler intrinsics — no memory-order template parameter exists.

## API
```cpp
template<typename T> class rbx::atomic {
    atomic(T value = 0);
    T operator=(T v);            // NON-atomic plain store
    operator T() const;          // non-atomic load
    T compare_and_swap(T value, T comparand); // returns OLD value
    T operator++();  T operator++(int);       // pre returns new, post returns old
    T operator--();  T operator--(int);
    T swap(T value);             // exchange
};
```
Win32: `BOOST_STATIC_ASSERT(sizeof(T) == sizeof(long))`; ctor asserts 32-bit alignment of storage. Ops map to BOOST_INTERLOCKED_{COMPARE_EXCHANGE,INCREMENT,DECREMENT,EXCHANGE}. Apple/Android: `__sync_val_compare_and_swap`, `__sync_add_and_fetch` etc.

## Usage
`rbx::atomic<int> refs;` in intrusive_ptr_target, Allocator counts, Diagnostics::Countable, TaskScheduler state machines.

## Gotchas
- Plain `operator=` and implicit conversion are NOT atomic: assignment from multiple threads races; only the interlocked ops are.
- Windows build only supports 4-byte types (sizeof==sizeof(long)); int64 atomics are impossible here.
- CAS argument order is `(value, comparand)` returning the previous value — compare against the returned value to detect success.
- No acquire/release semantics specified; on x86 interlocked ops give full fences, but ARM (`__sync` path) provides only full-barrier builtins — still correct but heavier than C11 relaxed ops. Relevant baseline when porting toward Luau's atomic model.
