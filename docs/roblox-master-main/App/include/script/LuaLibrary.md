# App/include/script/LuaLibrary.h

## Purpose

Declares `RBX::Lua::Library`, a lightweight value type identifying a Roblox library (e.g. `game`, `workspace`, `Instance` style namespaces) by name, and `RBX::Lua::LibraryBridge`, the `Bridge<Library>` that pushes/finds these libraries as Lua values (comment in source: "Represents a Reflection::EnumDescriptor::Item in Lua" — i.e. the bridge pattern reused for library tables).

## Declared API

- `class RBX::Lua::Library`
  - Private: `std::string libraryName;`
  - `Library(std::string libraryName);` (inline, takes by value)
  - `const std::string& getLibraryName() const;` (inline)
  - `bool operator ==(const Library& other) const;` (inline, compares names)
- `class RBX::Lua::LibraryBridge : public Bridge<Library>`
  - `static void registerClassLibrary(lua_State* L);`
  - `static int find(lua_State* L, const std::string& libraryName);`
  - `static void push(lua_State* L, const Library& item);`
  - `static void saveLibraryResult(lua_State* L, int results, std::string libraryName);`

## Usage notes

- Header-only value type; all Lua-facing behavior is in the bridge's .cpp (certified App/script module).

## Gotchas

- Equality is name-based only — two `Library` objects with the same name are interchangeable.
- The header comment claims it represents an EnumDescriptor item; in practice this file only models libraries — treat the comment as historical.
