# Network/PersistentDataStore.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 281 lines)

## Purpose

Implements the store: complexity accounting (`computeLimit` — strings by `Instance::computeStringCost`, instances by `getPersistentDataCost`, maps/arrays 1 + recursive, scalars 1), key deletion semantics for default values, leaderboard extraction from Players' registered keys, and XML serialization via `WebSerializer::writeTable` + `TextXmlWriter`. First construction with data fires a one-time GA `"DataPersistence"` event with placeId.

## API

```cpp
static int computeLimit(const Variant&); static void computeInstanceLimit/ValueMapLimit/ValueCollectionLimit(...);
bool serializeValueMap(std::string& out, const ValueMap&);
void removeKey(key); bool enforceComplexity(key); bool isNumber(key);
// getters return type defaults (0 / "" / false / null) on miss or type mismatch
```

## Usage

See header. `saveLeaderboard` clears `leaderboardDirty` as a side effect.

## Gotchas

- `isNumber` returns true both when the key is missing and when it's a double — the name understates it ("is absent or numeric").
- GA stat fires once per process (`boost::once_flag`) regardless of player count.
