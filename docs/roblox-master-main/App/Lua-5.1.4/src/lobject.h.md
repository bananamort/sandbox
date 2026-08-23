# App/Lua-5.1.4/src/lobject.h

## Purpose
Core object-layout header: `TValue` tagged values, GC object headers, `TString`/`Udata`/`Proto`/`UpVal`/`Closure`/`Table` structures and their accessor macros. This is where Roblox's structural hardening is most visible: **field order shuffling**, **pointer-obfuscating `LuaVMValue<T>` wrappers**, **encrypted doubles (`LuaSecureDouble`)**, the `InstructionV*` bytecode array, and the `Table::readonly` flag.

## API
Tags: `LAST_TAG (LUA_T___COUNT-1)`, `NUM_TAGS`; internal tags `LUA_TPROTO/LUA_TUPVAL/LUA_TDEADKEY`. `CommonHeader` = `GCObject *next; lu_byte tt; lu_byte marked;` (tt/marked order subject to `LUAVM_SHUFFLE2`). `GCheader`, `GCObject` union (defined in `lstate.h`).

**Value/TValue**: `union Value { GCObject *gc; void *p; lua_Number n | LuaSecureDouble n; int b; }`; `struct lua_TValue { Value value; int tt; }`.
Type tests: `ttisnil/number/string/table/function/boolean/userdata/thread/lightuserdata`, `ttype(o)`, accessors `gcvalue/pvalue/nvalue/rawtsvalue/tsvalue/rawuvalue/uvalue/clvalue/hvalue/bvalue/thvalue`, `l_isfalse`, debug helpers `checkconsistency/checkliveness`, setters `setnilvalue/setnvalue/setpvalue/setbvalue/setsvalue/setuvalue/setthvalue/setclvalue/sethvalue/setptvalue/setobj` + aliases (`setobjs2s`, `setobj2s`, `setsvalue2s`, …), `setttype`, `iscollectable(o) = ttype(o) >= LUA_TSTRING`.

`StkId` = `TValue*`.

**Structures** (Roblox layout annotations inline):
```c
typedef union TString { L_Umaxalign dummy;
  struct { CommonHeader; lu_byte reserved;
           LUAVM_SHUFFLE2(;, LuaVMValue<unsigned int> hash, size_t len); } tsv; } TString;
#define getstr(ts) ((const char*)(ts)+1); svalue(o)

typedef union Udata { L_Umaxalign dummy;
  struct { CommonHeader;
    bool may_gc;                                   // ROBLOX
    LUAVM_SHUFFLE3(;, LuaVMValue<Table*> metatable, Table* env, size_t len); } uv; } Udata;

typedef struct Proto { CommonHeader;
  LUAVM_SHUFFLE9(;, LuaVMValue<TValue*> k, LuaVMValue<InstructionV*> code,
       LuaVMValue<Proto**> p, LuaVMValue<int*> lineinfo,
       LuaVMValue<LocVar*> locvars, LuaVMValue<TString**> upvalues,
       LuaVMValue<TString*> source, int sizeupvalues, int sizek);
  LUAVM_SHUFFLE7(;, int sizecode, sizelineinfo, sizep, sizelocvars,
                    linedefined, lastlinedefined, GCObject* gclist);
  LUAVM_SHUFFLE4(;, lu_byte nups, numparams, is_vararg, maxstacksize); } Proto;

/* vararg flags */ VARARG_HASARG 1, VARARG_ISVARARG 2, VARARG_NEEDSARG 4
typedef struct LocVar { TString *varname; int startpc; int endpc; } LocVar;

typedef struct UpVal { CommonHeader; TValue *v;
  union { TValue value; struct{ LUAVM_SHUFFLE2(;, UpVal *prev, *next); } l; } u; } UpVal;

#define ClosureHeader CommonHeader; lu_byte isC; lu_byte nupvalues; GCObject *gclist; Table *env
typedef struct CClosure { ClosureHeader; LuaVMValue<lua_CFunction> f; TValue upvalue[1]; } CClosure;
typedef struct LClosure { ClosureHeader; LuaVMValue<Proto*> p; UpVal *upvals[1]; } LClosure;
typedef union Closure { CClosure c; LClosure l; } Closure;
iscfunction(o)/isLfunction(o)

typedef union TKey { struct { TValuefields; Node *next; } nk; TValue tvk; } TKey;
typedef struct Node { TValue i_val; TKey i_key; } Node;
typedef struct Table { CommonHeader;
  LUAVM_SHUFFLE3(;, lu_byte flags, lu_byte readonly /*ROBLOX patch*/, lu_byte lsizenode);
  LUAVM_SHUFFLE6(;, LuaVMValue<Table*> metatable, LuaVMValue<TValue*> array,
       LuaVMValue<Node*> node, Node *lastfree, GCObject *gclist, int sizearray); } Table;
```
Hash/util: `lmod(s,size)` (power-of-2 mask), `twoto(x)`, `sizenode(t)`, `luaO_nilobject(_ )`, `ceillog2`. Functions: `luaO_log2(unsigned)→int`, `luaO_int2fb`, `luaO_fb2int`, `luaO_rawequalObj(const TValue*,const TValue*)→int`, `luaO_str2d(const char*,lua_Number*)→int`, `luaO_pushvfstring/luaO_pushfstring(lua_State*,fmt,…)` , `luaO_chunkid(char* out,const char* src,size_t len)`.

