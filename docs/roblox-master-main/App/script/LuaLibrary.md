# App/script/LuaLibrary.cpp

## Purpose

Implements `RbxLibrary` (Bridge<Library>) — the userdata behind the legacy `LoadLibrary("Name")` global. Each library name resolves to a single reused userdata instance stored in a registry-side lookup table so identity is stable across accesses (usable as table keys), while the actual library contents live in a second registry table populated asynchronously when the library's core script finishes running (`LibraryBridge::saveLibraryResult`, wired as the readResults continuation by ScriptContext::loadLibrary).

## API

- `template<> std::string StringConverter<Lua::Library>::convertToString(const Lua::Library&)` — returns `getLibraryName()`.
- `static void registerLibraryTable(lua_State *L)` — creates a plain registry table keyed by the lightuserdata address of the function itself: `lua_pushlightuserdata(L, (void*)&registerLibraryTable); lua_newtable(L); lua_rawset(L, LUA_REGISTRYINDEX);`.
- `template<> const char* Bridge<Library>::className("RbxLibrary")`.
- `static int getApi(lua_State *L)` — enumerates keys of the library's backing table (`t[libraryName]`) skipping non-string/empty keys, returns them as a 1-based Lua array table.
- `template<> int Bridge<Library>::on_index(const Library&, const char* name, lua_State*)` — "GetApi" returns the getApi C function; "Name" returns the library name string; otherwise resolves through the registry: fetch table-at-&registerLibraryTable, index by library name, then index by member name, leaving the found value on the stack. Assertions fire if registerClassLibrary was skipped or a library was pushed without being created.
- `template<> void Bridge<Library>::on_newindex(Library&, const char*, lua_State*)` — throws "%s cannot be assigned to".
- `void LibraryBridge::saveLibraryResult(lua_State *L, int results, std::string libraryName)` — validates exactly 1 result which must be a table containing a `"Help"` function ("Libraries should return exactly 1 result, and shouldn't wait" / "Libraries should return exactly 1 table" / "Libraries must contain a \"Help\" function"); stores either the error string or the result table into `t[libraryName]` of the library-table; separately, if valid, pushes/caches the Library userdata via `push(L, Library(libraryName))`, else records the error in a second registry table keyed by `&push`.
- `int LibraryBridge::find(lua_State *L, const std::string& libraryName)` — looks up `t[libraryName]` in the &push-keyed cache table; nil → pop and return 0 (not loaded); string → rearrange to `nil, errormsg` and return 2; else leave the cached userdata and return 1.
- `void LibraryBridge::push(lua_State *L, const Library& item)` — memoizes one userdata per library name in the &push-keyed registry table (created once, "Not a weak table, unlike SharedPtrBridge"), pushing the existing instance on repeat calls.
- `void LibraryBridge::registerClassLibrary(lua_State *L)` — allocates both registry tables (&push cache + &registerLibraryTable store).

## Usage

Consumed exclusively through `ScriptContext::loadLibrary`: find → miss triggers `CoreScript::fetchSource("Libraries/"+name)` + `executeInNewThread(..., boost::bind(&LibraryBridge::saveLibraryResult, _1, _2, libraryName), ...)` → find again. `registerClass`/`registerClassLibrary` are called per VM in `ScriptContext::openState`. The comment credits "Matt Campbell at Serotek Corporation" (lua-l post) for the single-instance userdata idea.

## Gotchas

- Library loading is intentionally synchronous-only: saveLibraryResult rejects results-count != 1 with the message "...shouldn't wait" — libraries cannot yield during definition (matching the RBXASSERT in loadLibrary).
- Two parallel registry tables exist: `&push` caches userdata identity AND stores load-error strings (find returns them as nil+msg), while `&registerLibraryTable` holds the real member tables indexed by name. Indexing a library before its script completes hits `RBXASSERT(!lua_isnil...)` in debug and undefined behavior in release.
- Registry keys are lightuserdata addresses of static functions — unique per binary but fragile under any refactor that moves these symbols.
- Errors are sticky: once an error string is cached under a name, subsequent finds keep returning nil+errormsg until the VM is torn down; there is no invalidation path.
