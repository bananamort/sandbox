# App/include/v8datamodel/ColorSequence.h

## Purpose

Value-type color gradient used by particle/emitter properties: an ordered list of up to 20 `ColorSequenceKeypoint`s (time, Color3, envelope) with validation and resampling helpers. Header-only value class — not an Instance.

## Declared API

`class ColorSequenceKeypoint`

- Fields: `float time; Color3 value; float envelope;`
- Ctors: default (0, black, 0) and `(float t, Color3 v, float e)`; `bool operator==(const ColorSequenceKeypoint&) const;`

`class ColorSequence`

- `typedef ColorSequenceKeypoint Key;` `enum { kMaxSize = 20 }; // max number of keypoints permitted`
- Ctors: `explicit ColorSequence(Color3 constant = Color3(1,1,1));` `ColorSequence(Color3 a, Color3 b);` `ColorSequence(const std::vector<Key>& keys, bool exceptions = false);` copy ctor.
- Access: `const std::vector<Key>& getPoints() const;` `Key start() const { return m_data.front(); }` `Key end() const { return m_data.back(); }`
- `void resample(G3D::Vector3* min, G3D::Vector3* max, int numPoints) const;`
- `bool operator==(const ColorSequence&) const;`
- `static bool validate(const std::vector<Key>& keys, bool exceptions);`

## Gotchas

- File does `#undef min / #undef max` after `<vector>` — Windows.h macro pollution workaround that can break other headers relying on std::min/std::max unqualified.
- Keypoints are Color3 (RGB only) — no alpha channel in this sequence type.
- Validation throws vs returns depending on the `exceptions` flag.

## UNKNOWN

- Meaning/range of `envelope` per keypoint (.cpp consumers — see [ColorSequence.md](../../v8datamodel/ColorSequence.md)).

## Cross-links

- Implementation: [App/v8datamodel/ColorSequence.md](../../v8datamodel/ColorSequence.md).
- Numeric kin: [NumberSequence.md](NumberSequence.md), [NumberRange.md](NumberRange.md); consumer [CustomParticleEmitter.md](CustomParticleEmitter.md).
