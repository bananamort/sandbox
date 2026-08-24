# App/include/v8datamodel/LoginService.h

## Purpose

`LoginService` (non-creatable service) — thin signal hub for client login/logout flows: prompts and success/failure notifications consumed by app UI.

## Declared API

`class LoginService : public DescribedNonCreatable<LoginService, Instance, sLoginService>, public Service`

- Signals: `loginSucceededSignal<void(std::string)>`, `loginFailedSignal<void(std::string)>`, `promptLoginSignal<void()>`, `promptLogoutSignal<void()>`.
- Methods: `void promptSignup(); void promptLogin(); void logout();`

## Gotchas

- The service only fires signals — actual credential handling lives in the app layer (.cpp consumers).

## UNKNOWN

- Payload meaning of the success/failure string (token? username?) (.cpp).

## Cross-links

- Implementation: [App/v8datamodel/LoginService.md](../../v8datamodel/LoginService.md).
- App kin: [Game.md](Game.md), [Visit.md] (V–Z half).
