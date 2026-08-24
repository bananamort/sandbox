# LoginService.cpp

## Purpose

Implements `LoginService` ("LoginService") — thin frontend login prompts: PromptLogin/Logout funcs (frontend-only, else throw) firing internal signals, plus misnamed events LoginSucceeded (bound to loginSucceededSignal, carries username) and LoginFailed (bound to loginFAILED signal, carries loginError).

## Key types and API

Descriptors:
- `func_PromptLogin("PromptLogin", **Security::Roblox**)`, `func_Logout("Logout", Security::Roblox)`.
- `event_SignupFinished("LoginSucceeded", "username", Security::Roblox)`; `event_LoginFinished("LoginFailed", "loginError", Security::Roblox)`.

Constants: `sLoginService = "LoginService"`.

Behavior: both funcs require `Network::Players::frontendProcessing` — server calls throw "should only be accessed from a local script".

## Usage / reflection touchpoints

Shell-level auth UI hooks ([Game](Game.md)-adjacent); registered in DataModel bootstrap.

## Gotchas

- Event names are swapped relative to their signals' success/failure roles (SignupFinished→succeeded, LoginFinished→failed) — a naming trap for anyone wiring these.
- All four members are Roblox-security — game scripts cannot prompt logins.
