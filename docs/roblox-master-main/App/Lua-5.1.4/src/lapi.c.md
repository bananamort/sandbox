# App/Lua-5.1.4/src/lapi.c

## Purpose
The C API implementation ($Id: lapi.c,v 2.55.1.5): index translation (`index2adr` incl. pseudo-indices registry/globals/environ/upvalues), stack management (`checkstack/xmove/settop/insert/replace/remove`), type tests and coercions (`tonumber/tostring/tolstring/tointeger/toboolean/userdata/cfunction/thread/pointer/objlen`), push family, table access (`gettable/getfield/rawget[i]/createtable/settable/setfield/rawset[i]/setmetatable/getmetatable/setfenv/getfenv`), call/load/dump (`call/pcall/cpcall/load/dump/status`), GC control (`lua_gc`), userdata, upvalue get/set, error raise, next/concat, allocator swap.

## API
Full stock `LUA_API` surface of 5.1.4 plus Roblox additions:
```c
/* ROBLOX additions */
void lua_setreadonly (lua_State *L, int objindex, bool value);
const char *lua_tolstringsecure (lua_State *L, int idx, size_t *len);
/* internal */ static unsigned int lua_hash(const char* str, unsigned int l);
```

## Usage
- This is THE boundary every file under App/script/ uses thousands of times; signatures here are the ground truth for all bridge code.
- `lua_tolstringsecure` is used where strings cross trust boundaries (UNKNOWN exact call sites in App/script — grep recommended before graft).
- `lua_load` still routes into `luaD_protectedparser` (which always text-parses in this tree) — binary chunks therefore enter the VM via other paths (engine serializer / LuaVMServer), NOT via `lua_load`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Engine headers included**: `#include "V8DataModel/DataModel.h"`, `"V8DataModel/HackDefines.h"` — core now depends on DataModel stats flags.
2. **NEW `lua_tolstringsecure`** (bracketed `/* ROBLOX */`): like `lua_tolstring` but re-hashes the string bytes with `lua_hash` and compares against `TString.hash`; on mismatch sets `RBX::DataModel::sendStats |= HATE_LUA_HASH_CHANGED` and returns NULL/len 0. Bypassed entirely under `RBX_STUDIO_BUILD`.
3. **Readonly-table enforcement**: NEW `Table::readonly` flag consumed here — `lua_setreadonly` sets it; `lua_rawset`, `lua_rawseti`, and the TABLE case of `lua_setmetatable` raise `"Attempt to modify a readonly table"` when set. Stock has no such field/checks.
4. **VM-hook tripwires**: `lua_chk_ptr_rblx(fn, lua_vmhooked_handler, L)` in `lua_pushcclosure`, and on `_ReturnAddress()` in `f_call`/`f_Ccall` (commented `/* added for exploit */`) — detects hooked C functions / patched return addresses at pcall/ccall entry.
5. Everything else matches stock 5.1.4 flow-for-flow.

## Gotchas
- `lua_tolstring` may convert a number IN PLACE (changes stack slot type) and can reallocate the stack — callers must not cache StkIds across it.
- Readonly protection lives only in rawset/rawseti/setmetatable HERE; `lua_settable`/`lua_setfield` go through `luaV_settable` (see lvm.c.md) — protection coverage differs per entry point; audit both layers before assuming safety.
- `lua_pushcclosure`'s hook check runs AFTER closure creation but BEFORE upvalues are copied — an aborting check leaves the closure unreachable-but-linked (GC will collect).
- `lua_gc(LUA_GCSTEP)` loops steps until pause or cycle end — can run arbitrarily long inside one call.

