# App/include/lua/luaStubs1.h

## Purpose

Second decoy-stub unit: 100 global `RBX::Lua::LuaStubGen<N> stubN;` definitions (stub339, stub510, ... stub463) with template IDs disjoint from the other luaStubs files. Same anti-tamper filler role — inflating the population of Lua-callable stub functions.

## Declared API

- 100 `LuaStubGen<N>` file-scope globals; nothing else. (FIXED: doc previously claimed 99 — grep-verified 100 definition lines.)

## Usage notes

- See [luaStubs0.md](luaStubs0.md) for the shared pattern and caveats.

## Gotchas

- UNKNOWN: per-ID behavior differences, if any, are encoded in LuaStubGen's implementation, not here.
