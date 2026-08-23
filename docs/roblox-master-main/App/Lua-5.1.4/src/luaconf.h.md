# App/Lua-5.1.4/src/luaconf.h

## Purpose
Lua's configuration header (stock `$Id: luaconf.h,v 1.82.1.7`), normally the *only* file users edit. In this tree it is the **primary Roblox integration seam**: it drags engine headers into every Lua TU, replaces longjmp with C++ exceptions, embeds a `RobloxExtraSpace` object before every `lua_State`, and installs an anti-tamper hook on `lua_unlock`. It is the single most invasive non-VM modification in the vendored tree.

## API
### Stock configuration kept
Platform switches (`LUA_ANSI/LUA_WIN/LUA_USE_POSIX/…`), `LUA_PATH/LUA_CPATH/LUA_INIT`, default paths, `LUA_DIRSEP`, `LUA_PATHSEP/MARK/EXECDIR/IGMARK`, `LUA_INTEGER ptrdiff_t`, `LUA_API/LUALIB_API`, `LUAI_FUNC/LUAI_DATA`, `LUA_QL/LUA_QS`, `LUA_IDSIZE 256`, standalone-interpreter block (`lua_stdin_is_tty`, `LUA_PROMPT`, `LUA_MAXINPUT 512`, readline hooks) gated by `lua_c|luaall_c`, `LUAI_GCPAUSE 200`, `LUAI_GCMUL 200`, number config (`LUA_NUMBER double`, `LUA_NUMBER_FMT "%.14g"`, Pentium `lua_number2int` asm/union tricks), `LUAI_USER_ALIGNMENT_T`, `LUA_MAXCAPTURES 32`, `lua_tmpnam` block, `LUA_DL_DLOPEN/DLL`, `LUA_INTFRMLEN "l"` / `LUA_INTFRM_T long`.

Limits: `LUAI_MAXCALLS 20000`, `LUAI_MAXCSTACK 8000`, `LUAI_MAXCCALLS 200`, `LUAI_MAXVARS 200`, `LUAI_MAXUPVALUES 60`, `LUAL_BUFFERSIZE BUFSIZ`.

### Roblox-modified / added surface
```c
// Engine includes pulled into EVERY Lua TU (lines 14–26):
#include <boost/shared_ptr.hpp>, boost/weak_ptr.hpp,
        "script/ScriptContext.h", "security/securityContext.h",
        "security/ApiSecurity.h", "security/FuzzyTokens.h",
        "util/ProgramMemoryChecker.h", "Script/ExitHandlers.h",
        "rbx/Intrusive/Set.h", "Script/LuaVM.h", "Script/ThreadRef.h"
// forward decls: RBX::BaseScript, RBX::ScriptContext, RBX::Network::Player
#ifdef __APPLE__ #undef check

#ifdef _DEBUG  #define HARDSTACKTESTS          // stack revalidation in debug
#if defined(_DEBUG)||defined(_NOOPT)
#define lua_assert(x) RBXASSERT(x)              // internal asserts → engine assert
#else
#define lua_assert(x) ((void)0)
#endif

// compat flags all OFF (each marked // ROBLOX):
#undef LUA_COMPAT_VARARG / MOD / LSTR / GFIND / OPENLIB

#define luai_apicheck(L,o) { (void)L; lua_assert(o); }   // was assert-style

// C++ exception error handling (replaces stock C++ throw of int):
#define LUAI_THROW(L,c)      throw(lua_exception(L,c))
#define LUAI_TRY(L,c,a)      try{a;} catch(lua_exception& e){e.commit(); if(!(c)->status)(c)->status=-1;}
                             catch(RBX::base_exception const& e){ try{ luaG_runerror(L,"%s",e.what()); } catch(lua_exception& e2){...} }
#define luai_jmpbuf int /* dummy */

// popen disabled:
#define lua_popen(L,c,m)  luaL_error(L, LUA_QL("popen") " not supported"), (FILE*)0
#define lua_pclose(L,file) 0
```

**`RobloxExtraSpace`** (lines 758–877, `#pragma pack(8)`): class embedded immediately before each `lua_State`; inherits `RBX::Intrusive::Set<RobloxExtraSpace>::Hook`; holds shared `Shared{threadCount, ScriptContext* context, AllThreads allThreads}`, `WeakThreadRef::Node` intrusive-ptr, bitfields `RBX::Security::Identities identity:5` and `bool yieldCaptured:1`, `weak_ptr<BaseScript> script`, `scoped_ptr<Continuations> continuations`. Static API: `get(L)` (`(char*)L - sizeof(RobloxExtraSpace)` reinterpret-cast), `constructRoot/destroyRoot/constructChild/destroyChild`, `context()/setContext()`, `getThreadCount()`, `getNode()`, `createNewNode()`, `eraseRefsFromAllNodes()`, `forEachThread(f)`. Child ctor validates security anchor via `shared->context->checkSecurityAnchorValid()` else sets `RBX::Tokens::apiToken.addFlagSafe(RBX::kScriptContextCopy)`.

