// roboxlua_extraspace.h — REAL RobloxExtraSpace remap onto Luau
// Replaces 2016's old RobloxExtraSpace (luaconf.h:763-925, sizeof ~96 bytes
// with Shared/AllThreads/Set hooks) which lived in Luau 5.1.4's LUAI_EXTRASPACE
// and was accessed via `reinterpret_cast<RobloxExtraSpace*>((char*)L - sizeof(...))`.
//
// Luau 0.735 has only 1 extra slot (LUA_EXTRA_SIZE = LUA_VECTOR_SIZE - 2 = 1)
// used for vector data. We use lua_getthreaddata/lua_setthreaddata (Luau public
// API) as a per-coroutine side-table. The 2016 macros luai_userstate* are
// emulated via thin wrappers in this header (call into the namespace impl)
// so engine code that defines them in 2016 luaconf works without change.
#pragma once

#include "VM/include/lua.h"  // brings in lua_getthreaddata / lua_setthreaddata
#include <boost/weak_ptr.hpp>
#include <boost/intrusive_ptr.hpp>
#include <boost/scoped_ptr.hpp>
#include <set>
#include <vector>

namespace RBX { class BaseScript; class ScriptContext; namespace Lua { class Continuations; } }

// Per-thread state. Replaces 2016's RobloxExtraSpace fields 1:1.
struct RobloxExtraSpace {
    int identity : 5;                 // RBX::Security::Identities (0-31), default Anonymous
    int yieldCaptured : 1;            // set before lua_yield, cleared on resume
    int reserved : 26;                // padding
    boost::weak_ptr<RBX::BaseScript> script;  // owning Script/ModuleScript
    boost::scoped_ptr<RBX::Lua::Continuations> continuations;  // resume hooks
    boost::intrusive_ptr<class WeakThreadRef::Node> node;       // GC keep-alive
    RBX::ScriptContext* context;
    RobloxExtraSpace* parent;  // parent coroutine's extra space (for from arg)
    std::vector<RobloxExtraSpace*> children;
    void* legacyShared;  // threadCount+allThreads, owned by ScriptContext
};

// Use Lua's official per-thread pointer slot.
inline RobloxExtraSpace* getRobloxExtraSpace(lua_State* L) {
    if (!L) return nullptr;
    void* p = lua_getthreaddata(L);
    return reinterpret_cast<RobloxExtraSpace*>(p);
}

inline void setRobloxExtraSpace(lua_State* L, RobloxExtraSpace* es) {
    lua_setthreaddata(L, es);
}

// 2016 had: reinterpret_cast<RobloxExtraSpace*>((char*)L - sizeof(RobloxExtraSpace))
// We use the named function so engine call sites `RobloxExtraSpace::get(L)` work
// (via the static get() in 2016).
namespace RBX {
    struct RobloxExtraSpaceAccessor {
        static ::RobloxExtraSpace* get(lua_State* L) { return getRobloxExtraSpace(L); }
    };
}

// Lifecycle (luai_userstate* equivalents). Call from C++ wrapper or directly
// from the engine. The 2016 lstate.c would call these from lua_newstate etc;
// since we have no lstate.c, we expose them as a public API that the engine's
// ScriptContext calls.
namespace RobloxExtraSpaceImpl {
    void onNewState(lua_State* L);    // luai_userstateopen
    void onCloseState(lua_State* L);  // luai_userstateclose
    void onNewThread(lua_State* L);   // luai_userstatethread
    void onFreeThread(lua_State* L);  // luai_userstatefree
    void onResume(lua_State* L);      // luai_userstateresume
    void onYield(lua_State* L);       // luai_userstateyield (no-op for now)
}

extern std::set<RobloxExtraSpace*>& allExtraSpaces();

inline void setRobloxExtraSpaceContext(lua_State* L, RBX::ScriptContext* ctx) {
    if (auto* es = getRobloxExtraSpace(L)) es->context = ctx;
}

inline void setRobloxExtraSpaceIdentity(lua_State* L, int identity) {
    if (auto* es = getRobloxExtraSpace(L)) es->identity = identity & 0x1F;
}

inline void setRobloxExtraSpaceScript(lua_State* L, boost::weak_ptr<RBX::BaseScript> s) {
    if (auto* es = getRobloxExtraSpace(L)) es->script = s;
}

inline void setRobloxExtraSpaceYieldCaptured(lua_State* L, bool captured) {
    if (auto* es = getRobloxExtraSpace(L)) es->yieldCaptured = captured ? 1 : 0;
}

template<typename F>
inline void forEachExtraSpace(F&& f) {
    for (auto* es : allExtraSpaces()) {
        if (es) f(es);
    }
}

// Shim to 2016's RBX::RobloxExtraSpace::get(L) call pattern. The class in
// 2016 is defined in luaconf.h; the engine code uses `RBX::RobloxExtraSpace
// ::get(L)`. We provide that namespace class.
namespace RBX {
    class RobloxExtraSpace {
    public:
        static ::RobloxExtraSpace* get(lua_State* L) { return getRobloxExtraSpace(L); }
    };
}
