# StreamHelpers.h

## Purpose
Declares one helper for slurping a seekable `std::istream` into a `std::string` in a single allocation.

## API
```cpp
namespace RBX {
void readStreamIntoString(std::istream &stream, std::string& content);
}
```

## Usage
Implemented in util/StreamHelpers.cpp. Note the header has no `#pragma once`/include guards; it is small and header-only-declaration style, but double inclusion would redeclare harmlessly (same declaration).

## Gotchas
- Requires a seekable stream: uses `seekg(0, end)` / `tellg()` sizing, so pipes/stdin will misbehave (UNKNOWN whether any caller passes non-seekable streams).
