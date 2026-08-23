# App/Lua-5.1.4/src/lundump.h

## Purpose
Header for loading precompiled Lua chunks ($Id: lundump.h,v 1.37.1.1). Declares `luaU_undump` (deserialize a `Proto` from a ZIO stream), `luaU_header` (build the 12-byte format signature), `luaU_dump` (implemented in ldump.c), and `luaU_print` (luac-only pretty-printer). Defines the binary-chunk magic constants.

## API
```c
LUAI_FUNC Proto* luaU_undump (lua_State* L, ZIO* Z, Mbuffer* buff, const char* name);
LUAI_FUNC void   luaU_header (char* h);            /* builds LUAC_HEADERSIZE bytes */
LUAI_FUNC int    luaU_dump   (lua_State* L, const Proto* f, lua_Writer w, void* data, int strip);

#define LUAC_VERSION      0x51   /* Lua 5.1 */
#define LUAC_FORMAT       0      /* official format id */
#define LUAC_HEADERSIZE   12
```

## Usage
- **Not dispatched in this tree**: `ldo.c`'s `f_parser` calls `luaY_parser` unconditionally (no signature sniff, no `luaU_undump` call anywhere in the repo), and lundump.c's loader is `#ifndef LUAVM_SECURE`. Engine path instead: `App/script/LuaVMServer.cpp` compiles text with an internal-core VM keyed by `LUAVM_INTERNAL_CORE_ENCODE_KEY`/`DECODE_KEY` (641/6700417) and ships LuaSerializer-keyed binary chunks; client VMs receive them keyed by their per-VM `global_State::ckey`, deserialized engine-side. This header/lundump pair survives for tooling and non-secure builds.

## Roblox modifications (vs stock Lua 5.1.4)
1. File content itself is stock 5.1.4 — version/format constants untouched (`LUAC_FORMAT` stays 0; RESOLVED: nothing in luaU_header/LoadHeader re-tags chunks).
2. Semantics change arrives via `lundump.c`/`ldump.c` (both compiled out under `LUAVM_SECURE`) and via the engine's LuaSerializer pipeline: dumped protos carry Roblox-obfuscated `InstructionV` arrays keyed by the dumping state's key, so a chunk is only loadable by a VM whose key matches (see lstate.h.md). Note ldump.c itself references no key — the obfuscated words are simply stored as-is.
3. `luac.c`/`print.c` in this tree operate under `luac_c` assumptions that no longer hold for runtime chunks (they assume unobfuscated instructions) and are `#ifndef LUAVM_SECURE` anyway.

## Gotchas
- Header check is exact-match over all 12 bytes including the format byte `\x00`; any drift silently routes binary data into the text parser.
- No load-time ckey binding exists anywhere (RESOLVED, was UNKNOWN): `LoadFunction` validates only structural integrity via `luaG_checkcode(f, 0)` — inert-key identity validation that works because the loader exists solely in non-secure builds where decoders ignore keys entirely.

