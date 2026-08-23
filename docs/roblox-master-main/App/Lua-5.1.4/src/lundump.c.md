# App/Lua-5.1.4/src/lundump.c

## Purpose
Binary chunk deserializer ($Id: lundump.c,v 2.7.1.4): `luaU_undump` verifies the 12-byte header against `luaU_header`, then recursively rebuilds the Proto tree (source, line bounds, nups/numparams/vararg/maxstacksize, code vector, constants, debug sections), validating every count (`LoadInt` rejects negatives), string size, constant tag, nesting depth (`LUAI_MAXCCALLS`), and finally bytecode integrity via `luaG_checkcode`. Also defines `luaU_header` itself.

## API
```c
Proto* luaU_undump (lua_State* L, ZIO* Z, Mbuffer* buff, const char* name);
void   luaU_header (char* h);   /* "\x1bLua" 51 00 <endian> <sizeof int,size_t,
                                   Instruction,lua_Number> <integral?> */

/* internals */ LoadState, LoadBlock/Char/Int/Number/String/Vector,
               LoadCode, LoadConstants, LoadDebug, LoadFunction, LoadHeader
#define IF(c,s) if (c) error(S,s)          /* unless LUAC_TRUST_BINARIES */
static void error(LoadState*, const char*); /* pushfstring + throw LUA_ERRSYNTAX */
```

## Usage
- **No live dispatch in this tree**: `ldo.c`'s `f_parser` calls `luaY_parser` unconditionally (the stock binary-sniff branch was removed), and a repo-wide grep finds NO caller of `luaU_undump` outside lundump.c itself. The loader additionally compiles only under `#ifndef LUAVM_SECURE` — so this whole file is dead code at runtime in shipping configurations; Roblox's real chunk pipeline is LuaSerializer/LuaVMServer (`rbxDaxEncode`-keyed streams deserialized engine-side). Kept for tooling/non-secure builds.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`LoadCode` allocates and reads `InstructionV`** (`luaM_newvector(S->L,n,InstructionV)`, `LoadVector(...,sizeof(InstructionV))`) instead of stock `Instruction` — chunks carry the Roblox instruction container.
2. **Post-load validation calls `luaG_checkcode(f, 0)`** — Roblox extended the verifier with a key parameter (stock has none); here it passes 0. The keyed variant is used elsewhere (`LuaSerializer.inl`: `luaG_checkcode(p, L->l_G->ckey)`).
3. **Entire loader wrapped in `#ifndef LUAVM_SECURE`** — secure builds contain no undump path at all (matching ldump.c's stripped dump); `luaU_header` remains available outside the guard.
4. Optional `LUAC_TRUST_BINARIES` compiles away all `IF` integrity checks (stock feature retained).
5. UNKNOWN: nothing re-keys or validates `ckey` at load time — a chunk decoded for VM A loads cleanly into VM B and faults only during execution (no evidence of load-time key binding anywhere in this file).

## Gotchas
- Header mismatch throws `LUA_ERRSYNTAX` ("<name>: bad header in precompiled chunk") — engine callers must be inside protected frames.
- `sizeof(size_t)` participates in the header: 32/64-bit mixing fails loudly, good.
- Key-0 validation RESOLVED: `luaG_checkcode(f, 0)` (line 178) is safe only because this loader exists solely in non-secure builds, where every `rbxDecode*` in lopcodes.h is a compile-time identity passthrough that ignores its key argument — validation therefore runs on plaintext structure. Under keyed (`LUAVM_SECURE && !RBX_RCC_SECURITY`) compilation, `i.v * 0 == 0` would decode every word to the constant 0 (opcode value 0 = OP_LOADBOOL under the fixed shuffle; never OP_RETURN), so `precheck` would reject every chunk — key 0 validates nothing real and is never used against keyed data. Live keyed verification happens in LuaSerializer.inl with `L->l_G->ckey`, and `luaV_execute` additionally refuses live keys < 2.

