# App/include/v8world/JointBuilder.h

## Purpose

Near-empty factory header: the only surviving entry point is `JointBuilder::canJoin`, deciding whether two primitives can auto-join. The generic `makeJoint` factory is commented out.

## Declared API

- `class JointBuilder`
  - `static Joint* canJoin(Primitive* p0, Primitive* p1);`
  - Commented out: `// static Joint* makeJoint(Primitive*, Primitive*, const CoordinateFrame&, const CoordinateFrame&, Joint::JointType);`

## Gotchas

- Header includes nothing (the `V8World/Joint.h` include is commented out) — callers must include [Joint.md](Joint.md) themselves before using the returned pointer.

## UNKNOWN

- What `canJoin` returns on success (a prototype joint? a boolean-like pointer?) — implementation-only.

## Cross-links

- Auto-join predicates live on the Joint class itself: [Joint.md](Joint.md) (`compatibleForWeldAutoJoint` etc.).
