# util/InsertMode.h

## Purpose
Two unrelated small enums: where an object gets inserted (raw / tree / 3D view) and tool-prompt suppression mode. (The stray "hash function" comment is a copy-paste leftover from Hash.h.)

## Declared API
```cpp
typedef enum { INSERT_RAW, INSERT_TO_TREE, INSERT_TO_3D_VIEW } InsertMode;

typedef enum {
    PUT_TOOL_IN_STARTERPACK,  // The user has been prompted about putting a tool into the starter pack
    SUPPRESS_PROMPTS
} PromptMode;
```

## Gotchas
- `INSERT_RAW` == 0: zero-initialized variables read as INSERT_RAW.
- The header comment about Sedgewick hashing is vestigial — no hash code here.

## UNKNOWN
- Consumers (instance insertion pipeline; outside this slice).
