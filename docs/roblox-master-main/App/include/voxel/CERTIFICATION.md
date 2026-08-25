# CERTIFICATION — App/include/voxel docs review

Independent re-verification of the 12 docs in this directory against the 11 `.h` headers + 6 `.inl` files in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/voxel/`. Every source file was read in full (no sampling); every concrete claim in every doc was checked against source.

## Coverage

- Sources enumerated: 11 .h + 6 .inl — matches doc set 1:1.
- Documented folds verified: AreaCopy.md←AreaCopy.inl (1), ChunkMap.md←ChunkMap.inl (1), Region.md←Region.inl + Region.iterator.inl + Region.xline_iterator.inl (3), Water.md←Water.inl (1). Total 6/6 .inl folded, no orphans.
- INDEX.md table row count = 11/11 headers; fold counts stated there are correct.

## Known latent bugs — confirmed present and now correctly documented

1. **Region.iterator.inl ~L124**: `kFaceDirectionToLocationOffset[direction2))` missing `]` inside the two-direction `getNeighborMaterial` RBXASSERT_SLOW argument. Compiler repro established exact mechanics: compiles when `RBXASSERT_SLOW` discards its argument (unbalanced `[]` are legal pp-tokens in a macro argument); hard `expected ']'` error when slow asserts are active AND the overload is instantiated. Region.md originally claimed "no live callers" — WRONG: live calls exist at Rendering/GfxRender/MegaCluster.cpp L1043 (`detectOutlines`) and L1119 (`detectWedgeOutlines`) on RenderArea (=AreaCopy) region iterators. Doc FIXED. (Note for the record: no identifier `PRECISE_SORTING` exists anywhere under voxel/; it appears only in v8world/SpatialHashMultiRes.inl — no doc makes that claim.)
2. **Serializer.h L49–50 OOB-read TODO**: verbatim "The cell reads in this section aren't safe! They will read past the end of the cluster's data array." Present in source; Serializer.md documents it accurately. The related dedup-window hazard claim was verified against Util/FixedSizeCircularBuffer.h (`operator[]` wraps `% size`, never bounds against `pushed`).

## Per-file verdicts

| Doc | Verdict | Notes |
|---|---|---|
| INDEX.md | PASS | Coverage/fold claims all correct. |
| AreaCopy.md | FIXED | MISSING-GOTCHA: `kStaticEndRegion` declared (h L58) but defined nowhere in tree → odr-use is a link error; gotcha added. All other claims verified. |
| Cell.md | FIXED | WRONG gotcha #1: water payload does NOT occupy the block bits; block bits (3–5) carry the CELL_BLOCK_Empty marker (=`blockMustBeEmpty` view), payload lives in dataPart2/dataPart1; setForceAndDirection leaves block bits untouched. Rewritten. Enums/bitfields/packing math otherwise verified exactly. |
| CellChangeListener.md | PASS | Members, ctor, pure virtual, const-member non-assignability all correct. |
| ChunkMap.md | PASS | API + .inl bodies, operator[] semantics of insert(), hash functor name, pointer invalidation — all verified. |
| Grid.Chunk.md | PASS | State, layout constants, index math via region-relative coords, init contract, water delegation — all verified. |
| Grid.md | FIXED | WRONG gotcha: `isAllocated()` returns `countOfNonEmptyCells > 0` (App/voxel/Grid.cpp L201–203), not a lazy-allocation flag; rewritten with source reference. Rest of API/warnings verbatim-verified. |
| Region.md | FIXED | WRONG: syntax-bug gotcha claimed overload has "no live callers" — MegaCluster.cpp L1043/L1119 call it; mechanics qualified (fails only under active slow asserts). Rewritten. All Region.inl/iterator.inl/xline_iterator.inl content claims (sentinels, materialAt→Water on empty regions, carriage-return skips, even-index asserts, getLineMaterials offset) verified. |
| Serializer.md | PASS | TODO verbatim, token formats, 0xff terminator, filter asymmetry, raw-material decode, dedup hazard (verified vs FixedSizeCircularBuffer) — all correct. |
| Util.md | FIXED | STYLE/WRONG wording: OPPOSITE_CORNER described as "non-static storage"; it is a function-local `static const` array (Util.h L76). Corrected. Nibble math, FaceDirection order, map sizes (1536 = 2^8·6), coordinate conversions, ±32000 bounds — all verified. |
| Voxelizer.h→Voxelizer.md | PASS | Constants, OccupancyChunk dims [16][32][32], full method inventory incl. DataModelPartCache pfn signature and meshRadius default — all verified. |
| Water.md | PASS | Tables, orientation rule set (above / VerticalWedge / inverse-corner diagonal case / both-ortho-water), cellHasWater & interpretAsWaterCell logic, duck-typed fillLocalAreaInfo requirement — all verified against Water.h/.inl. |

## Totals

- **PASS: 7** — INDEX.md, CellChangeListener.md, ChunkMap.md, Grid.Chunk.md, Serializer.md, Voxelizer.md, Water.md
- **FIXED: 5** — AreaCopy.md, Cell.md, Grid.md, Region.md, Util.md
- **FAIL: 0**

(12/12 docs certified; 11/11 headers + 6/6 .inl covered.)

Severity tags applied overall: WRONG ×3 (Cell.md bits claim, Grid.md isAllocated, Region.md no-live-callers), UNSUPPORTED→refined ×1 (Region.md compile-failure scope), MISSING-GOTCHA ×1 (AreaCopy.md kStaticEndRegion), STYLE ×1 (Util.md storage wording). All fixes were mechanically certain (source line or compiler-repro backed); sources under roblox-sandbox/ were NOT modified.

Cross-checked outside the doc scope (read-only): MegaCluster.cpp, Grid.cpp, FixedSizeCircularBuffer.h, SpatialHashMultiRes.inl (PRECISE_SORTING grep).
