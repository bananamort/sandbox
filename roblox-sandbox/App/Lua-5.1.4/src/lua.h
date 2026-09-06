#pragma once
// 5.1.4 luaconf.h is the 2016 custom shim (LUA_QS, LUA_GLOBALSINDEX, our
// RobloxExtraSpace adapter). Pull it in BEFORE Luau's, then layer Luau's
// VM/include/lua.h on top so the 5.1.4 compat definitions take precedence
// over Luau's. luaconf.h does `#include "VM/include/luaconf.h"` internally
// to pull in Luau's base, then adds the 2016-specific shims.
#include "luaconf.h"
#include "VM/include/lua.h"
#include "VM/include/lualib.h"
// Provide legacy luaL_reg alias (lowercase) for old code
#ifndef luaL_reg
typedef luaL_Reg luaL_reg;
#endif
