# Network/BoostAppend.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 12 lines)

## Purpose

Provides a `boost::hash_value` overload for `shared_ptr<RBX::PartInstance>` so that Boost unordered containers and `boost::multi_index` hashed indices (this file explicitly includes `<boost/multi_index/hashed_index.hpp>`) can key on PartInstance pointers by identity rather than by pointed-to value.

## API

```cpp
// global namespace boost
std::size_t boost::hash_value(const shared_ptr<RBX::PartInstance>& b);
```

Implementation hashes the raw pointer (`b.get()`) through `boost::hash<void*>`, i.e. identity hashing.

## Usage

- Declared in sibling header `BoostAppend.h` (which only forward-declares `RBX::PartInstance`).
- Consumed implicitly wherever the Network module inserts `shared_ptr<PartInstance>` into a hashed Boost container (e.g. physics-sender assembly bookkeeping). No direct call sites exist inside this file; it is an ADL hook.

## Gotchas

- Hashing pointer *identity* means two different `shared_ptr`s to equal-content parts hash differently — this is intended for tracking specific part objects.
- The function lives in namespace `boost` on purpose: that is how ADL finds it for `boost::hash<shared_ptr<...>>`.
- Depends on `V8DataModel/PartInstance.h`; keep include order in mind if refactoring.
