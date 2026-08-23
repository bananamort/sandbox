# rbx/make_shared.h

## Purpose
A vendored copy of boost 1.42.1's `make_shared` (`rbx::make_shared<T>(args...)`) so `boost::shared_ptr` objects can be built with a single allocation: the pointee is constructed inside the deleter's aligned storage and destroyed there when refcount hits zero.

## API
```cpp
namespace rbx {
template<class T> boost::shared_ptr<T> make_shared();
template<class T> boost::shared_ptr<T> make_shared(std::allocator<T> a);
template<class T, class A1> boost::shared_ptr<T> make_shared(const A1&);
template<class T, class A1, class A2> ... make_shared(const A1&, const A2&);
template<class T, class A1, class A2, class A3> ... make_shared(const A1&, const A2&, const A3&);
}
```
Internals: `rbx::detail::sp_aligned_storage<N,A>` (union with `boost::type_with_alignment<A>`), `sp_ms_deleter<T>` (placement storage + destroy-on-invoke).

## Usage
Drop-in for engine code on old boost where `boost::make_shared` was unavailable ("When we upgrade we can use boost directly" per comment). Up to 3 constructor args supported, all by const-ref.

## Gotchas
- In-file TODO: "may not support shared_from_this properly" — avoid combining rbx::make_shared results with enable_shared_from_this until verified.
- Args are passed by `const&`: no move semantics (guarded `BOOST_HAS_RVALUE_REFS sp_forward` exists but unused in these overloads).
- Fixed arity (0–3); larger constructors fall back to plain `new`.
- Copy-constructor of the deleter deliberately does NOT copy `storage_` — safe only because shared_ptr's deleter copy happens pre-construction.
