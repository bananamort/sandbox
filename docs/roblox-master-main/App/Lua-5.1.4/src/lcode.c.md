# App/Lua-5.1.4/src/lcode.c

## Purpose
Code generator ($Id: lcode.c,v 2.25.1.3): instruction emission with jump-list bookkeeping (`luaK_code/codeABC/codeABx`, `fixjump/getjump/getjumpcontrol`, patch lists `patchlistaux/concat/patchtohere/jpc discharge`), LOADNIL coalescing optimization, register allocation (`reserveregs/freereg/freeexp/checkstack`), constant pooling through the FuncState dedup table (`addk/stringK/numberK/boolK/nilK` — nil keyed by the table itself), expression discharge to registers/RK slots (`discharge2reg/exp2reg/exp2anyreg/exp2RK/setreturns/setoneret/storevar/self`), conditional-jump synthesis for and/or/not/comparisons (`goiftrue/goiffalse/codenot/invertjump/jumponcond`), arithmetic/comparison coding with constant folding (`constfolding` skips div/mod-by-zero and NaN results, no folding for LEN), SETLIST emission incl. >255-element extra-word form.

## API
```c
/* all LUAI_FUNC per lcode.h; entire file compiled only #ifdef LUAVM_COMPILER */
int  luaK_codeABC/codeABx (FuncState*, OpCode, ...);
void luaK_ret/jump-patch family, exp2*/storevar/self/indexed,
     goiftrue/goiffalse/prefix/infix/posfix/setlist/fixline ...
static int luaK_code (FuncState *fs, Instruction i, int line);
```

## Usage
- Called exclusively by lparser.c grammar actions; produces plaintext instructions into `Proto::code` (as `InstructionV` cells) plus parallel lineinfo. In secure builds lineinfo is encoded later by lparser.c's `finalize()`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Whole unit guarded `#ifdef LUAVM_COMPILER`** (matches lparser.c).
2. **Instruction storage routed through `.v`**: every read/write of the code array goes through the `InstructionV` union member — `previous = &fs->f->code[fs->pc-1].v`, `f->code[fs->pc].v = i`, growth typed `InstructionV`. Stock manipulates bare `Instruction` words. Combined with lcode.h's `getcode` this makes ALL backpatching Roblox-typed.
3. Emitted values are still PLAINTEXT at compile time — obfuscation/keying happens after compilation (dump/load pipeline); nothing here multiplies by ckey.
4. Otherwise algorithm-for-algorithm stock 5.1.4.

## Gotchas
- Jump lists are threaded THROUGH instruction sBx fields; any pass that reorders or deletes instructions without re-walking lists corrupts control flow (the compiler's own invariants assume append-only + patch-at-end).
- `constfolding` refuses NaN and div/mod by zero so runtime errors are preserved; folding happens in double precision regardless of target float size.
- `MAXINDEXRK` bounds RK constants; overflowing silently spills to registers (perf cliff, not an error).

