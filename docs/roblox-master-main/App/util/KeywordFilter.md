# KeywordFilter.cpp

**Source**: `App/util/KeywordFilter.cpp` (18 lines).

## Purpose
Registers the `KeywordFilterType` reflection enum descriptor (name `"KeywordFilterType"`).

## API
Specialization `Reflection::EnumDesc<KeywordFilterType>::EnumDesc()` with pairs: `INCLUDE_KEYWORDS`→"Include", `EXCLUDE_KEYWORDS`→"Exclude".

## Usage
Consumed by chat/filter UI code that serializes keyword-filter enums by name.

## Gotchas
Registration only.
