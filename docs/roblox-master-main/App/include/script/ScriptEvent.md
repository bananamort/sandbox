# App/include/script/ScriptEvent.h

## Purpose

Declares `RBX::Lua::YieldingThreads`, the min-heap of threads parked by event `wait()`/`wait(delay)` calls, resumed in resumeTime order by the ScriptContext scheduler — plus four Lua-bridge `on_tostring` specializations for connections, weak thread nodes, and generic (async) function objects.

## Declared API

- `namespace RBX::Lua`
  - `class YieldingThreads`
    - Private nested: `struct WaitingThread { boost::intrusive_ptr<WeakThreadRef> thread; RBX::Time waitTime; RBX::Time resumeTime; WaitingThread(lua_State* L, RBX::Time::Interval requestedDelay); bool operator<(const WaitingThread& other) const; }` — inline ctor stamps `waitTime = now<Precise>()`, `resumeTime = waitTime + requestedDelay`; `operator<` is INVERTED (`this->resumeTime > other.resumeTime`) so `priority_queue` pops earliest first.
    - `typedef std::priority_queue<WaitingThread> WaitThreadRefs;` member `waitingThreads;` ("Lua refs to threads that are waiting on the event")
    - `YieldingThreads(ScriptContext* context);`
    - "Hooking up consumers:" `void queueWaiter(lua_State* L);` / `void queueWaiter(lua_State* L, LUA_NUMBER delay);`
    - `void resume(double wallTime, Time expirationTime, bool& throttling);`
    - `std::size_t waiterCount() const;`
    - Private: `friend class ScriptContext;` `void clearAllSinks();`
  - Specialization declarations:
    - `int Bridge<rbx::signals::connection>::on_tostring(const rbx::signals::connection&, lua_State* L);`
    - `int Bridge<boost::intrusive_ptr<class WeakThreadRef::Node>>::on_tostring(...);`
    - `int Bridge<shared_ptr<GenericFunction>>::on_tostring(...);`
    - `int Bridge<shared_ptr<GenericAsyncFunction>>::on_tostring(...);`

## Usage notes

- Depends on `script/ThreadRef.h` (WeakThreadRef), `util/runstateowner.h` (RBX::Time), `lua/luabridge.h`.
- Paired implementation documented under certified App/script module.

## Gotchas

- Threads are held via `WeakThreadRef` intrusive pointers — a destroyed coroutine silently drops out at resume time rather than erroring.
- The inverted comparator is load-bearing: removing it flips the queue to LIFO-latest-first and breaks wait ordering.
- `queueWaiter(L)` without delay uses default scheduling inside the .cpp; both overloads funnel into the same heap.
- `clearAllSinks` is ScriptContext-only (friend) — used on context teardown.
