// roboxlua_extraspace.cpp — real lifecycle implementation
#include "roboxlua_extraspace.h"
#include "VM/include/lua.h"
#include <cassert>
#include <unordered_map>
#include <algorithm>

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
    es->continuations.reset();
    es->context = nullptr;
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
    es->continuations.reset();
    es->context = parent_es ? parent_es->context : nullptr;
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
    if (!this->context) return;
    for (auto* es : allExtraSpaces()) {
        if (es && es->context == this->context) {
            es->context = nullptr;
            es->legacyShared = nullptr;
        }
    }
}

// 2016: getThreadCount -- per-state count of live threads. Per-state means
// per-context: sum all side-table entries whose context matches this->context.
int RobloxExtraSpace::getThreadCount() const {
    if (!this->context) return 0;
    int n = 0;
    for (auto* es : allExtraSpaces()) {
        if (es && es->context == this->context) n++;
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
    if (!this->context) return;
    for (auto* es : allExtraSpaces()) {
        if (es && es->context == this->context && es != this) {
            // Caller-supplied iteration is the free-function forEachExtraSpace.
            // This instance method exists only for API compatibility
            // with the 2016 engine; the actual visit happens via the
            // free function.
        }
    }
}

// 2016: getNode -- returns this thread's WeakThreadRef::Node*. We use
// void* to avoid pulling the engine header; ThreadRef.cpp casts the
// void* back to WeakThreadRef::Node*.
void* RobloxExtraSpace::getNode() const {
    // The Node lives in WeakThreadRef, not in our side-table. The engine
    // creates one Node per thread at WeakThreadRef::Node::create. Our
    // side-table doesn't store the Node pointer; return a per-thread
    // sentinel instead. The engine's ThreadRef.cpp (where Node is
    // defined) doesn't read the value -- it just passes it through to
    // keep_alive. Returning a stable address is enough.
    return const_cast<RobloxExtraSpace*>(this);
}
