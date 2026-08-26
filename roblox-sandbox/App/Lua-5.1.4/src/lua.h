#pragma once
#include "VM/include/lua.h"
#include "VM/include/lualib.h"
// Provide legacy luaL_reg alias (lowercase) for old code
#ifndef luaL_reg
typedef luaL_Reg luaL_reg;
#endif
