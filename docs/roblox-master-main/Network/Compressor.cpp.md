# Network/Compressor.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 212 lines)

## Purpose

Implements `Compressor` (see Compressor.h). Rotation always becomes a normalized `Quaternion`; translation uses per-axis fixed-point quantization when HEAVILY_COMPRESSED. A 2-bit compression-type tag precedes every value on the wire.

## API / wire format

- Constants: `translationBits0/1/2 = 15/14/15`, `translationMin = {-1024,-512,-1024}`, `translationMax = {1024,512,1024}`.
- `writeRotation`: UNCOMPRESSED writes `q.w,x,y,z` as floats; RAKNET_COMPRESSED and HEAVILY_COMPRESSED both call `bitStream.WriteNormQuat(...)` (identical encoding despite separate cases).
- `writeTranslation`: silently downgrades HEAVILY_COMPRESSED→RAKNET_COMPRESSED via `canHeavilyCompressTranslation` when out of range; heavy encoding is `(p - min)*(1<<bits)/(max-min)` as unsigned short with overflow clamp to 0xFFFF, written with `WriteBits`.
- `readTranslation`: heavy decode `p = v * (1.0f/(1<<bits) * (max-min)) + min`; RAKNET_COMPRESSED path uses `readVectorFast`.
- `readCompressionType`: 2-bit tag read via template `readFastN<2>`.

Includes boost iostreams gzip headers but no gzip code appears in this file.

## Usage

Called by physics replication to serialize PV components; symmetric read functions used on receive.

## Gotchas

- HEAVILY_COMPRESSED rotation == RAKNET_COMPRESSED rotation: the distinction exists only for translations.
- Overflow clamps to max quantized value rather than rejecting — positions slightly out of range snap to the boundary if downgraded encoding were bypassed.
- `readFastN<translationBits>` templates come from RakNet BitStream helpers; bit order matters — do not mix with byte-wise writers.
