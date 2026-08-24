# GamePassService.cpp

## Purpose

Implements `GamePassService` ("GamePassService") — the legacy per-server game-pass check: `PlayerHasPass(player, gamePassId)` GETs a configurable URL template via LuaWebService and resolves bool. Server-only at runtime (clients get warning + false).

## Key types and API

Descriptors:
- `func_SetPlayerHasPassUrl("SetPlayerHasPassUrl", "playerHasPassUrl", Security::LocalUser)` — stores printf template (playerId, gamePassId).
- `func_PlayerHasPass("PlayerHasPass", "player","gamePassId", Security::None)` — BoundYieldFunc bool.

Constants: `sGamePassService = "GamePassService"`.

Behavior:
- Empty URL → error "No playerHasPassUrl set"; non-Player arg → "Not a valid Player".
- Client call: prints localized STRING_BY_ID(HasGamePassLuaWarning) then resumes FALSE ("only warn them in this case; don't kill their script").
- `dispatchRequest<ResultType>` routes through LuaWebService::asyncRequest with STANDARD_PRIORITY; dispatch exception → "Error during dispatch"; missing service → "Shutting down".

## Usage / reflection touchpoints

Web-query pattern shared with [BadgeService](BadgeService.md)/[AssetService](AssetService.md); superseded by MarketplaceService UserOwnsGamePassAsync ([MarketplaceService](MarketplaceService.md)).

## Gotchas

- Client-side calls silently resolve false — scripts relying on truthiness can't distinguish "no pass" from "wrong context".
- URL must be injected by LocalUser shell; unset service is permanently erroring.
