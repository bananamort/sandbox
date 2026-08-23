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
- Dispatched by `lua_load` when the stream starts with the compiled-chunk signature. Engine path: LuaVMServer/ScriptContext feed ProtectedString-backed binary chunks here after compiling text on an internal-core VM; the resulting protos run under the target VM's `ckey`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`LoadCode` allocates and reads `InstructionV`** (`luaM_newvector(S->L,n,InstructionV)`, `LoadVector(...,sizeof(InstructionV))`) instead of stock `Instruction` — chunks carry the Roblox instruction container.
2. **Post-load validation calls `luaG_checkcode(f, 0)`** — Roblox extended the verifier with a key parameter (stock has none); here it passes 0. The keyed variant is used elsewhere (`LuaSerializer.inl`: `luaG_checkcode(p, L->l_G->ckey)`).
3. **Entire loader wrapped in `#ifndef LUAVM_SECURE`** — secure builds contain no undump path at all (matching ldump.c's stripped dump); `luaU_header` remains available outside the guard.
4. Optional `LUAC_TRUST_BINARIES` compiles away all `IF` integrity checks (stock feature retained).
5. UNKNOWN: nothing re-keys or validates `ckey` at load time — a chunk decoded for VM A loads cleanly into VM B and faults only during execution (no evidence of load-time key binding anywhere in this file).

## Gotchas
- Header mismatch throws `LUA_ERRSYNTAX` ("<name>: bad header in precompiled chunk") — engine callers must be inside protected frames.
- `sizeof(size_t)` participates in the header: 32/64-bit mixing fails loudly, good.
- Because validation runs `luaG_checkcode(f, 0)`, obfuscated streams must either be self-validating under key 0 semantics or bypass this path; treat any change to opcode encoding as breaking undump acceptance. UNKNOWN: exact `checkcode` key semantics (see ldebug.c.md).

