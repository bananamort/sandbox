# App/include/script/ThreadRef.h

## Purpose

Declares the thread/function reference system bridging Lua coroutines into C++: `detail::LiveThreadRef` (refcounted anchor keeping a coroutine's `lua_State` pinned in the registry), `ThreadRef` (strong lock), `WeakThreadRef` (weak, node-chained reference — the currency of the scheduler and event bridges), `WeakFunctionRef` (same pattern for function values), and the `lua_tofunction`/`lua_pushfunction` interop plus `GenericFunction`/`GenericAsyncFunction` typedefs.

## Declared API

- `namespace RBX::Lua`
  - `void dumpThreadRefCounts();`
  - `namespace detail`
    - `class LiveThreadRef : public rbx::quick_intrusive_ptr_target<LiveThreadRef>, public Diagnostics::Countable<LiveThreadRef>, boost::noncopyable` — friends WeakThreadRef/ThreadRef; "Do not create this. It is an internal class"; `LiveThreadRef(lua_State* thread); ~LiveThreadRef(); bool empty() const; lua_State* thread() const;` (both inline).
  - `class ThreadRef : public Diagnostics::Countable<ThreadRef>` ("You get this by calling lock() on WeakThreadRef")
    - Private ctor from `LiveThreadRef*`; public: `ThreadRef();` `ThreadRef(lua_State* thread);` `lua_State* get() const;` `operator lua_State*() const;` `bool empty() const;` (inline; NOTE: returns true when liveThreadRef non-null AND thread != NULL — inverted-looking semantics vs LiveThreadRef::empty).
  - `class WeakThreadRef : public rbx::quick_intrusive_ptr_target<WeakThreadRef>, boost::noncopyable, public Diagnostics::Countable<WeakThreadRef>` ("Registers a weak reference to a thread, ensuring that it isn't collected (sometimes)")
    - Statics: `typedef rbx::spin_mutex Mutex; static Mutex sync;` (comment: "TODO: boost::mutex would be safer")
    - Nested `class Node : public rbx::quick_intrusive_ptr_target<Node>, boost::noncopyable` — intrusive singly-linked list head (`WeakThreadRef* first`); `Node(); ~Node(); static boost::intrusive_ptr<Node> create(lua_State* thread); static Node* get(lua_State* thread); void eraseAllRefs();` ("Clear all refs to thread and its children"); template inline `void forEachRefs(Func func)` calling `func(ref->lock())`.
    - Instance: copy ctor/assignment, virtual dtor, `operator==/!=`, `void reset();` `bool empty() const;` `ThreadRef lock();` `lua_State* threadDangerous() const;` protected `Node* node; virtual void removeRef();` protected inline `lua_State* thread() const` (forwards to `threadDangerous()`); private linked-list pointers + `addRef/addToNode/removeFromNode`.
  - Typedefs/functions:
    - `typedef boost::function<shared_ptr<const Reflection::Tuple>(shared_ptr<const Reflection::Tuple>)> GenericFunction;` ("takes any number of arguments and returns a tuple")
    - `class IAsyncResult { virtual shared_ptr<const Reflection::Tuple> getValue() = 0; }` — comment: "This may throw"
    - `typedef boost::function<void(shared_ptr<const Reflection::Tuple>, boost::function<void(IAsyncResult*)>)> GenericAsyncFunction;`
    - `class WeakFunctionRef : public WeakThreadRef` — `WeakFunctionRef(); WeakFunctionRef(lua_State* thread, int index);` ("Constructs a FunctionRef from the Lua stack") virtual dtor, copy ops, comparisons, `friend` free functions, protected `virtual void removeRef();` member `int functionId;`
    - Interop: `WeakFunctionRef lua_tofunction(lua_State* L, int index);` `void lua_pushfunction(lua_State* L, const WeakFunctionRef&);` `void lua_pushfunction(lua_State*, shared_ptr<GenericFunction>);` `void lua_pushfunction(lua_State*, shared_ptr<GenericAsyncFunction>);`
- `LOGGROUP(WeakThreadRef)` diagnostics group declared at top.

## Usage notes

- Pairs with certified App/script docs for ref-count lifecycle behavior (registry anchoring, node teardown ordering).
- `dumpThreadRefCounts` exists specifically to debug leaks of these counted objects.

## Gotchas

- `ThreadRef::empty()` returns TRUE only when a live ref EXISTS with non-NULL thread — semantically inverted versus `LiveThreadRef::empty()` (NULL ⇒ true). Callers must not assume consistent polarity.
- `threadDangerous()` can return a `lua_State*` that another thread closes concurrently — hence the name; prefer `lock()` then use.
- Weak refs are chained per-thread through `Node` under one global spin mutex — contention point under many threads.
- `lua_tofunction(L, index)` friend declaration inside the class omits the index parameter while the real free function has it — the friend form is a different overload that is never defined; harmless but confusing.
