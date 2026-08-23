# NumberSequence.cpp

## Purpose

Implements the `NumberSequence` datatype — a normalized-time (0..1) keyframed curve with per-key envelopes, used by reflection properties such as ParticleEmitter size/transparency curves over lifetime. Provides construction/validation, linear resampling with envelope spread, and the full reflection plumbing (XML/string/Variant/type-registry) for both `NumberSequence` and `NumberSequenceKeypoint`.

## Key types and API

- `class NumberSequence`: `std::vector<Key>` where Key = {time, value, envelope} (`NumberSequenceKeypoint`).
  - `NumberSequence(float value)`: constant curve, two keys at t=0 and t=1.
  - `NumberSequence(const std::vector<Key>&, bool exc=false)`: validates; on failure (exc=false) silently substitutes a zero constant sequence; otherwise force-normalizes first key time to 0 and last to 1.
  - Copy-with-clamp ctor: clamps each value into [min,max] and envelope so value±envelope stays inside [min,max] (envelope clamped twice).
  - `resample(Vector2* result, int numPoints, minV, maxV)`: linear interpolation between keys producing numPoints pairs of (value-envelope, value+envelope), each clamped; asserts ≥2 keys with exact 0/1 endpoints; step shrunk by 1e-5.
  - `validate(keys, exc)`: throws (or returns false): <2 keypoints ("requires at least 2 keypoints"), >kMaxSize keypoints ("max. number of keypoints exceeded."), out-of-order times ("all keypoints must be ordered by time"), negative envelope ("envelope must be non-negative"), value-envelope<0 ("envelope must not exceed the value"), first-time≠0 within 1e-4 ("must start at time=0.0"), last-time≠1 within 1e-4 ("must end at time=1.0"). A non-negativity check on raw value is commented out.
  - `operator==` vector comparison; keypoint == uses memcmp.

Serialization: `"time value envelope "` triplets concatenated (trailing space); fromstr loops stream extraction until eof. Reflection specializations mirror NumberRange's: TypedPropertyDescriptor read/write/string forms (getDataSize = sizeof(Key)*count), Variant::convert, TType "NumberSequence" / "NumberSequenceKeypoint", StringConverter specializations (empty-string guard only).

## Usage / reflection touchpoints

Descriptors like `PropDescriptor<T, NumberSequence>` inherit all of this automatically. Lua sees NumberSequence values via the Variant conversion; NumberSequenceKeypoint is separately registered so scripts can construct `NumberSequenceKeypoint.new(t, v, e)` style values.

## Gotchas

- validate() allows EQUAL consecutive times (only strictly-decreasing rejected) — resample divides by zero segment width in that case (inf/nan propagation guarded only by lerp math).
- The exc=false path silently replaces invalid input with a zero constant curve instead of erroring.
- Envelope is symmetric around value and must satisfy envelope <= value in the default clamp ctor — negative final values are structurally impossible via validation.
- Endpoint times are only approximately enforced (±1e-4) but resample ASSERTS exact equality — sequences built through fromstr may trip RBXASSERT in debug builds if endpoints drift.
- Locale-dependent iostream float formatting, same as NumberRange.
