# util/NavKeys.h

## Purpose
Plain struct aggregating navigation-key states (arrows, WASD, Q/E vertical strafe, space, backspace, shift) with derived queries combining sources and signed axis getters. All fields public booleans, default-constructed false.

## Declared API
```cpp
class NavKeys {
public:
    bool forward_arrow, backward_arrow, left_arrow, right_arrow;
    bool forward_asdw, backward_asdw, left_asdw, right_asdw;
    bool strafe_left_q, strafe_right_e;
    bool space, backspace, shift;

    NavKeys();                       // all false

    bool forward() const;   bool backward() const;   // arrow || asdw
    bool left() const;      bool right() const;
    bool up() const;        bool down() const;       // NOTE: q / e respectively!
    bool backspaceDown() const;
    bool arrowKeyDown() const;  bool asdwKeyDown() const;  bool qeKeyDown() const;
    bool navKeyDown() const;         // any of the above or space/backspace
    int  leftRightASDW() const;      // +1 left, -1 right, 0 none (NOTE sign convention)
    int  strafeQE() const;           // +1 when q ("up"), -1 when e
    int  leftRightArrow() const;     // +1 left, -1 right
    int  forwardBackwardArrow() const;   // +1 forward, -1 backward
    int  forwardBackwardASDW() const;
    int  strafeLeftRightQE() const;  // same as strafeQE()
    bool shiftKeyDown() const;
};
```

## Gotchas
- Sign convention is inverted-feeling: **left/forward/q return +1**, right/backward/e return −1.
- `up()`/`down()` map to the Q/E keys — vertical movement via "strafe" keys, not space.
- `strafeQE()` and `strafeLeftRightQE()` are duplicates.
- Caller is responsible for resetting per-frame state; struct has no update logic.

## UNKNOWN
- Consumers (camera/user-input code outside this slice).
