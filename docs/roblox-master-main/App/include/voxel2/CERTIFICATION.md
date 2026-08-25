# Certification — voxel2 header docs review

Independent verification of `App/include/voxel2/*.h` (6 headers, each read in full) against the `.md` docs in this directory. Cross-checks extended to sibling implementation files where a doc claim was out-of-line (`App/voxel2/{Grid,MaterialTable,Mesher}.cpp`, `App/include/voxel/Cell.h`); source tree untouched.

Coverage: 6/6 headers ↔ 6/6 .md files (+ INDEX.md) — 1:1, no orphans either side.

| Doc | Verdict | Notes |
|---|---|---|
| BitSerializer.md | FIXED | All signatures/tags/throw message/asserts verified exact (incl. Occupancy_Bits=8 / Material_Bits=6 via Grid.h). Added mechanically-certain portability gotcha: run-length bit-cast through `(unsigned char*)&unsigned int` + plain-`char` diff narrowing bake host endianness and char signedness into the wire format. |
| Conversion.md | PASS | kMaterialTable serialized order verified entry-by-entry (16 entries); occupancy constants arithmetic correct (255/127/85/170); getCellMaterialFromMaterial asymmetry claim confirmed (8 cases, default→Grass); 32×16×32 box confirmed via voxel/Cell.h (kXZ=32, kY=16). |
| Grid.md | FIXED | All declarations/constants verified; "read yields unallocated Box serving emptyCell" confirmed against Grid.cpp (sized ctor doesn't allocate; copyCells lazily allocates on solid rows). Clarified mip gotcha — Grid::write regenerates mips 1..3 itself; annotated UNKNOWN with .cpp-pinned kChunkSizeLog2=5 (32³ chunks). |
| GridListener.md | PASS | Virtual dtor, single pure virtual `onTerrainRegionChanged(const Region&)`, forward-declared Region — all exact; callback-from-write-path confirmed (Grid.cpp:638-641). |
| MaterialTable.md | FIXED | Declarations exact; raw-indexing UB gotcha correct; cell-id→table indexing confirmed (Mesher.cpp passes cell materials into getMaterial; MegaCluster sizes table as Material_Max+1=64). Corrected imprecise materialCount claim: it is a pad floor (short tables padded with dummies, failed load → dummy atlas), not "must match". UNKNOWN resolved: rapidjson JSON schema documented from MaterialTable.cpp. |
| Mesher.md | FIXED | All struct layouts/function signatures verified exact (bitfields 1/7/8/16, TextureBasis[18], TriangleAdjacency enum -1/-2). Corrected two wrong behavior claims: missing prepareTables() reads an all-zero gEdgeTable → silently broken geometry (not UB); packPosition uses plain int→int16 conversion → truncation/wrap (no clamping exists). |
| INDEX.md | PASS | 6/6 mapping table accurate; per-file notes consistent with verified facts; "no .inl files" confirmed. |

## Totals

- Files reviewed: 7 (6 header docs + INDEX.md)
- PASS: 3 (Conversion.md, GridListener.md, INDEX.md)
- FIXED: 4 (BitSerializer.md, Grid.md, MaterialTable.md, Mesher.md)
- FAIL: 0
- Severity tags applied: WRONG ×2 (Mesher UB claim; Mesher clamp claim), UNSUPPORTED ×1 (MaterialTable materialCount semantics), MISSING-GOTCHA ×2 added (BitSerializer wire-format host dependence; Grid chunk size annotation), STYLE/ambiguity ×1 (Grid mip-coherence phrasing).

No unsalvageable errors found; every doc's declared API surface matched its header exactly after full reads.
