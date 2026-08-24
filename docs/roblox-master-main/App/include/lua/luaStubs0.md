# App/include/lua/luaStubs0.h

## Purpose

Defines 99 global objects `RBX::Lua::LuaStubGen<N> stubN;` with fixed template IDs (stub609, stub288, stub646, ... stub620 — IDs in the 0–999 decoy space). These are anti-tamper filler: `LuaStubGen` (defined in the LuaBridge implementation layer) instantiates inert callable objects so the binary carries a large field of near-identical Lua-callable stubs, obscuring real function locations.

## Declared API

- 99 instantiations of `template<int N> LuaStubGen<N>` as file-scope globals; no other declarations.

## Usage notes

- Included by ScriptContext's library-registration path to materialize the stub functions into a VM's registry.

## Gotchas

- UNKNOWN (header-level): exact runtime behavior of LuaStubGen<N> (no-op CFunction vs crash trap) lives in its defining .cpp — verify there before assuming inertness.
- Template IDs are unique across luaStubs0–9 and deliberately non-sequential.
