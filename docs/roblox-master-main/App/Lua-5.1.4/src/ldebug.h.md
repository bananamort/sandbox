# App/Lua-5.1.4/src/ldebug.h

## Purpose
Header for the debug/error module ($Id: ldebug.h,v 2.3.1.1): pc↔line mapping (`pcRel`, `getline`), hook counter reset, the runtime error raisers (`luaG_typeerror/concaterror/aritherror/ordererror/runerror/errormsg`), and the static bytecode verifier (`luaG_checkcode`) plus jump-into-block validator (`luaG_checkopenop`).

## API
```c
#define pcRel(pc, p)  (cast(int, (pc) - (p)->code) - 1)
#define getline(f,pc) (((f)->lineinfo) ? LUAVM_DECODELINE((f)->lineinfo[pc], pc) : 0)
#define resethookcount(L) (L->hookcount = L->basehookcount)

LUAI_FUNC void luaG_typeerror  (lua_State *L, const TValue *o, const char *opname);
LUAI_FUNC void luaG_concaterror(lua_State *L, StkId p1, StkId p2);
LUAI_FUNC void luaG_aritherror (lua_State *L, const TValue *p1, const TValue *p2);
LUAI_FUNC int  luaG_ordererror (lua_State *L, const TValue *p1, const TValue *p2);
LUAI_FUNC void luaG_runerror   (lua_State *L, const char *fmt, ...);
LUAI_FUNC void luaG_errormsg   (lua_State *L);
LUAI_FUNC int  luaG_checkcode  (const Proto *pt, unsigned int ckey);
LUAI_FUNC int  luaG_checkopenop(Instruction i);
```

## Usage
- Every error a script ever sees originates here; ScriptContext's error scrubbing/telemetry consumes the resulting messages after `luaD_pcall`.
- `luaG_checkcode(f, key)` validates operand structure of obfuscated code — called from lundump.c with key 0 and from LuaSerializer.inl with `L->l_G->ckey`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`getline` routes through `LUAVM_DECODELINE(lineinfo[pc], pc)`** — line tables are Roblox-encoded, not plain ints as in stock (`((f)->lineinfo) ? (f)->lineinfo[pc] : 0`). Any tool reading `Proto::lineinfo` directly gets wrong lines.
2. **`luaG_checkcode` gained an `unsigned int ckey` parameter** — stock signature is `int luaG_checkcode(const Proto*)`. All callers must supply the VM's opcode key.
3. `luaG_checkopenop` keeps its stock form (takes a decoded `Instruction`).

## Gotchas
- Because both code AND lineinfo are keyed/encoded, stack traces must decode twice (instruction for opcode identity, lineinfo for line number); mismatched keys corrupt both silently.
- `getline` returns 0 when lineinfo is stripped — C-function frames and stripped protos report line -1 upstream in ldebug.c.

