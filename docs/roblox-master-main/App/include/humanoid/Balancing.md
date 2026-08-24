# App/include/humanoid/Balancing.h

## Purpose

Declares `HUMAN::Balancing`, the intermediate humanoid-state base for balance-controlled states (derived: `RunningBase` [→ Running/RunningSlave/Landed/Climbing], `Flying` [→ Jumping], `Freefall`, `GettingUp`; NOTE `Swimming` and all other states derive straight from `HumanoidState`). Implements a PD balance controller: proportional gain kP (units 1/sec²) and derivative gain kD (1/sec) applied as torque = gain × momentOfInertia × (rotation | rotVelocity), clamped by a max torque component.

## Declared API

- `class RBX::HUMAN::Balancing : public HumanoidState`
  - Private: `float kP;` ("units: 1/sec^2      torque = kP * momentOfInertia * rotation"), `float kD;` ("units: 1/sec        torque = kD * momentOfInertia * rotVelocity"), `Vector3 lastBalanceTorque; int tick;`
  - Private statics: `static int balanceRate(double torqueMag);` `static int balanceRateForPGS();`
  - Protected:
    - inline static `const float maxTorqueComponent() {return 4000.0f;}` — "torque <= maxTorqueComponent * momentOfInertia"
    - inline setters `void setBalanceP(float P)` / `void setBalanceD(float D)`
    - override declared: `void onComputeForceImpl();`
  - Ctors: `Balancing(Humanoid*, StateType priorState);` and `Balancing(Humanoid*, StateType, const float kP, const float kD);`

## Usage notes

- Subclasses tune gains via protected setters — grep-verified callers: `Freefall` (kP=5000), `Flying` (kP=5000, inherited by Jumping), `GettingUp` (kP=2250, kD=50).
- See [HumanoidState.md](HumanoidState.md) for the base contract.

## Gotchas

- Gains are per-state-instance, not global: each state transition re-applies its tuned kP/kD.
- `balanceRate`/`balanceRateForPGS` imply different integration paths for the legacy vs PGS physics solvers.
