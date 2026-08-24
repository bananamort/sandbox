# App/include/v8datamodel/GamePassService.h

## Purpose

`GamePassService` (non-creatable service) — single-purpose web client answering "does this player own this game pass?" with a configurable endpoint URL.

## Declared API

`class GamePassService : public DescribedNonCreatable<GamePassService, Instance, sGamePassService>, public Service`

- `void setPlayerHasPassUrl(std::string);`
- `void playerHasPass(shared_ptr<Instance> playerInstance, int gamePassId, function<void(bool)> resumeFunction, function<void(std::string)> errorFunction);`
- Private: template `dispatchRequest<ResultType>(url, resume, error)`; member `playerHasPassUrl`.

## Gotchas

- Endpoint is runtime-injected — no default URL in the header.
- Boolean answer via async callback; errors surface as strings.

## UNKNOWN

- Response parsing rules (.cpp — see [GamePassService.md](../../v8datamodel/GamePassService.md)).

## Cross-links

- Implementation: [App/v8datamodel/GamePassService.md](../../v8datamodel/GamePassService.md).
- Commerce kin: [MarketplaceService.md](MarketplaceService.md), [BadgeService.md](BadgeService.md).
