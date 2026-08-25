# App/include/voxel2/BitSerializer.h

## Purpose

Template bit-stream codec for Voxel2 chunk data: delta-encoded chunk indices (1/2/4-byte per-component varints behind 1–2 tag bits) and RLE-compressed chunk cell payloads (run lengths up to 512 with material-run and occupancy shortcuts). Templated on any BitStream supporting `<<`/`>>` bool/char/short/int plus ReadBits/WriteBits.

## Declared API

- `template<typename BitStream> class BitSerializer`
  - Public session API (stateful — keeps `lastIndex`):
    - `void encodeIndex(const Vector3int32& index, BitStream&)` / `void decodeIndex(Vector3int32& index, BitStream&)` — encode writes `index − lastIndex` as a tagged diff and updates lastIndex; decode reconstructs additively.
    - `void encodeContent(const Box& box, BitStream&)` / `void decodeContent(Box& box, BitStream&)`.
  - Private state: `Vector3int32 lastIndex; std::vector<Cell> cells;` (scratch buffer).
  - `encodeChunkIndex(diff, stream)` — tags: `1` = three chars; `01` = three shorts; `00` = three full ints.
  - `encodeChunkData(box, stream)`:
    - Empty flag bit first (empty Box → nothing else).
    - Rows copied into the linear scratch via `box.readRow`.
    - Per run: 2-bit group count selector (`00`=single, then 3/6/9-bit count−1 fields → max run 512), then per-cell payload bits: `0` air; `1` solid + customOccupancy flag (`0`=assume OccMax, `1`=8 occupancy bits) + newMaterial flag (`0`=reuse lastMaterial, `1`=6 material bits).
  - `decodeChunkData(Box&, stream)` — mirror logic; **throws** `RBX::runtime_error("Error while decoding data: chunk overflow at %u cells", ...)` if a run would exceed the box size; asserts input box is empty before filling; rows memcpy'd out via `writeRow`.

## Gotchas

- Index coding is *delta against previous encode/decode call* — interleaving two streams or skipping indices desyncs everything; one serializer instance per ordered stream direction.
- The scratch `cells` vector is shared across calls but resized per chunk — not thread-safe even for read-only encodes of different grids.
- Run-length cap is 512 (`count < 512` loop bound) — longer uniform runs split into multiple tokens.
- Decode validates total cell count but not material values (>63) or stream truncation beyond the throw path — corrupt streams can still fabricate odd materials.
- Air cells are free in runs but still occupy a token; fully-empty chunks cost exactly 1 bit.
- Wire format is host-dependent: run lengths are bit-cast through `(const unsigned char*)&temp` on an `unsigned int` (little-endian layout assumed) and index diffs narrow through plain `char`/`short` (signedness implementation-defined) — streams are only safely interchangeable between like-configured platforms.

## UNKNOWN
- Which concrete BitStream types feed this (network vs save-file adapters live outside App/include).
