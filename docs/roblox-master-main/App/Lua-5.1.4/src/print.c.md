# App/Lua-5.1.4/src/print.c

## Purpose
Bytecode disassembler for luac ($Id: print.c,v 1.55a): `luaU_print` (aliased `PrintFunction`) prints a Proto's header stats, one decoded line per instruction (pc, line, opcode name, operands with RK constant resolution and jump targets), and — with `full` — constants, locals, and upvalue tables; recurses into nested protos. Build-tool only: compiled under `luac_c` and stripped by `LUAVM_SECURE`.

## API
```c
void luaU_print (const Proto* f, int full);   /* declared under #ifdef luac_c in lundump.h */
/* internals: PrintString/PrintConstant/PrintCode/PrintHeader/
   PrintConstants/PrintLocals/PrintUpvalues */
```

## Usage
- Referenced from luac.c (`-l` listing) and historically useful when diffing compiler output. In this tree it is a plaintext-assuming tool: engine chunks carry obfuscated code, so printing an engine-dumped chunk shows garbage unless the instructions were first de-obfuscated or the dump happened on a key-0 state.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Whole file wrapped in `#ifndef LUAVM_SECURE`** — secure builds ship no disassembler.
2. **Instruction fetch goes through the Roblox container**: `const InstructionV* code=f->code; ... Instruction i=code[pc].v;` — stock reads `Instruction i = f->code[pc]` directly. Same pattern for OP_SETLIST's trailing extra-arg word (`code[++pc].v`).
3. Everything else (format strings, RK decoding, jump-target math `sbx+pc+2`) is stock.

## Gotchas
- Prints to stdout via printf/putchar — never callable from engine runtime contexts.
- `getline(f,pc)` comes from ldebug.h; requires non-stripped lineinfo or prints `[-]`.
- Because opnames are compiled out under LUAVM_SECURE (see lopcodes.c.md), PrintCode would not link there even without its own guard — the guards are complementary, not redundant.

