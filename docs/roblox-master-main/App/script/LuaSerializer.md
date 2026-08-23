# App/script/LuaSerializer.inl

## Purpose

Header-only implementation of the RSB1 bytecode container format, compiled in two flavors via `#define LUAVM_SERIALIZER` (class `LuaSerializer`, included by LuaVMServer.cpp) and `#define LUAVM_DESERIALIZER` (class `LuaDeserializer`, included by LuaVMClient.cpp). Serializes a parsed 5.1 Proto tree into a compact stream with an interned string table, LZ4-compresses it, prepends the "RSB1" magic plus uncompressed size, then XOR-scrambles everything with an XXH32 hash of the result — and reverses that process on the client, rebuilding `Proto`/`Closure` objects by hand instead of going through lua_load.

## API

Format constants: `static const char kBytecodeMagic[] = "RSB1"`, `kBytecodeHashSeed = 42`, `kBytecodeHashMultiplier = 41`; `enum BytecodeConstantType { Constant_Nil, Constant_False, Constant_True, Constant_Number, Constant_String }`.

- `class LuaSerializer` (LUAVM_SERIALIZER only):
  - `static std::string serialize(lua_State* L, const std::string& source, RbxOpEncoder encode, unsigned int ckey)` — parses via `lua_load(L, getS, &ls, "=")`; writes error byte plus optional error string, or the proto tree (`writeRoot`); LZ4-compresses (`LZ4_compress` with `LZ4_compressBound`); builds `"RSB1" + int32 dataSize + compressed`; computes `XXH32(result, kBytecodeHashSeed)` and XORs every byte with `hashbytes[i % 4] + i * kBytecodeHashMultiplier`.
  - private: `static void writeRoot(std::ostringstream&, Proto*, RbxOpEncoder, unsigned int ckey)` (reserves a patched 4-byte string-table offset); `static void writeProto(...)` recursive writer (sizep/sizek/sizecode/sizelocvars/sizelineinfo/sizeupvalues ints; maxstacksize/is_vararg/nups/numparams bytes; constants via BytecodeConstantType; delta-coded lineinfo with comment "the lines were previously encoded"; locvars; upvalues; code words written as `encode(p->code[i].v, i, ckey)`; child protos); `writeByte/writeInt/writeDouble/writeString` (strings interned through `RBX::DenseHashMap<const TString*, unsigned int>`, index 0 = NULL); local `LoadS`+`getS` reader.
- `class LuaDeserializer` (LUAVM_DESERIALIZER only):
  - `static int deserialize(lua_State* L, const std::string& code, const char* chunkname, unsigned int modkey)` — empty input → `deserializeError(L, "", chunkname)` (comment: "deserves a special 'empty error' case for obscurity"); ≤8 bytes → failure; recovers the 4 hash bytes (`hashbytes[i] ^= kBytecodeMagic[i]; hashbytes[i] -= i * kBytecodeHashMultiplier`), un-XORs the whole buffer, verifies `XXH32(buffer, seed) == hash`; reads dataSize at offset 4 and `LZ4_decompress_safe(&buffer[8], ...)`; nonzero error byte → embedded compile-error path with sanity check `length == data.size() - 5`; success → `TString* source = luaS_new(L, chunkname); Proto* p = readRoot(ss, L, source, modkey); Closure* cl = luaF_newLclosure(L, p->nups, hvalue(gt(L))); cl->l.p = p;` fresh upvalues via `luaF_newupval`, `setclvalue(L, L->top, cl); incr_top(L);`, then `RBXASSERT_VERY_FAST(luaG_checkcode(p, L->l_G->ckey))`; returns 0.
  - `static int deserializeFailure(lua_State*, const char*)` — sets global `RBX::DataModel::sendStats |= HATE_INVALID_BYTECODE`, then empty-text deserializeError.
  - `static int deserializeError(lua_State*, const std::string&, const char*, int code = 1)` — pushes `luaO_chunkid(chunkid) + error`, returns code.
  - private: `class VectorStream` (read/tellg/seekg over std::vector<char>; over-reads clamp silently); `static Proto* readRoot(VectorStream&, lua_State*, TString* source, unsigned int modkey)` (jumps to string table, interns every string with `luaS_newlstr`, rewinds to streamStart+4); `static Proto* readProto(...)` recursive builder allocating via `luaM_newvector` — `p->code` is an `InstructionV` array and each word decodes as `p->code[i].v = readInt(ss) * modkey;`.
- Read helpers: `readByte/readInt/readDouble/readString` (string index 0 → NULL, else strings[index-1]).

## Usage

Included only from App/script/LuaVMServer.cpp (LUAVM_SERIALIZER) and App/script/LuaVMClient.cpp (LUAVM_DESERIALIZER); `LuaVM::compile*/load` are thin wrappers around these classes. On clients the rebuilt closure appears on the Lua stack exactly where `ScriptContext::executeInNewThread` expects the loaded chunk. `luaG_checkcode` verifies against the VM's current `l_G->ckey`, tying container validity to the replication-delivered key state set up by `ScriptContext::setKeys`.

## Gotchas

- Container layout: `[0..3] scrambled hash bytes (= XXH32 adjusted against "RSB1"/multiplier)`, `[4..7] uncompressed dataSize`, `[8..] LZ4 payload`. The XOR keystream `hashbytes[i%4] + i*41` covers the entire post-magic buffer including the size field.
- Instruction decode is multiplication by `modkey` (mod 2^32) — pairs with the encode side where keys are odd and decode keys are multiplicative inverses (see multiplicativeInverse in LuaVMServer.cpp). Any Luau graft replacing InstructionV must redefine this pipeline or ship its own container format end-to-end.
- lineinfo is delta-coded both ways and already obfuscated upstream ("previously encoded").
- Failure paths are deliberately opaque: deserializeFailure pushes an EMPTY error string so tampered bytecode yields no diagnostic, while still raising the HATE_INVALID_BYTECODE telemetry flag globally.
- VectorStream clamps over-reads rather than erroring — malformed containers rely on the xxhash/LZ4 checks upstream to fail first.
- Everything is file-static per including TU: exactly one flavor may be linked per binary.
