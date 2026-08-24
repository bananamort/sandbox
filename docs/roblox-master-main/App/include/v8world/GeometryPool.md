# App/include/v8world/GeometryPool.h

## Purpose

Process-wide refcounted cache of immutable geometry payloads (meshes, corner arrays, Bullet shapes) keyed by size — so thousands of same-sized parts share one payload. Template `GeometryPool<Key, Value, Comparer>` plus the key comparers used across v8world.

## Declared API

- Comparers (each with strict-weak `operator()` + boost hash where needed):
  - `Vector3Comparer` — lexicographic x→y→z.
  - `Vector3_2Ints` struct `{Vector3 vectPart; int int1; int int2;}` with `Vector3_2IntsComparer`.
  - `StringComparer`, `IntComparer`, `FloatComparer`.
- `template<class Key, class Value, typename Comparer> class GeometryPool`
  - Storage: per-instantiation `SAFE_STATIC(StaticData)` holding `std::map<Key, Entry*, Comparer> map` guarded by `rbx::spin_mutex`; `Entry { Value value; size_t count; Map::iterator iterator; }`.
  - `static void init();` — force early static construction.
  - `static Token getToken(const Key& key, const Key& data);` — find-or-create using `key` for lookup but constructing `Value(data)`; refcounts up. `getToken(key)` = `getToken(key, key)`.
  - `static void returnToken(Entry*);` — decrement; erase+delete at zero (asserts count > 0).
  - `static int getSize();`
  - `class Token` — move-only RAII handle "modeled after unique_ptr with custom deleter": move ctor/assign return old token; `operator*`/`operator->` expose `const Value&`; boolean via `operator void*()` ("slightly horrible but we don't have C++11 explicit operator bool").

## Gotchas

- One pool instance **per template instantiation** exists for the whole process (`SAFE_STATIC`) — all Blocks everywhere share one BlockMeshPool.
- Float/Vector3 keys are compared/hashed bit-exactly: `-0.0f` vs `0.0f` or differently-rounded sizes create separate entries; no epsilon merging.
- Token's copy ctor/assignment are declared private but not `= delete` (pre-C++11 idiom) — attempts fail at link time, not compile time on some toolchains.

## Cross-links

- Payloads pooled here: [BlockMesh.md](BlockMesh.md), [BlockCorners.md](BlockCorners.md), [CornerWedgeMesh.md](CornerWedgeMesh.md), [BulletGeometryPoolObjects.md](BulletGeometryPoolObjects.md).
- Spin mutex primitive: Base [threadsafe.h](../../../Base/include/rbx/threadsafe.h.md).
