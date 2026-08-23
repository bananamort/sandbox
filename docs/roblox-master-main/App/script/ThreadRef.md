# App/script/ThreadRef.cpp

## Purpose

Implements the Lua-thread and Lua-function reference machinery: `WeakThreadRef` (an intrusive doubly-linked list of weak observers attached to a per-thread `WeakThreadRef::Node` stored in `RobloxExtraSpace`), its strong RAII subclass `ThreadRef`, `detail::LiveThreadRef` (registry pin that keeps a coroutine alive), and `WeakFunctionRef` (weak thread ref plus a `LUA_REGISTRYINDEX` pin of a callable). Also defines the custom helpers `Lua::lua_tofunction` / `Lua::lua_pushfunction` and the bridge glue that lets reflection-level `GenericFunction`/`GenericAsyncFunction` objects be invoked from Lua, including the transparent-yield async pattern.

## API

- `WeakThreadRef::WeakThreadRef(lua_State* thread)` — locks global `WeakThreadRef::Mutex sync`, attaches to `Node::get(thread)`, inserts into the node's intrusive list (`addToNode`), pins the thread via `addRef(thread)` → `new detail::LiveThreadRef(L)`. Copy ctor copies node+liveThreadRef and re-inserts; dtor calls `reset()`; `operator=` re-links when nodes differ.
- `void WeakThreadRef::reset()`, `lua_State* thread()` (from header), `bool empty()` (from header), `static getCount()` used in diagnostics.
- Node plumbing: `void WeakThreadRef::addToNode()`, `removeFromNode()`, `void WeakThreadRef::addRef(lua_State*)` (asserts no existing live ref), `void WeakThreadRef::removeRef()` (resets liveThreadRef).
- `static void WeakThreadRef::Node::eraseAllRefs()` — under lock, walks the list calling each ref's `removeRef()` and nulling `node`; called from `Node::~Node()` and from `ScriptContext::closeState`/`disassociateState`.
- `static boost::intrusive_ptr<WeakThreadRef::Node> WeakThreadRef::Node::create(lua_State* thread)` — calls `RobloxExtraSpace::get(thread)->createNewNode()` and returns `space->getNode()`; `static Node* WeakThreadRef::Node::get(lua_State* thread)` — returns current node.
- Bridge specializations for `Bridge<boost::intrusive_ptr<WeakThreadRef::Node>>`: `className = "WeakThreadRef::Node"`, `on_index` throws "%s is not a valid member", `on_newindex` throws "%s cannot be assigned to". Same throw-only pattern for `GenericFunctionBridge` ("GenericFunction") and `GenericAsyncFunctionBridge` ("GenericAsyncFunction").
- `WeakFunctionRef::WeakFunctionRef(lua_State* thread, int functionIndex)` — super-constructs from thread, then `lua_pushvalue(thread, functionIndex); functionId = luaL_ref(thread, LUA_REGISTRYINDEX);` with a note that the value may be any callable (function or table with `__call`) so type checking is deferred.
- `WeakFunctionRef::~WeakFunctionRef()` — `luaL_unref(ScriptContext::getGlobalState(thread()), LUA_REGISTRYINDEX, functionId)` when non-empty; `removeRef()` mirrors this for the node-erase path; copy ctor and `operator=` re-ref via `lua_rawgeti` + `luaL_ref` on the *global state*; `operator==` compares `functionId` then base thread identity.
- `WeakFunctionRef Lua::lua_tofunction(lua_State* L, int index)` — wraps the ctor.
- `void Lua::lua_pushfunction(lua_State* L, const WeakFunctionRef& function)` — `lua_rawgeti(L, LUA_REGISTRYINDEX, function.functionId)`.
- `void Lua::lua_pushfunction(lua_State* L, shared_ptr<GenericFunction> function)` — pushes a bridge userdata as upvalue behind `lua_pushcclosure(L, callGenericFunctionBridge, 1)`; `static int callGenericFunctionBridge(lua_State*)` collects args via `LuaArguments::getValues(L)`, invokes `(*f)(args)`, pushes result tuple via `LuaArguments::pushTuple` (0 values if NULL result).
- `void Lua::lua_pushfunction(lua_State* L, shared_ptr<GenericAsyncFunction> function)` — closure over `callGenericAsyncFunctionBridge`, which grabs args, calls `(*f)(args, callback)` where the callback is `static void onAsyncResult(ThreadRef thread, weak_ptr<ScriptContext>, IAsyncResult*)` → `lockedContext->scheduleResume(thread, value)`; the C function then asserts/yields: sets `RobloxExtraSpace::get(L)->yieldCaptured = true` and `return lua_yield(L, 0)`.
- `RBX::Lua::detail::LiveThreadRef::LiveThreadRef(lua_State* thread)` — `lua_pushthread(L); threadId = luaL_ref(L, LUA_REGISTRYINDEX);`; dtor `luaL_unref(ScriptContext::getGlobalState(L), LUA_REGISTRYINDEX, threadId)`.
- `void dumpThreadRefCounts()` — FASTLOG3 of `ThreadRef::getCount()`, `WeakThreadRef::getCount()`, `detail::LiveThreadRef::getCount()` under log variable `ThreadRefCounts`.
- Reflection specializations at file bottom: `Type::getSingleton<RBX::Lua::WeakFunctionRef>()` named "Function"; `Variant::convert<RBX::Lua::WeakFunctionRef>()` converts a `void`-typed variant (Lua nil) into a null WeakFunctionRef, else throws "Unable to cast value to function"; singletons "GenericFunction"/"GenericAsyncFunction" with throwing converts.

