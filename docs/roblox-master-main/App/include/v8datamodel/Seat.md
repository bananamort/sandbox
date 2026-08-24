# App/include/v8datamodel/Seat.h

## Purpose

Template `SeatImpl<Base>` (over `ActionStation<Base>`) implements sit-on-touch seating: a humanoid touching an unoccupied seat gets a non-archivable `Weld` named "SeatWeld" (torso↔seat); humanoid done-sitting or weld removal unseats. Concrete `Seat` = `SeatImpl<BasicPartInstance>` with remote signals and occupant replication. Two DYNAMIC_FASTFLAGs gate behavior fixes (`FixAnchoredSeatingPosition`, `FixSeatingWhileSitting`).

## Declared API

- DFFlags: `DYNAMIC_FASTFLAG(FixAnchoredSeatingPosition)`, `DYNAMIC_FASTFLAG(FixSeatingWhileSitting)`.

- `template<class Base> class SeatImpl : public ActionStation<Base>`
  - Connections: `seatTouched` (wired to `ActionStation::onDemandWrite()->localSimulationTouchedSignal`), `humanoidDoneSitting`; `bool disabled`.
  - `onEvent_seatTouched(shared_ptr<Instance>)` — inline mount gate: humanoid from body part, sleep time up, no SeatWeld present, not already sitting, not dead, not disabled, torso network-owned locally, both in workspace.
  - `createSeatWeldInternal(Humanoid*)` — inline: bails if `FixSeatingWhileSitting && h->getSit()`; computes seat/torso offsets; C1 torso hover is `-1.5` legacy or `-(torsoOffset + 0.5)` under FixAnchoredSeatingPosition ("0.5 studs higher ... for the leg room"); zeroes root velocity; under FixAnchoredSeatingPosition ALSO pre-teleports the torso part via setCoordinateFrame before welding ("If the seat is anchored the weld will not move the torso"); creates Weld named "SeatWeld", sets Part0/Part1/C0/C1, propArchivable=false, parents to seat.
  - `onEvent_humanoidDoneSitting()` → destroy weld; child add/remove hooks detect "SeatWeld" by NAME + cast, manage occupant/humanoid.setSeatPart/setSit(true)/doneSittingSignal, destroyOtherWelds; helpers `humanoidFromWeld/findSeatWeld/isChildSeatWeld/destroyOtherWeld(s)`.
  - Protected: `shared_ptr<Humanoid> occupant`; `onServiceProvider` override re-wiring touch + clearing seated state; virtuals `createSeatWeld(Humanoid*)`, `findAndDestroySeatWeld()`, extension points `/*implement*/ onSeatedChanged(bool, Humanoid*) {}` and `setOccupant(Humanoid*) {}`.
  - Public: inline `const bool& getDisabled() const`; `setDisabled(const bool&)` — enabling→disabling also un-sits and destroys all seat welds; `Humanoid* getOccupant() const {return occupant.get();}`.
- `extern const char* const sSeat;`
- `class Seat : public DescribedCreatable<Seat, SeatImpl<BasicPartInstance>, sSeat>`
  - Remote signals: `createSeatWeldSignal<void(shared_ptr<Instance>)>`, `destroySeatWeldSignal<void()>`.
  - Overrides createSeatWeld / findAndDestroySeatWeld / onSeatedChanged / setOccupant.

## Gotchas

- SeatWeld identified by literal name "SeatWeld" — user-created Welds with that name are treated as seating state.
- DFFlag-gated behavior: seating math DIFFERS at runtime depending on FixAnchoredSeatingPosition/FixSeatingWhileSitting values.
- Occupant is a shared_ptr<Humanoid> held by the seat — seats keep humanoids alive while occupied.
- RBXASSERT(root == torso) inside weld creation assumes assembly-root welding.

## UNKNOWN

- Where createSeatWeldSignal is fired from (network layer, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Seat.md](../../v8datamodel/Seat.md).
- Base machinery: [ActionStation.md](ActionStation.md), [BasicPartInstance.md](BasicPartInstance.md); vehicle variant: [VehicleSeat.md](VehicleSeat.md); platform twin: [Platform.md](Platform.md).
