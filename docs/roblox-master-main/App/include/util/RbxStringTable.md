# util/RbxStringTable.h

## Purpose
Obfuscated string table: string literals are compiled into a table and fetched by integer id at runtime via a `noinline` function — hiding sensitive literals (script names, security messages) from casual binary-string scans.

## Declared API
```cpp
#define STRING_BY_ID(id) (getStringById(id))

#ifdef _WIN32
__declspec(noinline) const char* getStringById(int id);
#elif __APPLE__ || __ANDROID__
__attribute__((noinline)) const char* getStringById(int id);
#else
#error Unsupported Platform.
#endif

enum StringIDs {
    ArgStringID = 0,
    LuaStringStringId = 1,        // "lua"
    CommandOutStringId = 2,       // "> %s"
    StudioASHXFmt = 3,            // fmt
    StudioASHX = 4,               // ashx
    RunningScript = 5,            // "Running script %s"
    ExecScriptNewThread = 6,      // "Execute script in new thread, name: %s, identity: %u"
    FullScriptCode = 7,           // "Full script code:\n %s"
    EnableToCreateSBThread = 8,   // "Unable to create trusted sandbox thread"
    EnableToCreateNewThread = 9,  // "Unable to create new thread"
    ScriptStr = 10,               // "Script"
    Rocky = 11,                   // "rocky"
    HasGamePassLuaWarning = 12,   // Game passes server-only warning
    NoTeleportInStudio = 13,      // Teleporting in Studio not permitted
    LoadingScreenScriptPath = 14, // path to loading-GUI-creating script
};
```

## Gotchas
- Only Windows / Apple / Android builds compile; anything else hits `#error`.
- The comments list the expected literal contents, but the real strings live in the implementation (and may be encoded/decoded at runtime).
- `noinline` is deliberate: keeps the fetch function out of caller frames so its identity is less obvious.
- IDs are fixed enum positions — inserting into the middle renumbers consumers; append only.

## UNKNOWN
- Where the table data + decoder live per platform (.cpp files outside App/include).
