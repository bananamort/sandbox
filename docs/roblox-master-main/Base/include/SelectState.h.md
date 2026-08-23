# SelectState.h

## Purpose
Defines the three-state selection visual enum used by selection/adornment UI code: `SELECT_NORMAL`, `SELECT_LIMIT`, `SELECT_HOVER`.

## API
```cpp
namespace RBX { enum SelectState { SELECT_NORMAL, SELECT_LIMIT, SELECT_HOVER }; }
```

## Usage
Imported wherever 3D adornments or Studio-style selection boxes distinguish steady-state selection from hover highlight and limit indicators.

## Gotchas
- Unscoped C enum inside namespace RBX: enumerators leak as `RBX::SELECT_*` but also unqualified in using-directives; no `enum class` type safety.
