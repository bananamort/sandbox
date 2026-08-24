# App/include/humanoid/Running.h

## Purpose

Declares four grounded-movement humanoid states: `HUMAN::Running` (normal walking/running), `HUMAN::RunningSlave` (network-slave variant that "stays running until some other change to respond to touch events correctly"), `HUMAN::Landed` (brief post-landing state), and `HUMAN::Climbing` (ladder climbing, header-defined).

## Declared API

- Name externs: `sRunning`, `sRunningSlave`, `sLanded`, `sClimbing`.
- `class RBX::HUMAN::Running : public Named<RunningBase, sRunning>`
  - Inline: `getStateType() → RUNNING`; overrides declared `void fireEvents(); void onComputeForceImpl();`
  - `Running(Humanoid*, StateType priorState);`
- `class RBX::HUMAN::RunningSlave : public Named<Running, sRunningSlave>`
  - Comment: "Slave side only - stays running until some other change to respond to touch events correctly"
  - `RunningSlave(Humanoid*, StateType priorState);` — no overrides.
- `class RBX::HUMAN::Landed : public Named<RunningBase, sLanded>`
  - Inline `getStateType() → LANDED`; ctor only.
- `class RBX::HUMAN::Climbing : public Named<RunningBase, sClimbing>`
  - Inline overrides: `getStateType() → CLIMBING`; declared `void fireEvents();` inline `int ladderCheckRate() { return 0; }` (disables ladder re-checks), auto-jump off.
  - Header-defined ctor delegating to Named base.

## Usage notes

- See [RunningBase.md](RunningBase.md) for shared movement logic, [HumanoidState.md](HumanoidState.md) for the base contract.

## Gotchas

- RunningSlave exists purely for replication fidelity on the non-authority side — it suppresses premature state exits so touch events resolve identically to the master.
- Climbing pins `ladderCheckRate()` to 0 — once climbing, the state machine stops polling for ladders until another transition.
