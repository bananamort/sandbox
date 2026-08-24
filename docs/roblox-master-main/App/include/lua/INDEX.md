# App/include/lua — Index

Lua integration layer for this patched Lua 5.1 VM: the C++ umbrella header with RAII helpers, the userdata bridging templates every Lua-facing class builds on, and ten decoy-stub units (1000 inert `LuaStubGen<N>` callables total) used as anti-tamper filler.

## Files

- [LuaBridge.md](LuaBridge.md) — Bridge/SharedPtrBridge/SingletonBridge userdata reuse machinery + member-function closures.
- [lua.md](lua.md) — lua.hpp umbrella: safe tostring variants, ScopedPopper, ScopedState.
- [luaStubs0.md](luaStubs0.md) … [luaStubs9.md](luaStubs9.md) — decoy stub units, 100 `LuaStubGen<N>` globals each.

## Related

- Vendored VM sources: `App/Lua-5.1.4/` (certified docs at `docs/roblox-master-main/App/Lua-5.1.4/`).
- Bridge consumers: `../script/` (ScriptContext, Lua*Bridge headers).
