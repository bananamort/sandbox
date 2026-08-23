# App/Lua-5.1.4/src/ldump.c

## Purpose
Binary chunk serializer ($Id: ldump.c,v 2.8.1.1): `luaU_dump` writes a 12-byte header (via `luaU_header`) followed by a recursive function tree — source name, line bounds, nups/numparams/vararg/maxstacksize, code vector, nested constants (nil/bool/number/string), and optional debug info (lineinfo, locvars, upvalue names) — through a caller-supplied `lua_Writer`. `strip` suppresses debug sections.

## API
```c
typedef struct { lua_State* L; lua_Writer writer; void* data; int strip; int status; } DumpState;

LUAI_FUNC int luaU_dump (lua_State* L, const Proto* f,
                         lua_Writer w, void* data, int strip);
/* internal: DumpBlock/DumpChar/DumpInt/DumpNumber/DumpVector/DumpString/
   DumpCode/DumpConstants/DumpDebug/DumpFunction/DumpHeader */
#define DumpCode(f,D) DumpVector(f->code,f->sizecode,sizeof(Instruction),D)
```

## Usage
- **No engine callers**: repo-wide grep finds no caller of `luaU_dump` outside ldump.c itself; Roblox's real pipeline is `LuaSerializer::serialize` (+`rbxDaxEncode`, key 641) writing ProtectedStrings directly. Like lundump.c's loader, the dump body compiles only under `#ifndef LUAVM_SECURE`, so this file is tooling/non-secure-only.
- Format written here must match lundump.c's reader byte-for-byte (`DumpInt` = 4 bytes native-endian, strings length+1 including trailing NUL).

## Roblox modifications (vs stock Lua 5.1.4)
1. **Everything except `DumpHeader` is wrapped in `#ifndef LUAVM_SECURE`** — secure builds emit only the header from `luaU_dump` (status stays 0), i.e. dumping is disabled in production/secure configurations.
2. **Code dumped via `sizeof(Instruction)` from the `InstructionV` array**: `f->code` is `InstructionV*` but the stride used is plain `sizeof(Instruction)` (works because `struct InstructionV { Instruction v; }` has identical size/layout). In non-secure builds nothing ever encoded the words, so the payload is plaintext stock-format code; keyed obfuscation happens only in LuaSerializer, not here.

## Gotchas
- No byte-swapping: chunks are only portable between same-endian, same-`sizeof(int)`/`sizeof(lua_Number)` platforms (stock limitation, unchanged).
- With LUAVM_SECURE defined the function silently "succeeds" writing just a header — callers checking status==0 get a useless 12-byte chunk rather than an error.
- `DumpString(NULL)` writes size 0 (valid empty string on load), used when stripping or when source matches parent.

