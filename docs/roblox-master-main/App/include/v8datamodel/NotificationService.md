# App/include/v8datamodel/NotificationService.h

## Purpose

`NotificationService` — internal, non-creatable service that relays scheduled user notifications (schedule / cancel / cancel-all / list) to the UI layer via four public `rbx::signal`s; the methods just fire the signals.

## Declared API

`class NotificationService : public DescribedNonCreatable<NotificationService, Instance, sNotificationService, Reflection::ClassDescriptor::INTERNAL>, public Service`

- Signals:
  - `rbx::signal<void(int, int, std::string, int)> scheduleNotificationSignal`
  - `rbx::signal<void(int, int)> cancelNotificationSignal`
  - `rbx::signal<void(int)> cancelAllNotificationSignal`
  - `rbx::signal<void(int, boost::function<void(shared_ptr<const Reflection::ValueArray>)>, boost::function<void(std::string)>)> getScheduledNotificationsSignal`
- Methods (fire the matching signals):
  - `void scheduleNotification(int userId, int alertId, std::string alerMsg, int minutesToFire)` — note misspelled parameter `alerMsg` in the real signature.
  - `void cancelNotification(int userId, int alertId)`
  - `void cancelAllNotification(int userId)`
  - `void getScheduledNotifications(int userId, boost::function<void(shared_ptr<const Reflection::ValueArray>)> resumeFunction, boost::function<void(std::string)> errorFunction)`
- Private: `bool canUseService()`.

## Gotchas

- INTERNAL non-creatable: obtained via service lookup, not construction.
- Async pattern is signal-based: the service itself does no HTTP; whoever connects `getScheduledNotificationsSignal` owns the fetch and must invoke the passed resume/error functions.
- No reflection-exposed properties/methods declared in this header — Lua surface (if any) lives in reflection tables elsewhere.

## UNKNOWN

- What `canUseService()` gates (body not in header).
- Who consumes these signals at runtime.

## Cross-links

- Implementation: [App/v8datamodel/NotificationService.md](../../v8datamodel/NotificationService.md).
- Sibling notification surface: [GuiService.md](GuiService.md); base machinery: [../v8tree notes via Instance](../../include/v8tree/) — see also [DataModel.md](DataModel.md) for service lookup.
