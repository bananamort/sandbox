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

// WS4-C2 compat stub for RobloxExtraSpace (proper remap lands in WS4-C3)
struct lua_State;
namespace RBX { struct RobloxExtraSpace { static RobloxExtraSpace* get(lua_State*) { return nullptr; } int dummy; }; }
namespace RBX { namespace Lua { struct Continuations {}; } }
class LuaVM { public: static bool canCompileScripts() { return true; } static const char* getBytecodeCore() { return nullptr; } };
// Minimal LUA_QS compat
#ifndef LUA_QS
#define LUA_QS(x) "'" x "'"
#endif
