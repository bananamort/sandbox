# App/include/script/ExitHandlers.h

## Purpose

Declares the continuation plumbing used when Lua threads finish: `RBX::Scripts::Continuations` holds script-level success/error callbacks operating on `Reflection::Tuple` results, and `RBX::Lua::Continuations` adapts those into `lua_State*`-flavored boost functions invoked from `ScriptContext::resume`.

## Declared API

- `namespace RBX::Scripts`
  - `typedef boost::function<void(shared_ptr<const Reflection::Tuple> results)> SuccessHandler;`
  - `typedef boost::function<void(const char* message, const char* callStack, shared_ptr<BaseScript> source, int line)> ErrorHandler;`
  - `struct Continuations { SuccessHandler successHandler; ErrorHandler errorHandler; bool empty() const; };` (`empty()` inline: both handlers empty)
- `namespace RBX::Lua`
  - `class Continuations`
    - `Continuations(const Scripts::Continuations& eh);` — converting ctor
    - `Continuations();` (empty)
    - `boost::function<void(lua_State*)> success;` — "called when the thread exits via ScriptContext::resume"
    - `boost::function<void(lua_State*)> error;` — "called when the thread errors via ScriptContext::resume"
    - Private statics: `static void onSuccessHandler(lua_State* thread, Scripts::SuccessHandler handler);` `static void onErrorHandler(lua_State* thread, Scripts::ErrorHandler handler);`

## Usage notes

- Forward-declares `struct lua_State` and `RBX::BaseScript`; only needs `reflection/Type.h` for Tuple.
- Paired implementation documented under certified App/script module.

## Gotchas

- Error handlers receive raw `const char*` message/callstack pointers valid only during the callback invocation.
- The two same-named `Continuations` types in sibling namespaces are intentionally distinct — mixing them up compiles poorly but the converting ctor exists precisely for the handoff.
