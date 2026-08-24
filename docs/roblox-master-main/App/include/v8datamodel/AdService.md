# App/include/v8datamodel/AdService.h

## Purpose

`AdService` Instance (registered INTERNAL, i.e. not creatable from scripts) that orchestrates video-ad playback: client asks the server to verify ad eligibility, server relays a show/deny message, client plays and reports impression/closure via remote signals.

## Declared API

`class AdService : public DescribedCreatable<AdService, Instance, sAdService, Reflection::ClassDescriptor::INTERNAL>, public Service`

- State: `bool showingVideoAd;`
- Local signals: `rbx::signal<void(bool)> videoAdClosedSignal;` `rbx::signal<void()> playVideoAdSignal;`
- Remote signals:
  - `rbx::remote_signal<void(int, UserInputService::Platform)> sendServerVideoAdVerification;`
  - `rbx::remote_signal<void(bool, int, std::string)> sendClientVideoAdVerificationResults;`
  - `rbx::remote_signal<void(int, UserInputService::Platform, bool)> sendServerRecordImpression;`
- Methods: `void showVideoAd()`; `void videoAdClosed(bool didPlay)`; `void sendAdImpression(int userId, UserInputService::Platform platform, bool didPlay)`; `void checkCanPlayVideoAd(int userId, UserInputService::Platform userPlatform)`; `void receivedServerShowAdMessage(bool success, int userId, const std::string& errorMessage)`.
- Verification response handlers: `verifyCanPlayVideoAdReceivedResponseNoDMLock(const std::string&, int)`, `verifyCanPlayVideoAdReceivedErrorNoDMLock(...)`, `verifyCanPlayVideoAdReceivedError(const std::string&, int)`.
- Private helpers: `std::string platformToWebString(const UserInputService::Platform)`; `bool canUseService()`.
- Override: `onServiceProvider(ServiceProvider* oldProvider, ServiceProvider* newProvider)`.

## Gotchas

- The two `...NoDMLock` handlers exist alongside a locked variant — naming implies DataModel-lock discipline matters on these entry points; misuse risks lock-order bugs.
- Platform typing comes straight from `UserInputService::Platform`, coupling ad reporting to input-service enums.
- Class is INTERNAL: Lua cannot create or (typically) script it; all flow is engine-driven over the remote signals above.

## UNKNOWN

- Wire format of verification responses / impression endpoint (implemented in .cpp — see [AdService.md](../../v8datamodel/AdService.md)).
- Who fires `playVideoAdSignal` vs who consumes it.

## Cross-links

- Implementation: [App/v8datamodel/AdService.md](../../v8datamodel/AdService.md).
- Siblings: [UserInputService.md](UserInputService.md).
