// This file is part of the Luau programming language and is licensed under MIT License; see LICENSE.txt for details
// This code is based on Lua 5.x implementation licensed under MIT License; see lua_LICENSE.txt for details
#pragma once

// When debugging complex issues, consider enabling one of these:
// This will reallocate the stack very aggressively at every opportunity; use this with asan to catch stale stack pointers
// #define HARDSTACKTESTS 1
// This will call GC validation very aggressively at every incremental GC step; use this with caution as it's SLOW
// #define HARDMEMTESTS 1
// This will call GC validation very aggressively at every GC opportunity; use this with caution as it's VERY SLOW
// #define HARDMEMTESTS 2

// To force MSVC2017+ to generate SSE2 code for some stdlib functions we need to locally enable /fp:fast
// Note that /fp:fast changes the semantics of floating point comparisons so this is only safe to do for functions without ones
#if defined(_MSC_VER) && !defined(__clang__)
#define LUAU_FASTMATH_BEGIN __pragma(float_control(precise, off, push))
#define LUAU_FASTMATH_END __pragma(float_control(pop))
#else
#define LUAU_FASTMATH_BEGIN
#define LUAU_FASTMATH_END
#endif

// Some functions like floor/ceil have SSE4.1 equivalents but we currently support systems without SSE4.1
// Note that we only need to do this when SSE4.1 support is not guaranteed by compiler settings, as otherwise compiler will optimize these for us.
#if (defined(__x86_64__) || defined(_M_X64)) && !defined(__SSE4_1__) && !defined(__AVX__)
#if defined(_MSC_VER) && !defined(__clang__)
#define LUAU_TARGET_SSE41
#elif defined(__GNUC__) && defined(__has_attribute)
#if __has_attribute(target)
#define LUAU_TARGET_SSE41 __attribute__((target("sse4.1")))
#endif
#endif
#endif

// Used on functions that have a printf-like interface to validate them statically
#if defined(__GNUC__)
#define LUA_PRINTF_ATTR(fmt, arg) __attribute__((format(printf, fmt, arg)))
#else
#define LUA_PRINTF_ATTR(fmt, arg)
#endif

#ifdef _MSC_VER
#define LUA_NORETURN __declspec(noreturn)
#else
#define LUA_NORETURN __attribute__((__noreturn__))
#endif

// Can be used to reconfigure visibility/exports for public APIs
#ifndef LUA_API
#define LUA_API extern
#endif

#define LUALIB_API LUA_API

// Can be used to reconfigure visibility for internal APIs
#if defined(__GNUC__)
#define LUAI_FUNC __attribute__((visibility("hidden"))) extern
#define LUAI_DATA LUAI_FUNC
#else
#define LUAI_FUNC extern
#define LUAI_DATA extern
#endif

// Can be used to reconfigure internal error handling to use longjmp instead of C++ EH
#ifndef LUA_USE_LONGJMP
#define LUA_USE_LONGJMP 0
#endif

// LUA_IDSIZE gives the maximum size for the description of the source
#ifndef LUA_IDSIZE
#define LUA_IDSIZE 256
#endif

// LUA_MINSTACK is the initial number of reserved stack slots for a C function
#ifndef LUA_MINSTACK
#define LUA_MINSTACK 20
#endif

// LUAI_MAXCSTACK limits the number of Lua stack slots that a C function can use
#ifndef LUAI_MAXCSTACK
#define LUAI_MAXCSTACK 8000
#endif

// LUAI_MAXCALLS limits the number of nested calls
#ifndef LUAI_MAXCALLS
#define LUAI_MAXCALLS 20000
#endif

// LUAI_MAXCCALLS is the maximum depth for nested C calls; this limit depends on native stack size
#ifndef LUAI_MAXCCALLS
#define LUAI_MAXCCALLS 200
#endif

// buffer size used for on-stack string operations; this limit depends on native stack size
#ifndef LUA_BUFFERSIZE
#define LUA_BUFFERSIZE 512
#endif

// number of valid Lua userdata tags
#ifndef LUA_UTAG_LIMIT
#define LUA_UTAG_LIMIT 128
#endif

// number of valid Lua lightuserdata tags
#ifndef LUA_LUTAG_LIMIT
#define LUA_LUTAG_LIMIT 128
#endif

// upper bound for number of size classes used by page allocator
#ifndef LUA_SIZECLASSES
#define LUA_SIZECLASSES 40
#endif

// available number of separate memory categories
#ifndef LUA_MEMORY_CATEGORIES
#define LUA_MEMORY_CATEGORIES 256
#endif

// extra storage for execution callbacks in global state
#ifndef LUA_EXECUTION_CALLBACK_STORAGE
#define LUA_EXECUTION_CALLBACK_STORAGE 512
#endif

// minimum size for the string table (must be power of 2)
#ifndef LUA_MINSTRTABSIZE
#define LUA_MINSTRTABSIZE 32
#endif

// maximum number of captures supported by pattern matching
#ifndef LUA_MAXCAPTURES
#define LUA_MAXCAPTURES 32
#endif

// }==================================================================

#ifndef LUA_VECTOR_SIZE
#define LUA_VECTOR_SIZE 3 // must be 3 or 4
#endif

#ifndef LUA_VECTOR_DOUBLE
#define LUA_VECTOR_DOUBLE 0
#endif

#if LUA_VECTOR_DOUBLE == 1
#define LUA_VECTOR_TYPE double
#else
#define LUA_VECTOR_TYPE float
#endif

#define LUA_EXTRA_SIZE (LUA_VECTOR_SIZE - 2)


