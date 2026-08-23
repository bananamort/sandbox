# RbxFormat.cpp

## Purpose
Implements `RBX::format`, `RBX::vformat`, and `RBX::runtime_error(fmt, ...)` declared in RbxFormat.h: vsnprintf-based formatting with a 161-char stack fast path, 1 MB cap, heap fallback via `boost::scoped_array`.

## API
```cpp
std::runtime_error RBX::runtime_error(const char* fmt, ...);
std::string RBX::format(const char* fmt, ...);
std::string RBX::vformat(const char* fmt, va_list argPtr);
```
Windows uses `_vscprintf` to pre-size; POSIX relies on vsnprintf's return value (re-formats into heap buffer on truncation).

## Usage
The engine's universal error/message formatter; every `throw RBX::runtime_error(...)` site routes here.

## Gotchas
- Output is hard-capped at 1,000,000 chars — silently truncated beyond that.
- POSIX path formats TWICE for >160-char results (measure then re-format); side-effectful %n or stateful format tricks would misbehave.
- `NEWLINE` macro defined then #undef'd locally.
- MSVC warning 4530 (C++ exceptions) suppressed file-locally.
