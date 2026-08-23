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
- This is how compiled text becomes shippable binary chunks in the engine pipeline: an internal-core VM compiles script text (key 641 path), then dump hands the Proto to a memory writer whose buffer goes to ProtectedString storage; clients later undump it into per-VM-keyed states.
- Format written here must match lundump.c's reader byte-for-byte (`DumpInt` = 4 bytes native-endian, strings length+1 including trailing NUL).

## Roblox modifications (vs stock Lua 5.1.4)
1. **Everything except `DumpHeader` is wrapped in `#ifndef LUAVM_SECURE`** — secure builds emit only the header from `luaU_dump` (status stays 0), i.e. dumping is disabled in production/secure configurations.
2. **Code dumped via `sizeof(Instruction)`**: in this tree `Instruction` is the Roblox value type (see lopcodes.h.md — `InstructionV` union with `.v`); the dumped payload is therefore the obfuscated instruction stream of the compiling VM, not stock words.
3. UNKNOWN: whether the writer callback in engine use post-processes the buffer further (e.g. re-keying ckey) — that logic would live in App/script callers, not here.

## Gotchas
- No byte-swapping: chunks are only portable between same-endian, same-`sizeof(int)`/`sizeof(lua_Number)` platforms (stock limitation, unchanged).
- With LUAVM_SECURE defined the function silently "succeeds" writing just a header — callers checking status==0 get a useless 12-byte chunk rather than an error.
- `DumpString(NULL)` writes size 0 (valid empty string on load), used when stripping or when source matches parent.

