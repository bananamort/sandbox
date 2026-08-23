# format_string.h

Source: `roblox-sandbox/ClientShared/format_string.h` (114 lines)

## Purpose

Declares the shared printf helpers and string conversions (see format_string.cpp) plus two extras defined entirely in the header: `CVTW2S`/`CVTS2W`/`MAKE_STRING` UNICODE macros and the `simple_logger<CHARTYPE>` template — a timestamped temp-file logger used by client bootstrapping code.

## API

```cpp
std::string vformat(const char*, va_list);
std::wstring vformat(const wchar_t*, va_list);
std::string format_string(const char*, ...);
std::wstring format_string(const wchar_t*, ...);
std::string convert_w2s(const std::wstring&);
std::wstring convert_s2w(const std::string&);
std::vector<std::string> splitOn(const std::string&, const char&, bool trimEmpty = true);
std::vector<std::wstring> splitOn(const std::wstring&, const wchar_t&, bool trimEmpty = true);

// UNICODE-aware macros: CVTW2S(v), CVTS2W(v), MAKE_STRING(lit)

template<class CHARTYPE> class simple_logger {
    simple_logger();                                  // temp file "RBX-%08X.log" in GetTempPath
    simple_logger(const CHARTYPE *fileName);          // explicit file
    void write_logentry(const char *format, ...);     // timestamp + vformat + flush per line
    static STRING get_tmp_path();
    static STRING get_temp_filename(const CHARTYPE* ext);
    STRING &log_filename();
};
```

## Usage

- `simple_logger<wchar_t>` is the logger type passed to `CountersClient`'s constructor; `write_logentry` is used by CountersClient.cpp and SharedLauncher-style bootstrap logging.
- The default constructor generates a GUID-suffixed file name via `CoCreateGuid`.

## Gotchas

- `get_temp_filename` formats with `"%SRBX-%08X.%S"` into a **narrow** `char` buffer while passing wide-string args under UNICODE. This only works because MSVC inverts `%s`/`%S` in narrow printf (`%S` = wide there): the expansion resolves to `<GetTempPath()>RBX-<CoCreateGuid().Data1 as %08X>.<ext>` (e.g. `...RBX-1A2B3C4D.log`). Standard C libraries would treat `%S` differently, so the code is MSVC-only by construction (it is inside `#ifdef _WIN32`).
- `write_logentry_raw` is Windows-only (`#ifdef _WIN32`); on other platforms log entries are silently dropped while the ofstream still opens.
- Timestamps use UTC (`GetSystemTime`), flushed after every line.
- Non-Windows `get_tmp_path()` returns an empty string, so named loggers write into the working directory.
