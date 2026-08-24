# App/include/voxel/ChunkMap.h

*(coverage includes **ChunkMap.inl** — folded per orchestrator ruling)*

## Purpose

`SpatialRegion::Id → ValueType` associative container over a `boost::unordered_map`, with a mutating `insert()` that default-constructs on first access. All method bodies live in **ChunkMap.inl**, tail-included by the header.

## Declared API (ChunkMap.h)

- `template<class ValueType> class ChunkMap`
  - Contract comment: "ValueType should implement no-arg constructor and assignment operator."
  - Backing store: `boost::unordered_map<SpatialRegion::Id, ValueType, SpatialRegion::Id::boost_compatible_hash_value> values;` (private).
  - `ChunkMap();`
  - **`ValueType& insert(const SpatialRegion::Id& id)`** — "mutating accessor, will insert a new ValueType if the id wasn't already contained" (implemented as `values[id]`).
  - `const ValueType* find(id) const; ValueType* find(id);` — pointer accessors, NULL when absent.
  - `void erase(id);` — "does nothing if the key is not present".
  - `std::vector<SpatialRegion::Id> getChunks() const;` — key snapshot.
  - `size_t size() const;`

## ChunkMap.inl contents

Straightforward template implementations of every method listed above (insert = `operator[]`; find returns `&it->second` or NULL; getChunks reserves size and copies keys).

## Gotchas

- `insert` never overwrites: second call returns a reference to the existing value — it's `unordered_map::operator[]` semantics despite the insert name.
- Hash function is `SpatialRegion::Id::boost_compatible_hash_value` — ids from different region encodings must normalize to the same hash or lookups miss.
- find() returning pointers into the map: pointers invalidate on any later insert that rehashes.
