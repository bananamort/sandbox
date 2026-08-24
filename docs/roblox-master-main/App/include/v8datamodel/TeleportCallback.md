# App/include/v8datamodel/TeleportCallback.h

## Purpose

`TeleportCallback` — plain abstract interface (not an Instance) the embedder implements to perform cross-place teleports: given a URL, join ticket, and script payload, execute the teleport; plus an enablement probe and an Xbox gamertag hook used by placeLauncher.ashx.

## Declared API

`class TeleportCallback`

- `virtual ~TeleportCallback() {}`
- `virtual void doTeleport(const std::string& url, const std::string& ticket, const std::string& script) = 0`
- `virtual bool isTeleportEnabled() const = 0`
- `virtual std::string xBox_getGamerTag() const { return ""; }` — in-header comment: "needed for placeLauncher.ashx when connecting from xbox client".

## Gotchas

- No certified implementation doc exists for this header (verified against App/v8datamodel/ index).
- The ticket string is a live join credential — logging it leaks auth material.
- Pure interface: whoever registers the implementation with TeleportService controls teleport capability.

## UNKNOWN

- Where the implementation instance is registered/consumed (out-of-line; presumably [TeleportService.md](TeleportService.md)).

## Cross-links

- Consumer: [TeleportService.md](TeleportService.md) (implementation: [App/v8datamodel/TeleportService.md](../../v8datamodel/TeleportService.md)).
