# util/CompactEnum.h

## Purpose
Stores an enum value in a caller-chosen (smaller) `Storage` type while still presenting the original enum's interface via implicit conversion — memory-optimized enum member for packed structs.

## Declared API
```cpp
template <typename Enum, typename Storage>
class CompactEnum {
public:
    CompactEnum();                    // leaves data uninitialized
    CompactEnum(Enum value);          // implicit from enum
    operator Enum() const;            // implicit back to enum
private:
    Storage data;                     // e.g. uint8_t
};
```

## Gotchas
- Default ctor does NOT initialize `data` — reading a default-constructed CompactEnum before assignment yields garbage cast to Enum.
- No range validation: a Storage value outside the enum's valid range converts silently.
- Only single-inheritance-friendly trivially-copyable storage assumed; no serialization helpers.

## UNKNOWN
- Which enums use it and with what Storage widths (call sites outside this slice).
