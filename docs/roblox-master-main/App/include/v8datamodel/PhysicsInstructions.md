# App/include/v8datamodel/PhysicsInstructions.h

## Purpose

`PhysicsInstructions` — plain helper class (not an Instance) computing physics duty-cycle throttles per `Network::Player`: tracks dt/duty averages and simulation-radius changes, decides whether to grow/shrink a player's dedicated-physics simulation radius, and exposes static duty-percent presets for solo/server/DPhysics modes.

## Declared API

`class PhysicsInstructions`

- Public data: `double requestedDutyPercent; bool bandwidthExceeded; double networkBufferHealth;`
- Ctor `PhysicsInstructions()`.
- Throttle entry points:
  - `void setThrottles(RBX::Network::Player* dPhysPlayer, Workspace* workspace, double dt, double dutyDt)`
  - `void setCyclicThrottles(Player*, Workspace*, double cyclicDt, double dt, double dutyDt)`
  - `void setThrottlesBase(Player*, Workspace*, bool realTimePerfOK, bool dutyPerfOK, double avgDutyPercent, double dt)`
- Static duty presets: `visitSoloDutyPercent()=0.50`, `regularServerDutyPercent()=0.25`, `zeroDutyPercent()=0.0`, plus out-of-line `dPhysicsServerDutyPercent()`, `dPhysicsClientDutyPercent()`, `dPhysicsClientEThrottleDutyPercent()`.
- Private: `Average<double> averageCyclicDt/averageDt/averageDutyDt`, timers (`timeSinceLastRadiusChange`, `throttleTimer`, `throttleAdjustTime`), radius changers `changeSimulationRadius/changeMaxSimulationRadius(Player*, float)`.

## Gotchas

- Per project recon: decoy hackFlag usage is associated with this file's area (hackFlag0/6/7 decoys live in SurfaceSelection/PhysicsInstructions/TouchTransmitter cluster) — anti-tamper noise around the throttle path; see certified doc before trusting any flag semantics here.
- Class mutates player-owned simulation radii as a side effect — calling setThrottles is not read-only.
- Duty presets differ per role (solo 50% vs regular server 25%); DPhysics values are computed, not constant.

## UNKNOWN

- Numeric DPhysics duty percents and the hysteresis behind `throttleAdjustTime` (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PhysicsInstructions.md](../../v8datamodel/PhysicsInstructions.md).
- Consumers: [Workspace.md](Workspace.md), [DataModel.md](DataModel.md) (physicsStep), [Stats.md](Stats.md).
