# util/KeywordFilter.h

## Purpose
Single enum for keyword-filter direction (include-list vs exclude-list).

## Declared API
```cpp
typedef enum KeywordFilterType {
    INCLUDE_KEYWORDS = 0,
    EXCLUDE_KEYWORDS
} KeywordFilterType;
```

## Gotchas
- INCLUDE is the zero value — zero-initialized variables read as include-mode.

## UNKNOWN
- Consumers (search/filter UI code outside this slice).
