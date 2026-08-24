# Network/PersistentDataStore.h

**Module**: Network (root) · **Type**: header (.h, 58 lines)

## Purpose

Declares `RBX::Network::PersistentDataStore`, the per-Player key/value backing for the classic `Player:LoadString/SaveNumber/...` API: a `Reflection::ValueMap` with a complexity budget (string/instance/map/array cost accounting), leaderboard-key tracking, and XML (`WebSerializer::writeTable`) serialization used by `Player::saveData/saveLeaderboardData`.

## API

```cpp
class PersistentDataStore : boost::noncopyable {
    PersistentDataStore(const Reflection::ValueMap* input, const Players*, int complexityLimit);
    bool empty();  bool isLeaderboardDirty();
    bool save(std::string& output);              // whole map → XML
    bool saveLeaderboard(std::string& output);   // only Players' registered leaderboard keys
    int getComplexity/getComplexityLimit(); void setComplexityLimit(int);
    float getLeaderboard(key); bool setLeaderboard(key, float);
    double/String/bool/Instance*/List/Table  getX(key)/setX(key, v);
};
```

## Usage

Constructed in `Player::loadDataResult` from the LoadData HTTP response; saved by `Player::saveData` POSTs. Zero-values/empty strings/false booleans delete keys instead of storing them.

## Gotchas

- `enforceComplexity` silently erases the just-written key when over budget — callers (`Player::setX`) translate that to an exception.
- Loaded non-empty data marks `leaderboardDirty=true` immediately.
