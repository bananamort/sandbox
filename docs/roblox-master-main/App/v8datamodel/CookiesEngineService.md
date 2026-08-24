# CookiesEngineService.cpp

## Purpose

Implements `CookiesService` ("CookiesService") — engine-side persistent cookie jar access over the platform CookiesEngine file: Set/Get/Delete string values by key. Every operation opens a fresh CookiesEngine on the cookies file path captured at construction.

## Key types and API

Descriptors (all **Security::Roblox** — Roblox-internal scripts only):
- `setValue("SetCookieValue", "key", "value")` — void.
- `getValue("GetCookieValue", "key")` — returns string; empty string unless result==0 && valid.
- `deleteValue("DeleteCookieValue", "key")` — void.

Constants: `sCookiesService = "CookiesService"`. Platform sleep helper (Sleep/usleep) present but unused.

Behavior:
- ctor caches `path = convert_w2s(CookiesEngine::getCookiesFilePath())`.
- SetValue/DeleteValue construct `CookiesEngine(convert_s2w(path))` and delegate.
- GetValue delegates, returning value only on success flag pair.

## Usage / reflection touchpoints

Roblox-security utility alongside other Security::Roblox services ([AdService](AdService.md)); the actual storage format lives in the platform CookiesEngine ([Base](../../Base/)-adjacent).

## Gotchas

- New CookiesEngine PER CALL — no caching or locking visible here; concurrent calls race at the file layer (UNKNOWN whether CookiesEngine serializes internally).
- GetCookieValue cannot distinguish "key absent" from "empty value stored".
- The unused sleep() suggests removed retry logic.
