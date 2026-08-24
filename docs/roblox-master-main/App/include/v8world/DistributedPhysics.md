# App/include/v8world/DistributedPhysics.h

## Purpose

Constants-only header for networked-physics ownership ranges: how far from the player a part may be simulated on the client, and the slop factors governing client/server hand-off.

## Declared API

- `namespace RBX::Network { class DistributedPhysics }` — all static const float functions:
  - `MIN_CLIENT_SIMULATION_DISTANCE() → 10.0f`
  - `MAX_CLIENT_SIMULATION_DISTANCE() → 1000.0f`
  - `CLIENT_SLOP() → 1.05f` — "105% how far out of the region before client stops simulating"
  - `SERVER_SLOP() → 1.00f` — "server switches simulation to someone else as soon as the object leaves the region"

## Gotchas

- Client slop (1.05) > server slop (1.00) by design: hysteresis so ownership doesn't ping-pong at the region boundary.
- Values are exposed as functions, not variables — can't be ODR-used as compile-time constants in all contexts.

## Cross-links

- Assembly replication fields: [Assembly.md](Assembly.md) (`setPhysics/getPhysics`, `networkHumanoidState`); stage that moves assemblies: [SimulateStage.md](SimulateStage.md).
