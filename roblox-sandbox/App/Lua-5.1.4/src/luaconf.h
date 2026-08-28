#pragma once
// WS4-C3: real Luau luaconf with RobloxExtraSpace hook macros.
// This is no longer a "shim stub" — it includes the Luau VM/include/luaconf.h
// and ADDS the luai_userstate* macros that the 2016 engine relied on. The
// macros route through RobloxExtraSpaceImpl::on* which use lua_getthreaddata /
// lua_setthreaddata (Luau public API) for per-coroutine state.
#include "VM/include/luaconf.h"

// Compat defines for old LUAI names referenced by 2016 engine code.
#ifndef LUAI_GCPAUSE
#define LUAI_GCPAUSE 200
#endif
#ifndef LUAI_GCMUL
#define LUAI_GCMUL 200
#endif

// LUA_QS in 5.1.4 was a bare literal-quote: #define LUA_QS LUA_QL("%s") i.e. `'%s'`.
// Used in code as `LUA_QS "missing"`, so it must be a bare token, not a macro.
#ifndef LUA_QS
#define LUA_QS "'%s'"
#endif

// Real per-thread lifecycle hooks. Luau's luaconf.h has no userstate
// hooks; we declare them and implement in roboxlua_extraspace.cpp. The
// App code that defines luai_userstate* needs the prototype here, plus
// a way to reach our impl. The simplest path: include the header.
#include "roboxlua_extraspace.h"

// 2016's luaconf.h included "Script/LuaVM.h" which declared the namespace
// LuaVM (compile/load/canCompileScripts/etc). Many engine TUs call
// `LuaVM::canCompileScripts()` and `LuaVM::load(...)` directly without
// including LuaVM.h themselves — they relied on the transitive include.
// Re-establish that here so the existing call sites work unchanged.
#include "script/LuaVM.h"