## Usage
- Included by every VM file; `Proto`/`Closure`/`Table` are manipulated directly by engine code in `App/script/LuaSerializer.inl` (walks `cl->p`, reads `p->code[i].v`, allocates with `luaM_newvector(L, p->sizecode, InstructionV)`), `LuaVMDummy.cpp` (re-encodes all protos via `RbxOpEncoder`), and read through `global_State` in `ScriptContext.cpp`.
- `readonly` byte is what `lua_setreadonly` toggles — Roblox locks the globals table / API tables against script writes.
- `may_gc` on Udata lets the engine mark userdata that can trigger GC reentrancy (used by instance userdata wrappers).

## Roblox modifications (vs stock Lua 5.1.4)
1. **Field-order obfuscation**: nearly every structure's fields are wrapped in `LUAVM_SHUFFLE2/3/6/7/9(;)` from `App/include/script/LuaVM.h` — under `LUAVM_SECURE` compiled field order differs from source and from stock (e.g. `CommonHeader` puts `marked` before `tt`; `TString` puts `len` before `hash`).
2. **NEW template `LuaVMValue<T>`** wrapping pointer/hash/function fields (`Proto::k/code/p/lineinfo/locvars/upvalues/source`, `Table::metatable/array/node`, `CClosure::f`, `LClosure::p`, `Udata::metatable/env`, `TString::hash`): under `LUAVM_SECURE` stores `value - this` and returns `storage + this` (pointer-delta encoding; documented as unsafe for `float`).
3. **`LuaSecureDouble`**: `Value::n` becomes an encrypted double type on `_WIN32` and macOS non-iOS **non-studio** builds (line 62 condition) — numeric payloads at rest are not plaintext IEEE doubles.
4. `Proto::code` is `LuaVMValue<InstructionV *>` (stock: plain `Instruction*`) — ties into `llimits.h` `InstructionV` + per-VM `ckey` decode.
5. **NEW `bool may_gc`** in `Udata` (`// ROBLOX`).
6. **NEW `lu_byte readonly`** in `Table` (comment: *"ROBLOX patch to Lua. search code for readonly"*).
7. Tag arithmetic derives from shuffled enum (`LAST_TAG = LUA_T___COUNT-1`).
Stock algorithms (`Table` node layout, `UpVal` open/closed union, closure header contents, `LocVar`) otherwise preserved.

## Gotchas
- Never memcpy or serialize these structs raw: `LuaVMValue` storage is address-relative, and shuffled layouts make binary offsets build-specific.
- `LuaSecureDouble` means reading `o->value.n` directly yields ciphertext unless going through `nvalue()` path that decrypts (see `lvm.c`/`lapi.c` handling).
- `iscollectable` relies on tag ordering (`LUA_TSTRING` after the nil/bool/lightudata/number block) — preserved by the shuffle placement but fragile to edits.
- Engine code that walks `Proto` must use `.v` on `InstructionV` and apply `ckey` decode (`rbxDecodeOp`) before interpreting opcodes.
- `lsizenode` is log2 — table node array is `2^lsizenode` entries of 2×TValue-ish `Node`s (~24–32 B each depending on shuffle/alignment).
