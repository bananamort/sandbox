# util/Action.h

## Purpose
Trivial namespace-scoped enum holder for game-outcome actions (pause/lose/draw/win). Class is not instantiable; it exists purely to scope `ActionType`.

## Declared API
```cpp
class Action {
public:
    enum ActionType {
        NO_ACTION = 0,
        PAUSE_ACTION,
        LOSE_ACTION,
        DRAW_ACTION,
        WIN_ACTION,
        NUM_ACTION_TYPES
    };
private:
    Action();   // unconstructible
};
```

## Gotchas
- Private constructor: use as `RBX::Action::PAUSE_ACTION` etc.; never instantiate.
- A commented-out include of `Util/SoundWorld.h` hints at a former sound coupling — no live dependency.

## UNKNOWN
- Current consumers (appears legacy; usage sites not in this slice).