// === RobloxExtraSpace merged from 2016 (WS4-C2 shim) ===
// This object is embedded in every Lua thread to manage Roblox-specific information

class RobloxExtraSpace : public RBX::Intrusive::Set<RobloxExtraSpace>::Hook
{
	typedef RBX::Intrusive::Set<RobloxExtraSpace> AllThreads;

	struct Shared
	{
		int threadCount;
		RBX::ScriptContext* context;
		// We need to keep track of all Nodes so that we can clear them on shutdown.
		// See eraseRefsFromAllNodes
		AllThreads allThreads;
		Shared():threadCount(0),context(NULL) {}
	};
	const boost::shared_ptr<Shared> shared;
	typedef RBX::Lua::WeakThreadRef::Node Node;
	boost::intrusive_ptr<Node> node;
public:
	RBX::Security::Identities identity : 5;
	bool yieldCaptured : 1; 
	boost::weak_ptr<RBX::BaseScript> script;	// The script associated with this thread, if any
	boost::scoped_ptr<RBX::Lua::Continuations> continuations;

	RBX::ScriptContext* context() const { return shared->context; }
	size_t getThreadCount() const { return (size_t) shared->threadCount; }

	void setContext(RBX::ScriptContext* context) { shared->context = context; }

	Node* getNode() const { return node.get(); }

	void createNewNode()
	{
		node = new Node();
	}

	// This is called when we're shutting down everything. 
	// Makes sure all refs are cleared before we call lua_close()
	void eraseRefsFromAllNodes()
	{
		for (AllThreads::Iterator iter = shared->allThreads.begin(); iter != shared->allThreads.end(); ++iter)
			iter->node->eraseAllRefs();
	}

	template<class Func>
	inline void forEachThread(Func func)
	{
		for (AllThreads::Iterator iter = shared->allThreads.begin(); iter != shared->allThreads.end(); ++iter)
			iter->node->forEachRefs(func);
	}

	static RobloxExtraSpace* get(struct lua_State *L)
	{
		return L ? reinterpret_cast<RobloxExtraSpace*>(((char*) L) - sizeof(RobloxExtraSpace)) : 0;
	}
	static void constructRoot(lua_State *L)
	{
		new(get(L)) RobloxExtraSpace();
	}
	static void destroyRoot(lua_State *L)
	{
		get(L)->~RobloxExtraSpace();
	}
	static void constructChild(lua_State *L, RobloxExtraSpace *parent)
	{
		new(get(L)) RobloxExtraSpace(parent);
	}
	static void destroyChild(lua_State *L)
	{
		get(L)->~RobloxExtraSpace();
	}

private:
	RobloxExtraSpace()
		:shared(new Shared())
		,identity(RBX::Security::Anonymous)
		,node(0)
	{
		shared->threadCount++;

		shared->allThreads.insert(*this);
	}

	RobloxExtraSpace(RobloxExtraSpace* parent)
		:shared(parent->shared)
		,identity(parent->identity)
		,yieldCaptured(false)
		,script(parent->script)
		,node(parent->node)
	{
		shared->threadCount++;

		RBXASSERT(node);

        if (!shared->context->checkSecurityAnchorValid())
        {
            RBX::Tokens::apiToken.addFlagSafe(RBX::kScriptContextCopy);
        }
        else
        {
           shared->allThreads.insert(*this);
        }
	}

	~RobloxExtraSpace()
	{
		shared->allThreads.remove_element(*this);

		shared->threadCount--;
		RBXASSERT(shared->threadCount >= 0);
	}


};
#pragma pack(pop)

#ifndef getlocaledecpoint
#ifdef __ANDROID__
#   define getlocaledecpoint() '.'
#else
#   define getlocaledecpoint() (localeconv() ? localeconv()->decimal_point[0] : '.');
#endif
#endif

/*
@@ LUAI_EXTRASPACE allows you to add user-specific data in a lua_State
@* (the data goes just *before* the lua_State pointer).
** CHANGE (define) this if you really need that. This value must be
** a multiple of the maximum alignment required for your machine.
*/
#define LUAI_EXTRASPACE		sizeof(RobloxExtraSpace)


/*
@@ luai_userstate* allow user-specific actions on threads.
** CHANGE them if you defined LUAI_EXTRASPACE and need to do something
** extra when a thread is created/deleted/resumed/yielded.
*/
inline void luai_userstateopen(lua_State *L)
{
	RobloxExtraSpace::constructRoot(L);
}
inline void luai_userstateclose(lua_State *L)
{
	RobloxExtraSpace::destroyRoot(L);
}
inline void luai_userstatethread(lua_State *L, lua_State *L1)
{
	RobloxExtraSpace::constructChild(L1, RobloxExtraSpace::get(L));
}
inline void luai_userstatefree(lua_State *L)
{
	RobloxExtraSpace::destroyChild(L);
}
inline void luai_userstateresume(lua_State *L, int nargs)
{
	RobloxExtraSpace::get(L)->yieldCaptured = false;
}

inline void luai_userstateyield(lua_State *L, int nresults)
{
}
// ROBLOX - END

// Compatibility defines for old LUAI names
#ifndef LUAI_GCPAUSE
#define LUAI_GCPAUSE 200
#endif
#ifndef LUAI_GCMUL
#define LUAI_GCMUL 200
#endif
#ifndef LUA_GLOBALSINDEX
#define LUA_GLOBALSINDEX (-10002)
#endif
#ifndef LUA_ENVIRONINDEX
#define LUA_ENVIRONINDEX (-10001)
#endif
