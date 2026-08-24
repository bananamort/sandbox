# App/include/voxel/Serializer.h

## Purpose

Bit-stream codec for replicating terrain cell edits: `encodeCells` walks a caller-supplied cell queue, emitting per-chunk headers and RLE-ish per-cell tokens (new-cell vs repeat-last-seen-content), with a 2-bit control scheme; `decodeCells` replays them into a [Grid.md](Grid.md) through a caller filter. Everything is header-defined templates except the marker constants.

## Declared API

- `class SerializerConstants` — public static consts "visible for testing": `kNewCellMarker`, `kRepeatCellMarker`, `kEndSequenceMarker` (unsigned char), `kRecentlyEncodedReferenceBits` (unsigned int).
- `class Serializer`
  - Private `typedef FixedSizeCircularBuffer<unsigned int, 8> RecentlyEncodedBuffer;` — dedup window of last 8 distinct (material<<8 | cellByte) contents.
  - Private template `encodeFromPosition(voxelStore, Vector3int16& cellpos, lastChunkPos, Grid::Region& region, RecentlyEncodedBuffer&, CellBuffer&, OutputStream*) const`:
    - New content → 2-bit kNewCellMarker + 8-bit material + 8-bit cell byte; push to buffer; advance one cell.
    - Seen content → 2-bit kRepeatCellMarker + `kRecentlyEncodedReferenceBits` back-reference + VarInt run-length of identical following cells (same chunk & same content); consumes those from the buffer.
    - In-header TODO verbatim: **"The cell reads in this section aren't safe! They will read past the end of the cluster's data array."**
  - Public template **`encodeCells(const Grid* voxelStore, CellBuffer& cellBuffer, OutputStream*, int sizeLimitInBytes) const`** — loop while cells remain and byte budget holds (`sizeLimitInBytes == -1` = unlimited): on chunk change emit changed-flag bit, a "0 not finished" bit, then 16-bit chunk x/y/z; always emit chunk-relative cell coords using region dimension bit-shifts; per-chunk sequence ends with kEndSequenceMarker; final stream terminator writes `0xff` as two bits ("chunk changed"=1 + EOM=1).
  - Public template **`decodeCells(Grid* voxelStore, InputStream&, CellUpdateFilter& filter)`** — mirrors encode: reads chunk header/EOM token, per-cell coords, control bits; new cells push into the dedup buffer and apply via `voxelStore->setCell(...)` **only if `filter.canSet(cellPos)`**; repeat cells replay count times; loop exits on EOM.

## Gotchas

- The acknowledged out-of-bounds read hazard in encodeFromPosition's repeat-run lookahead is unfixed in this source — runs ending exactly at cluster edges are the risk.
- Dedup window is only 8 entries (`FixedSizeCircularBuffer<unsigned int, 8>`); back-references beyond that cannot occur by construction but corrupt streams can index stale slots unchecked.
- `CellMaterial` is written raw as the 8-bit material value — decode casts without validation; hostile/mismatched streams can set out-of-range materials.
- Cell ordering contract lives in `CellBuffer::nextCellInIterationOrder` / `chk` / `pop` — the codec is agnostic but encode/decode must agree on the same CellBuffer type semantics.
- Filter gate makes decode safe for selective application (e.g. region permissions) — encode has no symmetric filter.
