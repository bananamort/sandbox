# App/include/v8datamodel/FlagStand.h

## Purpose

CTF capture hardware: `FlagStand` (a BasicPartInstance subclass) holds one [Flag](Flag.md), detects touch captures, and can re-home flags; `FlagStandService` (non-creatable service) tracks all stands, steps them, and assigns flags to random empty stands.

## Declared API

`class FlagStand : public DescribedCreatable<FlagStand, BasicPartInstance, sFlagStand>`

- Signal: `rbx::signal<void(shared_ptr<Instance>)> flagCapturedSignal;`
- Team: public field `BrickColor teamColor;` + getter/setter.
- Flag binding: `void affixFlag(Flag* flag); Flag* getJoinedFlag();` private `affixFlagToRandomEmptyStand(Flag*)`; watched/cloned flags `shared_ptr<Flag> watchingFlag; shared_ptr<Flag> clonedReplacementFlag;`
- Touch: logged scoped connection + `onEvent_standTouched(shared_ptr<Instance>)`.
- Lifecycle: ctor; `onServiceProvider(old,new)`; per-frame `void onStepped();`

`class FlagStandService : public DescribedNonCreatable<FlagStandService, Instance, sFlagStandService>, public IStepped, public Service`

- Registry: `std::list<FlagStand*> flagStands;` with `RegisterFlagStand(FlagStand*)/UnregisterFlagStand(...)`.
- Operations: `void affixFlagToRandomEmptyStand(Flag*); FlagStand* FindStandWithFlag(Flag*);` private `findRandomEmptyStandForFlag(Flag*)`.
- Overrides: `onServiceProvider` (+IStepped hookup), `onStepped(const Stepped&)`. Ctor/dtor.

## Gotchas

- Stands register by raw pointer — unregister on destroy or the service list dangles.
- The stand clones a replacement flag (`clonedReplacementFlag`) — capture flow duplicates the tool.
- teamColor matching is BrickColor-based like Flag.

## UNKNOWN

- Capture rules on touch (.cpp — see [FlagStand.md](../../v8datamodel/FlagStand.md)).

## Cross-links

- Implementation: [App/v8datamodel/FlagStand.md](../../v8datamodel/FlagStand.md).
- Pair: [Flag.md](Flag.md); base part: [BasicPartInstance.md](BasicPartInstance.md).
