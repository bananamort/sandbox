# App/humanoid/Balancing.cpp

## Purpose

Implements `HUMAN::Balancing`, the intermediate humanoid-state base that provides the upright PD balance controller shared by RunningBase (→ Running/Landed/Climbing), Flying (→ Jumping), Freefall, and GettingUp. Each force pass computes a corrective torque from torso tilt and angular velocity, applies it to the root body through the kernel, and caches it for reuse across a solver-dependent number of ticks.

## API

Real signatures from the source:

- `Balancing::Balancing(Humanoid* humanoid, StateType priorState)` — member-init `kP(2250.0f)`, `kD(50.0f)`, `tick(-1)`, `lastBalanceTorque(0,0,0)`. These are the default gains every two-arg subclass ctor inherits.
- `Balancing::Balancing(Humanoid* humanoid, StateType priorState, const float kP, const float kD)` — gain-passing variant used by GettingUp (5000/300 legacy) and Landed (7500/50).
- `int Balancing::balanceRate(double torqueMag)` — legacy tick rate `(int)(20.0f - (torqueMag / 12000.0f))`: the computed torque is reused for N iterations without recomputation; above roughly 240k torque magnitude the formula reaches ~0 and force is recomputed every iteration. Source comment states the constants were tuned for performance versus unwanted behavior.
- `int Balancing::balanceRateForPGS()` — returns 1 (recompute every iteration under PGS).
- `void Balancing::onComputeForceImpl()` — the PD controller (details below).

The protected `maxTorqueComponent()` (4000), `setBalanceP`/`setBalanceD` setters, and the `kP`/`kD`/`tick`/`lastBalanceTorque` members are declared in Balancing.h.

## Usage

Implements Balancing.h inside the humanoid state machine driven by HumanoidState (`onComputeForce()` → virtual `onComputeForceImpl()`). Subclasses reach this code either directly (two-arg ctor keeps 2250/50) or after retuning gains via `setBalanceP`/`setBalanceD` in their constructors.

Controller flow per call:

1. Guard: humanoid must be in the kernel (`RBXASSERT(getHumanoid()->Connector::isInKernel())`); null root or torso body returns silently.
2. If `tick > 0`, decrement and re-accumulate the cached `lastBalanceTorque` without recomputation (the throttle window).
3. Compute world-space inputs from the torso: tilt axis `unitY().cross(torsoUpAxis)`, angular velocity, plus the root's existing branch torque; transform all into root object space.
4. P term: `-kP * (root->getBranchIBody() * tiltRoot)` (Matrix3 multiply); D term subtracted separately as `kD * (branchIBodyV3 * angVelRoot)`.
5. Clamp/override loop runs `for (int i = 0; i < 3; i += 2)` — **X and Z components only**: where the control-to-external difference is below `maxTorqueComponent() * branchIBody[i]` (4000 × inertia), the exact control torque replaces the summed value. The Y component never gets this treatment.
6. Final added torque = world torque minus external torque; accumulated on the root, cached in `lastBalanceTorque`, and the next tick count selected by solver (`balanceRateForPGS()` under PGS, else `balanceRate(magnitude)`).

## Gotchas

- Default gains are kP=2250, kD=50 — numerically identical to GettingUp's PGS override pair (see [GettingUp.md](GettingUp.md)); Freefall and Flying raise kP to 5000 but leave kD at this default 50.
- The tick-throttle means balance torque is stale for up to `balanceRate` iterations on the legacy solver; instrumentation sampling torques once per frame will see repeated values by design.
- The clamp/override skips index 1 (Y) entirely — pitch-axis balance torque is unclamped by the `maxTorqueComponent` comparison path (it is still bounded indirectly because the P input tilt is horizontal).
- `balanceRate` can return negative values for extreme torque magnitudes (>400k); `tick > 0` guards make that benign (immediate recompute), but it is not clamped.
