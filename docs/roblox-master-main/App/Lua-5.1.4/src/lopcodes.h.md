# App/Lua-5.1.4/src/lopcodes.h

## Purpose
VM instruction format + opcode definitions (`$Id: lopcodes.h,v 1.125.1.1`). Stock defines a fixed 32-bit instruction (6-bit op low bits, then A/C/B). Roblox's version is the heart of bytecode obfuscation: **reversed bit-field layout**, **shuffled OpCode enum**, and the **`rbxDaxDecode` / `rbxDecodeOp*` decoder family** keyed by `global_State::ckey` plus PC-dependent affine mixing.

## API
### Format & accessors
Sizes unchanged: `SIZE_OP 6`, `SIZE_A 8`, `SIZE_B 9`, `SIZE_C 9`, `SIZE_Bx 18`; limits `MAXARG_A/B/Bx/sBx`, RK machinery (`BITRK/ISK/INDEXK/MAXINDEXRK/RKASK`), `NO_REG`, `LFIELDS_PER_FLUSH 50`.

**Bit positions flip under `LUAVM_SECURE`**:
```c
#ifdef LUAVM_SECURE
#define POS_OP (POS_A + SIZE_A)   /* opcode moves to TOP bits */
#define POS_A  (POS_C + SIZE_C)
#define POS_C  (POS_B + SIZE_B)
#define POS_B  0
#define POS_Bx 0                   /* wait: Bx sits at bit 0 too */
#else  /* stock layout */
#define POS_OP 0
#define POS_A  (POS_OP + SIZE_OP)
#define POS_C  (POS_A + SIZE_A)
#define POS_B  (POS_C + SIZE_C)
#define POS_Bx POS_C
#endif
```
All GET_/SET_/CREATE_ macros (`GET_OPCODE/SET_OPCODE/GETARG_A/B/C/Bx/sBx`, `CREATE_ABC/CREATE_ABx`) are stock text but operate differently because positions differ.

### OpCode enum (shuffled)
All 38 stock opcodes present (`OP_MOVE … OP_VARARG`) but wrapped in `LUAVM_SHUFFLE9×4 + LUAVM_SHUFFLE2` blocks with sentinel `OP___COUNT`; `NUM_OPCODES = OP___COUNT`. Under `LUAVM_SECURE` numeric opcode values ≠ stock order.

### Decoder family (ROBLOX, all `INLINE_OP`)
```c
#if !defined(INLINE_OP) && defined(WIN32) #define INLINE_OP __forceinline
#else                                     #define INLINE_OP inline __attribute__((always_inline))

INLINE_OP uint32_t rbxDaxDecode(uint32_t x, uint32_t mulEven, uint32_t addEven,
                                uint32_t mulOdd, uint32_t addOdd) {
    return (x*mulOdd + addOdd) ^ (x*mulEven + addEven);
}
/* constants */ LUAVM_DAX_MO 0x29451AFB, LUAVM_DAX_ME 0x72394BC8,
                LUAVM_DAX_AO 0x46582A8B, LUAVM_DAX_AE 0x62A0B4E3

#if defined(LUAVM_SECURE) && !defined(RBX_RCC_SECURITY)
Instruction   rbxDecodeArgs(Instruction i, int pc);
  // for OP_CALL/OP_TAILCALL/OP_RETURN/OP_CLOSURE only:
  //   i = rbxDaxDecode(i, LUAVM_DAX_ME, pc, LUAVM_DAX_MO, LUAVM_DAX_AO); SET_OPCODE(i, op);
InstructionP  rbxDecodeOpPartial(InstructionV i, unsigned int ckey); // = i.v*ckey  (whole word mult-decoded; op plaintext)
Instruction   rbxDecodeOp(InstructionP i, int pcRel, unsigned int ckey);      // = rbxDecodeArgs(i.p, pcRel)
Instruction   rbxDecodeOpFast(InstructionP i, unsigned int ckey);             // = i.p
Instruction   rbxDecodeFakeOp(InstructionP i, unsigned int ckey);             // = i.p
Instruction   rbxDecodeOp(InstructionV i, int pcRel, unsigned int ckey);      // = rbxDecodeArgs(i.v*ckey, pcRel)
Instruction   rbxDecodeOpFast(InstructionV i, unsigned int ckey);             // = i.v*ckey
Instruction   rbxDecodeFakeOp(InstructionV i, unsigned int ckey);             // = i.v*ckey
#else  /* identity passthroughs (.v unwrapping only) */
#endif
```

