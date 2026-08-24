# App/include/v8datamodel/EventReplicator.h

## Purpose

Header-only template machinery that replicates a reflection remote event *only while someone listens*: watches an int `...ConnectionCount` REPLICATE_ONLY property; when the far side subscribes (count > 0) it connects the local signal and mirrors firings through `remoteEvent.replicateEvent`. Includes the `DECLARE_EVENT_REPLICATOR_SIG` / `IMPLEMENT_EVENT_REPLICATOR` / `CONSTRUCT_EVENT_REPLICATOR` / `CONNECT_EVENT_REPLICATOR` macro family used by ArcHandles, Handles, Mouse-style classes.

## Declared API

`template <typename Parent, typename Signature> class EventReplicatorBase`

- Holds refs: `Reflection::BoundProp<int>& connectionCount; Reflection::RemoteEventDesc<Parent,Signature>& remoteEvent; rbx::signal<void()>& connectionSignal; Parent* instance;`
- `void setInstance(Parent*)`; `void setListenerMode(bool alreadyConnected)` — connects to the connection signal (RBXASSERTs only one replicator per signal), optionally bumps count immediately.
- `listenerConnectionAdded()` — sets count to `max(count+1, 1)` (floor of 1).
- `void onPropertyChanged(const Reflection::PropertyDescriptor&)` — when the count prop changes from the other side: >0 connects the signal listener (`connectSignalListener()` virtual), ==0 disconnects.
- Destructor disconnects both connections.

Arity dispatch: `template<int arity, class Parent, typename Signature> class EventReplicatorImpl` specializations for 0–3 args, each with static arity asserts (`BOOST_STATIC_ASSERT(function_traits<Signature>::arity == N)`) and a `signalProducedIncremented(args...)` that calls `remoteEvent.replicateEvent(instance, ...)`.

Final selector: `template<class Parent, typename Signature> class EventReplicator : public EventReplicatorImpl<boost::function_traits<Signature>::arity, Parent, Signature>`.

Macros:
- `DECLARE_EVENT_REPLICATOR_SIG(Parent, eventName, signature)` — declares member `int var<eventName>ConnectionCount`, `static BoundProp<int> prop_<eventName>ConnectionCount`, and `EventReplicator<Parent, signature> eventReplicator<eventName>`.
- `category_EventReplicator "EventReplicator"`.
- `IMPLEMENT_EVENT_REPLICATOR(Parent, eventDesc, eventText, eventName)` — defines the count prop as REPLICATE_ONLY with name `<eventText>ConnectionCount`.
- `CONSTRUCT_EVENT_REPLICATOR(Parent, remoteSignalName, eventDesc, eventName)` — ctor-init list wiring signal + zeroed counter.
- `CONNECT_EVENT_REPLICATOR(eventName)` — `setInstance(this)`.

## Gotchas

- The header's own comment warns the scheme is fragile: connection counts are unreliable under replication — server-only increment/decrement works at best, and a client that incremented then disconnects never decrements.
- Count is clamped to ≥1 on local increments but can be driven to 0 by replication.
- One EventReplicator per signal enforced only by assert.

## UNKNOWN

- Which concrete classes instantiate EventReplicator beyond ArcHandles (grep users of DECLARE_EVENT_REPLICATOR_SIG across tree).

## Cross-links

- Users: [ArcHandles.md](ArcHandles.md), [Handles.md](Handles.md); base infra [DataModel.md](DataModel.md) replication layer.
