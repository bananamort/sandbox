# App/Lua-5.1.4/src/luac.c

## Purpose
The Lua compiler CLI ($Id: luac.c,v 1.54): parses input files (or stdin) via luaL_loadfile into protos, optionally combines multiple chunks under a synthetic `=(luac)` main proto emitting CLOSURE/CALL/RETURN stubs (`combine`), lists bytecode (`-l`, via luaU_print), and dumps binary chunks (`-o file`, `-s` strip, `-p` parse-only) through luaU_dump to a FILE writer.

## API
```c
int main(int argc, char* argv[]);
/* internal: doargs/combine/writer/pmain/fatal/cannot/usage */
#define toproto(L,i) (clvalue(L->top+(i))->l.p)
```

## Usage
- Build tool for producing binary chunks offline. In THIS tree the compiler proper (lparser.c/lcode.c) only compiles under `LUAVM_COMPILER` (defined by App/script/LuaVMDummy.cpp / LuaVMServer.cpp); luac.exe itself is not referenced by any engine build file. As written it cannot even compile against these headers: `llimits.h` is C++-only (`InstructionP` has a constructor, no `__cplusplus` guard; luaconf.h pulls in boost headers), and `combine()`'s `f->code=luaM_newvector(L,pc,Instruction)` assigns `Instruction*` to the `LuaVMValue<InstructionV*>` field — an ill-formed conversion. Treat as vestigial stock tooling, kept for reference.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`combine` allocates code as plain `Instruction`** (`luaM_newvector(L,pc,Instruction)`, line 131) while the rest of the tree types `Proto::code` as `LuaVMValue<InstructionV*>` — a latent type mismatch that confirms this file is not built anywhere in the Roblox tree; emitted instructions are unkeyed.
2. Otherwise stock 5.1.4 flow (options parsing, listing levels, strip flag).

## Gotchas
- Chunks produced here carry key-agnostic plaintext instructions: loading them into a keyed VM fails validation or faults at dispatch — engine chunks must go through the ScriptContext/LuaSerializer pipeline instead.
- `-l` listing requires luaP_opnames (compiled out under LUAVM_SECURE, see lopcodes.c.md).