Also `enum OpMode {iABC,iABx,iAsBx}`, `enum OpArgMask {OpArgN,U,R,K}`, `luaP_opmodes[NUM_OPCODES]` + mode getters (`getOpMode/getBMode/getCMode/testAMode/testTMode`), `luaP_opnames[]`.

## Usage
- Decoders are called at every fetch in `lvm.c`'s dispatch loop (`rbxDecodeOpPartial` once per instruction, `rbxDecodeOp` per operand-bearing use, `rbxDecodeOpFast`/`rbxDecodeFakeOp` for jump offsets / SETLIST extra word), plus `ldebug.c` (`precheck`/`symbexec`/`luaG_checkcode(pt, ckey)` verification, `luaG_typeerror`-adjacent info) and `ldo.c:438-439` (`rbxDecodeOpPartial` to test whether the caller frame ends in OP_CALL/OP_TAILCALL). `lundump.c` calls none of them directly — its loader passes literal key `0` to `luaG_checkcode(f, 0)` and exists only in non-secure builds, where every decoder here compiles to an identity passthrough. `print.c` references no decoders (whole file is `#ifndef LUAVM_SECURE`).
- Encoding side mirrors live in engine code: `RbxOpEncoder` typedef (`unsigned (*)(unsigned insn, int pc, unsigned key)`) in `App/include/script/LuaVM.h`, used by `LuaSerializer.inl` / `LuaVMDummy.cpp`; core-script keys `LUAVM_INTERNAL_CORE_ENCODE_KEY 641` / `DECODE_KEY 6700417` are multiplicative inverses mod 2³².

## Roblox modifications (vs stock Lua 5.1.4)
1. `INLINE_OP` macro (new).
2. **Reversed operand-bit layout** under `LUAVM_SECURE` (op in bits 26–31; B lowest).
3. **Shuffled `OpCode` enum** + `OP___COUNT` sentinel replacing stock fixed ordering.
4. **NEW decoder family**: `rbxDaxDecode`, `LUAVM_DAX_MO/ME/AO/AE`, `rbxDecodeArgs` (pc-dependent affine-XOR applied *only* to OP_CALL/OP_TAILCALL/OP_RETURN/OP_CLOSURE operands after multiplicative decode), `rbxDecodeOpPartial`, two overloads each of `rbxDecodeOp/rbxDecodeOpFast/rbxDecodeFakeOp` for `InstructionV` vs pre-partially-decoded `InstructionP`.
5. Gated by `LUAVM_SECURE && !RBX_RCC_SECURITY` (RCC = server build keeps instructions plaintext).

## Gotchas
- The shuffle permutations are fixed compile-time constants defined in `App/include/script/LuaVM.h` (active exactly when `LUAVM_SECURE`, which luaconf.h pulls in via `#include "Script/LuaVM.h"`; non-secure builds expand the SHUFFLE macros to identity order). So opcode *values* differ between secure and non-secure configurations — cross-configuration chunk loading is impossible by design — but they are not randomized per build. Under the secure permutation, opcode value 0 is `OP_LOADBOOL` (first group emits `a2,a6,a4,a7,a1,a8,a0,a3,a5`), never one of the four DAX-protected opcodes.
- `SET_OPCODE(i, op)` inside `rbxDecodeArgs` restores the op after the affine mix scrambles all 32 bits — forgetting this yields garbage ops only for the four protected opcodes. (Encoder side mirrors this: `rbxDaxEncode` in `App/script/LuaVMDummy.cpp` re-installs the plaintext opcode BEFORE multiplying by the key, so after `rbxDecodeOpPartial` the opcode is already readable even for protected ops.)
- `pcRel` reaching `rbxDecodeArgs` must be the pc of the instruction being decoded (callers in `lvm.c`/`ldebug.c` pass the absolute pc); wrong pc silently decodes B/C args of CALL/TAILCALL/RETURN/CLOSURE incorrectly. Encoder also stashes `pc|1` into OP_MOVE's unused C field (`rbxDaxEncode`), a canary for forged/re-encoded bytecode.
- Multiplicative decode means `ckey` must be odd (it is: 641, 6700417…) or decoding is lossy mod 2³². Engine constants name the degenerate keys: `LUAVM_KEY_INVALID 0`, `LUAVM_KEY_DUMMY 1` (LuaVM.h) — and `lvm.c` refuses to interpret at all when `ckey < 2`. With key 0, `i.v*ckey = 0` regardless of input: every word "decodes" to the same constant, so keyed decoding with key 0 validates nothing (see lundump.c.md / INDEX.md).
