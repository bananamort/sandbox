# App/include/solver/SolverContainers.h

## Purpose

Container shims + POD vector type for the hot solver paths: selectable map implementations behind typedefs and a POD clone of `Vector3` legal inside unions.

## Declared API

- `template<class K, class T> struct SolverUnorderedMap` — nested `Type` is `boost::unordered::unordered_map<K,T>`, or `std::map<K,T>` when `SOLVER_DEBUG_MAP` is defined ("easier debugger inspection").
- `template<class K, class T> struct SolverOrderedMap` — `Type` is always `std::map<K,T>`.
- `typedef DenseHashMap<const SimBody*, int> BodyIndexation;` — the actually-used body→index map (commented-out alternative above shows it replaced a `SolverUnorderedMap` variant).
- `class Vector3Pod` — plain `float x,y,z`; convertible from/to `Vector3` (`operator=(const Vector3&)`, `operator Vector3() const`), plus `float dot(const Vector3&)` and `Vector3Pod& operator+=(const Vector3&)`.
  - Free operators: `Vector3Pod operator*(float s, const Vector3Pod&)`, `Vector3Pod operator+(const Vector3Pod&, const Vector3Pod&)`.

## Gotchas

- `Vector3Pod::dot` takes a real `Vector3` (implicit conversion works both ways, but mixing types in one expression relies on the conversion operators).
- `SOLVER_DEBUG_MAP` changes container *type*, i.e. iteration order and allocator behavior differ between debug-map builds and normal builds — anything depending on iteration order is build-dependent.
- `BodyIndexation` keys raw `const SimBody*` pointers; lifetime of SimBodies must outspan the map (see [v8kernel/SimBody.h](../v8kernel/SimBody.md)).
