#pragma once
#include "VM/include/luaconf.h"
// Compatibility defines for old LUAI names
#ifndef LUAI_GCPAUSE
#define LUAI_GCPAUSE 200
#endif
#ifndef LUAI_GCMUL
#define LUAI_GCMUL 200
#endif
#ifndef LUA_GLOBALSINDEX
#define LUA_GLOBALSINDEX (-10002)
#endif
#ifndef LUA_ENVIRONINDEX
#define LUA_ENVIRONINDEX (-10001)
#endif
