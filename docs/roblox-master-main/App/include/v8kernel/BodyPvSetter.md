# App/include/v8kernel/BodyPvSetter.h

## Purpose

Empty tag base class: `Primitive` descends from it so that only Primitive-typed code can naturally supply the `const BodyPvSetter&` parameter that gates `Body::setPv/setCoordinateFrame/setVelocity/setCanThrottle` — a compile-time capability token ("protect body::setCoordinateFrame() from others").

## Declared API

- `class BodyPvSetter {}` — no members.

## Gotchas

- Purely structural; its meaning exists only as the tag-parameter type on [Body.md](Body.md)'s guarded setter quartet (no friendship involved). Because the class is public with an implicit default constructor, any code can technically fabricate one — the guard is by convention plus type intent, not enforcement. Adding public setters that take `BodyPvSetter&` would defeat the guard.
