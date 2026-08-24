# App/include/v8datamodel/TimerService.h

## Purpose

`TimerService` — PERSISTENT_HIDDEN creatable service + HeartbeatInstance scheduling one-shot callbacks in GAME time: `delay(func, seconds)` queues into a time-sorted list drained on heartbeat. Header carries two TODOs (repeat signal; thread-aware scheduler).

## Declared API

`class TimerService : public DescribedCreatable<TimerService, Instance, sTimerService, Reflection::ClassDescriptor::PERSISTENT_HIDDEN>, public Service, public HeartbeatInstance`

- Nested `class Item { public: Time time; boost::function0<void> func; };`
- Storage: `std::list<Item> items` — "func list sorted in ascending time order".
- Public: ctor; `void delay(boost::function0<void> func, double seconds)` — "Request that func be called once after specified time has elapsed".
- Overrides: inline `onServiceProvider` chaining Super + `onServiceProviderHeartbeatInstance`; `onHeartbeat(const Heartbeat&)`.

## Gotchas

- Single-threaded game-time semantics: callbacks fire during heartbeat only — not real-time.
- std::list kept manually sorted; delay() presumably inserts in order — O(n) per insert.
- In-header TODOs confirm the design is intentionally minimal.

## UNKNOWN

- Whether delayed callbacks survive DataModel close (drained or dropped at shutdown).

## Cross-links

- Implementation: [App/v8datamodel/TimerService.md](../../v8datamodel/TimerService.md).
- Sibling schedulers: [DebrisService.md](DebrisService.md), [DataModelJob.md](DataModelJob.md), [SleepingJob.md](SleepingJob.md).
