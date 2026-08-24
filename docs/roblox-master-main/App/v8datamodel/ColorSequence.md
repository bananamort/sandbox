# ColorSequence.cpp

## Purpose

Implements the `ColorSequence` value type — a 2..kMaxSize-keypoint RGB gradient over normalized time [0,1] with strict validation (ordered, starts at 0, ends at 1, components clamped to [0,1]), plus its full Reflection plumbing: XML string serialization ("time r g b envelope " repeated), Variant/StringConverter support, and Type registration as "ColorSequence"/"ColorSequenceKeypoint".

## Key types and API

No descriptors or Security:: tiers — this TU is a VALUE TYPE, not an Instance.

- Ctors: constant (2 identical keys at t=0/1), two-color (a@0 → b@1), key-vector ctor that VALIDATES (`exceptions=true` throws) then force-snaps first/last times to exactly 0/1; copy ctor clamps all times/values and zeroes envelopes.
- `validate(keys, exc)` — ≥2 keys ("ColorSequence: requires at least 2 keypoints"), ≤kMaxSize (error text says "NumberSequence: max number of keypoints exceeded." — copy-paste bug), strictly increasing times, value.min()≥0 && value.max()≤1, |first.time|≤1e-4, |last.time−1|≤1e-4.
- `resample(min[], max[], numPoints)` — linear interpolation walk producing per-sample min/max arrays (identical values; envelope ignored).
- Equality: memcmp for keypoints, vector == for sequences.
- Serialization: space-separated `time r g b envelope` text via TypedPropertyDescriptor<>{readValue,writeValue,getStringValue,setStringValue}; getDataSize = sizeof(Key)·count. Empty-string conversion fails cleanly.
- Reflection types registered: TType "ColorSequence" and "ColorSequenceKeypoint".

## Usage / reflection touchpoints

Property payload for particle/emitter color-over-lifetime ([CustomParticleEmitter](CustomParticleEmitter.md) family); sibling numeric type documented in [NumberSequence](NumberSequence.md).

## Gotchas

- The >max error message names NumberSequence — cosmetic, but greppable confusion when debugging limits.
- Envelope field is parsed/serialized yet forced to 0 in copies and unused by resample — dead weight kept for format compatibility.
- validate() allows first time up to ±1e-4 but the ctor then hard-snaps it to 0 — tiny input drift silently normalizes.
