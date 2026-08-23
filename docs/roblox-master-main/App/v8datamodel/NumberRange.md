# NumberRange.cpp

## Purpose

Implements the `NumberRange` datatype used by reflection properties (e.g., ParticleEmitter rate ranges): a simple min/max float pair. This TU provides construction with automatic swap plus all plumbing that lets NumberRange participate in the property system: XML serialization, string conversion, Variant conversion, and Reflection type identity.

## Key types and API

- `class NumberRange` (header): two floats `min`, `max`. Two-arg ctor swaps so min<=max always holds ("NumberRange(5,1)" yields 1..5).
- Serialization format: whitespace-separated `"min max "` via ostringstream/istringstream (`tostr`/`fromstr`) — note trailing space in output.
- Reflection template specializations for `TypedPropertyDescriptor<NumberRange>`: getDataSize = sizeof(NumberRange); readValue/writeValue parse/print the string form; hasStringValue() true; getString/setStringValue bridge to the same parser.
- `Variant::convert<NumberRange>` generic conversion — makes it a first-class Lua-facing value type.
- `Reflection::Type::getSingleton<NumberRange>` registers TType named "NumberRange".
- `StringConverter<NumberRange>` specializations: convertToValue returns false only on empty text, true otherwise.

## Usage / reflection touchpoints

Any descriptor declared as `PropDescriptor<T, NumberRange>` picks these specializations up automatically — no per-class work needed. Consumers are emitter/GUI classes elsewhere in this directory.

## Gotchas

- The ctor silently reorders swapped arguments rather than erroring.
- fromstr performs NO validation: malformed strings leave fields partially stream-extracted (min possibly set, max garbage); StringConverter's bool only guards the empty-string case.
- Serialized form is locale-dependent iostream formatting.
