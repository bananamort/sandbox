#include "stdafx.h"
#include "script/LuaVM.h"

#include "util/ProtectedString.h"

#include "../Lua-5.1.4/src/VM/include/lua.h"
#include "../Lua-5.1.4/src/Compiler/include/luacode.h"

#include <cstdlib>

namespace LuaVM
{
    // WS4 Option-1 graft (dummy flavor for unit tests): source-only,
    // matching the server/client contract. The 5.1.4 lcode.c/lparser.c
    // includes and Proto-surgery finalize() are gone; tests compile
    // unobfuscated code straight through luau_compile.
    std::string compile(const std::string& source)
    {
        return source;
    }

    std::string compileLegacy(const std::string& source)
    {
        return source;
    }

    int load(lua_State* L, const RBX::ProtectedString& source, const char* chunkname, unsigned int modkey)
    {
        (void)modkey;

        const std::string& code = source.getSource();
        if (!code.empty())
        {
            lua_CompileOptions opts = {};
            opts.optimizationLevel = 1;
            opts.debugLevel = 1;

            size_t outsize = 0;
            char* bytecode = luau_compile(code.c_str(), code.size(), &opts, &outsize);
            int status = luau_load(L, chunkname ? chunkname : "?", bytecode, outsize, 0);
            free(bytecode);
            return status;
        }

        if (!source.getBytecode().empty())
        {
            lua_pushstring(L, "unsupported bytecode payload in source-only graft");
            return LUA_ERRSYNTAX;
        }

        lua_pushstring(L, "");
        return LUA_ERRSYNTAX;
    }

    unsigned int getKey()
    {
        return LUAVM_KEY_DUMMY;
    }

    std::string compileCore(const std::string& source)
    {
        return source;
    }

    unsigned int getKeyCore()
    {
        return LUAVM_KEY_DUMMY;
    }

    unsigned int getModKeyCore()
    {
        return LUAVM_MODKEY_DUMMY;
    }

    bool useSecureReplication()
    {
        return false;
    }

    bool canCompileScripts()
    {
        return true;
    }

    std::string getBytecodeCore(const std::string& name)
    {
        (void)name;
        return "";
    }

    boost::unordered_map<std::string, std::string> getBytecodeCoreModules()
    {
        return boost::unordered_map<std::string, std::string>();
    }

    unsigned int rbxOldEncode(unsigned int i, int pc, unsigned int key)
    {
        (void)i;
        (void)pc;
        (void)key;
        return i;
    }

    unsigned int rbxDaxEncode(unsigned int i, int pc, unsigned int key)
    {
        (void)pc;
        (void)key;
        return i;
    }
}
