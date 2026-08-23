# RbxStrings.h

## Purpose
Provides `Rbx_strcasestr`, a case-insensitive substring search for platforms whose libc lacks `strcasestr`. Algorithm borrowed from Apache's ap_strcasestr style.

## API
```cpp
namespace RBX {
static const char *Rbx_strcasestr(const char *h, const char *n); // returns pointer into h at first case-insensitive match of n, or 0
static inline const char *Rbx_strcasestr(const char *h, char *n);   // overload for mutable needle
static inline const char *Rbx_strcasestr(char *h, const char *n);   // overload for mutable haystack
}
```
Case folding via local `ap_tolower`/`ap_toupper` macros. The whole body is guarded by `#ifndef Rbx_strcasestr`, allowing a platform to supply its own macro/definition instead.

## Usage
Header-only (`static` functions), included by code needing loose string matching (protocol/header parsing). Because all three are `static`, every TU including it gets its own copy.

## Gotchas
- Returns a pointer to the START of the match region within `h`, but the inner loop advances both `h` and `a`; on success it returns `h` at the position where the matched run began — correct, but subtle.
- Empty haystack or empty needle returns 0 (NULL), unlike some strstr variants that return the haystack for an empty needle.
- O(n*m) naive scan; fine for short strings, not for hot paths.
- 2003–2005 ROBLOX copyright banner; one of the oldest files in Base.
