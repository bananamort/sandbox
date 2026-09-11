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

// Forward declare so the forEachThread template (line 70) can reference
// allExtraSpaces() at template-definition time (non-dependent name lookup
// uses only declarations visible at the point of template definition).
struct RobloxExtraSpace;
extern std::set<RobloxExtraSpace*>& allExtraSpaces();

namespace RobloxExtraSpaceImpl {
// Process-wide guard for allExtraSpaces(). Entries are created on engine
// threads (onNewState/onNewThread) and now also destroyed on GC threads
// (userthread -> onFreeThread), so every mutation and every iteration
// must hold this. Callbacks run under it must never touch the set.
void rbx_extraSpacesLock();
void rbx_extraSpacesUnlock();
struct ExtraSpacesGuard {
    ExtraSpacesGuard() { rbx_extraSpacesLock(); }
    ~ExtraSpacesGuard() { rbx_extraSpacesUnlock(); }
};
}

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
    // continuations: 2016 stored boost::scoped_ptr<RBX::Lua::Continuations>
    // here. A scoped_ptr needs the complete type in every TU that
    // includes this header, which the Luau adapter can't provide — so
    // the field is a raw pointer to the forward-declared engine type.
    // Ownership matches 5.1.4: the entry owns it, freed by
    // rbx_deleteContinuations (defined where the full type is visible)
    // from onFreeThread/onCloseState.
    RBX::Lua::Continuations* continuations;
    // threadNode: one real WeakThreadRef::Node per thread, owned by the
    // entry (freed with it). Stored as void* because Node's type lives
    // in the engine's script/ThreadRef.h, which this adapter must not
    // include. Created on demand by WeakThreadRef::Node::create,
    // destroyed by rbx_freeThreadNode (both engine-side, full type).
    // Never the entry pointer itself: Node's intrusive list head
    // (`first`) is written through this pointer, so aliasing the
    // entry clobbers the script weak_ptr beside it.
    void* threadNode;
    RBX::ScriptContext* scriptContext;
    RobloxExtraSpace* parent;
    std::vector<RobloxExtraSpace*> children;
    void* legacyShared;
    // 2016's l_G->ckey/modKey lived in a global_State* that Luau removed.
    // We store the same two values on the side-table struct so the
    // engine's setKeys logic works without l_G.
    unsigned int ckey;
    unsigned int modKey;
    // Back-pointer to the owning thread, so engine code holding only an
    // entry (e.g. hook propagation) can reach its lua_State. Set once at
    // creation; the entry outlives all such uses (freed with the state).
    lua_State* self;
    // Per-thread 5.1-style hook state for the real lua_sethook. Plain
    // C struct (declared in lua.h) so the VM loop can poll it without
    // engine types; the engine reads/writes it through rbx_hookstate.
    RbxHookState hook;

    // 2016 instance methods — inline so the engine call pattern
    // `RobloxExtraSpace::get(L)->method()` resolves to these via the
    // global struct's lookup.
    void setContext(RBX::ScriptContext* ctx) { this->scriptContext = ctx; }
    RBX::ScriptContext* getContext() const { return this->scriptContext; }
    // 5.1.4 used just `->context()` as a method-call-style accessor.
    // Provide a real method named `context` that returns the underlying
    // ScriptContext* so the engine's call pattern works. The data
    // member is `scriptContext` so there is no name collision.
    RBX::ScriptContext* context() const { return this->scriptContext; }
    void eraseRefsFromAllNodes();
    int getThreadCount() const;

    // 2016 ThreadRef/WeakThreadRef integration methods. Real
    // implementations live in the .cpp; declared inline so the engine
    // call sites compile.
    void createNewNode();
    void getNode(void** outNode) const;  // returns typed pointer
    // Destroys the per-thread Node (engine-side; needs the full Node
    // type). Called from onFreeThread/onCloseState before the entry
    // itself is deleted. The Node destructor drops every member ref.
    template <typename Func>
    void forEachThread(Func func) {
        RobloxExtraSpaceImpl::ExtraSpacesGuard guard;
        for (auto* es : allExtraSpaces()) {
            if (es && es->scriptContext == this->scriptContext) {
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
    // parent supplies identity/context/ckey inheritance; the new thread's
    // own entry is always empty at this point, so it cannot be the source.
    void onNewThread(lua_State* L, lua_State* parent);
    void onFreeThread(lua_State* L);
    void onResume(lua_State* L);
    void onYield(lua_State* L);
}

// Defined where RBX::Lua::Continuations is complete (ScriptContext.cpp).
// Lets the adapter free continuations without seeing the full type.
void rbx_deleteContinuations(RBX::Lua::Continuations* p);

// Defined engine-side (ThreadRef.cpp, full Node type). Destroys the
// per-thread Node: its destructor drops every member WeakThreadRef.
void rbx_freeThreadNode(void* node);

inline void setRobloxExtraSpaceContext(lua_State* L, RBX::ScriptContext* ctx) {
    if (auto* es = RobloxExtraSpace::get(L)) es->scriptContext = ctx;
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
    RobloxExtraSpaceImpl::ExtraSpacesGuard guard;
    for (auto* es : allExtraSpaces()) {
        if (es) f(es);
    }
}

// 2016: the engine writes `RobloxExtraSpace::get(L)->setContext(this)`.
// The 2016 setContext was inline in luaconf.h and operated on Shared.
// In our shim the same call resolves to the inline method above; the
// non-inline pieces (eraseRefsFromAllNodes, getThreadCount) go to the
// .cpp where the global set is visible.
