# signal.h

## Purpose
Roblox's home-grown signals/slots system (`rbx::signal<Signature>`, `rbx::remote_signal`, `rbx::signals::connection`/`scoped_connection`) — a minimal boost.signal clone with intrusive-refcounted slots in a mutex-protected linked list. This is the backbone of every engine event (property Changed, instance events, cross-system notifications).

## API
```cpp
namespace rbx::signals {
    extern boost::function<void(std::exception&)> slot_exception_handler;
    class connection { void disconnect() const; bool connected() const; ==,!=; flogPrint(); };  // weak ref to slot
    class scoped_connection : noncopyable { connect/assign auto-disconnect in dtor; get(); };
    class scoped_connection_logged : same + FASTLOG on assign/disconnect/dtor (FLog::ScopedConnection group);
    template<typename Signature> class signal : noncopyable {
        connection connect(const Delegate& function);
        void disconnectAll();
        bool empty() const;
    protected: bool next(boost::intrusive_ptr<slot>&);  // iterator used by fire
    };
}
template<typename Signature>
class rbx::signal : public signals::signal_with_args<boost::function_traits<Signature>::arity, Signature> {};
// signal_with_args specializations for arity 0..7: void operator()(args...);
template<typename Signature>
class rbx::remote_signal : public signal<Signature> {
    signal<void()> connectionSignal;
    template<typename F> signals::connection connect(const F& function);  // fires connectionSignal first
};
```

## Usage
Included everywhere events exist. Slots are `boost::function`-like delegates wrapped via rbx/callable.h's icallable/callable CRTP. Firing walks the list with `next()` holding intrusive_ptrs so concurrent disconnects can't dangle. RBX_SIGNALS_DEBUGGING (defined in _DEBUG) swaps asserts for crash-asserts and disables optimization for the whole header.

## Gotchas
- Thread-safety contract (in-file comment): connect/disconnect from any thread; FIRING is NOT thread-safe — one thread at a time per signal.
- operator() catches ONLY RBX::base_exception from slots, routes to slot_exception_handler, then `goto begin` RESUMES FROM HEAD of the list — a throwing slot causes already-fired slots to fire AGAIN (at-least-once, not exactly-once).
- disconnectAll uses "chunk" logic (DE131): nulls 10 sigs per locked pass then drops refs outside the lock to avoid stack crash from recursive destruction.
- SAFE_HEAP_STATIC (not SAFE_STATIC) for the shared per-signature mutex — comment: global objects using signals outlive static destruction order otherwise.
- Header #errors if windows.h was included without NOMINMAX (`#ifdef max`).
- remote_signal is deliberately NOT polymorphic against signal; comment warns Event must stay templatized or "THIS CODE WILL FAIL".
