# Seat.cpp

## Purpose

Implements `Seat` ("Seat"), the sittable PartInstance. In deferred-physics/client game modes it replicates seat-weld create/destroy requests as remote events (with a client debounce); otherwise welds locally via the base Humanoid-seat machinery. Exposes Disabled and read-only Occupant, and un-sits the local humanoid when the weld breaks.

## Key types and API

Descriptors:
- `propDisabled("Disabled")` — bool, category "Control", no cap/security args.
- `propOccupant("Occupant")` — RefPropDescriptor Humanoid, category "Control", read-only (NULL setter), cap SCRIPTING.
- Remote events (**Security::None**, REPLICATE_ONLY, CLIENT_SERVER): "RemoteCreateSeatWeld(humanoid)", "RemoteDestroySeatWeld()".

Tunables: DFInt ActionStationDebounceTime(2); DFFlags FixAnchoredSeatingPosition(false), FixSeatingWhileSitting(false) [declared here, consumed elsewhere].

Behavior:
- Ctor wires both remote signals to local handlers (`createSeatWeldInternal(shared_ptr<Instance>)` overload / `findAndDestroySeatWeldInternal`).
- `createSeatWeld(Humanoid*)`: DPHYS_CLIENT/CLIENT modes → replicate event only when `debounceTimeUp()` (debounce = DFInt seconds), stamping debounceTime; other modes → Super (direct weld).
- `findAndDestroySeatWeld()`: fire-and-replicate destroy (both sides run their internal handler).
- `onSeatedChanged(false, humanoid)`: when LOCAL humanoid stops sitting, forces `humanoid->setSit(false)` (prevents stuck sit state).
- `setOccupant(Humanoid*)`: change-tracked raise.

## Usage / reflection touchpoints

Occupant readable by scripts; weld replication pairs with Platform.md (same REPLICATE_ONLY pattern) and [Network](../../Network/) transport; Humanoid seating logic documented via CharacterMesh/Humanoid headers.

## Gotchas

- Occupant has NO setter descriptor — scripts can't assign it; engine sets via setOccupant.
- Client-side create debounces but DESTROY does not — rapid sit/stand cycles could out-of-order if network reorders.
- The two DFFlags declared here are not referenced in this TU — their gating logic lives in other TUs (UNKNOWN which).
- onSeatedChanged only auto-unsits the LOCAL humanoid; remote players' humanoids rely on weld-break handling elsewhere.
