# StringConv.cpp

Source: `roblox-sandbox/ClientShared/StringConv.cpp` (25 lines)

## Purpose

Windows implementation of `RBX::utf8_encode` / `RBX::utf8_decode` using `WideCharToMultiByte(CP_UTF8, ...)` and `MultiByteToWideChar(CP_UTF8, ...)`. This is the variant compiled into Windows targets.

## API

```cpp
std::string   RBX::utf8_encode(const std::wstring &path);  // wstring -> UTF-8
std::wstring  RBX::utf8_decode(const std::string &path);   // UTF-8 -> wstring
```

## Usage

Called wherever engine code meets Windows filesystem or Win32 APIs expecting wide strings (paths, registry, window titles). Platform alternates: `App/util/Darwin/StringConv.cpp` (CoreFoundation) and `App/util/Android/StringConv.cpp`.

## Gotchas

- Includes `<windows.h>` with no guard — this exact file can only compile on Windows.
- Uses `&path[0]` to get a writable buffer (fine for C++11, technically UB before).
- No error checking of the conversion return values; invalid sequences are silently replaced per CP_UTF8 defaults.
