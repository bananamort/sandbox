# App/include/voxel/CellChangeListener.h

## Purpose

Callback interface for components that want to be notified when terrain cells change, plus the `CellChangeInfo` payload describing one cell transition (before/after cells, water state flip, resulting material).

## Declared API

- `struct CellChangeInfo` — const members: `const Vector3int16 position; Cell beforeCell; Cell afterCell; bool hadWaterBefore; bool hasWaterAfter; CellMaterial afterMaterial;` aggregate-style ctor taking all six.
- `class CellChangeListener` — single pure virtual: `virtual void terrainCellChanged(const CellChangeInfo& info) = 0;`

## Gotchas

- No virtual destructor (same as most RBX callback interfaces) — manage via concrete types/shared_ptr.
- `position` is `const`, so CellChangeInfo is non-assignable; fine for by-value callback payloads.
- Water booleans are separate from material because water lives in a parallel cell layer ([Water.md](Water.md), [Cell.md](Cell.md)).
