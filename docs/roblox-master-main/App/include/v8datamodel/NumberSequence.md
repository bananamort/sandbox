# App/include/v8datamodel/NumberSequence.h

## Purpose

`RBX::NumberSequence` (+ `NumberSequenceKeypoint`) — reflection value type holding up to 20 (time, value, envelope) float keypoints; used for animated numeric properties (transparency/size sequences on emitters, etc.).

## Declared API

`class NumberSequenceKeypoint`
- Members: `float time; float value; float envelope;` (public).
- `NumberSequenceKeypoint()` → all zeros; `NumberSequenceKeypoint(float t, float v, float e)`.
- `bool operator==(const NumberSequenceKeypoint&) const` — out-of-line.

`class NumberSequence`
- `typedef NumberSequenceKeypoint Key;`
- `enum { kMaxSize = 20 }` — max permitted keypoints.
- `explicit NumberSequence(float value = 0)` — constant sequence.
- `NumberSequence(const std::vector<Key>& keys, bool exceptions = false)` — from array; `exceptions=true` turns validation failures into throws.
- `NumberSequence(const NumberSequence& r, float min = -1e22f, float max = 1e22f)` — copy with optional clamp window.
- `const std::vector<Key>& getPoints() const`; `Key start() const` / `Key end() const` (front/back of vector).
- `void resample(Vector2* result, int numPoints, float minV = -1e22f, float maxV = 1e22f) const` — comment: "resamples, result is {min,max} rather than {value, envelope}".
- `bool operator==` — out-of-line; `static bool validate(const std::vector<Key>& keys, bool exceptions)`.
- Private: `std::vector<Key> m_data`.

## Gotchas

- Validation is a separate static (`validate`); the array ctor with `exceptions=false` silently tolerates invalid input — check which mode each caller uses.
- `resample` output Vector2 packing is {min,max}, NOT {value,envelope} — per the in-header comment; easy to misuse downstream.
- `start()`/`end()` call `front()/back()` — undefined behavior on an empty sequence.

## UNKNOWN

- Exact validation rules inside `validate` (sorted-by-time? envelope>=0?) live out of line.

## Cross-links

- Implementation: [App/v8datamodel/NumberSequence.md](../../v8datamodel/NumberSequence.md).
- Range sibling: [NumberRange.md](NumberRange.md); color analog: [ColorSequence.md](ColorSequence.md); consumers: [CustomParticleEmitter.md](CustomParticleEmitter.md), [Smoke.md](Smoke.md), [Fire.md](Fire.md), [Sparkles.md](Sparkles.md).
