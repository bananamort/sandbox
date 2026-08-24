# Backpack.cpp

## Purpose

Implements `Backpack` ("Backpack") — the per-player carried-items container. The TU is one policy function deciding whether a script inside the backpack should run, encoding the classic BaseScript/LocalScript × local/backend execution matrix (source comment spells it out verbatim).

## Key types and API

Descriptors: none. Constant: `sBackpack = "Backpack"` (with source note "rename class ultimately").

Behavior:
- ctor — name shell only.
- `scriptShouldRun(BaseScript*)` — asserts script is a descendant; finds local player; `isLocalBackpack = parent == localPlayer`:
  1. Local backpack + LocalScript → `setLocalPlayer(localPlayer)`, run.
  2. NOT LocalScript AND backendProcessing → run (BaseScripts in server-side backpacks).
  3. Otherwise false.

## Usage / reflection touchpoints

Container semantics pair with [Hopper](Hopper.md) (the legacy tool-bin it once held), [Tool](Tool.md), and [PlayerGui](PlayerGui.md)-style per-player containers; execution gating mirrors [App/script](../../script/) contexts.

## Gotchas

- A BaseScript in a LOCAL player's backpack does NOT run locally unless it's a LocalScript — rule 2 requires backendProcessing, which is false on the client.
- setLocalPlayer is only called for the LocalScript-in-local-backpack path; server-run scripts never get it here.
- No descriptors/security tiers at all — everything is inherited behavior.
