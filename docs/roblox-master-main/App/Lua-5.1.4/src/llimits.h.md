# App/Lua-5.1.4/src/llimits.h

## Purpose
Lua VM core "limits & basic types" header: installation-dependent integer typedefs, small helper macros, internal assertion plumbing, and the VM's instruction word types. Included by nearly every `.c/.h` in `src/`. This copy is stock Lua 5.1.4 (`$Id: llimits.h,v 1.69.1.1`) **plus two Roblox-added types that are central to bytecode obfuscation**.

## API
Stock Lua 5.1.4 surface (unchanged):
- `typedef LUAI_UINT32 lu_int32;` `lu_mem` (`LUAI_UMEM`), `l_mem` (`LUAI_MEM`), `lu_byte` (unsigned char)
- Limits: `MAX_SIZET`, `MAX_LUMEM`, `MAX_INT` (`INT_MAX-2`), `MAXSTACK 250`, `MINSTRTABSIZE 32`, `LUA_MINBUFFER 32`
- `IntPoint(p)` — pointer→uint hash helper
- `L_Umaxalign` (`LUAI_USER_ALIGNMENT_T`), `l_uacNumber`
- Assertion plumbing: if `lua_assert` defined → `check_exp(c,e)`, `api_check(l,e)`; else `lua_assert(c) ((void)0)`, `check_exp(c,e) (e)`, `api_check` = `luai_apicheck`
- Cast macros: `UNUSED(x)`, `cast(t,exp)`, `cast_byte`, `cast_num`, `cast_int`
- Threading stubs: `lua_lock/unlock`, `luai_threadyield`; `condhardstacktests(x)`
- **`typedef lu_int32 Instruction;`** — the raw instruction word (unsigned ≥4 bytes)

### Roblox additions
```c
// line ~90: used wherever an instruction is stored in OBFUSCATED form
struct InstructionV {
    Instruction v;
};

// line ~96: partially decoded instruction; at least the op field is plaintext
struct InstructionP {
    Instruction p;
    InstructionP(Instruction i) : p(i) {}
};
```

## Usage
- Included by all Lua core files (`lobject.h`, `lstate.h`, `lopcodes.h`, `lvm.c`, `lcode.c`, …).
- `InstructionV` is the storage type of `Proto::code` (`p->code[i].v`) — see `lundump.c`, `ldump.c`/`luaU_dump` callers, `print.c`, `luac.c`, and engine-side `App/script/LuaSerializer.inl` (`luaM_newvector(L, p->sizecode, InstructionV)`), `App/script/LuaVMDummy.cpp`.
- `InstructionP` appears in the `lvm.c` dispatch loop as the pre-decoded operand passed into opcode handlers.
- The type is deliberately a *struct wrapping* the int (not a typedef) so encrypted instructions cannot silently mix with plaintext ones at C++ compile time — a Roblox anti-tamper measure that survives even though the value inside may be XOR-encoded (`rbxDecodeOp`).

## Roblox modifications (vs stock Lua 5.1.4)
| Delta | Symbol | Evidence |
|---|---|---|
| NEW | `struct InstructionV { Instruction v; }` (lines 90–94) | Comment: *"this is used to indicate an instruction that is obfuscated."* Stock stores plain `Instruction* code`. |
| NEW | `struct InstructionP { Instruction p; InstructionP(Instruction); }` (lines 96–102) | Comment: *"partially decoded instruction that has at least the op field in plaintext"* — feeds the fast dispatch path in `lvm.c`. |
Everything else matches stock 5.1.4 verbatim.

## Gotchas
- Because `Proto::code` holds `InstructionV`, any tooling that treats it as `int[]` must go through `.v` and remember the values are keyed by `global_State::ckey` per-VM.
- `MAXSTACK 250` bounds locals+temporaries; `LUAI_MAXUPVALUES` (60, set in `luaconf.h`) and `LUAI_MAXVARS` (200) interlock with this.
- `api_check` collapses to `((void)0)`-strength unless `lua_assert` is defined — in this tree `lua_assert` maps to `RBXASSERT` only in `_DEBUG/_NOOPT` builds (see `luaconf.h`).
