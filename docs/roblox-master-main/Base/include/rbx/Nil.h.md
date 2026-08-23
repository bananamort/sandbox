# rbx/Nil.h

## Purpose
Apple-only hygiene header: `#undef nil` if defined. Prevents Objective-C/macOSHeaders' `nil` macro from colliding with Roblox code that uses `nil` as an identifier or enum member.

## API
```cpp
#if defined(__APPLE__)
#ifdef nil
#undef nil
#endif
#endif
```

## Usage
Include after Apple frameworks headers (or before engine headers) on Darwin targets.

## Gotchas
- No effect off __APPLE__; include unconditionally in cross-platform headers that need it.
