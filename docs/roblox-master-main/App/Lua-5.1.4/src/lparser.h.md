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
- Reached from `lua_load` (ldo.c) when the input fails the binary-chunk sniff. In stock Lua this is THE compile path; in this Roblox tree:
  - Client VMs stub it to throw `LUA_ERRSYNTAX` (no text compilation on the client).
  - The core/internal path still compiles text (used by ScriptContext's loadstring-equivalent decisions and by LuaVMServer's key-641 internal VM).
- `App/script/ScriptAnalyzer.cpp` re-implements parsing as an embedded AST-based analyzer for linting; it does NOT call `luaY_parser`.

## Roblox modifications (vs stock Lua 5.1.4)
1. Header content is stock 5.1.4; no added syntax kinds, no Luau-style type annotations, no compound assignment.
2. Downstream effect: protos produced here get their `code` array obfuscated into `InstructionV` keyed by the compiling state's `ckey` before use (obfuscation applied at emit/dump time — see ldump.c.md / lopcodes.h.md).
3. UNKNOWN: whether Roblox patched anything inside lparser.c body (verify against lparser.c.md); the public surface in this header shows zero deltas.

## Gotchas
- `expdesc.u.s.aux` doubles as "index register OR RK constant" depending on kind — misreading it corrupts indexed access codegen.
- `LUAI_MAXUPVALUES` / `LUAI_MAXVARS` bounds come from llimits.h; exceeding them aborts compilation with LUAI_MAXCCALLS-guarded recursion depth.
- Parser allocates via `luaM_*` on the target state — a parse error longjmps out through `luaD_throw`, relying on `luaD_protectedparser` to restore invariants.

