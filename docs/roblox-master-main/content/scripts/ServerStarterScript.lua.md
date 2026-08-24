# ServerStarterScript.lua

Source: `roblox-sandbox/content/scripts/ServerStarterScript.lua` (56 lines)

## Purpose

Server-side core script bootstrap: waits for a running engine (not Studio edit mode), wires the server half of social features (followers) and creates/relays the `SetDialogInUse` RemoteEvent for Dialog objects.

## API / Behavior

- Spin-wait loop: `wait(0.1)` until `game:GetService('RunService'):IsRunning()`.
- Services used: `RobloxReplicatedStorage`, `ScriptContext` (+RunService).
- FastFlag via pcall: `settings():GetFFlag("UserServerFollowers")` → `IsServerFollowers`.
- If followers enabled: `ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerSocialScript", script.Parent)`; else it CREATES `RemoteEvent "NewFollower"` in RobloxReplicatedStorage itself (legacy path).
- Always creates RemoteEvent `"SetDialogInUse"` in RobloxReplicatedStorage.
- Handlers:
  - `onNewFollower(followerRbxPlayer, followedRbxPlayer)` → re-Fires `NewFollower` to the FOLLOWED client so they see "X followed you".
  - `setDialogInUse(player, dialog, value)` → sets `dialog.InUse = value` (guards nil dialog).

## Usage

Loaded by the engine's server CoreScript mechanism (content/scripts is the CoreScript root). Client counterpart logic lives in ServerSocialScript + notification scripts.

## Gotchas
- `NewFollower` RemoteEvent only exists when the flag path does NOT load ServerSocialScript — dual-ownership of that channel.
- Busy-wait loop polls every 100 ms before doing anything.
- No sanitization of `dialog` argument type — any Instance with an InUse property can be targeted.
