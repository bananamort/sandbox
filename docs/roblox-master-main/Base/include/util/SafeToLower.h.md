# SafeToLower.h

## Purpose
Header-only ASCII-ish in-place lowercase conversion for `std::string`, guarded so only uppercase bytes are touched (avoids the UB/behavior pitfalls of passing non-uppercase chars through `tolower`).

## API
```cpp
namespace RBX {
inline void safeToLower(std::string& s);
}
```
Mutates the argument in place; no return value.

## Usage
Inline utility included wherever case-insensitive comparisons are prepared (e.g., name normalization). Callers typically call it then compare with `==`.

## Gotchas
- Uses C locale `isupper/tolower` per byte — not UTF-8 aware; multibyte sequences pass through untouched (which is the "safe" part).
- Loop index is `unsigned` against `s.size()` — fine on 32-bit size_t builds, narrowing-free but stylistically dated.
