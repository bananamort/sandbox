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
- Build tool for producing binary chunks offline. In THIS tree it is only functional in `LUAVM_COMPILER` configurations (needs the real parser linked via ldo/lparser); its output is plaintext-instruction chunks — i.e. suitable for the internal-core compile path, not directly runnable in production keyed VMs without the engine's re-keying pipeline.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`combine` allocates code as plain `Instruction`** (`luaM_newvector(L,pc,Instruction)`) while the rest of the tree types `Proto::code` as `InstructionV*` — a latent type mismatch tolerated by the C build of this tool; emitted instructions are unkeyed.
2. Otherwise stock 5.1.4 flow (options parsing, listing levels, strip flag).

## Gotchas
- Chunks produced here carry `ckey`-agnostic instructions: loading them into a keyed VM fails luaG_checkcode(f,0)-style validation paths or faults at dispatch — engine chunks must go through the ScriptContext/LuaSerializer pipeline instead.
- `-l` listing requires luaP_opnames (compiled out under LUAVM_SECURE, see lopcodes.c.md).

