# Network/InterpolatingPhysicsReceiver.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 321 lines) · **Status**: `#if 1`-wrapped pending removal via `FFlag::RemoveInterpolationReciever`

## Purpose

Implements the interpolation receiver (see InterpolatingPhysicsReceiver.h): per-part history buffers, adaptive lag estimation, buffer seek + lerp rendering, and out-of-order packet handling.

## API / behavior

- `Job`: `ReplicatorJob("Net InterpolatePhysics", PhysicsIn)`, cyclic executive, rate from `settings().getReceiveRate()`; steps `receiver->step(RakNet::GetTimeMS())`.
- `Nugget::receive`: detects out-of-order timestamps (decodes into a throwaway `MechanismItem dummy`, samples `outOfOrderMechanisms=1`, returns); otherwise advances ring buffer and decodes via `receiveMechanism`. Lag update: `newLag = Δt * 1.2` then harmonic-ish blend `(lag²+newLag²)/(lag+newLag)` — comment explains it is an "asymmetric log average that favors large values". Parts under `noLagModel` get lag 0.
- `Nugget::step`: skips parts being dragged or without assembly or rejected by distributed-receive check (returns false → nugget erased); with 1 sample applies directly; otherwise finds bracketing samples around `time - lag` and calls `setLerpedPhysics(item, itemAfter, lerpAlpha)`; records `sampleBufferSeek(i+1)`.
- `setLerpedPhysics`: shortcuts at alpha ≤0.001 / ≥0.99; falls back to `itemAfter` when `MechanismItem::consistent` fails; else lerps into `reusableMechanismItem`.
- `receivePacket`: loops root parts; updates existing nugget via multi-index `modify`, or inserts a new one (only if part non-null).
- Static `lerpValue = 0.05` seeds both RunningAverages.

## Usage

Instantiated by Replicator when interpolation mode is active; stats surfaced as max/avg buffer seek and lag for perf dashboards.

## Gotchas

- `History` holds 40 inline `MechanismItem`s per part — memory-heavy; header TODO suggests `boost::circular_buffer`.
- `step()` TODO: "Erase if no longer relevant" — nuggets for destroyed parts are only dropped when their step() returns false.
- No mutex: nuggets are touched from both the packet-processing path and the job thread — relies on caller-side serialization.
