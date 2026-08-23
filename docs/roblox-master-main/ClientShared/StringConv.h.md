# StringConv.h

Source: `roblox-sandbox/ClientShared/StringConv.h` (14 lines)

## Purpose

Declares the platform-neutral UTF-8 <-> system-string conversion pair and the `SysPathString` typedef used across the engine for filesystem paths (wide on Windows, narrow elsewhere).

## API

```cpp
namespace RBX {
#if defined(_WIN32)
    typedef std::wstring SysPathString;
#else
    typedef std::string  SysPathString;
#endif
    std::string     utf8_encode(const SysPathString &path);
    SysPathString   utf8_decode(const std::string &path);
}
```

## Usage

Widely included: Rendering/GfxRender (ShaderManager, TextureManager, Typesetters), Rendering/GfxCore/D3D11, Network/GameConfigurer, ClientBase/ReflectionMetadata.cpp, WindowsClient/Application.cpp, Win/VersionInfo.cpp, App/script/CoreScript.cpp + ScriptContext.cpp, App/v8datamodel (SafeChat, GlobalSettings), App/util (ContentProvider, Sound, AsyncHttpQueue, MD5Hasher, ProfanityFilter...). Implementations live in this directory (`StringConv.cpp`, Windows) and in `App/util/{Darwin,Android}/StringConv.cpp`.

## Gotchas

- The header is platform-agnostic but the sibling `StringConv.cpp` in this directory is Windows-only; picking the wrong implementation TU for a target is a link-time issue, not a compile error.
- Callers must know which direction they need — names are encode/decode relative to UTF-8.
