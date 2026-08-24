# App/include/v8datamodel/NumberRange.h

## Purpose

`RBX::NumberRange` — trivial value-type pair of floats (`min`, `max`) used as a reflection property type (e.g. particle/emitter size ranges). Header is intentionally header-only apart from the two-arg ctor.

## Declared API

`class NumberRange`

- Members: `float min; float max;` (public, no accessors).
- `NumberRange(float a = 0)` — inline, degenerate range [a,a].
- `NumberRange(float a, float b)` — defined elsewhere (not in this header).
- `bool operator==(const NumberRange&) const` / `operator!=` — inline exact float comparison.

## Gotchas

- Opens with `#undef min` / `#undef max` — including this header destroys the Windows `<min>`/`<max>` macros for the whole TU (classic Windows.h interaction).
- Exact `==` on floats: strict value-equality semantics, no epsilon (and unlike a true bitwise compare, `+0.0 == -0.0` while NaN compares unequal).
- No clamping/inversion check here — whether `min<=max` is enforced depends on the out-of-line ctor and reflection setters.

## UNKNOWN

- Where `NumberRange(float,float)` is defined and whether it normalizes ordering.

## Cross-links

- Implementation: [App/v8datamodel/NumberRange.md](../../v8datamodel/NumberRange.md).
- Sequence sibling: [NumberSequence.md](NumberSequence.md); Color2D counterpart: [ColorSequence.md](ColorSequence.md).
