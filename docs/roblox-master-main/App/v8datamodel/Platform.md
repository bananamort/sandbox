# Platform.cpp

## Purpose

Implements `Platform`, the legacy Instance representing the old SkateboardPlatform-era "platform" part concept — here reduced to just two replicated remote events that create/destroy a Motor6D joint when a Humanoid stands on / steps off the platform. The actual joint construction happens on the receiving side (Humanoid/Platform wiring elsewhere); this TU only fires and replicates the requests.

## Key types and API

Descriptors:
- `event_createPlatformMotor6D` → RemoteEventDesc "RemoteCreateMotor6D(humanoid:Instance)", **Security::None**, flag REPLICATE_ONLY, direction CLIENT_SERVER.
- `event_destroyPlatformMotor6D` → RemoteEventDesc "RemoteDestroyMotor6D()", same tiers/flags.

Methods:
- `createPlatformMotor6D(Humanoid*)`: `fireAndReplicateEvent(this, shared_from(h))` — broadcast creation request.
- `findAndDestroyPlatformMotor6D()`: fire-and-replicate destroy request (note: fires unconditionally; does not first verify a motor exists despite the "FindAnd…" name).

Constant: `sPlatform = "Platform"`.

## Usage / reflection touchpoints

Script-facing only as replicated events at Security::None; consumers are Humanoid platform-standing logic and the replicator documented under [Network](../../Network/) (RemoteEventDesc REPLICATE_ONLY semantics). Related: `SkateboardPlatform.md`, `VehicleSeat.md` in this folder for other rideable-part machinery.

## Gotchas

- Both events replicate CLIENT_SERVER but carry Security::None — any context holding the Platform can trigger joint churn across the network boundary.
- No guard against duplicate create events; idempotency must be enforced by the handler side.
- The class body is otherwise EMPTY — all geometry/physics behavior inherited from its base (header-side, UNKNOWN from this file).