## Usage

Used everywhere threads must outlive the stack slot that produced them: `ScriptContext::executeInNewThread/spawn/delay/ypcall/on_ypcall_*`, `startRunningModuleScript`, `requireModuleScriptFromInstance/AssetId` all wrap raw `lua_newthread` results in `WeakThreadRef`/`ThreadRef`; `BaseScript::threadNode` holds a `WeakThreadRef::Node` created by `Node::create(thread)` so `disassociateState` can `eraseAllRefs()` at teardown. `WeakFunctionRef` is how callbacks (event connections, GenericFunctions) are stored by C++ and later re-invoked through `Lua::lua_pushfunction` + `ScriptContext::resume`. `dumpThreadRefCounts` is invoked by `ScriptContext::closeState` around teardown.

## Gotchas

- The weak/strong distinction lives entirely in whether the observer keeps a `detail::LiveThreadRef`: a bare `WeakThreadRef` inserted without `addRef` (e.g. copies made after detach, or refs cleared by `eraseAllRefs`) observes a possibly-dead thread; callers always write `if (ThreadRef t = weak.lock())` before resuming.
- All list mutation goes through one process-wide mutex `WeakThreadRef::sync` — thread-safe but globally contended; `operator=` deliberately does NOT re-copy `liveThreadRef` under the lock (it copies it outside), an ordering subtlety if copied concurrently.
- `eraseAllRefs` nulls every observer's `node` pointer while leaving the observer objects alive — afterwards those refs are inert and `lock()` will fail; this is how script shutdown breaks reference cycles without waiting for GC.
- `WeakFunctionRef` pins its target in the registry of the *global state*, not the thread (`ScriptContext::getGlobalState(thread())`), so functions survive coroutine death as long as some holder exists — and conversely the destructor's unref can run on whatever thread destroys the last holder (the code itself carries a TODO questioning datamodel-thread safety there).
- `callGenericAsyncFunctionBridge` marks the calling thread `yieldCaptured = true` before yielding, which prevents `ScriptContext::resume` from double-queueing the waiter — the resume happens later via `scheduleResume` → `waitingThreads` queue.
- `Variant::convert<WeakFunctionRef>` treats nil as a *null* function rather than an error (flagged TODO in source) — callers checking `empty()` must expect this conversion path.
- `onAsyncResult` swallows exceptions from `result->getValue()` into a warning log with a TODO about surfacing them to Lua — errors inside async completions never reach script pcall handlers.
