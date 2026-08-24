# App/include/reflection/Event.h

## Purpose

Declares the reflection event (signal) system — "an event system inspired by boost's signal library" allowing typed AND generic (Variant-list) slot connection so signals interop with Lua: `GenericSlotWrapper`/`TGenericSlotWrapper`, `EventSource` base, `EventDescriptor` + arity-specialized `EventDescImpl` (0–7 args) behind the user-facing `EventDesc` template, the `Event` handle and `EventInvocation` record, replication-flavored `RemoteEventDescImpl` (0–7) / `RemoteEventDesc` with `RemoteEventCommon` functionality/behavior flags.

## Declared API

- `typedef std::vector<Variant> EventArguments;`
- Header TODO comment block describing the design goal (typed + generic slots for Lua/runtime interop).
- `class RBXInterface GenericSlotWrapper : boost::noncopyable, public Diagnostics::Countable<...>` — pure virtual `execute(const EventArguments&)`; inline templated helpers execute1..execute7 packing Variants; static factory `create<GenericSlot>(slot)` wrapping into TGenericSlotWrapper.
- `template<class GenericSlot> class TGenericSlotWrapper : GenericSlotWrapper, Countable` — public member `GenericSlot slot;` execute() invokes it inside try/catch of `RBX::base_exception`, logging "Exception caught in TGenericSlotWrapper. %s" via StandardOut MESSAGE_ERROR.
- `class EventSource` ("The base class of any object that fires Events") — virtual dtor; virtual `processRemoteEvent(descriptor, args, const SystemAddress& source);` virtual `raiseEventInvocation(descriptor, args, const SystemAddress* target = NULL);` ("used to replicate events"); virtual `bool useSubmitTaskForLuaListeners() const { return false; }` (comment about multi-DataModel locking via submit task).
- `class RBXBaseClass EventDescriptor : public MemberDescriptor`
  - Typedefs Event ConstMember/Member; protected SignatureDescriptor + ctor.
  - Pure virtuals: `connectGeneric(EventSource*, shared_ptr<GenericSlotWrapper>)`, `fireEvent(EventSource*, const EventArguments&)`, `disconnectAll(EventSource*)`.
  - Virtuals: isScriptable() default true; isPublic() = isScriptable(); isBroadcast() default false; sendEvent(...) default asserts false ("Should only be called on RemoteEventDesc").
  - Identity ==/!=.
- `template<class EventClass, typename Signature, typename SignalType, typename SignalGetter = SignalType EventClass::*> class EventDescBase;` — two specializations:
  - member-pointer form: holds `SignalType EventClass::*sig`; getSignal(obj); connect() polymorphic_downcast to EventClass, NULL source → empty connection; disconnectAll().
  - getter-method form (`SignalType* (EventClass::*)(bool)`): getOrCreate(true) in getSignal (asserts non-null); disconnectAll uses getOrCreate(false), only disconnecting when present.
- `template<int arity, ...> class EventDescImpl;` — specializations 0..7 each providing:
  - `connectGeneric` binding `GenericSlotWrapper::executeN<arg types>` with `_1.._N`;
  - `fireEvent(source, args)` asserting `RBX_SIGNALS_ASSERT(args.size()==N)` then casting each Variant to its function_traits arg type;
  - typed convenience `fireEvent(instance, arg1..argN)` calling the signal directly.
- `template<EventClass, Signature, SignalType=rbx::signal<Signature>, SignalGetter=member-ptr> class EventDesc : public EventDescImpl<arity,...>` — "This is the final class used for defining Events." Twelve ctors covering arities 0–7 (each ×2: with Security::Permissions+Attributes or Attributes-only for arity 0/1... precisely: arity0 has 2 ctors, arity1..7 have security+attributes ctor each plus attribute-only variants where shown), each static-asserting exact arity and pushing named SignatureDescriptor Items.
- `class Event` — descriptor + `shared_ptr<EventSource>` handle: copy ops, getName/getDescriptor/getInstance, identity ==/!=.
- `std::size_t hash_value(const Event& prop);`
- `class EventInvocation` — "class used to hold the arguments/EventDesc of an event": `const Event event; EventArguments args;` ctors; `fireEvent()` → descriptor->fireEvent(instance.get(), args); `replicateEvent()` → descriptor->sendEvent(...); == compares events only (args comparison commented out).
- `template<int arity,...> class RemoteEventDescImpl;` — specializations 0..7 extending EventDesc with `fireAndReplicateEvent(instance[, args...])` (fires locally THEN replicateEvent) and `replicateEvent(EventSource*[, args])` building EventArguments and calling instance->raiseEventInvocation(*this, args).
- `class RemoteEventCommon`
  - `enum Functionality { SCRIPTING=1, REPLICATE_ONLY=0 };` nested Attributes with flags + static deprecated(flags, preferred);
  - `enum Behavior { CLIENT_SERVER=0, BROADCAST=1 };` ("A full broadcasts, all clients will recieve the message" [sic])
- `template<EventClass, Signature, SignalType=rbx::remote_signal<Signature>, SignalGetter> class RemoteEventDesc : public RemoteEventDescImpl<arity,...>, public RemoteEventCommon`
  - Protected members behavior/flags; ctors arity 0–7 taking (sig, name[, argnames...], security, RemoteEventCommon::Attributes, Behavior);
  - `getSignalPtr(source)` (asserts non-null source);
  - overrides: isScriptable = `(flags & 1) != 0`; isBroadcast = `(behavior & 1) != 0`; sendEvent → instance->raiseEventInvocation.

## Usage notes

- Every reflected Instance signal (Touched, Changed, ...) is an `EventDesc` static member; networked ones are RemoteEventDesc (e.g. LuaWebServices, LuaSourceContainer requestLock).
- Pairs with [../script/LuaSignalBridge.md](../script/LuaSignalBridge.md) for Lua-side Connect/Wait.

## Gotchas

- fireEvent casts Variants blindly per declared signature — a remote-sent argument of the wrong type throws at cast time.
- EventInvocation equality ignores arguments (deliberately commented out).
- Default EventDescriptor::sendEvent asserts — firing replication paths through plain EventDesc is a programming error caught only in checked builds.
- useSubmitTaskForLuaListeners defaults false; sources shared across DataModels must override to keep Lua listeners under the right lock.
