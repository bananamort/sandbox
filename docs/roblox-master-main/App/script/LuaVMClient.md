# App/script/LuaVMClient.cpp

## Purpose

The client-side implementation of the `LuaVM` namespace facade (declared in App/include/script/LuaVM.h). Clients cannot compile Lua source at all — `load` exclusively *deserializes* precompiled, encrypted bytecode containers (RSB1) shipped in core scripts or received from the server. Also stubs the Lua parser to a hard error and embeds the giant generated table of core-script bytecodes (`LuaGenCS.inl`).

## API

Namespace `LuaVM` functions defined here:

- `std::string compile(const std::string& source)` — returns "" (no client compiler).
- `std::string compileLegacy(const std::string& source)` — returns "".
- `int load(lua_State* L, const RBX::ProtectedString& source, const char* chunkname, unsigned int modkey)` — calls `LuaDeserializer::deserialize(L, source.getBytecode(), chunkname, modkey)` inside try/catch; `std::bad_alloc` → `LuaDeserializer::deserializeFailure(L, chunkname)`. The deserializer comes from LuaSerializer.inl compiled with `#define LUAVM_DESERIALIZER`.
- `unsigned int getKey()` — returns `LUAVM_KEY_DUMMY` ("initial value, it will be corrected by the server via SET_GLOBALS packet").
- `std::string compileCore(const std::string& source)` — returns "".
- `unsigned int getKeyCore()` — returns `LUAVM_INTERNAL_CORE_DECODE_KEY`.
- `unsigned int getModKeyCore()` — returns `LUAVM_MODKEY_DUMMY` (server-corrected as above).
- `bool useSecureReplication()` — returns true.
- `bool canCompileScripts()` — returns false.
- `std::string getBytecodeCore(const std::string& name)` — looks up `RBX::rot13(name)` in the embedded array `gCoreScripts[]` (`struct CoreScriptBytecode { const char* name; const unsigned char* value; size_t dataSize; }`) and returns the bytes as a string; empty string if absent.
- `boost::unordered_map<std::string, std::string> getBytecodeCoreModules()` — flattens embedded `gCoreModuleScripts[]` into a name→bytecode map.
- `unsigned int rbxOldEncode(unsigned int i, int pc, unsigned int key)` / `unsigned int rbxDaxEncode(unsigned int i, int pc, unsigned int key)` — identity functions on the client.
- Global (external linkage, replaces the stock parser for the whole binary): `Proto *luaY_parser(lua_State*, ZIO*, Mbuffer*, const char*)` — pushes "" and `luaD_throw(L, LUA_ERRSYNTAX)`, so any attempt to parse source text on a client fails.

## Usage

`ScriptContext` calls into this namespace everywhere (`LuaVM::load`, `canCompileScripts`, `getKeyCore`, `setKeys` path); `ScriptContext::openState`'s ckey assignment branches on `canCompileScripts()` which is false here. Core scripts reach the client through `getBytecodeCore`/`getBytecodeCoreModules` (consumed by CoreScript loading code outside this module). The build selects between implementations by linking LuaVMClient.cpp (client), LuaVMServer.cpp (server), or LuaVMDummy.cpp (tests/studio-style builds).

## Gotchas

- This file is why clients only ever run serialized+encrypted bytecode: with `luaY_parser` stubbed, even a direct `lua_load` of text cannot succeed; `ScriptContext::loadstring` additionally checks `LuaVM::canCompileScripts()` and throws "loadstring() is not available".
- `gCoreScripts` names are rot13'd before comparison — the embedded table stores obfuscated keys; `LuaGenCS.inl` (22k lines, included here via `#include "LuaGenCS.inl"`) is the generated data blob and defines both arrays.
- `getKey()` returning LUAVM_KEY_DUMMY is safe only because the real key arrives later in the SET_GLOBALS replication packet — a graft that changes handshake ordering will break decryption.
- `rbxOldEncode/rbxDaxEncode` are identities on the client because clients never encode, only decode; do not "simplify" them away without checking the deserializer's expectations.
