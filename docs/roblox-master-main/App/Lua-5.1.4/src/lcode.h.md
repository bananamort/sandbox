# App/Lua-5.1.4/src/lcode.h

## Purpose
Header for the code generator ($Id: lcode.h,v 1.48.1.1). Declares the `BinOpr`/`UnOpr` operator enums (with "ORDER OPR" grep contract tying them to lparser.c's switch tables), jump patch-list machinery (`NO_JUMP`, `luaK_concat/patchlist/getlabel`), instruction emission (`luaK_codeABC/codeABx`), register allocation, constant pooling (`luaK_stringK/numberK`), and expression discharge/store helpers used by lparser.c to turn `expdesc` trees into bytecode.

## API
```c
#define NO_JUMP (-1)
#define getcode(fs,e) ((fs)->f->code[(e)->u.s.info].v)   /* ROBLOX: .v — InstructionV */
#define luaK_codeAsBx(fs,o,A,sBx) luaK_codeABx(fs,o,A,(sBx)+MAXARG_sBx)
#define luaK_setmultret(fs,e)     luaK_setreturns(fs, e, LUA_MULTRET)

typedef enum BinOpr { OPR_ADD..OPR_POW, OPR_CONCAT, OPR_NE, OPR_EQ,
                      OPR_LT, OPR_LE, OPR_GT, OPR_GE, OPR_AND, OPR_OR,
                      OPR_NOBINOPR } BinOpr;
typedef enum UnOpr { OPR_MINUS, OPR_NOT, OPR_LEN, OPR_NOUNOPR } UnOpr;

/* emission */
LUAI_FUNC int  luaK_codeABx (FuncState*, OpCode, int A, unsigned Bx);
LUAI_FUNC int  luaK_codeABC (FuncState*, OpCode, int A, int B, int C);
LUAI_FUNC void luaK_fixline (FuncState*, int line);
LUAI_FUNC int  luaK_jump (FuncState*);  LUAI_FUNC void luaK_ret (FuncState*,int,int);
/* registers & constants */
LUAI_FUNC void luaK_nil/reserveregs/checkstack/setlist (...);
LUAI_FUNC int  luaK_stringK (FuncState*, TString*);  LUAI_FUNC int luaK_numberK (FuncState*, lua_Number);
/* expression handling */
LUAI_FUNC void luaK_dischargevars/exp2nextreg/exp2val/self/indexed/goiftrue/
              storevar/setreturns/setoneret/patchtohere/prefix/infix/posfix (...);
LUAI_FUNC int  luaK_exp2anyreg/exp2RK/getlabel (...);
LUAI_FUNC void luaK_patchlist/concat (...);
```

## Usage
- Sole consumer is lparser.c; each grammar production ends in a `luaK_*` call. Jump lists are singly-linked through instruction sBx fields terminated by `NO_JUMP`.
- Roblox's obfuscation interacts here: emitted instructions are stored as `InstructionV` and `getcode` already dereferences `.v`, so backpatching writes go through the value-typed union member rather than a raw word.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`getcode` macro changed**: stock is `(fs)->f->code[(e)->u.s.info]`; this tree appends `.v`, i.e. `Proto::code` is an array of `InstructionV` (obfuscated instruction container), not raw `Instruction`. Every backpatch site inherits the change.
2. Operator enum order preserved ("ORDER OPR" contract intact); no new operators (no Luau compound-assign, no `!=`).
3. Constant pooling (`luaK_numberK`/`addk` dedup table) is stock — RESOLVED via lcode.c: nothing there re-keys or re-encodes constants; only instruction storage gained the `InstructionV` `.v` indirection.

## Gotchas
- Patch lists link jumps via their own sBx payloads: patching before all list members exist corrupts control flow silently.
- `luaK_exp2RK` may convert an expression to a constant-table index only if it fits RK bounds (MAXINDEXRK); otherwise it spills to a register.
- Because of the `.v` change, any external tool that re-implements these macros against stock headers mis-patches Roblox protos.

