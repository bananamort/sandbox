# CSGMesh.cpp

## Purpose

Implements `CSGMesh` — the in-memory triangle mesh for CSG union operations — plus its obfuscated serialization format ("CSGMDL" blobs: XOR-scrambled, MD5+salt tamper hash, VMProtect-wrapped hashing) and the CSGMeshFactory injectable singleton. Also carries per-face decal UV remap tables (FixGlowingCSG) and Bullet physics blob generation.

## Key types and API

No Instance descriptors/Security:: tiers (raw geometry object). Flag: `FASTFLAGVARIABLE(FixGlowingCSG, true)`.

CSGMeshFactory:
- Injectable via static `set(factory)`; `singleton()` falls back to a heap default; `createMesh()` news a plain CSGMesh.

CSGMesh:
- State: `vertices` (CSGVertex), `indices`, version(2), brepVersion(1), badMesh flag; per-face `decalVertexRemap[6]`/`decalIndexRemap[6]`.
- `toBinaryString()` — "CSGMDL" tag + version + 32-byte hash(hash‖salt) + vertex count/stride/array + index count/array, THEN whole-buffer XOR with a 31-byte LcmRand key (`xorBuffer`). Source comment: defense-in-depth against "expert users injecting random data… slow down the process" while mesh generation moves server-side.
- `fromBinaryString(str)` — un-XOR, verify tag + exact version==2 + vertexStride match; recompute hash WITH the stored salt and set badMesh=true on mismatch (does NOT reject); builds decal remaps; returns false only on structural failure.
- `createHash(salt?)` — VMProtect "17" mutation region: MD5 over vertex+index bytes with a random 16-byte salt, byte-shuffled via LcmRand before hashing.
- `computeDecalRemap()` — groups vertices/indices by face id stored in `extra.r − 1` (skipped entirely when FixGlowingCSG off).
- `toBinaryStringForPhysics()` — delegates to `TriangleMesh::generateStaticMeshData` (Bullet static mesh bytes).
- `CSGVertex::generateUv()` — box-projected planar UV per face enum (UV_BOX_X/Y/Z ± variants; NO_UV_GENERATION keeps stored uv).
- Misc: clearMesh, set, clone, isNotEmpty.

## Usage / reflection touchpoints

Produced/consumed by [CSGDictionaryService](CSGDictionaryService.md)/[NonReplicatedCSGDictionaryService](NonReplicatedCSGDictionaryService.md) caches and [PartOperation](PartOperation.md); physics bytes feed Bullet collision ([Base](../../Base/)).

## Gotchas

- Hash mismatch only FLAGS badMesh — corrupted meshes still load and render.
- xorBuffer's key is regenerated per call from LcmRand seeded state — encode/decode symmetry relies on identical PRNG sequences at both ends within one process lifetime.
- Version check is EXACT equality: any future format bump orphans old blobs (no migration path in this TU).
- Whole TU is compiled out under CSG_KERNEL_OLD.
