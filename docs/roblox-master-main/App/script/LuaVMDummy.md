# App/script/LuaVMDummy.cpp

## Purpose

The test/studio-flavored implementation of the `LuaVM` namespace: it *does* compile Lua 5.1 source text directly (it statically compiles in lcode.c and lparser.c from ../Lua-5.1.4/src), then applies the DAX opcode obfuscation + instruction encoding locally so unit tests and Studio behave like the desktop pipeline without needing serialized containers. Per its own comment block: Server/Mobile run unobfuscated code, Desktop runs obfuscated serialized code, Studio runs/compiles unobfuscated code — this TU serves the last case (and tests treated as desktop that don't serialize).

## API

Namespace `LuaVM` functions defined here:

- `std::string compile(const std::string& source)` / `compileLegacy(...)` / `compileCore(...)` — all return "" (not used in this configuration).
- `static void finalize(Proto* p, RbxOpEncoder encode, unsigned int ckey)` — recursive: encodes every `p->code[i].v = encode(p->code[i].v, i, ckey)` (comment notes lineinfo was previously encoded), recursing into `p->p[i]`; entire body compiled out under RBX_STUDIO_BUILD.
- `int load(lua_State* L, const RBX::ProtectedString& source, const char* chunkname, unsigned int modkey)` — feeds `source.getSource()` through `lua_load(L, getS, &ls, chunkname)` with file-static reader `getS(lua_State*, void* ud, size_t*)` over a `struct LoadS { const char *s; size_t size; }`; on success grabs `const LClosure*` via `lua_topointer` and calls `finalize(cl->p, rbxDaxEncode, modkey)`; returns the lua_load error code.
- `unsigned int getKey()` / `getKeyCore()` — return `LUAVM_KEY_DUMMY`; `unsigned int getModKeyCore()` — returns `LUAVM_MODKEY_DUMMY`.
- `bool useSecureReplication()` — returns false.
- `bool canCompileScripts()` — returns true.
- `std::string getBytecodeCore(const std::string&)` — returns ""; `getBytecodeCoreModules()` — returns an empty map.
- `unsigned int rbxOldEncode(unsigned int i, int pc, unsigned int key)` — identity.
- `unsigned int rbxDaxEncode(unsigned int i, int pc, unsigned int key)` — non-studio: for OP_CALL/OP_TAILCALL/OP_RETURN/OP_CLOSURE applies bit-level `rbxDaxEncodeOp(i, LUAVM_DAX_ME, pc, LUAVM_DAX_MO, LUAVM_DAX_AO)` then restores the opcode field via `SET_OPCODE(enc, op)`; for OP_MOVE sets `SETARG_C(enc, (pc|1))` ("non-zero"); finally `return LUAVM_ENCODEINSN(enc, key)`. Studio: identity.
- File-local `static uint32_t rbxDaxEncodeOp(uint32_t x, uint32_t mulEven, uint32_t addEven, uint32_t mulOdd, uint32_t addOdd)` (guarded `#ifndef RBX_STUDIO_BUILD`) — bitwise-solves per-bit for the value whose even-bit linear form XOR odd-bit linear form equals the input bits.

## Usage

Selected at link time as the third alternative to LuaVMClient.cpp/LuaVMServer.cpp; consumed identically by `ScriptContext` (`LuaVM::load`, `canCompileScripts()==true` here means `openState` sets every VM's `l_G->ckey = LUAVM_KEY_DUMMY`). Because it includes the actual 5.1 compiler sources with `#define LUAVM_COMPILER`, it documents exactly how Roblox's patched lparser/lcode integrate — the same files a Luau graft must replace wholesale.

## Gotchas

- It includes `../Lua-5.1.4/src/lcode.c` and `lparser.c` directly into the TU under `LUAVM_COMPILER` — symbol collisions with any other copy of the parser are avoided purely by link-time selection; a Luau graft must remove/replace these includes.
- The DAX encoder only obfuscates five opcodes (CALL/TAILCALL/RETURN/CLOSURE/MOVE); everything else passes through `LUAVM_ENCODEINSN(enc, key)` untouched apart from the global instruction scramble — knowing which opcodes carry pc-dependent encodings matters when porting the decoder.
- `finalize` asserts `lua_assert(ckey)` — zero modkeys are invalid outside Studio, where the whole body vanishes and `rbxDaxEncode` becomes identity.
- OP_MOVE's `(pc|1)` trick makes C nonzero so the decoder can distinguish MOVE from other instructions without extra bits.
- `lua_load` here is the stock-text path (the same call LuaVMServer.cpp uses for its text branch) — contrast with the client where text parsing is impossible.
