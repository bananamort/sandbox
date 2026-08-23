# App/include/v8tree/Service.h

## Purpose

Declares the service pattern of the datamodel: `RBX::Service` (mixin tag marking an Instance subclass as singleton-within-a-ServiceProvider, with an `isPublic` flag), `RBX::ServiceProvider` (an Instance-derived container that lazily creates/caches services keyed by class index and class name and exposes FindService/GetService reflection functions), and `RBX::ServiceClient<S>` (a lazily-resolving smart-pointer wrapper around a service for a given context Instance).

## Declared API

- `class Service` - public `const bool isPublic`; protected ctor `Service(bool isPublic=true)`, protected dtor.
- `extern const char* const sServiceProvider;`
- `class ServiceProvider : DescribedNonCreatable<ServiceProvider, Instance, sServiceProvider>`
  - Reflection statics: `func_FindService`, `func_GetService`, plus deprecated aliases `dep_service`, `dep_GetService` - all `BoundFuncDesc<ServiceProvider, shared_ptr<Instance>(std::string)>`.
  - Signals: `closingSignal`, `closingLateSignal`, `serviceAddedSignal(service)`, `serviceRemovingSignal(service)`.
  - Ctors `ServiceProvider()`, `ServiceProvider(const char* name)`.
  - `template<class S> S* find() const` - compile-time asserts S derives from both Service and Instance; consults per-class-index slot in mutable `serviceArray`, falls back to `findServiceByClassName(S::className())`, caches result; NULL if absent.
  - `template<class S> S* create() const` - find-or-create via `Creatable<Instance>::create<S>()`, then `setAndLockParent(this)` before mutating caches (comment: setParent may throw).
  - Statics: `findServiceProvider(const Instance*)` (root-ancestor cast), `find<S>(context|provider)`, `create<S>(context|provider)`; string-based `create(Instance*, const RBX::Name&)`, `getPublicServiceByClassNameString(std::string)`.
  - Overrides: `createChild`, `onDescendantRemoving/onDescendantAdded/onChildAdded/onChildRemoving`, `askAddChild` (only allows children that are `Service` instances).
  - Protected `clearServices()`; private per-type index via function-local static + `boost::call_once` (`getClassIndex<S>` -> `newIndex()` monotonic counter); mutable `serviceMap` keyed by `const RBX::Name*`; mutable `serviceArray`.
- `template<class S> class ServiceClient`
  - `ServiceClient(Instance* context)`; `bool isNull()`; implicit conversions `operator S*()`/`operator const S*()` and `operator->()` - lazily resolve through cached `shared_ptr<S>`; conversions *create* the service if missing (`createService`), while `isNull` only finds (`findService`).

## Usage notes

- Canonical usage mirrors Lua's `game:GetService(name)`: `ServiceProvider::find<Players>(instance)` for optional access, or `create<...>`/`ServiceClient<S>` for guaranteed creation.
- Design note from comments: ServiceProvider deliberately uses mutable members so services can be created through const paths ("a ServiceProvider doesn't really change fundamentally when creating and providing Services").

## Gotchas

- `serviceArray` grows to max class index seen - sparse slots hold null shared_ptrs; each service type gets its index once per process.
- `ServiceClient::operator->` *creates* the service on first dereference - even read-looking code can mutate the provider; call `isNull()` first when creation is unwanted.
- Services are singletons only within one ServiceProvider subtree: two DataModels hold independent instances.
- Commented-out `reentrant_concurrency_catcher threadGuard` shows create() has known re-entrancy concerns left unguarded.
