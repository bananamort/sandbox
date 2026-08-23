# App/Lua-5.1.4/src/ldo.h

## Purpose
Header for Lua's stack and call machinery ($Id: ldo.h,v 2.7.1.1): stack growth macros, CallInfo save/restore offsets, `luaD_precall` result codes, protected-execution plumbing (`luaD_pcall`, `luaD_rawrunprotected`, `luaD_throw` longjmp-based error propagation), call hooks, and the protected parser entry used by `lua_load`.

## API
```c
#define luaD_checkstack(L,n) /* grow if less than n TValues of headroom */
#define incr_top(L)          {luaD_checkstack(L,1); L->top++;}
#define savestack(L,p)   ((char *)(p) - (char *)L->stack)
#define restorestack(L,n)((TValue *)((char *)L->stack + (n)))
#define saveci(L,p)      ((char *)(p) - (char *)L->base_ci)
#define restoreci(L,n)   ((CallInfo *)((char *)L->base_ci + (n)))

/* results from luaD_precall */
#define PCRLUA     0  /* initiated a call to a Lua function */
#define PCRC       1  /* did a call to a C function */
#define PCRYIELD   2  /* C function yielded */

typedef void (*Pfunc)(lua_State *L, void *ud);

LUAI_FUNC int  luaD_protectedparser (lua_State *L, ZIO *z, const char *name);
LUAI_FUNC void luaD_callhook        (lua_State *L, int event, int line);
LUAI_FUNC int  luaD_precall         (lua_State *L, StkId func, int nresults);
LUAI_FUNC void luaD_call            (lua_State *L, StkId func, int nResults);
LUAI_FUNC int  luaD_pcall           (lua_State *L, Pfunc func, void *u,
                                     ptrdiff_t oldtop, ptrdiff_t ef);
LUAI_FUNC int  luaD_poscall         (lua_State *L, StkId firstResult); // cvx: want to inline
LUAI_FUNC void luaD_reallocCI       (lua_State *L, int newsize);
LUAI_FUNC void luaD_reallocstack    (lua_State *L, int newsize);
LUAI_FUNC void luaD_growstack       (lua_State *L, int n);
LUAI_FUNC void luaD_throw           (lua_State *L, int errcode);
LUAI_FUNC int  luaD_rawrunprotected (lua_State *L, Pfunc f, void *ud);
LUAI_FUNC void luaD_seterrorobj     (lua_State *L, int errcode, StkId oldtop);
```

## Usage
- Every bridge-level protected entry funnels through `luaD_pcall`: `ScriptContext::resumeImpl` and coroutine resumes wrap `lua_resume`'s inner work in it; error objects land via `luaD_seterrorobj`.
- `PCRYIELD` is how a C function yields mid-call (`lua_yield` → yieldable CFunc marker); Roblox's `ypcall` replacement and Continuations machinery rely on resuming threads whose `ci` sits in exactly this state.
- `savestack/restorestack` offsets exist because `luaD_reallocstack` can move `L->stack` mid-operation — any code caching `StkId` across a potential growth must re-derive it.

## Roblox modifications (vs stock Lua 5.1.4)
1. Only delta in the header: `// cvx: want to inline` annotation on `luaD_poscall` (a CVX-era build note; the declaration itself is unchanged).
2. All structural changes live in the .c: `luaD_poscall` handling of `InstructionV` savedpc restore, `luaD_throw` behavior differences, and parser stubbing (client `luaY_parser` throws `LUA_ERRSYNTAX` — see ldo.c.md).

## Gotchas
- `luaD_checkstack` compares raw char pointers minus top — passing huge `n` raises a memory error inside the macro, so callers must be re-entrant-safe for `luaD_throw`.
- `luaD_precall` returning `PCRLUA` means the frame was PREPARED but not executed; the caller (`luaV_execute` / `luaD_call`) still runs the loop — forgetting this double-runs frames.
- Error-jump semantics: `luaD_throw` on the main thread without a `errorJmp` chain calls `g->panic` then exits — Roblox replaces `panic` (LuaVMValue<lua_CFunction> in global_State) and expects scripts never to hit bare throw paths.

