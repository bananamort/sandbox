# PhysicsInstructions.cpp

## Purpose

Implements `PhysicsInstructions`, the Workspace-owned physics duty-cycle/throttle controller for the cyclic executive. Samples frame and physics-step timings into rolling averages and adjusts (a) the World's EThrottle load and (b) the deferred-physics player's simulation radius so physics stays inside its duty budget on slow devices. Pure internal controller — no reflection, nothing reaches Lua. Also hosts the anti-tamper decoy global `Security::hackFlag6`.

## Key types and API

Module: `LOGGROUP(CyclicExecutiveThrottling)` declared here; whole tuning section wrapped in `#pragma optimize("", off/on)` (duty getters must not be optimized).

Constants (hardcoded duty budgets):
- `dPhysicsServerDutyPercent()` → **0.60** (comment trail: 0.15 → 0.10 → "0.40 under a FASTFLAG" → now unconditional 0.60).
- `dPhysicsClientDutyPercent()` → **0.40** ("higher than normal").
- `dPhysicsClientEThrottleDutyPercent()` → **0.60**.

State: three 30-sample running averages (`averageDt`, `averageDutyDt`, `averageCyclicDt`), `throttleTimer` vs `throttleAdjustTime` (seeded from `PhysicsSettings::singleton().getThrottleAdjustTime()`), `timeSinceLastRadiusChange`, `requestedDutyPercent(0.0)`, `bandwidthExceeded(false)`, `networkBufferHealth(1.0)`.

Methods:
- `setThrottles(dPhysPlayer, workspace, dt, dutyDt)`: fps-mode entry — `fpsOK = avgFps > 40`; `dutyOK = prevDutyPercent < requestedDutyPercent && avgDutyPercent < requestedDutyPercent`; delegates to `setThrottlesBase`.
- `setCyclicThrottles(...)`: cyclic-mode entry — samples `averageCyclicDt`; `stepsOK = (avgCyclicDt/avgDt) > 0.6` (world steps keeping up); same dutyOK formula; delegates.
- `setThrottlesBase(player, workspace, perfOK, dutyOK, avgDutyPercent, dt)`:
  - perf OK but duty bad → accumulate throttleTimer; on reaching adjust time → `World::getEThrottle().increaseLoad(false)`; duty good → immediate `increaseLoad(true)`; timer resets.
  - perf BAD → react immediately: `increaseLoad(false)`.
  - Radius control gated on `timeSinceLastRadiusChange ≥ throttleAdjustTime`: shrink ×0.7 when `bandwidthExceeded` OR !perfOK OR avgDuty > 0.40; grow ×1.05 when perfOK AND avgDuty < 0.20 (duty−0.2).
  - Max-radius drift vs network buffer health: ≤0.5 → ×0.95; ≥0.9 → ×1.05.
- `changeSimulationRadius(player, change)`: multiplies current radius, pushes via `player->updateSimulationRadius(newRadius)`; `changeMaxSimulationRadius` likewise over `setMaxSimulationRadius`.

File-tail decoy: `namespace RBX::Security { unsigned int hackFlag6 = 0; }` under comment "Randomized Locations for hackflags".

## Usage / reflection touchpoints

No REFLECTION macros — zero Lua surface. Consumers: Workspace stepping code (passes its World and the deferred-physics Network::Player), PhysicsSettings supplies the adjust interval (see `PhysicsSettings.md`, same folder), EThrottle lives in V8World, radius fields live on [Network Player](../../Network/).

## Gotchas

- `requestedDutyPercent` initializes to 0.0 and is NEVER assigned in this TU, so `dutyOK` compares against < 0.0 — effectively always false unless some header inline/other TU mutates it; as written, duty-driven throttle-down cannot trigger (UNKNOWN: intended setter location).
- `bandwidthExceeded` and `networkBufferHealth` are read here but never written in this TU — external wiring unknown.
- The comment block's EThrottle truth table says "Bad FPS ⇒ down" regardless of duty — implemented as the unconditional early branch before duty logic.
- Radius changes are multiplicative and rate-limited by `throttleAdjustTime`; repeated slow frames compound shrinking (0.7^n).
- `averageDt(30, 1.0)` seeds averages at 1.0 s/sample — first seconds of runtime read artificially slow/fast until 30 real samples land.
- Server duty percent is hardcoded despite comments describing flag behavior — the flag path was removed.
