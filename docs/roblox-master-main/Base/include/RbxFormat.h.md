# RbxFormat.h

## Purpose
printf-style string formatting plus the engine-wide base exception hierarchy. Declares `RBX::format`/`RBX::vformat` (safe sprintf replacement), `RBX::runtime_error(fmt, ...)` convenience thrower, and the typedef `RBX::base_exception` from which `RBX::physics_receiver_exception` and `RBX::network_stream_exception` derive. This is where the exception type that propagates across `lua_pcall` boundaries in signal/scheduler code is rooted.

## API
```cpp
std::runtime_error runtime_error(const char* fmt, ...) RBX_PRINTF_ATTR(1,2);
std::string format(const char* fmt, ...) RBX_PRINTF_ATTR(1,2);
std::string vformat(const char* fmt, va_list argPtr);
std::string trim_trailing_slashes(const std::string& path);

#ifdef RBX_PLATFORM_IOS
typedef std::runtime_error base_exception;
#else
typedef std::exception base_exception;
#endif
class physics_receiver_exception : public base_exception { explicit physics_receiver_exception(const std::string& m); };
class network_stream_exception : public base_exception { explicit network_stream_exception(const std::string& m); };
```

## Usage
`throw RBX::runtime_error("bad value %d", v);` is the idiomatic engine error raise; `catch (RBX::base_exception&)` appears throughout `signal.h` handler dispatch. Non-Windows builds get portability shims: `sprintf_s`→`snprintf`, `sscanf_s`→`sscanf`, `strcasecmp`→(Win: `stricmp`), `DWORD`→`uint32_t`, `ARRAYSIZE` macro.

## Gotchas
- On iOS `base_exception` is `std::runtime_error`; elsewhere plain `std::exception`. The iOS-derived classes inherit message storage from the STL type; on other platforms each subclass stores its own `const std::string msg` and overrides `what()`.
- Non-iOS exception classes declare throwing-less destructors via `throw()` — mixing with C++17 (where `throw()` differs) would need review.
- `format` is documented fast only under ~160 characters of output.
- GCC/Clang get printf-format attribute checking; MSVC does not.
