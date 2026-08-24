# App/include/v8datamodel/Bindable.h

## Purpose

Script-to-script communication primitives: `BindableFunction` (queued invoke with resume/error callbacks) and `BindableEvent` (signal fire). A third design, `PropertyInstance`, is fully present but compiled out under `#if 0`.

## Declared API

`class BindableFunction : public DescribedCreatable<BindableFunction, Instance, sBindableFunction>`

- Constructor stamps display name "Function".
- Invocation queue: private struct `Invocation { shared_ptr<const Reflection::Tuple> arguments; boost::function<void(shared_ptr<const Reflection::Tuple>)> resumeFunction; boost::function<void(std::string)> errorFunction; };` `typedef std::queue<Invocation> Queue; Queue queue;`
- `void invoke(shared_ptr<const Reflection::Tuple> arguments, function<void(shared_ptr<const Tuple>)> resumeFunction, function<void(std::string)> errorFunction);`
- Callback slot: `typedef boost::function<void(shared_ptr<const Tuple>, resumeFn, errorFn)> OnInvokeCallback; OnInvokeCallback onInvoke;` plus `void processQueue(const OnInvokeCallback& oldValue);`
- Override: `bool askSetParent(const Instance*) const;`

`class BindableEvent : public DescribedCreatable<BindableEvent, Instance, sBindableEvent>`

- Constructor stamps display name "Event".
- `rbx::signal<void(shared_ptr<const Reflection::Tuple>)> event;`
- `void fire(shared_ptr<const Reflection::Tuple> arguments);`
- Override: `bool askSetParent(const Instance*) const;`

Dead code: `class PropertyInstance` (`valueChanged` signal, get/setCallback functions, getValue/setValue/fireValueChanged) inside `#if 0`, descriptor `sPropertyInstance`.

## Gotchas

- BindableFunction queues invocations and drains them in processQueue — the onInvoke callback is swapped atomically against the old value (hence the parameter).
- Arguments are Reflection Tuples, not arbitrary Lua values — marshalling rules live at the Lua bridge.
- PropertyInstance never compiles: do not count it as available API.

## UNKNOWN

- Threading context of invoke vs processQueue (.cpp — see [Bindable.md](../../v8datamodel/Bindable.md)).

## Cross-links

- Implementation: [App/v8datamodel/Bindable.md](../../v8datamodel/Bindable.md).
- Consumers pair these with [Remote.md](Remote.md)-style networking objects for cross-boundary messaging.
