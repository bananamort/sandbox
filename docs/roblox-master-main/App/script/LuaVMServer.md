# App/script/LuaVMServer.cpp

## Purpose

The server-side implementation of the `LuaVM` namespace: the only build flavor that can both compile Lua 5.1 source text (it statically compiles in lcode.c/lparser.c) and serialize compiled bytecode into the encrypted RSB1 containers (`LuaSerializer.inl` with LUAVM_SERIALIZER). Owns the process-wide encode/decode key pair used to scramble serialized instruction words (`InstructionV.code[i].v`, see LuaSerializer.inl) and derives the core-script transform key.

## API

Namespace `LuaVM` functions defined here:

- `std::string compile(const std::string& source)` — fresh throwaway state via `luaL_newstate()`, then `LuaSerializer::serialize(L, source, rbxDaxEncode, gLuaKeyPair.first)`, `lua_close`. Produces a DAX-obfuscated, key-encoded serialized chunk.
- `std::string compileLegacy(const std::string& source)` — same but with `rbxOldEncode` (plain instruction encoding, no DAX).
- `std::string compileCore(const std::string& source)` — serializes with the fixed constant `LUAVM_INTERNAL_CORE_ENCODE_KEY`.
- `int load(lua_State* L, const RBX::ProtectedString& source, const char* chunkname, unsigned int modkey)` — the text path: feeds `source.getSource()` through stock `lua_load(L, getS, &ls, chunkname)` using file-static reader `getS`/`struct LoadS`. No post-load encoding is applied on this path.
- `unsigned int getKey()` / `getKeyCore()` — return `gLuaKeyPair.second` (the decode half).
- `unsigned int getModKeyCore()` — returns `LUAVM_INTERNAL_CORE_DECODE_KEY * gLuaKeyPair.first` (the modkey transform handed to clients via SET_GLOBALS).
- `bool useSecureReplication()` — true; `bool canCompileScripts()` — true.
- `getBytecodeCore(name)`/`getBytecodeCoreModules()` — empty stubs (servers don't embed core scripts).
- File-local helpers: `static long long multiplicativeInverse(long long a, long long n)` — extended-Euclid inverse mod 2^32 with `RBXASSERT(r == 1)`; `static uint32_t rbxDaxEncodeOp(uint32_t x, mulEven, addEven, mulOdd, addOdd)` — bitwise per-bit solver; `static std::pair<unsigned int,unsigned int> createLuaKeyPair()` — encode = odd integer derived from `boost::hash_value(RBX::Guid::generateStandardGUID(guid)) * 2 + 1`, decode = its multiplicative inverse mod 2^32 (`RBXASSERT(encode * decode == 1)`); static `gLuaKeyPair = createLuaKeyPair()`.
- Encoders: `unsigned int rbxOldEncode(unsigned int i, int pc, unsigned int key)` → `LUAVM_ENCODEINSN(i, key)`; `unsigned int rbxDaxEncode(unsigned int i, int pc, unsigned int key)` → for OP_CALL/OP_TAILCALL/OP_RETURN/OP_CLOSURE applies `rbxDaxEncodeOp(i, LUAVM_DAX_ME, pc, LUAVM_DAX_MO, LUAVM_DAX_AO)` + `SET_OPCODE(enc, op)`, for OP_MOVE `SETARG_C(enc, (pc|1))`, then `LUAVM_ENCODEINSN(enc, key)`.

## Usage

Same consumers as LuaVMClient.cpp/LuaVMDummy.cpp: `ScriptContext` uses `load` (text path — servers compile scripts directly), `getKey` feeds `l_G->ckey` through ScriptContext::setKeys/onServiceProvider; the build toolchain calls `compile*` to produce bytecode for clients and `getModKeyCore` is shipped in the replication packet. The serializer lives in App/script/LuaSerializer.inl included here with LUAVM_SERIALIZER.

## Gotchas

- The text-path `lua_load` at lines 121–128 is the graft-critical anchor: servers run scripts from raw source, so replacing the parser (Luau) changes exactly this function plus the static includes of lcode.c/lparser.c under `#define LUAVM_COMPILER`.
- `gLuaKeyPair` is initialized once per process from a GUID hash; every serialized script is bound to it, and clients receive `getKey()`'s value via SET_GLOBALS before any bytecode can be decoded — restart ordering matters.
- Core-script keys form a two-level scheme: bytecode is encoded with fixed `LUAVM_INTERNAL_CORE_ENCODE_KEY`; loading into a VM whose ckey equals the internal decode key works directly (modkey = LUAVM_MODKEY_DUMMY in privileged VM), while the normal VM needs `LUAVM_INTERNAL_CORE_DECODE_KEY * gLuaKeyPair.first` as modkey — matching the branch in `ScriptContext::loadLibrary`.
- DAX obfuscation is pc-dependent: the same opcode encodes differently at each instruction index, and OP_MOVE smuggles its pc into arg C — decoders must replicate exact arithmetic (`result*mul ± add` bit equations).
- Like LuaVMDummy.cpp, including ../Lua-5.1.4/src/*.c directly means any Luau graft must excise these includes, not just swap the load call.
