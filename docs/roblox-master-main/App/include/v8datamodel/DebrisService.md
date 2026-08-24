# App/include/v8datamodel/DebrisService.h

## Purpose

`Debris` service (non-creatable; descriptor sDebrisService) — delayed destruction queue: `AddItem(instance, lifetime)` schedules an Instance for cleanup after a delay, with an item cap and legacy-cap toggle.

## Declared API

`class DebrisService : public DescribedNonCreatable<DebrisService, Instance, sDebrisService>, public Service`

- `void addItem(shared_ptr<Instance> item, double lifetime);`
- Cap: `void setMaxItems(int value); int getMaxItems() const { return maxItems; }` plus `void setLegacyMaxItems(bool);`
- State: `std::queue<weak_ptr<Instance>> queue; int maxItems; bool legacyMaxItems; shared_ptr<TimerService> timer;`
- Overrides: protected `onServiceProvider(old,new)`; private `cleanup();`

## Gotchas

- Queue holds weak_ptrs — instances destroyed by other means silently drop out.
- Two cap modes (modern maxItems vs legacyMaxItems) — semantics differ (.cpp).
- Cleanup timing rides TimerService.

## UNKNOWN

- Default lifetime/cap values (.cpp — see [DebrisService.md](../../v8datamodel/DebrisService.md)).

## Cross-links

- Implementation: [App/v8datamodel/DebrisService.md](../../v8datamodel/DebrisService.md).
- Partner: [TimerService.md](TimerService.md) (T–Z half).
