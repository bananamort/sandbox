# App/include/v8kernel/ContactParams.h

## Purpose

Per-contact physical parameter bundle (`ContactParams`) and the `GeoPairType` enum naming every geometric contact/connector pairing the kernel understands (ball-vs-block family, block-vs-block, vertex/edge/plane connectors, bullet shapes).

## Declared API

- `class ContactParams`
  - `float kSpring;` — spring constant.
  - `float kNeg;` — "elastic — spring constant on bounceback".
  - `float kFriction;` — header comment verbatim: "contact only variable stored as true value * -0.5;???".
  - `float kElasticity;`
  - Ctor zeroes all four.
- `enum GeoPairType { BALL_POINT_PAIR, BALL_EDGE_PAIR, BALL_PLANE_PAIR, POINT_PLANE_PAIR, EDGE_EDGE_PLANE_PAIR, EDGE_EDGE_PAIR, VERTEX_PLANE_CONNECTOR, EDGE_EDGE_CONNECTOR, EDGE_EDGE_PLANE_CONNECTOR, BALL_VERTEX_CONNECTOR, BALL_EDGE_CONNECTOR, BALL_PLANE_CONNECTOR, BULLET_SHAPE_CONNECTOR, BULLET_SHAPE_CELL_CONNECTOR };`

## Gotchas

- `kFriction` is stored pre-multiplied by **−0.5** — consumers must know to un-scale it; the in-header `???` shows even authors were unsure late in life.
- `_PAIR` vs `_CONNECTOR` suffixes distinguish instantaneous contact pairs from persistent connectors ([Connector.md](Connector.md) / [PolyConnectors.md](PolyConnectors.md) / [BulletShapeConnectors.md](BulletShapeConnectors.md)).
- Unscoped enum: identifiers like `BALL_PLANE_PAIR` are global within RBX.
