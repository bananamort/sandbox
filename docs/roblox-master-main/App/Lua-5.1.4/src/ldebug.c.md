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
3. **`lua_getlocal` pushes the value**: stock only returns the variable NAME and touches nothing; Roblox additionally does `luaA_pushobject(L, ci->base + (n - 1))` when a name is found. Symmetrically `lua_setlocal` assigns `L->top - 1` into the local's slot and then pops it (`L->top--`) — stock neither writes nor pops. Debugger watch/set features depend on this.
4. **`getfuncname` name-kinds extended** beyond stock CALL/TAILCALL/TFORLOOP: decoding the caller's pc gives OP_GETTABLE/OP_SELF → `"index"` (name from `kname(..., GETARG_C(i))`) and OP_SETTABLE → `"newindex"` (name from `GETARG_B(i)`); stock falls through to NULL for those opcodes.
5. Everything else structurally stock.

## Gotchas
- Key mismatch during validation produces failing checks ("bad code" at undump) rather than targeted errors; when porting, keep the SAME decode helpers as lvm.c or verifier and interpreter disagree.
- Key-0 semantics RESOLVED (see lopcodes.h.md / INDEX.md): the keyed `rbxDecode*` bodies compile only under `LUAVM_SECURE && !RBX_RCC_SECURITY`; in that configuration `i.v * 0 == 0` maps EVERY word to the constant 0 (opcode value 0 = OP_LOADBOOL after the fixed shuffle), so `precheck`'s final-instruction-must-be-OP_RETURN test fails and validation rejects everything. But lundump.c's loader (the only key-0 caller) is itself compiled only when NOT `LUAVM_SECURE`, where all decoders are identity passthroughs that ignore the key — so `luaG_checkcode(f, 0)` validates plaintext structure. Engine-shipped keyed chunks are verified post-load by LuaSerializer.inl with the live `L->l_G->ckey` instead.
- `LUA_HOOKERROR` fires inside `errormsg` while the error value sits at stack top — hooks yielding here would corrupt error propagation; Roblox's debugger yields only from COUNT/LINE hooks.
- `currentline` returns -1 for C functions and stripped protos; message prefixes then omit position info.

