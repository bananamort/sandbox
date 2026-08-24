# App/include/v8datamodel/Posture.h

## Purpose

Header defining exactly one enum: `RBX::CharacterActionType` — a three-value tag distinguishing why a character action was issued (none / remote-driven / steer-driven). Consumed by humanoid/character-control code elsewhere.

## Declared API

- `typedef enum CharacterActionType { NO_CHARACTER_ACTION = 0, REMOTE_CHARACTER_ACTION, STEER_CHARACTER_ACTION } CharacterActionType;`

## Gotchas

- No class, no includes — the file is just the enum; anything "posture"-named (sit/platform-standing etc.) lives in Humanoid, not here.
- Values are ordinal (0..2) and likely serialized or switched on numerically.

## UNKNOWN

- All consumers (no in-header references).

## Cross-links

- Implementation: [App/v8datamodel/Posture.md](../../v8datamodel/Posture.md).
- Consumer domain: [SkateboardController.md](SkateboardController.md), [Seat.md](Seat.md), humanoid docs under App/v8datamodel.
