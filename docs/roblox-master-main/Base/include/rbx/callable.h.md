# callable.h

## Purpose
CRTP-free mixin pair behind rbx::signals slots: `icallable<arity, Signature>` declares a virtual `call(args...)` per arity 0–7, and `callable<Base, Delegate, arity, Signature>` stores the delegate BY VALUE in the slot object and forwards `call` to it. In-file comment: like boost::function but with more efficient storage because the functor is special-cased — usable only from template code that knows the concrete type.

## API
```cpp
template<int arity, typename Signature> class icallable;      // primary; arity 0..7 specializations:
    virtual void call(arg1_type, ..., argN_type) = 0;         // arg types via boost::function_traits
template<class Base, class Delegate, int arity, typename Signature> class callable;
    callable(const Delegate& d, Arg1 baseArg);                // forwards extra arg to Base ctor (e.g. signal*)
    virtual void call(...) { deleg(...); }                    // arity 0..7
```

## Usage
signal.h's `callable_slot : public callable<slot, Delegate, arity, Signature>` — the Delegate is whatever was passed to signal::connect. No other consumers found in Base (it exists for the signals machinery).

## Gotchas
- No #pragma once/include guard — double inclusion redefines classes (compile error); single-include discipline assumed.
- Delegates are copied into each slot; stateful functors shared by reference elsewhere will not observe mutations made through connections.
- Arity ceiling is 7 — signals with more args don't compile.
