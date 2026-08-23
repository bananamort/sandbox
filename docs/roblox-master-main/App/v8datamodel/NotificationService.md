# NotificationService.cpp

## Purpose

Implements `NotificationService` (Instance name "NotificationService") — a thin client-side gateway for scheduling OS-level (device) notifications from local scripts. Every method just validates eligibility and re-fires an internal signal (`scheduleNotificationSignal` etc.) consumed by platform code; this file contains no actual scheduling logic.

## Key types and API

Reflection functions (all Security::RobloxPlace — game scripts):
- `ScheduleNotification(userId, alertId, alertMsg, minutesToFire)`
- `CancelNotification(userId, alertId)`
- `CancelAllNotification(userId)`
- `GetScheduledNotifications(userId) [yields]` → ValueArray of scheduled notifications.

Gate: every entry point calls `canUseService()` which requires ALL of: FFlag `NotificationServiceEnabledForEveryone` (declared here, default FALSE), the device reports touch enabled via UserInputService::getTouchEnabled(), and the caller runs under frontend processing (client side). Each failure prints its own warning ("Sorry, NotificationService is currently off.", "Sorry, NotificationService only works on touch devices currently.", "NotificationService:ScheduleNotification must be called from a local script!"). GetScheduledNotifications additionally invokes the error callback with "Notification Service Not Available" when gated out.

Signals (non-reflection): scheduleNotificationSignal / cancelNotificationSignal / cancelAllNotificationSignal / getScheduledNotificationsSignal — connected elsewhere by platform backends.

## Usage / reflection touchpoints

Single REFLECTION_BEGIN/END block registers the four functions. Because all are RobloxPlace security and client-gated, typical use is a LocalScript scheduling per-user alerts. The yield function's resume/error pair follows the standard BoundYieldFuncDesc async pattern.

## Gotchas

- The enabling flag defaults to false, so by default EVERY call is rejected with "currently off" — this was a 2014-era feature flag rollout.
- Desktop/non-touch clients always fail the touch check.
- Server-side callers silently do nothing (frontend check).
- alertId is caller-chosen; no uniqueness enforcement in this file.
