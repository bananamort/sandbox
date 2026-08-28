// roboxlua_extraspace.h — REAL RobloxExtraSpace remap onto Luau
// Replaces 2016's old RobloxExtraSpace (luaconf.h:763-925, sizeof ~96 bytes
// with Shared/AllThreads/Set hooks) which lived in Luau 5.1.4's LUAI_EXTRASPACE
// and was accessed via `reinterpret_cast<RobloxExtraSpace*>((char*)L - sizeof(...))`.
//
// Luau 0.735 has only 1 extra slot (LUA_EXTRA_SIZE = LUA_VECTOR_SIZE - 2 = 1)
// used for vector data. We use lua_getthreaddata/lua_setthreaddata (Luau public
// API) as a per-coroutine side-table.
#pragma once

#include "VM/include/lua.h"  // brings in lua_getthreaddata / lua_setthreaddata
#include <boost/weak_ptr.hpp>
#include <boost/intrusive_ptr.hpp>
#include <boost/scoped_ptr.hpp>
#include <set>
#include <vector>

namespace RBX { class BaseScript; class ScriptContext; namespace Lua { class Continuations; } }

// Per-thread state. Engine code does `RobloxExtraSpace::get(L)->identity = X`,
// so the namespace struct must have identity/yieldCaptured as accessible
// bitfields and the methods the engine calls (setContext, context,
// eraseRefsFromAllNodes, getThreadCount) as inline methods. The side-table
// pointer IS this struct, so methods operate on `this`.
struct RobloxExtraSpace {
    int identity : 5;                 // RBX::Security::Identities (0-31)
    int yieldCaptured : 1;            // set before lua_yield, cleared on resume
    int reserved : 26;                // padding
    boost::weak_ptr<RBX::BaseScript> script;
    boost::scoped_ptr<RBX::Lua::Continuations> continuations;
    // node: 2016 stored boost::intrusive_ptr<WeakThreadRef::Node> here for
    // GC keep-alive. We use std::set in the .cpp instead, so the Node
    // field is not present in our side-table (avoids pulling the
    // engine's script/ThreadRef.h into the vendored Luau adapter).
    RBX::ScriptContext* context;
    RobloxExtraSpace* parent;
    std::vector<RobloxExtraSpace*> children;
    void* legacyShared;
    // 2016's l_G->ckey/modKey lived in a global_State* that Luau removed.
    // We store the same two values on the side-table struct so the
    // engine's setKeys logic works without l_G.
    unsigned int ckey;
    unsigned int modKey;

    // 2016 instance methods — inline so the engine call pattern
    // `RobloxExtraSpace::get(L)->method()` resolves to these via the
    // global struct's lookup.
    void setContext(RBX::ScriptContext* ctx) { this->context = ctx; }
    RBX::ScriptContext* getContext() const { return this->context; }
    void eraseRefsFromAllNodes();
    int getThreadCount() const;

    // 2016 ThreadRef/WeakThreadRef integration methods. Real
    // implementations live in the .cpp; declared inline so the engine
    // call sites compile.
    void createNewNode();
    void getNode(void** outNode) const;  // returns typed pointer
    template <typename Func>
    void forEachThread(Func func) {
        for (auto* es : allExtraSpaces()) {
            if (es && es->context == this->context) {
                func(es);
            }
        }
    }
    // 0-arg overload (compat with call sites that don't pass a func).
    void forEachThread();

    // Static get() that the engine's RobloxExtraSpace::get(L) call resolves
    // to. Returns the side-table pointer for L.
    static RobloxExtraSpace* get(lua_State* L) {
        if (!L) return nullptr;
        void* p = lua_getthreaddata(L);
        return reinterpret_cast<RobloxExtraSpace*>(p);
    }
};

// The struct's static get(lua_State*) is the public API. The internal
// lifecycle hooks (onNewState etc) use the side-table pointer directly.
inline void setRobloxExtraSpace(lua_State* L, RobloxExtraSpace* es) {
    lua_setthreaddata(L, es);
}

namespace RobloxExtraSpaceImpl {
    void onNewState(lua_State* L);
    void onCloseState(lua_State* L);
    void onNewThread(lua_State* L);
    void onFreeThread(lua_State* L);
    void onResume(lua_State* L);
    void onYield(lua_State* L);
}

extern std::set<RobloxExtraSpace*>& allExtraSpaces();

inline void setRobloxExtraSpaceContext(lua_State* L, RBX::ScriptContext* ctx) {
    if (auto* es = RobloxExtraSpace::get(L)) es->context = ctx;
}
inline void setRobloxExtraSpaceIdentity(lua_State* L, int identity) {
    if (auto* es = RobloxExtraSpace::get(L)) es->identity = identity & 0x1F;
}
inline void setRobloxExtraSpaceScript(lua_State* L, boost::weak_ptr<RBX::BaseScript> s) {
    if (auto* es = RobloxExtraSpace::get(L)) es->script = s;
}
inline void setRobloxExtraSpaceYieldCaptured(lua_State* L, bool captured) {
    if (auto* es = RobloxExtraSpace::get(L)) es->yieldCaptured = captured ? 1 : 0;
}

template<typename F>
inline void forEachExtraSpace(F&& f) {
    for (auto* es : allExtraSpaces()) {
        if (es) f(es);
    }
}

// 2016: the engine writes `RobloxExtraSpace::get(L)->setContext(this)`.
// The 2016 setContext was inline in luaconf.h and operated on Shared.
// In our shim the same call resolves to the inline method above; the
// non-inline pieces (eraseRefsFromAllNodes, getThreadCount) go to the
// .cpp where the global set is visible.
