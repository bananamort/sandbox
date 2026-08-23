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
- `lua_load` in `ldo.c` sniffs the first `LUAC_HEADERSIZE` bytes via `luaZ_read`; if they match `luaU_header` output it dispatches to `luaU_undump`, else to `luaY_parser`.
- In this Roblox tree, plaintext source never reaches `luaY_parser` from engine callers: `App/script/LuaVMServer.cpp` compiles text with an internal-core VM keyed by `LUAVM_INTERNAL_CORE_ENCODE_KEY`/`DECODE_KEY` (641/6700417) and ships the resulting binary chunk through this path, while client VMs receive precompiled chunks decoded with their per-VM `global_State::ckey`.

## Roblox modifications (vs stock Lua 5.1.4)
1. File content itself is stock 5.1.4 — version/format constants untouched.
2. Semantics change arrives via `lundump.c`/`ldump.c`: dumped protos carry Roblox-opfuscated `InstructionV` arrays keyed by the dumping state's `ckey`, so a chunk is only loadable by a VM whose `ckey` matches (see lstate.h.md). UNKNOWN: whether Roblox altered `LUAC_FORMAT` to tag its own chunks (no evidence in this header; check lundump.c's `LoadHeader` for deviations).
3. `luac.c`/`print.c` in this tree operate under `luac_c` assumptions that no longer hold for runtime chunks (they assume unobfuscated instructions).

## Gotchas
- Header check is exact-match over all 12 bytes including `\x64` format byte; any drift silently routes binary data into the text parser.
- A chunk undumped into a VM with mismatched `ckey` produces garbage instructions rather than a clean error — the decode multiply happens per-instruction at run time, not at load validation time (UNKNOWN: whether LoadFunction validates ckey; verify in lundump.c).

