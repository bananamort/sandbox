# App/Lua-5.1.4/src/ldebug.c

## Purpose
Debug interface and runtime diagnostics ($Id: ldebug.c,v 2.29.1.6): hook management (`lua_sethook/gethook/gethookmask/getstack/count`), `lua_Debug` population (`lua_getinfo`, funcinfo/namewhat inference via symbolic execution), locals get/set through `luaF_getlocalname`, the bytecode verifier (`precheck` + `symbexec`: operand-mode validation, jump-target sanity incl. SETLIST-count ambiguity resolution, pseudo-instruction checks after CLOSURE/comparison ops), error raisers with variable naming (`luaG_typeerror/concaterror/aritherror/ordererror/runerror/errormsg`) and source-position decoration (`addinfo`).

## API
```c
LUA_API int lua_sethook (lua_State *L, lua_Hook f, int mask, int count);
LUA_API int lua_getinfo (lua_State *L, const char *what, lua_Debug *ar);
LUA_API const char *lua_getlocal / lua_setlocal (...);
int luaG_checkcode (const Proto *pt, unsigned int ckey);   /* ROBLOX: +ckey */
int luaG_checkopenop (Instruction i);
void luaG_typeerror/concaterror/aritherror/ordererror/runerror/errormsg (...);
/* internal */ static int symbexec(const Proto *pt, int lastpc, int reg, unsigned int ckey);
```

## Usage
- `luaG_checkcode` is invoked by lundump.c (`key 0`) and App/script/LuaSerializer.inl (`L->l_G->ckey`) to validate decoded bytecode before execution.
- DebuggerManager builds its pause/step/watch machinery on `lua_sethook` + `lua_getinfo`/`lua_getlocal`; ScriptContext error scrubbing sees strings from `luaG_runerror`.
- `symbexec` doubles as name resolver for "attempt to index field 'X'" messages via `getobjname`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Every code-reading path decodes through the VM key**: `symbexec` takes an `unsigned int ckey` and wraps each fetch as `rbxDecodeOp(pt->code[pc], pc, ckey)` (position-mixed); `precheck`'s final-OP_RETURN test uses `rbxDecodeOpPartial(...).p`; `checkopenop` macro becomes `rbxDecodeOp((pt)->code[(pc)+1], (pc)+1, ckey)`; `getobjname`/`getfuncname` decode with `L->l_G->ckey`. Stock read raw words.
2. **NEW error hook event**: `luaG_errormsg` fires `luaD_callhook(L, LUA_HOOKERROR, -1)` when `L->hookmask & LUA_MASKERROR` (bracketed `// BEGIN/END ROBLOX CHANGES`) — runs BEFORE the errfunc; requires the new `LUA_HOOKERROR`/`LUA_MASKERROR` constants (see lua.h.md).
3. Everything else structurally stock.

## Gotchas
- Key mismatch during validation produces failing checks ("bad code" at undump) rather than targeted errors; when porting, keep the SAME decode helpers as lvm.c or verifier and interpreter disagree.
- Passing `ckey == 0` (as lundump.c does) only validates if `rbxDecodeOp(·,·,0)` is effectively identity — engine-shipped keyed chunks are instead verified post-load by LuaSerializer with the real key. UNKNOWN: exact semantics of decode-at-key-0 (defined in lopcodes.h.md macros).
- `LUA_HOOKERROR` fires inside `errormsg` while the error value sits at stack top — hooks yielding here would corrupt error propagation; Roblox's debugger yields only from COUNT/LINE hooks.
- `currentline` returns -1 for C functions and stripped protos; message prefixes then omit position info.

