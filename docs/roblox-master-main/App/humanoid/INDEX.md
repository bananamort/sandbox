# App/humanoid — Index

Implementation directory for the humanoid character-control subsystem: `Humanoid` (the character Instance and IStepped/KernelJoint hub) plus one .cpp per finite-state-machine class, driven by the 17×26 STATE_TABLE in HumanoidState.cpp. Header-side counterparts are documented under [App/include/humanoid](../include/humanoid/INDEX.md); every fact below was verified against these sources (6,999 lines total).

## Files

- [Balancing.md](Balancing.md) — PD balance-controller base: default gains kP=2250/kD=50, torque tick-throttling, X/Z-only clamp.
- [FallingDown.md](FallingDown.md) — Dead (health zeroing + joint breaking), FallingDown (3 s timer), Physics (no control).
- [Flying.md](Flying.md) — airborne state; both step hooks are EMPTY stubs, so kP=5000 is dead tuning here.
- [Freefall.md](Freefall.md) — air control; kP=5000 confirmed, deferred-init commented out, friction save/restore real.
- [GettingUp.md](GettingUp.md) — recovery; legacy gains 5000/300, PGS overrides to 2250/50 (header doc needed correction).
- [Humanoid.md](Humanoid.md) — reflection surface, ctor defaults, testWalkSpeed call site, simulate/noSimulate driver, billboards, platform networking.
- [HumanoidState.md](HumanoidState.md) — full transition matrix, event computation, floor/ladder raycasts, factory, anti-exploit machinery.
- [Jumping.md](Jumping.md) — jump impulse along jumpDir; ceiling rays; PGS force factor 0.52; swim/ladder entry special cases.
- [MovingNoPhysicsBase.md](MovingNoPhysicsBase.md) — kinematic base: engine-type swap, CFrame integration, half-gravity floor impulses.
- [Ragdoll.md](Ragdoll.md) — limp state; 8 s backstop timer with 1 s-later rest detection exit; dtor clears touchedHard.
- [Running.md](Running.md) — Running (+ragdoll entrance gate), RunningSlave (identical, replication-pinned), Landed (7500/50, 0.05 s), Climbing (signed/abs climb signal).
- [RunningBase.md](RunningBase.md) — grounded movement: hover PD (kAltitudeP 30000/kD 1100), infinity altitude sentinel, solver-split turn gains, ladder overrides.
- [RunningNoPhysics.md](RunningNoPhysics.md) — kinematic run; ctor fires running signal once (flag-gated clamp variant).
- [Seated.md](Seated.md) — Seated + PlatformStanding; only throttled states; dtors restore flags/signals (no weld teardown here).
- [StatusInstance.md](StatusInstance.md) — locked-name "Status" marker; askSetParent always false.
- [StrafingNoPhysics.md](StrafingNoPhysics.md) — tag-only kinematic strafe; reachable only from RUNNING_NO_PHYS.
- [Swimming.md](Swimming.md) — direct HumanoidState subclass confirmed; custom pitch PD; turn logic #if 0'd out.

## Related

- Certified header docs for this module: `App/include/humanoid/*.md` (pairing context, declared API).
- State ownership: `Humanoid.cpp` drives `simulate`/`noSimulate`; `HumanoidState.cpp` owns transitions and the factory; concrete states own forces/steps/timers only.
