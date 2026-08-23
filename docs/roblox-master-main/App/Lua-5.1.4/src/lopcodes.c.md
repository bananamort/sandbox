# App/Lua-5.1.4/src/lopcodes.c

## Purpose
Opcode metadata tables ($Id: lopcodes.c,v 1.37.1.1): `luaP_opnames[]` (debug/disassembler names, ORDER OP) and `luaP_opmodes[]` (per-opcode T/A/B/C/mode bit-packed operand descriptors consumed by the parser's `checkArgMode` and debug tooling). This is the only .c in the core whose entire data payload is wrapped in Roblox obfuscation scaffolding.

## API
```c
#ifndef LUAVM_SECURE
const char *const luaP_opnames[NUM_OPCODES+1] = { "MOVE", ..., NULL };
#endif

#define opmode(t,a,b,c,m) (((t)<<7)|((a)<<6)|((b)<<4)|((c)<<2)|(m))
const lu_byte luaP_opmodes[NUM_OPCODES] = { /* 38 entries, ORDER OP */ };
```

## Usage
- `luaP_opmodes` is consulted by lparser.c (`luaK_...` argument validation via GETARG-mode checks) and by print.c/luac.c for disassembly.
- `luaP_opnames` feeds `luaG_typeerror`-adjacent trace output? No — it is used by print.c (`luaU_print`) and luac listing; compiled out under `LUAVM_SECURE`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`luaP_opnames` guarded by `#ifndef LUAVM_SECURE`** — secure builds strip opcode names entirely (anti-reverse-engineering).
2. **`luaP_opmodes` initializer split into four `LUAVM_SHUFFLE9(...)` + one `LUAVM_SHUFFLE2(...)` blocks with `LUAVM_SHUFFLE_COMMA`** — the build-time shuffle machinery (fixed permutations in `App/include/script/LuaVM.h`, active exactly when `LUAVM_SECURE`) reorders the textual entries so secure and non-secure configurations produce different enum/mode orderings while each stays internally consistent with its shuffled `OpCode` enum.
3. **Inline annotation `(cvx: added op c)` on OP_MOVE** — CVX-era note claiming OpArgU for C added; the mode bytes themselves match stock values. Treat as historical comment, not a functional change.
4. Opcode set itself unchanged: all 38 stock 5.1 opcodes, no additions/removals.

## Gotchas
- The shuffle macros make naive table-index math on source lines wrong; always trust the ORDER OP comments inside each entry.
- Under `LUAVM_SECURE`, any code referencing `luaP_opnames` fails to link — debug/dump tools must be conditionally compiled (print.c does this).
- `opmode` packs into a byte: T(bit7) A(bit6) B(bits4-5) C(bits2-3) mode(bits0-1); changing OpArg enum widths in lopcodes.h breaks this packing.

