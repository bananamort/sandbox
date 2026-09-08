#include "stdafx.h"
#include <cstdio>
#include "script/LuaVM.h"

#include "util/ProtectedString.h"
#include "script/ScriptCapture.h"


#include "../Lua-5.1.4/src/VM/include/lua.h"
#include "../Lua-5.1.4/src/Compiler/include/luacode.h"
#include "luaconf.h"  // RobloxExtraSpace for thread identity in load log

#include <cstdlib>

namespace LuaVM
{
    // WS4 Option-1 graft: no RSB1 bytecode crypto. compile() is the
    // identity (the wire carries source text while useSecureReplication()
    // is false); load() compiles source with luau_compile and loads the
    // result with luau_load. modkey/ckey are unused.
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
        {
            int identity = -1;
            if (RobloxExtraSpace* es = RobloxExtraSpace::get(L))
                identity = es->identity;
            const char* cn = chunkname ? chunkname : "?";
            char head[160];
            snprintf(head, sizeof(head), "chunk=%s bytes=%u identity=%d",
                cn, (unsigned)code.size(), identity);
            std::vector<RBX::ScriptCapture::Field> loadFields;
            loadFields.push_back({"chunk", RBX::ScriptCapture::FieldVal::str(cn)});
            loadFields.push_back({"bytes", RBX::ScriptCapture::FieldVal::num((long long)code.size())});
            loadFields.push_back({"identity", RBX::ScriptCapture::FieldVal::num(identity)});
            RBX::ScriptCapture::emitFields("load", head, loadFields);
            if (!code.empty())
            {
                std::vector<RBX::ScriptCapture::Field> srcFields(loadFields);
                srcFields.push_back({"source", RBX::ScriptCapture::FieldVal::str(code)});
                RBX::ScriptCapture::emitFields("loadSource", std::string(head) + "\n" + code, srcFields);
            }
        }
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
