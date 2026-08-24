# App/include/voxel2/GridListener.h

## Purpose

Callback interface for observers of smooth-voxel ([Voxel2](Grid.md)) terrain changes: notified with the changed `Region` whenever grid content mutates.

## Declared API

- `class GridListener`
  - Virtual dtor (present, unlike most RBX callback interfaces here).
  - Single pure virtual: `virtual void onTerrainRegionChanged(const Region& region) = 0;`

## Gotchas

- Forward-declared `Region` — implementers must include voxel2/Grid.h themselves.
- Callbacks fire from Grid write paths; keep handlers fast and non-re-entrant.