```c
#define LUAI_EXTRASPACE sizeof(RobloxExtraSpace)
inline void luai_userstateopen(L)  { RobloxExtraSpace::constructRoot(L); }
inline void luai_userstateclose(L) { RobloxExtraSpace::destroyRoot(L); }
inline void luai_userstatethread(L,L1) { constructChild(L1, get(L)); }
inline void luai_userstatefree(L)  { destroyChild(L); }
inline void luai_userstateresume(L,nargs) { get(L)->yieldCaptured = false; }
inline void luai_userstateyield(L,nresults) {}
void lua_vmhooked_handler(lua_State* L);                       // defined in lstate.c
inline void lua_vmhooked_handler_ex(lua_State* L) {
    RBX::Tokens::apiToken.addFlagFast(RBX::kLuaHooked);
    RBX::pmcHash.nonce = 0;
    lua_vmhooked_handler(L);
}
#if defined(_WIN32) && !defined(RBX_STUDIO_BUILD)
#define lua_chk_ptr_rblx(ptr,handler,L) (RBX::isRbxTextAddr(ptr)?((void)0):handler(L))
#define lua_lock(L) ((void)0)
#define lua_unlock(L) lua_chk_ptr_rblx(_ReturnAddress(), lua_vmhooked_handler_ex, L)
#define lua_threadyield(L) ((void)0)
#else
#define lua_chk_ptr_rblx(...) ((void)0)
#endif
```
Plus `getlocaledecpoint()` with an `__ANDROID__` constant-dot special case.

## Usage
- Included first by `lua.h`; therefore transitively by **every** Lua core/lib file.
- The engine headers mean Lua TUs only compile inside the Roblox build (CMake target `include_directories(App/Lua-5.1.4/src)` in `App/CMakeLists.txt`).
- `ScriptContext.cpp` reaches through `l_G` to set per-VM keys; `RobloxExtraSpace` is how script code finds its `ScriptContext*` from any `lua_State`.
- `lua_exception` type itself lives in **`ldo.c`** (class definition at ldo.c:91–129, befriending `luaD_throw`/`luaD_rawrunprotected`; only expanded at `LUAI_THROW` use sites); `RBX::base_exception` in `security/securityContext.h`.

## Roblox modifications (vs stock Lua 5.1.4, symbol-level)
1. **Engine header injection**: `boost/*`, `script/ScriptContext.h`, `security/*`, `util/ProgramMemoryChecker.h`, `rbx/Intrusive/Set.h`, `Script/LuaVM.h`, `Script/ThreadRef.h` + `#undef check` on Apple.
2. `HARDSTACKTESTS` forced on in `_DEBUG`.
3. `lua_assert` → `RBXASSERT` in debug/nonopt builds.
4. All five `LUA_COMPAT_*` macros `#undef`'d with `// ROBLOX` markers.
5. `luai_apicheck` redefined to `lua_assert(o)` form.
6. **Exception model replaced**: `LUAI_THROW` throws `lua_exception`; `LUAI_TRY` adds `RBX::base_exception` handler that converts engine exceptions into Lua errors via `luaG_runerror`.
7. `lua_popen`/`lua_pclose` neutered (error + no-op).
8. **NEW class `RobloxExtraSpace`** + `LUAI_EXTRASPACE = sizeof(RobloxExtraSpace)` + all six `luai_userstate*` hooks implemented inline.
9. **Anti-tamper**: `lua_vmhooked_handler[_ex]`, token flag `kLuaHooked`, `RBX::pmcHash.nonce = 0` (ProgramMemoryChecker hash reset), `lua_chk_ptr_rblx` verifying `_ReturnAddress()` lies in `RBX::isRbxTextAddr`; wired into `lua_unlock` on Win32 non-studio builds — i.e., any call whose return address isn't Roblox code trips the hooked-Lua handler. This is the SEH/HATE_LUA family's companion at the lock level.
10. `getlocaledecpoint()` Android shim.

## Gotchas
- Editing anything here rebuilds essentially the whole engine: the header is included by `lua.h` → everywhere.
- `RobloxExtraSpace` sits at negative offset from `lua_State`; raw `malloc`'d or memcpy'd states corrupt it instantly. Always create threads via `lua_newthread` so `luai_userstatethread` runs.
- On Win32 release/client builds `lua_unlock` executes a return-address check on **every** unlock site — perf- and debugger-sensitive; studio (`RBX_STUDIO_BUILD`) and non-Win32 compile it out.
- `identity` is a 5-bit field — adding new `Security::Identities` beyond 31 silently truncates.
- `LUAI_TRY` swallowing `RBX::base_exception` means engine exceptions thrown across Lua frames become string errors (`e.what()`) — original exception object identity is lost.
