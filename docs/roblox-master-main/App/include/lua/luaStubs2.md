# App/include/lua/luaStubs2.h

## Purpose

Third decoy-stub unit: 100 global `RBX::Lua::LuaStubGen<N> stubN;` definitions (stub925, stub311, ... stub485) with IDs disjoint from sibling files; identical anti-tamper filler pattern.

## Declared API

- 100 `LuaStubGen<N>` file-scope globals; nothing else. (FIXED: doc previously claimed 99 — grep-verified 100 definition lines.)

## Usage notes

- See [luaStubs0.md](luaStubs0.md).

## Gotchas

- UNKNOWN: LuaStubGen semantics live in its defining .cpp.
