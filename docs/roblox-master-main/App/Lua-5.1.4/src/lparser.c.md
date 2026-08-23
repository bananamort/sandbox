# App/Lua-5.1.4/src/lparser.c

## Purpose
Recursive-descent parser + code generator driver ($Id: lparser.c,v 2.42.1.3): full Lua 5.1 grammar — chunks/blocks, statements (if/while/repeat/do/for num & list/function/local/return/break/expression), expression precedence climbing (`subexpr` with priority table), table constructors with SETLIST flushing every LFIELDS_PER_FLUSH items, local/upvalue resolution (`singlevaraux` walking FuncState chain, `indexupvalue` dedup), assignment adjustment incl. multi-ret and LHS conflict copies (`check_conflict`), function bodies with self/params/vararg compat, and Proto finalization (`open_func/close_func`: shrink arrays to exact size, emit implicit RETURN, verify).

## API
```c
Proto *luaY_parser (lua_State *L, ZIO *z, Mbuffer *buff, const char *name);
/* everything else static: expr/subexpr/statement/chunk/body/constructor/
   assignment/retstat/forstat/whilestat/repeatstat/ifstat/localstat/... */
```

## Usage
- Only entry point is `luaY_parser`, reached from ldo.c's protected parser (which no longer sniffs binary). In THIS tree the whole file compiles only under `LUAVM_COMPILER` — text compilation exists solely in internal-core/compiler configurations; runtime client builds link a stub that throws LUA_ERRSYNTAX.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Entire translation unit guarded `#ifdef LUAVM_COMPILER` … `#endif`** — parser absent from non-compiler builds (pairs with the stubbed luaY_parser elsewhere; see ldo.c.md/lvm dispatch notes).
2. **TAIL CALLS DISABLED** (`retstat`, in-source comment `/* ROBLOX: disable tail calls */`): the OP_TAILCALL conversion branch is dead-coded with `&& false`. Consequence: `return f()` inside itself consumes a stack frame per iteration — unbounded recursion overflows instead of running in constant space.
3. **Code arrays typed `InstructionV`**: `close_func` reallocs `f->code` as `InstructionV`; backpatch sites go through `.v` (`SETARG_B(fs->f->code[pc].v, …)` in `constructor`, and `exprstat`'s `SETARG_C(getcode(...))` via the modified getcode macro).
4. **NEW `finalize()` under `LUAVM_SECURE`**: recursively encodes every Proto's lineinfo at compile time — `p->lineinfo[i] = LUAVM_ENCODELINE(p->lineinfo[i], i)` — producing the encoded line tables that `getline`'s `LUAVM_DECODELINE` expects at run time (see ldebug.h.md).
5. Post-compile verification: `close_func` asserts `luaG_checkcode(f, 0)` when not LUAVM_SECURE.
6. Grammar otherwise exactly stock 5.1.4 (no new syntax of any kind).

## Gotchas
- Because tail calls are disabled, code ported from stock-Lua assumptions about O(1) stack for tail recursion will crash with "stack overflow" in Roblox; conversely, decompiled OP_TAILCALL in shipped chunks cannot originate from THIS parser (legacy or hand-built chunks only).
- In secure builds lineinfo is encoded BEFORE dump; any tool reading lineinfo must decode with pc index — plain ints are only pre-finalize.
- Parser recursion depth is bounded by nCcalls/LUAI_MAXCCALLS ("chunk has too many syntax levels"); deep expression nesting in generated code can hit it.

