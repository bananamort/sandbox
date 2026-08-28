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
