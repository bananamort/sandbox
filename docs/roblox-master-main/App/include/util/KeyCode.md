# util/KeyCode.h

## Purpose
Keyboard/gamepad key code enumeration adapted from SDL 1.2 (LGPL header notice included): `RBX::KeyCode` (SDLK_* values) and `RBX::ModCode` (KMOD_* modifier bit flags). ASCII codes match their character values; extended keys start at 256.

## Declared API
```cpp
namespace RBX {
enum KeyCode {
    SDLK_UNKNOWN = 0,
    // control chars: BACKSPACE=8, TAB=9, CLEAR=12, RETURN=13, PAUSE=19, ESCAPE=27
    // printable ASCII: SPACE=32 .. DELETE=127 (lowercase letters only; uppercase skipped)
    SDLK_WORLD_0..95 = 160..255,        // international keyboard syms
    SDLK_KP0..KP9 = 256..265, KP_PERIOD=266, KP_DIVIDE=267, ..., KP_EQUALS=272,
    SDLK_UP=273, DOWN, RIGHT, LEFT, INSERT, HOME, END, PAGEUP, PAGEDOWN,
    SDLK_F1..F15 = 282..296,
    SDLK_NUMLOCK=300, CAPSLOCK, SCROLLOCK, RSHIFT, LSHIFT, RCTRL, LCTRL,
      RALT, LALT, RMETA, LMETA, LSUPER, RSUPER, MODE, COMPOSE,
    SDLK_HELP=315, PRINT, SYSREQ, BREAK, MENU, POWER, EURO, UNDO,
    // Roblox gamepad extension (1000+):
    SDLK_GAMEPAD_BUTTONX=1000, BUTTONY, BUTTONA, BUTTONB, BUTTONR1, BUTTONL1,
      BUTTONR2, BUTTONL2, BUTTONR3, BUTTONL3, BUTTONSTART, BUTTONSELECT,
      DPADLEFT..DPADDOWN (1012-1015), THUMBSTICK1=1016, THUMBSTICK2=1017,
    SDLK_LAST
};

enum ModCode {
    KMOD_NONE=0x0000, KMOD_LSHIFT=0x0001, KMOD_RSHIFT=0x0002,
    KMOD_LCTRL=0x0040, KMOD_RCTRL=0x0080, KMOD_LALT=0x0100, KMOD_RALT=0x0200,
    KMOD_LMETA=0x0400, KMOD_RMETA=0x0800, KMOD_NUM=0x1000, KMOD_CAPS=0x2000,
    KMOD_MODE=0x4000, KMOD_RESERVED=0x8000
};
}
```

## Gotchas
- Values are SDL 1.2 keysyms — NOT Windows VK_* or modern SDL2 scancodes.
- Uppercase A–Z deliberately absent ("skip uppercase letters"); use lowercase `SDLK_a`..`SDLK_z`.
- Gamepad buttons piggyback on the keyboard enum at 1000+ (`SDLK_LAST` follows them) — treat KeyCode as a unified input-code space here.
- LGPL licensing note applies to this adapted block.
- Modifier flags are bitmask-combinable via ModCode; note the gaps in values (shift/ctrl/alt/meta groups).

## UNKNOWN
- Where platform input backends translate native events into these codes (outside util/).
