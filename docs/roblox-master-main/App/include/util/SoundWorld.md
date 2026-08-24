# util/SoundWorld.h

## Purpose
Defines the classic `SoundType` enum of stock UI/game sounds (boing, bomb, click, step, victory...) and a `SoundWorld` static-mapping class that gives semantic names (TrashSound, LimitSound, WinSound...) to specific SoundTypes.

## Declared API
```cpp
typedef enum SoundType {
    NO_SOUND = 0,
    BOING_SOUND, BOMB_SOUND, BREAK_SOUND, CLICK_SOUND, CLOCK_SOUND,
    RUBBERBAND_SOUND, PAGE_SOUND, PING_SOUND, SNAP_SOUND, SPLAT_SOUND,
    STEP_SOUND, STEP_ON_SOUND, SWOOSH_SOUND, VICTORY_SOUND
} SoundType;

class SoundWorld {
public:
    static SoundType ActionSound();   // PING_SOUND
    static SoundType TrashSound();    // PAGE_SOUND
    static SoundType ClickSound();    // CLICK_SOUND
    static SoundType SplatSound();    // SPLAT_SOUND
    static SoundType StepSound();     // STEP_SOUND
    static SoundType StepOnSound();   // STEP_ON_SOUND
    static SoundType SwooshSound();   // SWOOSH_SOUND
    static SoundType LimitSound();    // BOING_SOUND
    static SoundType WinSound();      // VICTORY_SOUND
    static SoundType LoseSound();     // BOING_SOUND
};
```

## Gotchas
- `NO_SOUND == 0` — zero-initialized variables read as "no sound".
- `LimitSound` and `LoseSound` both map to BOING_SOUND; the semantic layer is just fixed aliases.
- `SoundType` is consumed by `Soundscape::SoundService::playSound(SoundType)` (see SoundService.md).

## UNKNOWN
- Where each SoundType maps to an actual asset id (.cpp / content side).
