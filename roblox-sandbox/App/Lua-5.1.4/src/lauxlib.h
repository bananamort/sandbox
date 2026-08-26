#pragma once
#include "lua.h"
#include "lualib.h"
// Compatibility for old Lua 5.1 lauxlib.h -> Luau lualib.h
// Luau defines luaL_Reg in lualib.h as struct luaL_Reg { const char *name; lua_CFunction func; };
// Old code uses luaL_reg (lowercase) as alias; provide it.
#ifndef luaL_reg
typedef luaL_Reg luaL_reg;
#endif
// Also provide luaL_Reg if needed (already in lualib.h)
// Provide other lauxlib helpers that may be missing
