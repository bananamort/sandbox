# App/include/v8kernel/BodyPvSetter.h

## Purpose

Empty tag base class: `Primitive` descends from it so that only Primitive-typed code can reach the friend-protected `Body::setCoordinateFrame()` — a compile-time capability token ("protect body::setCoordinateFrame() from others").

## Declared API

- `class BodyPvSetter {}` — no members.

## Gotchas

- Purely structural; its meaning exists only via friendship in [Body.md](Body.md). Adding public setters that take `BodyPvSetter&` would defeat the guard.
