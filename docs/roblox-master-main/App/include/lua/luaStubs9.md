# App/include/lua/luaStubs9.h

## Purpose

Tenth decoy-stub unit: 100 global `RBX::Lua::LuaStubGen<N> stubN;` definitions (stub137, stub966, ... stub673, including stub0); same anti-tamper filler pattern as the other luaStubs files. Across luaStubs0–9 this yields 1000 unique stub IDs spanning 0–999 (FIXED: doc previously claimed 99 per file / 990 total — grep-verified 100 definition lines each, 1000 unique names).

## Declared API

- 100 `LuaStubGen<N>` file-scope globals; nothing else.

## Usage notes

- See [luaStubs0.md](luaStubs0.md).

## Gotchas

- UNKNOWN: LuaStubGen semantics live in its defining .cpp.
