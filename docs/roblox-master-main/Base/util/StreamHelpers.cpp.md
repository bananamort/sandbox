# StreamHelpers.cpp

## Purpose
Implementation of `RBX::readStreamIntoString`: sizes the stream via `seekg(end)/tellg()`, pre-sizes the output string, then bulk-reads into `&content[0]`.

## API
```cpp
void readStreamIntoString(std::istream &stream, std::string& content)
```
Overwrites `content` completely (assigns a fresh zero-filled buffer of stream length).

## Usage
Declared in include/util/StreamHelpers.h. Generic utility used by file/config loaders elsewhere in the tree.

## Gotchas
- `tellg()` result is cast straight to `size_t`; a failed `tellg()` (-1) becomes a huge allocation request — no error handling.
- C++98-era pattern `&content[0]` (pre-`.data()` writable guarantee); fine on the compilers this code shipped with.
