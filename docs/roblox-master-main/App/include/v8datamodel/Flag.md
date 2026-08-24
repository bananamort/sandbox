# App/include/v8datamodel/Flag.h

## Purpose

`Flag` Instance — CTF flag implemented as a [Tool](Tool.md) subclass: cannot be unequipped, refuses pickup by same-team players (teamColor BrickColor), watches touches to detect capture, and can report the FlagStand it belongs to.

## Declared API

`class Flag : public DescribedCreatable<Flag, Tool, sFlag>`

- `BrickColor teamColor;` + `BrickColor getTeamColor() const; void setTeamColor(BrickColor color);`
- `FlagStand* getJoinedStand();`
- Overrides: `virtual bool canUnequip() { return false; } // The flag cannot be unequipped`; `virtual bool canBePickedUpByPlayer(Network::Player* p);` — "cannot be picked up by a member of the same team as the flag".
- Touch handling: logged scoped connection `flagTouched` + handler `onEvent_flagTouched(shared_ptr<Instance> other)`.
- `void onServiceProvider(ServiceProvider* oldProvider, ServiceProvider* newProvider);` ctor/dtor.

## Gotchas

- Inheritance from Tool means all equip/handle machinery applies; unequipping is blocked only by this override.
- Team identity flows through a plain BrickColor comparison — not a Teams-service link.

## UNKNOWN

- Capture/return flow on touch (.cpp — see [Flag.md](../../v8datamodel/Flag.md)).

## Cross-links

- Implementation: [App/v8datamodel/Flag.md](../../v8datamodel/Flag.md).
- Pair: [FlagStand.md](FlagStand.md); base [Tool.md](Tool.md).
