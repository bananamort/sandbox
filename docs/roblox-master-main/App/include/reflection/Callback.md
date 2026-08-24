# App/include/reflection/Callback.h

## Purpose

Declares the reflected-callback system (Lua-facing `RBXScriptConnection`-style invokable members that SCRIPTS SET and engine CALLS, e.g. `OnTouched`): `CallbackDescriptor` base with async flag; `SyncCallbackDescriptor` (returns a Tuple synchronously) and `AsyncCallbackDescriptor` (resume/error continuation style); the lightweight `Callback` handle; typed template stack `SyncCallbackDesc<Signature>` → arity-specialized `SyncCallbackDescImpl` (0–4 args) → member-binding `BoundCallbackDesc`; and `BoundAsyncCallbackDesc<Class, Signature, arity>` specializations (0–2 args).

## Declared API

- `class RBXBaseClass CallbackDescriptor : public MemberDescriptor`
  - Typedefs Callback ConstMember/Member; protected `SignatureDescriptor signature; bool async;` ctor `(ClassDescriptor&, name, Attributes, security, bool async)`; inline getSignature()/isAsync().
- `class SyncCallbackDescriptor : public CallbackDescriptor`
  - `typedef boost::function<shared_ptr<Tuple>(shared_ptr<const Tuple> args)> GenericFunction;`
  - Pure virtuals: setGenericCallback(object, shared_ptr<GenericFunction>), clearCallback(object); helper `setGenericCallbackHelper(object, const GenericFunction&)` ("use this function if you don't have a shared_ptr").
- `class AsyncCallbackDescriptor : public CallbackDescriptor`
  - Typedefs: `ResumeFunction = boost::function<void(shared_ptr<const Tuple>)>`; `ErrorFunction = boost::function<void(std::string)>`; `GenericFunction = boost::function<void(args, ResumeFunction, ErrorFunction)>`.
  - Same pure virtual set + helper; protected static `callGenericImpl(function, args, resume, error)`; protected template `setGenericCallbackImpl(object, member-ptr, onChanged-ptr, value)` — swaps member value and invokes onChanged(oldValue).
- `class Callback` — descriptor+instance handle: copy ops, getName/getInstance/getDescriptor.
- `template<typename Signature> class SyncCallbackDesc : public SyncCallbackDescriptor`
  - Protected typedefs Function = boost::function<Signature>, result_type via function_traits; static enable_if/disable_if helpers callGeneric<Result> (void vs non-void) and convertResult<Result> (Tuple-returning passthrough vs first-value extraction — throws `"Callback did not return a value"` on empty tuple).
  - Nested `class RBXInterface ISetter { virtual void setCallback(DescribedBase*, const Function&) const = 0; }` + scoped_ptr setter; ctor passthrough.
  - Public setCallback(object, Function)/clearCallback (sets empty Function).
- `template <typename Signature, int arity> class SyncCallbackDescImpl;` — primary undeclared; specializations for arity 0..4 each:
  - static callGeneric packing N pushed Variants into a fresh Tuple then invoking base callGeneric<Result>;
  - protected ctor static-asserting exact arity, setting signature.resultType, addArgument(name, Type) per arg;
  - override setGenericCallback binding callGeneric with `_1.._N`.
- `template<typename Signature> class BoundCallbackDesc : public SyncCallbackDescImpl<Signature, arity>`
  - Nested Setter<Class> : ISetter — assigns to `Function Class::*member`, optionally calling `void (Class::*)()` onChanged after.
  - Ten templated ctors covering arity 0–4 × with/without onChanged; all default security=Security::None, attributes default.
- `template <class Class, typename Signature, int arity = boost::function_traits<Signature>::arity> class BoundAsyncCallbackDesc;` — primary declared only; specializations for arity 0,1,2 each:
  - Local Function typedef appending ResumeFunction/ErrorFunction params to the script-callable signature;
  - static callGeneric building the Tuple then delegating AsyncCallbackDescriptor::callGenericImpl;
  - private declareSignature([argnames]) static-asserting arity and filling resultType+arguments;
  - members `Function Class::*member; void (Class::*onChanged)(const Function&);`
  - ctors with/without onChanged; overrides setGenericCallback (via setGenericCallbackImpl + bind) and clearCallback (empty Function).

## Usage notes

- This header is pure template machinery — no .cpp beyond the descriptor-base constructors.
- Pairs with Lua bridge plumbing ([../script/LuaInstanceBridge.md](../script/LuaInstanceBridge.md)) where callbacks surface as writable function properties.

## Gotchas

- convertResult silently drops all but the FIRST tuple value for scalar-returning callbacks.
- Async callback signatures are C++-side `(args..., resume, error)` — the Lua-visible signature omits the two trailing continuations.
- SyncCallbackDesc::setter is a scoped_ptr left NULL unless a BoundCallbackDesc installs one — calling setCallback on a bare SyncCallbackDesc crashes.
