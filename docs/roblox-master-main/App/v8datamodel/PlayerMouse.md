# PlayerMouse.cpp

## Purpose

Implements `PlayerMouse` ("PlayerMouse"), the DescribedNonCreatable Mouse subclass instantiated for actual players (vs. Studio's PluginMouse). The TU is intentionally near-empty: per its own comment, "only differences between Mouse and PlayerMouse lie in Mouse.Icon behavior" — and even those get/set implementations just forward to the Super (Mouse) implementation here.

## Key types and API

- Ctor: `DescribedNonCreatable<PlayerMouse, Mouse, sPlayerMouse>` — scriptable type descriptor but never creatable from Lua.
- `getIcon()` / `setIcon(TextureId)` — straight pass-through to Mouse's implementation in this TU.
- All real behavior (raycasting via MouseCommand, Target/Hit properties, Button1Down-style events, icon state machine) is inherited from Mouse.cpp — see Mouse.md.

## Usage / reflection touchpoints

Inherits Mouse's full Lua surface. Created engine-side for each player input context; pairs with Mouse.md, MouseCommand.md, PlayerScripts.md in this folder.

## Gotchas

- The Icon "difference" is vestigial in this file — any actual divergence must live header-side or was removed; UNKNOWN what historically differed.
- Being NonCreatable, scripts obtain it only via traversal (e.g., LocalScript Mouse), never by Instance.new.
