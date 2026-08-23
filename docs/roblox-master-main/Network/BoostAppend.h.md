# Network/BoostAppend.h

**Module**: Network (root) · **Type**: header (.h, 14 lines)

## Purpose

Declares the custom `boost::hash_value` overload for `shared_ptr<RBX::PartInstance>` implemented in `BoostAppend.cpp`. Exists so translation units that build hashed Boost containers of PartInstance smart pointers can include the declaration without dragging in the full PartInstance definition.

## API

```cpp
namespace boost {
    std::size_t hash_value(const shared_ptr<RBX::PartInstance>& b);
}
```

Forward declaration only: `RBX::PartInstance` is declared but not defined here.

## Usage

Include alongside `<boost/functional/hash.hpp>`-based containers (`unordered_set`, `multi_index` hashed indices) that store `shared_ptr<PartInstance>`. Implemented in `BoostAppend.cpp`.

## Gotchas

- The overload is *identity* based on the raw pointer; copying this pattern for value semantics would be wrong.
- `#pragma once` guarded; includes only `rbx/boost.hpp`.
