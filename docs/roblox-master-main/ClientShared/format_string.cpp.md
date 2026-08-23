# format_string.cpp

Source: `roblox-sandbox/ClientShared/format_string.cpp` (227 lines)

## Purpose

printf-family helpers shared by nearly every subsystem: `format_string` / `vformat` (narrow and wide), ANSI-codepage `convert_w2s` / `convert_s2w`, and `splitOn` tokenizers. Also supplies `_vscprintf`/`vsnprintf_s` shims for Apple/Android builds.

## API

```cpp
std::string  vformat(const char *fmt, va_list argPtr);
std::wstring vformat(const wchar_t *fmt, va_list argPtr);      // WIN32 only
std::string  format_string(const char* fmt, ...);
std::wstring format_string(const wchar_t* fmt, ...);           // WIN32 only
std::string  convert_w2s(const std::wstring &str);   // CP_ACP on Win32
std::wstring convert_s2w(const std::string &str);    // codepage 0 (system default) on Win32
std::vector<std::string>  splitOn(const std::string&,  const char&,  bool trimEmpty = true);
std::vector<std::wstring> splitOn(const std::wstring&, const wchar_t&, bool trimEmpty = true);
```

Apple/Android shims at top of file:

```cpp
inline int _vscprintf(const char*, va_list);            // via vsnprintf(NULL,0,...)
static const size_t _TRUNCATE = 0;
inline int vsnprintf_s(char*, size_t, size_t, const char*, va_list);
```

## Usage

Included by dozens of TUs: WindowsClient (Application, View, RbxWebView, WebBrowserAxDialog), Win (VersionInfo, SharedLauncher via its header), ClientShared itself (CountersClient via its header, RobloxServicesTools, InfluxDbHelper), ClientBase (MachineConfiguration), Network (Player), App/v8datamodel (DataModel, Stats, CookiesEngineService), App/util (Statistics, MachineIdUploader). It is effectively the engine's low-level formatting layer.

## Gotchas

- `convert_w2s` uses **CP_ACP** and `convert_s2w` uses codepage 0 — both are the legacy ANSI codepage, NOT UTF-8. Use `RBX::utf8_encode/decode` (StringConv.h) when UTF-8 semantics matter; mixing them produces mojibake for non-ASCII paths.
- `vformat` caps output at 1 MB (`maxSize`) and uses a 161-char stack buffer fast path; strings between 161 chars and 1 MB always allocate the full 1 MB heap block (deliberate, avoids a second sizing pass).
- Wide overloads exist only under `#ifdef WIN32`; non-Windows callers get narrow-only.
- `splitOn("a,b,", ',', true)` drops empty tokens including a trailing one; with `trimEmpty=false` empties are kept.
- On non-Windows, `WIN32` (no underscore) guards the windows.h include while other files use `_WIN32`; both spellings appear across the tree.
