# TouchTransmitter.cpp

## Purpose

Implements `TouchTransmitter` (instance name "TouchInterest"), the per-part touch-interest object that DEBOUNCES duplicate touch/untouch event pairs before they reach Touched/TouchEnded scripts. Contains the `TouchDebouncer` helper: per (other part) entry tracking last event type with a 5-second expiration window sized "for network lag". File tail hosts anti-tamper decoy `Security::hackFlag7`.

## Key types and API

No reflection. TouchDebouncer::checkTouch(other, type):
- mutex-guarded linear vector scan; matching part refreshes expiry and ACCEPTS only when lastType differs (duplicate same-type events rejected).
- Expired entries fast-deleted via swap-with-last during the sweep; unknown parts get a new entry accepted.
- Acknowledged minor memory leak for parts that stop receiving touches (bounded by next-touch sweep).

TouchTransmitter::checkTouch / checkUntouch delegate with TouchPair::Touch / Untouch.

Tail decoy: `Security::hackFlag7 = 0` ("Randomized Locations for hackflags" — family: hackFlag0 SurfaceSelection.md, hackFlag6 PhysicsInstructions.md).

## Usage / reflection touchpoints

Engine plumbing behind Touched/TouchEnded; pairs with PartInstance.md touchedSignal consumers, PhysicsService.md touch pipeline in this folder.

## Gotchas

- Debounce means legit rapid re-touch of the SAME pair within 5 s is silently dropped if no untouch arrived — physics tunneling can eat events.
- O(n) per check with n = recent touch partners per transmitter.
