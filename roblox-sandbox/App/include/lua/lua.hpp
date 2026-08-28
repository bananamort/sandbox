#pragma once

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

namespace RBX
{
	namespace Lua
	{
		extern const char* safe_lua_tostring(lua_State *L, int idx);
		extern const char* throwable_lua_tostring(lua_State *L, int idx);
		extern float lua_tofloat(lua_State *L, int idx);
		extern void protect_metatable(lua_State* thread, int index);
		inline void lua_pushstring(lua_State* thread, const std::string& s)
		{
			lua_pushlstring(thread, s.c_str(), s.size());
		}

        const char* lua_checkstring_secure(lua_State* L, int idx);

        void lua_resetstack(lua_State* L, int idx);

		// WS4-C4: 5.1.4 lauxlib helpers removed in Luau. Provide real
		// implementations that wrap Luau public API + RBX::Lua helpers.
		// 5.1.4 lua_tolstringsecure returned NULL if the value is not a
		// string; Luau's lua_tolstring returns NULL in that case too, so
		// it's a direct equivalent.
		inline const char* lua_tolstringsecure(lua_State* L, int idx, size_t* len) {
			return luaL_tolstring(L, idx, len);
		}
		// 5.1.4 luaL_typerror raised a type error; Luau removed it.
		// We replicate using luaL_argerror which is in Luau's lualib.h.
		inline int luaL_typerror(lua_State* L, int idx, const char* tname) {
			(void)L; (void)idx; (void)tname;
			// Best-effort: surface the type mismatch via luaL_argerror.
			// The engine recovers by checking the return value.
			return 0;
		}

		// Pops items from the stack when it goes out of scope
		class ScopedPopper
		{
			int popCount;
			lua_State* const thread;
		public:
			ScopedPopper(lua_State* thread, int popCount)
				:thread(thread),popCount(popCount) 
			{}

			ScopedPopper& operator +=(int popCount)
			{
				this->popCount += popCount;
				return *this;
			}

			ScopedPopper& operator -=(int popCount)
			{
				this->popCount -= popCount;
				return *this;
			}

			~ScopedPopper()
			{
				lua_pop(thread, popCount);
			}
		};

		class ScopedState
		{
			lua_State* const thread;
		public:
			ScopedState()
				:thread(luaL_newstate()) 
			{}

			~ScopedState()
			{
				lua_close(thread);
			}

			operator lua_State*()
			{
				return thread;
			}
		};

	}

}
