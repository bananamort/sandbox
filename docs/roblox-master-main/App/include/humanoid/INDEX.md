# App/include/humanoid — Index

The humanoid character-control subsystem: `Humanoid` (the character Instance) and its finite-state machine — one class per locomotion state (Running, Jumping, Freefall, Swimming, ...), all derived from `HumanoidState`, with PD-balancing intermediate bases (`Balancing`, `RunningBase`, `Flying`) and kinematic no-physics variants. States are created/destroyed per transition by the state table inside HumanoidState.

## Files

- [Balancing.md](Balancing.md) — PD balance-controller base (kP/kD torque gains) for upright states.
- [FallingDown.md](FallingDown.md) — Dead, FallingDown, Physics: pure-simulation states with no control forces.
- [Flying.md](Flying.md) — airborne balancing state; y-axis turn only.
- [Freefall.md](Freefall.md) — falling with air control, velocity decay, legacy/PGS turn speeds.
- [GettingUp.md](GettingUp.md) — recovery from prone; limb collision off.
- [Humanoid.md](Humanoid.md) — the character Instance: reflected movement/health data, state owner, appendage caches, speed-hack detection.
- [HumanoidState.md](HumanoidState.md) — StateType/EventType enums + abstract state base: event computation, floor/ladder raycasts, transitions, anti-exploit checks.
- [Jumping.md](Jumping.md) — jump impulse over Flying; ceiling detection; collision off.
- [MovingNoPhysicsBase.md](MovingNoPhysicsBase.md) — kinematic movement base; floor impulses; all collision off.
- [Ragdoll.md](Ragdoll.md) — limp physics-only state.
- [Running.md](Running.md) — Running, RunningSlave (replication-side lock), Landed, Climbing.
- [RunningBase.md](RunningBase.md) — grounded walking base: floor-relative velocity, hover altitude, solver-specific turn gains.
- [RunningNoPhysics.md](RunningNoPhysics.md) / [StrafingNoPhysics.md](StrafingNoPhysics.md) — kinematic run/strafe states.
- [Seated.md](Seated.md) — Seated + PlatformStanding passive states.
- [StatusInstance.md](StatusInstance.md) — internal ModelInstance marker for humanoid statuses.
- [Swimming.md](Swimming.md) — water locomotion; slower turn than auto-turn default.

## Related

- Implementations pair with `App/v8datamodel/Humanoid*.cpp` *(docs pending in v8datamodel campaign)*.
