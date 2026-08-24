# FlagStand.cpp

## Purpose

Implements `FlagStand` ("FlagStand"), the CTF capture pad with TeamColor + FlagCaptured event, and `FlagStandService` ("FlagStandService", non-archivable) which steps all registered stands, tracks watching/cloned replacement flags, and places returned flags on random empty same-color stands.

## Key types and API

Descriptors:
- `prop_Color("TeamColor", category_Data)` — BrickColor (unconditional raise like Flag).
- `event_FlagCaptured("FlagCaptured", "player")` — plain Event.

Constants: `sFlagStand`, `sFlagStandService`.

Behavior:
- Stand registration: onServiceProvider registers to service when first attached under backendProcessing, unregisters on detach.
- `FlagStand::onStepped()` (runs ONLY while game running — comment) — watches its joined flag; on first sight CLONES it as `clonedReplacementFlag` (EngineCreator); if watched flag re-joins elsewhere → drop watch+clone; if watched flag DESTROYED (parent NULL) → affix the clone to a random empty stand.
- `onEvent_standTouched` — capture rule: toucher is non-neutral player whose team == stand's team AND carried flag color != stand team → fire flagCapturedSignal(player) + affix that flag elsewhere.
- `affixFlag(flag)` — only if no joined flag; reparents flag next to stand, resets handle CF identity, moveToPointAndJoin at stand location +0.5y ("little hack - fix"), join() noted "should be redundant".
- Service: `RegisterFlagStand/UnregisterFlagStand` (raw pointer list), per-step fan-out, `findRandomEmptyStandForFlag` (same-color + unoccupied, rand() pick), `FindStandWithFlag`.

## Usage / reflection touchpoints

Counterpart [Flag](Flag.md); teams via [Teams](Teams.md)/[Team](Team.md); joints via RigidJoint walk ([Base](../../Base/) physics).

## Gotchas

- Capture requires holding an ENEMY-colored flag while standing on YOUR stand — same-color flags never cap.
- The clone-on-first-sight design means the ORIGINAL flag can be carried off while the stand holds a hidden clone instance in memory (parented nowhere until needed).
- affixFlag asserts backendProcessing — client calls are debug-only traps.
- rand() % size — modulo bias and shared RNG state with everything else using srand-seeded rand.
