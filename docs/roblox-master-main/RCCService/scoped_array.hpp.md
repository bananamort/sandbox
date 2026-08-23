# scoped_array.hpp

Source: `roblox-sandbox/RCCService/scoped_array.hpp` (16 lines)

## Purpose

Local compatibility shim for Boost's `boost::scoped_array`. The file is the classic Boost smart-pointer header reduced to an include-forwarder: after the license block it contains exactly one directive:

```cpp
#include <smart_ptr/scoped_array.hpp>
```

It exists so that code in this project can write `#include "scoped_array.hpp"` (relative to the RCCService folder) and resolve against whatever internal smart-ptr root the build's include paths provide (`<smart_ptr/scoped_array.hpp>` — angle-bracket form, i.e. resolved from an additional include directory, not a full vendored Boost tree).

## API

Re-exports everything from `<smart_ptr/scoped_array.hpp>` — nominally `boost::scoped_array<T>` (non-copyable, array-scoped RAII owner with `operator[]`, `get()`, `reset()`). No local symbols are declared.

## Usage

Include guard mirrors upstream: `BOOST_SCOPED_ARRAY_HPP_INCLUDED`.

## Gotchas

- **Not self-contained**: the actual implementation lives in `<smart_ptr/scoped_array.hpp>` supplied by the build environment; UNKNOWN which tree provides it in this sandbox (a trimmed boost or engine-local `smart_ptr` folder).
- Vendored third-party code (Boost license, Greg Colvin / Beman Dawes / Peter Dimov); treated as unmodified upstream.
- Header is trivially safe to keep as-is; nothing here needs porting.
