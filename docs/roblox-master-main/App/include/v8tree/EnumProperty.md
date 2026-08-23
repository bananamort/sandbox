# App/include/v8tree/EnumProperty.h

## Purpose

Effectively an empty translation unit: includes `reflection/enumconverter.h` and `V8Tree/Property.h` inside an empty `namespace RBX {}`. Historically it presumably hosted enum-property descriptor helpers; today its only role is as an include aggregation point.

## Declared API

- None. No types, functions, or macros are declared in this header.

## Gotchas

- Including it pulls in the full reflection enum-converter machinery transitively; if that include chain is ever trimmed, dependents break silently.
