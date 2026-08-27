// roboxlua_extraspace.cpp — real lifecycle implementation
#include "roboxlua_extraspace.h"
#include "VM/include/lua.h"
#include <cassert>

// Global set mirrors 2016's Intrusive::Set<RobloxExtraSpace>::Hook so
// ScriptContext::eraseRefsFromAllNodes + forEachThread work.
std::set<RobloxExtraSpace*>& allExtraSpaces() {
    static std::set<RobloxExtraSpace*> s;
    return s;
}

namespace RobloxExtraSpaceImpl {

void onNewState(lua_State* L) {
    auto* es = new RobloxExtraSpace();
    es->identity = 0;          // Anonymous
    es->yieldCaptured = 0;
    es->script.reset();
    es->continuations.reset();
    es->node.reset();
    es->context = nullptr;
    es->parent = nullptr;
    es->legacyShared = nullptr;
    lua_setthreaddata(L, es);
    allExtraSpaces().insert(es);
}

void onCloseState(lua_State* L) {
    auto* es = getRobloxExtraSpace(L);
    if (es) {
        // Erase children entries that point back to us
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
    // 2016: constructChild copies shared (threadCount, context, allThreads)
    // and inserts into AllThreads.
    auto* parent_es = getRobloxExtraSpace(L);  // parent thread
    auto* es = new RobloxExtraSpace();
    es->identity = parent_es ? parent_es->identity : 0;
    es->yieldCaptured = 0;
    es->script = parent_es ? parent_es->script : boost::weak_ptr<RBX::BaseScript>();
    es->continuations.reset();  // child has its own continuations
    es->node = parent_es ? parent_es->node : boost::intrusive_ptr<class WeakThreadRef::Node>();
    es->context = parent_es ? parent_es->context : nullptr;
    es->parent = parent_es;
    es->legacyShared = parent_es ? parent_es->legacyShared : nullptr;
    if (parent_es) parent_es->children.push_back(es);
    lua_setthreaddata(L, es);
    allExtraSpaces().insert(es);
}

void onFreeThread(lua_State* L) {
    // 2016: destroyChild removes from AllThreads and decrements threadCount.
    auto* es = getRobloxExtraSpace(L);
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
    auto* es = getRobloxExtraSpace(L);
    if (es) es->yieldCaptured = 0;  // 2016: luai_userstateresume sets yieldCaptured=false
}

void onYield(lua_State* L) {
    // 2016: luai_userstateyield does nothing; yieldCaptured set by callers
    // (YieldingThreads::queueWaiter / EventBridge::wait). No-op here.
    // Caller-side: use setRobloxExtraSpaceYieldCaptured(L, true) before lua_yield.
}
} // namespace RobloxExtraSpaceImpl
