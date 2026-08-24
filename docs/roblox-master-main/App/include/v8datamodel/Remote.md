# App/include/v8datamodel/Remote.h

## Purpose

Remote-event/function machinery: free helper `isPlayerValid`, `DelayedInvocationQueue` (bounded deferred-call buffer), template `LatchedSignal` — a signal that QUEUES fires until the first connect() then replays them (so Lua handlers attached late still see early events) — and the two creatable networking instances: `RemoteFunction` (client↔server invoke with id-matched promise callbacks) and `RemoteEvent` (fireServer/fireClient/fireAllClients with latched OnServerEvent/OnClientEvent signals).

## Declared API

- Free function: `bool isPlayerValid(Instance* instance, const SystemAddress& address)`.

- `class DelayedInvocationQueue`
  - `DelayedInvocationQueue(size_t limit)`; `bool push(const boost::function<void()>& item)`; `void process()`; private `std::vector<boost::function<void()>> items` + limit.

- `template <template<typename> class BaseSignal, typename Signature> class LatchedSignal : public BaseSignal<Signature>`
  - Ctor `(Instance* instance, const char* eventName, size_t queueLimit)`.
  - `operator()(A1)` / `operator()(A1,A2)` forward to fire1/fire2.
  - `connect(F)` connects THEN immediately `queue.process()` — latch drain on first subscriber.
  - fireN semantics: if no slots connected (`this->empty()`), push a bound replay onto the queue; else dispatch now. Queue overflow prints "Remote event invocation queue exhausted for %s; did you forget to implement %s?" via StandardOut with instance full name + event name.
  - Holds raw `Instance*` + `const char* eventName` for that error message only.

- `class RemoteFunction : public DescribedCreatable<RemoteFunction, Instance, sRemoteFunction>`
  - Callback typedefs/members (public): `ServerInvokeCallback onServerInvoke` = fn(shared_ptr<Instance> player, args Tuple, resume(Tuple), error(string)); `ClientInvokeCallback onClientInvoke` = fn(args, resume, error).
  - Invoke entry: `invokeServer(args Tuple, resume, error)`, `invokeClient(shared_ptr<Instance> player, args, resume, error)`.
  - Remote signals: `remoteOnInvokeServer<void(int id, shared_ptr<Instance>, shared_ptr<const Tuple>)>`, `remoteOnInvokeClient<void(int, shared_ptr<const Tuple>)>`, `remoteOnInvokeSuccess<void(int, shared_ptr<const Tuple>)>`, `remoteOnInvokeError<void(int, std::string)>`.
  - Bookkeeping API: `onServerInvokeChanged(oldValue)`, `onClientInvokeInvokeChanged(oldValue)` (sic — actual name `onClientInvokeChanged`), `processDelayedInvocations()`, `askSetParent` override, `onServiceProvider` override.
  - Private: `struct RemoteInvocation { weak_ptr<Instance> player; resume; error; }`; `DelayedInvocationQueue delayedInvocations`; `std::map<int, RemoteInvocation> remoteInvocations`; scoped playerRemoving connection; `int lastRemoteInvocationId`; `consumeRemoteInvocation(id, result&)`, `createRemoteInvocation(player, resume, error)`; virtual `processRemoteEvent(descriptor, args, source)`; local invoke pair (`localInvokeServer/localInvokeClient`); network result pair (`remoteSuccess(address, id, result)` / `remoteError(address, id, error)`); local completion pair (`localSuccess/localError`); `onPlayerRemoving`.

- `class RemoteEvent : public DescribedCreatable<RemoteEvent, Instance, sRemoteEvent>`
  - Fire API: `fireServer(shared_ptr<const Reflection::Tuple>)`, `fireClient(shared_ptr<Instance> player, args)`, `fireAllClients(args)`.
  - `LatchedSignal<rbx::remote_signal, void(shared_ptr<Instance>, shared_ptr<const Tuple>)>* getOrCreateOnServerEvent(bool create=true)` (+OnClientEvent variant without player arg).
  - `askSetParent` override; private virtual processRemoteEvent + members `onServerEvent/onClientEvent` LatchedSignals.

## Gotchas

- LatchedSignal queues EVERY pre-connect fire up to queueLimit — a RemoteEvent fired before any Lua listener exists is replayed on first connect; this is deliberate but surprising vs modern Roblox semantics.
- RemoteFunction matches replies to callers via int invocation ids in a map keyed by id, holding weak player refs; ids from lastRemoteInvocationId.
- askSetParent overrides exist on both classes — parenting restrictions enforced at runtime.
- DelayedInvocationQueue.push returns false when full — overflow path only logs an error, invocations are DROPPED.

## UNKNOWN

- Concrete queue limits passed to LatchedSignal ctors (set in .cpp/creator code).

## Cross-links

- Implementation: [App/v8datamodel/Remote.md](../../v8datamodel/Remote.md).
- Replication layer: Network Replicator docs under App/network; related services: [TeleportService.md](TeleportService.md), [TouchTransmitter.md](TouchTransmitter.md).
