# App/script/ScriptEvent.cpp

## Purpose

Implements `YieldingThreads`, the priority queue of yielded coroutines that drives `wait()`-style resumption: threads queued with an optional delay are resumed by the WaitingScriptsJob (via `ScriptContext::resumeWaitingScripts`) with the two return values `wait()` promises — elapsed time and current wall time. Also supplies four trivial `on_tostring` bridge specializations for connection/thread-node/generic-function userdata.

## API

- `YieldingThreads::YieldingThreads(ScriptContext* context)`.
- `void YieldingThreads::queueWaiter(lua_State *L)` → forwards with delay 0.0; `void YieldingThreads::queueWaiter(lua_State *L, LUA_NUMBER delay)` — asserts `!RobloxExtraSpace::get(L)->yieldCaptured`, sets it true, pushes `WaitingThread(L, RBX::Time::Interval(delay))` onto `waitingThreads` (a priority container ordered by computed resume time).
- `std::size_t YieldingThreads::waiterCount() const`.
- `void YieldingThreads::resume(double wallTime, Time expirationTime, bool& throttling)` — pops due waiters (`now >= w.resumeTime`), locks each `w.thread`, pushes `elapsedTime.seconds()` then `wallTime`, calls `context->resume(thread, 2)`, clears the stack when not Yield again, and counts via `context->scriptResumedFromEvent()`; sets `throttling = true` when `now > expirationTime` but always processes at least one thread for forward progress. Loop bound differs by flag: `while ((!DFFlag::FixYieldThrottling || count-- > 0) && !waitingThreads.empty())`.
- `void YieldingThreads::clearAllSinks()` — drains the queue.
- Bridge specializations: `Bridge<rbx::signals::connection>::on_tostring` → literal "Connection"; `Bridge<boost::intrusive_ptr<WeakThreadRef::Node>>::on_tostring` → "WeakThreadRef"; `Bridge<shared_ptr<GenericFunction>>::on_tostring` / `Bridge<shared_ptr<GenericAsyncFunction>>::on_tostring` → "GenericFunction"/"GenericAsyncFunction".
- `DYNAMIC_FASTFLAGVARIABLE(FixYieldThrottling, false)`.

## Usage

Owned by ScriptContext (`yieldEvent.reset(new YieldingThreads(this))` in openState). Producers: `ScriptContext::wait/spawn/delay` call `queueWaiter`; `ScriptContext::resume(ThreadRef,int)` queues plain yields when `!yieldCaptured`. Consumer: `WaitingScriptsJob::stepDataModelJob` → `resumeWaitingScripts(expiration)` → `yieldEvent->resume(runService->wallTime(), expirationTime, throttling)`.

## Gotchas

- `queueWaiter` asserts yieldCaptured is false then sets it — double-queueing a thread is a bug; paths that capture yields themselves (ypcall, EventBridge::wait, async callbacks, module require) must NOT go through here.
- The resume contract hardcodes exactly 2 pushed values (elapsed seconds, wallTime) matching the documented wait() return.
- Without DFFlag::FixYieldThrottling the loop condition degenerates to `!empty() && ...` because `count-- > 0` is skipped — combined with the always-one-thread throttle break this can starve under sustained re-yields; the flag restores a snapshot-bounded pass.
- Dead waiters whose owning script died are silently dropped (`if (thread)` guard) after being popped — no error continuation fires for them.
