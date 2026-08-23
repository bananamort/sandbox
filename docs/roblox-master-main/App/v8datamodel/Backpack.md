# App/v8datamodel/Backpack.cpp

## Purpose

Implements `Backpack` ("Backpack") — the per-player container for tools and gear. Its entire content in this TU is the `IScriptFilter` implementation that decides which scripts run when parented inside a Backpack.

## API

- `const char* const sBackpack = "Backpack"` (source comment: "rename class ultimately").
- `Backpack::Backpack()` — sets name only; no reflection descriptors.
- `bool Backpack::scriptShouldRun(BaseScript* script)` — the run policy (documented rule table in source):
  1. A **LocalScript** runs only if this is the *local* player's backpack (`getParent() == Network::Players::findLocalPlayer`); on match it also calls `script->setLocalPlayer(shared_from(localPlayer))`.
  2. A **BaseScript/Script** (non-local) runs if the context is backend processing (server).
  3. Everything else returns false.

## Usage

Backpack implements `IScriptFilter`; BaseScript's workspace negotiation (`computeNewWorkspace` → `ServiceProvider::create<RuntimeScriptService>(this)`) consults it, so dropping a Tool with Scripts into a player's Backpack starts/stops them per these rules as the Backpack moves between Player and Workspace.

## Gotchas

- Scripts inside a HopperBin within a local backpack are covered by the same filter through ancestry (see comment table: "In HopperBin if local backpack").
- LocalScripts in a *server-side* backpack (not the local player's) never run.
- Requires a Workspace service to be present, otherwise returns false.
