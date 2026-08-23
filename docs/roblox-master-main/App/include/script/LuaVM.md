# App/include/script/LuaVM.h

## Purpose

Declares the `LuaVM` namespace — script compile/load entry points and per-script obfuscation keys — plus the security macro scaffolding (`LUAVM_SECURE`, shuffle macros, `LuaVMValue<T>` pointer-relative field obfuscation, instruction/line encoders) and, on secure-double platforms, `LuaSecureDouble` (SSE2 XOR-masked doubles). This is the header that defines how bytecode keys work in this patched engine.

## Declared API

Macros / build flags:
- `RBX_SECURE_DOUBLE` defined when `(WIN32 || (Apple && !iOS)) && !RBX_STUDIO_BUILD`; pulls `<emmintrin.h>`.
- `LUAVM_SECURE` defined when NOT `RBX_STUDIO_BUILD`.
- `LUAVM_SHUFFLE_COMMA` = `,`; `LUAVM_SHUFFLE2..9(sep, a0..aN)` permute argument order under `LUAVM_SECURE`, identity order otherwise.
- `RBX_ALIGN(s)` → `_declspec(align(s))` on WIN32 else `__attribute__((__aligned__(s)))`.
- `LUAVM_ENCODELINE/DECODELINE(line, pc)` — secure: `(line) ^ ((pc) << 8)`; plain otherwise.
- `LUAVM_ENCODEINSN(insn, key)` — secure: `(insn) * key`; `LUAVM_DECODEINSN(insn, key)` — secure: `(insn).v * key` (note InstructionV `.v` storage).
- `typedef unsigned int (*RbxOpEncoder)(unsigned int i, int pc, unsigned key);`
- Core-script fixed keys (comment: "Don't use these except in LuaVM*.cpp! These are defines to make sure they don't end up in an executable by complete accident"): `LUAVM_INTERNAL_CORE_ENCODE_KEY 641`, `LUAVM_INTERNAL_CORE_DECODE_KEY 6700417`.
- Sentinel keys: `LUAVM_KEY_DUMMY 1`, `LUAVM_KEY_INVALID 0`, `LUAVM_MODKEY_DUMMY 1`.

Types:
- `template <typename T> class LuaVMValue` — obfuscated primitive field; `operator const T()` decodes as `(T)((uintptr_t)storage + reinterpret_cast<uintptr_t>(this))` under LUAVM_SECURE (address-relative additive), assignment mirrors with subtraction; `operator->()` forwards to decode. Header warning: "this will give incorrect results if T = float."

Namespace `LuaVM`:
- Regular scripts: `std::string compile(const std::string& source);` `std::string compileLegacy(const std::string& source);` `int load(lua_State* L, const RBX::ProtectedString& source, const char* chunkname, unsigned int modkey = 1);` `unsigned int getKey();`
- Core scripts: `std::string compileCore(const std::string& source);` `unsigned int getKeyCore();` `unsigned int getModKeyCore();`
- Policy queries: `bool useSecureReplication();` ("Controls whether replication uses bytecode or source code"), `bool canCompileScripts();`
- Embedded core bytecode: `std::string getBytecodeCore(const std::string& name);` `boost::unordered_map<std::string, std::string> getBytecodeCoreModules();`
- Encoders: `unsigned int rbxOldEncode(unsigned int i, int pc, unsigned int key);` ("Old Encoding Scheme") and `unsigned int rbxDaxEncode(...)` ("Dual-Affine-Xor Encoding").

Secure doubles (`#if defined(RBX_SECURE_DOUBLE)`):
- `class LuaSecureDouble` — private `double storage;` static `RBX_ALIGN(16) int luaXorMask[4];` conversion/assignment XOR the double against the mask via SSE2 `_mm_xor_pd`; `static void initDouble();`. Comment caveat: "users who can find a value can still change magnitude or sign easily."

## Usage notes

- Paired implementation documented under certified App/script module (`docs/roblox-master-main/App/script/`) including the encoder/key-inverse-multiply flow.
- Certification cross-reference: `lua_unlock`'s `_ReturnAddress()` anti-tamper (luaconf.h:965–976) is part of the same secure-build posture.

## Gotchas

- Decode of instructions multiplies by key (`(insn).v * key`) while encode also multiplies — consistent only because unsigned overflow wraps; the "key inverse multiply" happens at a different layer (see certified ScriptContext/LuaSerializer docs).
- `LUAVM_INTERNAL_CORE_*` keys are #defines precisely so accidental linkage embeds them; treat any new reference outside LuaVM*.cpp as a leak.
- Key 0 is inert by design: keyed verification callers exist only in non-secure builds where decoders are identity passthroughs (resolved in App/Lua-5.1.4 INDEX §RESOLVED); `luaV_execute` refuses keys < 2.
- `LuaVMValue<T>` stores address-relative offsets — copying instances to different addresses breaks decoding; do not memcpy or relocate objects containing these fields.
