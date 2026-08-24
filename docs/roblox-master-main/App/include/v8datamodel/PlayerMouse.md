# App/include/v8datamodel/PlayerMouse.h

## Purpose

`PlayerMouse` — thin non-creatable `Mouse` subclass that adds the player-facing Icon (TextureId) property on top of the shared Mouse machinery. This is the class behind `Player:GetMouse()`'s icon behavior.

## Declared API

`class PlayerMouse : public DescribedNonCreatable<PlayerMouse, Mouse, sPlayerMouse>`

- `PlayerMouse(); ~PlayerMouse();`
- `TextureId getIcon() const; void setIcon(const TextureId& value);` — out-of-line; presumably forwards to the icon prop defined on Mouse.

## Gotchas

- Everything else (position, target filtering, hit signals) is inherited from [Mouse.md](Mouse.md) — nothing new declared here.
- Non-creatable: constructed by the player/player-gui plumbing, not by user code.

## UNKNOWN

- Whether setIcon validates content URLs (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PlayerMouse.md](../../v8datamodel/PlayerMouse.md).
- Base: [Mouse.md](Mouse.md); siblings: [PluginMouse.md](PluginMouse.md), [Workspace.md](Workspace.md).
