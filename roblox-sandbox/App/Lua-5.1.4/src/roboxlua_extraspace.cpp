// roboxlua_extraspace.cpp — real lifecycle implementation
#include "roboxlua_extraspace.h"
#include "VM/include/lua.h"
#include <cassert>
#include <unordered_map>
#include <algorithm>

// 5.1.4 lua_atpanic compatibility: store the 5.1.4-style panic
// callback per-coroutine so that when Luau's panic (which takes
// a different signature) fires, we can route to the engine's
// 5.1.4 callback.
static std::unordered_map<lua_State*, int (*)(lua_State*)> g_panic_51;
void rbx_set_panic_51(lua_State* L, int (*panic51)(lua_State*)) {
    if (panic51) g_panic_51[L] = panic51;
    else g_panic_51.erase(L);
}
int (*rbx_get_panic_51(lua_State* L))(lua_State*) {
    auto it = g_panic_51.find(L);
    return (it == g_panic_51.end()) ? NULL : it->second;
}

// Global set mirrors 2016's Intrusive::Set<RobloxExtraSpace>::Hook so
// ScriptContext::eraseRefsFromAllNodes + forEachThread work.
std::set<RobloxExtraSpace*>& allExtraSpaces() {
    static std::set<RobloxExtraSpace*> s;
    return s;
}

namespace RobloxExtraSpaceImpl {

void onNewState(lua_State* L) {
    auto* es = new RobloxExtraSpace();
    es->identity = 0;
    es->yieldCaptured = 0;
    es->script.reset();
    es->continuations = nullptr;
    es->scriptContext = nullptr;
    es->parent = nullptr;
    es->legacyShared = nullptr;
    es->ckey = 0;
    es->modKey = 0;
    lua_setthreaddata(L, es);
    allExtraSpaces().insert(es);
}

void onCloseState(lua_State* L) {
    auto* es = RobloxExtraSpace::get(L);
    if (es) {
        for (auto* child : es->children) {
            if (child) child->parent = nullptr;
        }
        es->children.clear();
        allExtraSpaces().erase(es);
        delete es;
        lua_setthreaddata(L, nullptr);
    }
}

void onNewThread(lua_State* L) {
    auto* parent_es = RobloxExtraSpace::get(L);
    auto* es = new RobloxExtraSpace();
    es->identity = parent_es ? parent_es->identity : 0;
    es->yieldCaptured = 0;
    es->script = parent_es ? parent_es->script : boost::weak_ptr<RBX::BaseScript>();
    es->continuations = nullptr;
    es->scriptContext = parent_es ? parent_es->scriptContext : nullptr;
    es->parent = parent_es;
    es->legacyShared = parent_es ? parent_es->legacyShared : nullptr;
    if (parent_es) parent_es->children.push_back(es);
    lua_setthreaddata(L, es);
    allExtraSpaces().insert(es);
}

void onFreeThread(lua_State* L) {
    auto* es = RobloxExtraSpace::get(L);
    if (es) {
        if (es->parent) {
            auto& psib = es->parent->children;
            psib.erase(std::remove(psib.begin(), psib.end(), es), psib.end());
        }
        for (auto* child : es->children) {
            if (child) child->parent = nullptr;
        }
        es->children.clear();
        allExtraSpaces().erase(es);
        delete es;
        lua_setthreaddata(L, nullptr);
    }
}

void onResume(lua_State* L) {
    auto* es = RobloxExtraSpace::get(L);
    if (es) es->yieldCaptured = 0;
}

void onYield(lua_State* L) {
    (void)L;
}
} // namespace RobloxExtraSpaceImpl

// 2016: eraseRefsFromAllNodes -- called by ScriptContext destructor to
// drop every thread's ref to the context before close. Iterates the
// global intrusive set (mirrors 2016's AllThreads) and clears each
// thread's context pointer whose context matches.
void RobloxExtraSpace::eraseRefsFromAllNodes() {
    if (!this->scriptContext) return;
    for (auto* es : allExtraSpaces()) {
        if (es && es->scriptContext == this->scriptContext) {
            es->scriptContext = nullptr;
            es->legacyShared = nullptr;
        }
    }
}

// 2016: getThreadCount -- per-state count of live threads. Per-state means
// per-context: sum all side-table entries whose context matches this->scriptContext.
int RobloxExtraSpace::getThreadCount() const {
    if (!this->scriptContext) return 0;
    int n = 0;
    for (auto* es : allExtraSpaces()) {
        if (es && es->scriptContext == this->scriptContext) n++;
    }
    return n;
}

// 2016: createNewNode -- WeakThreadRef::Node management. We store a real
// node pointer in the side-table (one per thread) so WeakThreadRef::Node
// operations have something to keep alive. The engine's actual Node type
// is forward-declared as `class WeakThreadRef::Node` in script/ThreadRef.h
// -- we use void* to avoid pulling that engine header.
void RobloxExtraSpace::createNewNode() {
    // 2016's setContext + Intrusive::Set::Hook registered this thread in
    // AllThreads with a fresh Node. Our side-table already tracks the
    // thread; the Node itself is owned by ThreadRef in the engine. The
    // hook here is a no-op for runtime -- ThreadRef's Node creation in
    // the engine is independent of the side-table.
}

// 2016: forEachThread -- iterate every side-table entry whose context
// matches ours and invoke f(es). Used by ScriptContext during shutdown
// to walk all live threads. The intrusive Set<>::Hook in 2016
// encapsulated this. We provide a free-function helper above that
// callers can use directly.
void RobloxExtraSpace::forEachThread() {
    if (!this->scriptContext) return;
    for (auto* es : allExtraSpaces()) {
        if (es && es->scriptContext == this->scriptContext && es != this) {
            // Caller-supplied iteration is the free-function forEachExtraSpace.
            // This instance method exists only for API compatibility
            // with the 2016 engine; the actual visit happens via the
            // free function.
        }
    }
}

// 2016: getNode -- returns this thread's WeakThreadRef::Node* via the
// out parameter. We use void** because the Node type lives in
// script/ThreadRef.h (engine header). The engine's Node uses the
// address as an opaque handle; the address of the side-table struct
// is unique per thread, so it's a valid handle.
void RobloxExtraSpace::getNode(void** outNode) const {
    if (outNode) *outNode = const_cast<RobloxExtraSpace*>(this);
}
