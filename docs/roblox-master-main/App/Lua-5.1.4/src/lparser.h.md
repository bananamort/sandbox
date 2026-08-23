# App/Lua-5.1.4/src/lparser.h

## Purpose
Header for the recursive-descent parser ($Id: lparser.h,v 1.57.1.1). Declares `luaY_parser` (text source → `Proto` tree), plus the parser's core data structures: `expdesc` expression descriptor (kind + info/aux/nval union + true/false jump patch lists), `upvaldesc`, and `FuncState` (per-function codegen state: Proto under construction, constant dedup table, register allocator cursor, active-var stack, upvalue table).

## API
```c
typedef enum { VVOID, VNIL, VTRUE, VFALSE, VK, VKNUM, VLOCAL, VUPVAL,
               VGLOBAL, VINDEXED, VJMP, VRELOCABLE, VNONRELOC, VCALL,
               VVARARG } expkind;

typedef struct expdesc {
  expkind k;
  union { struct { int info, aux; } s; lua_Number nval; } u;
  int t;   /* patch list of 'exit when true' */
  int f;   /* patch list of 'exit when false' */
} expdesc;

typedef struct upvaldesc { lu_byte k; lu_byte info; } upvaldesc;

typedef struct FuncState {
  Proto *f;                 /* current function header */
  Table *h;                 /* dedup table for constants k */
  struct FuncState *prev;   /* enclosing function */
  struct LexState *ls;      /* lexical state */
  struct lua_State *L;
  struct BlockCnt *bl;      /* block chain */
  int pc, lasttarget, jpc, freereg, nk, np;
  short nlocvars;  lu_byte nactvar;
  upvaldesc upvalues[LUAI_MAXUPVALUES];
  unsigned short actvar[LUAI_MAXVARS];
} FuncState;

LUAI_FUNC Proto *luaY_parser (lua_State *L, ZIO *z, Mbuffer *buff, const char *name);
```

## Usage
- Reached from `lua_load` via ldo.c's protected parser — which calls it UNCONDITIONALLY in this tree (the stock binary-chunk sniff branch was removed; there is no undump dispatch anywhere). In this Roblox tree:
  - The whole parser body compiles only under `LUAVM_COMPILER`; client builds instead link the stub at `App/script/LuaVMClient.cpp:24`, which pushes an empty string and throws `LUA_ERRSYNTAX` — no text compilation on the client.
  - The core/internal path still compiles text (LuaVMServer's internal VM keyed 641/6700417).
- `App/script/ScriptAnalyzer.cpp` re-implements parsing as an embedded AST-based analyzer for linting; it does NOT call `luaY_parser`.

## Roblox modifications (vs stock Lua 5.1.4)
1. Header content is stock 5.1.4; no added syntax kinds, no Luau-style type annotations, no compound assignment.
2. Downstream effect: protos produced here carry plaintext code/lineinfo at emit time; obfuscation happens afterwards — `finalize()` XOR-encodes lineinfo under `LUAVM_SECURE`, and instruction keying happens only in the engine's LuaSerializer pipeline (nothing in this header or lparser.c multiplies by `ckey`).
3. RESOLVED (was UNKNOWN): lparser.c body carries five Roblox deltas — `LUAVM_COMPILER` unit guard, dead-coded tail calls (`&& false`), `InstructionV` code-array typing, secure-build `finalize()` lineinfo encoding, and a non-secure `luaG_checkcode(f, 0)` debug assert — while the public surface in this header stays untouched.

## Gotchas
- `expdesc.u.s.aux` doubles as "index register OR RK constant" depending on kind — misreading it corrupts indexed access codegen.
- `LUAI_MAXUPVALUES` / `LUAI_MAXVARS` bounds come from llimits.h; exceeding them aborts compilation with LUAI_MAXCCALLS-guarded recursion depth.
- Parser allocates via `luaM_*` on the target state — a parse error longjmps out through `luaD_throw`, relying on `luaD_protectedparser` to restore invariants.

