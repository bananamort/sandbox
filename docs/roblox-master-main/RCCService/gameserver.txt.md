# gameserver.txt

Source: `roblox-sandbox/RCCService/gameserver.txt` (110 lines)

## Purpose

Lua bootstrap script for the **console test-server mode** of RCCService. When the service is started with `-Console -PlaceId:<id>`, `_tmain` reads this file (RCCService.cpp:717), appends `start(<placeId>, 53640, '<baseURL>')`, and submits the combined source as a local `OpenJob` with job id `"Test"` and a 600 s lease — standing up a full game server without the web tier.

## API

Defines exactly one global function:

```lua
function start(placeId, port, url)
```

Execution flow inside `start`:

1. Helper `waitForChild(parent, childName)` (busy-yield loop over `ChildAdded:wait()`).
2. Network/TaskScheduler settings via pcall'd `settings()` writes: instance+physics packet caches on; priority method `AccumulatedError`; physics send `TopNErrors`; `ExperimentalPhysicsEnabled=true`; `WaitingForCharacterLogRate=100`; optional legacy script mode.
3. `scriptContext:AddStarterScript(37801172)` (pcall — asset may not exist); `ScriptsDisabled = true` during setup.
4. `game:SetPlaceID(assetId, false)`; ChangeHistoryService disabled.
5. Establishes peer as server: `NetworkServer` service; when `url ~= nil`, wires AbuseReport / ScriptInformationProvider asset URL / ContentProvider base URL / ChatFilter URLs, BadgeService place id, InsertService base/user/collection/asset/version URL templates (`<url>/Asset/?id=%d` etc.), and pcalls `loadfile(url .. "/Game/LooadPlaceInfo...")` — actually `/Game/LoadPlaceInfo.ashx?PlaceId=`.
6. `settings().Diagnostics.LuaRamLimit = 0` (unlimited).
7. PlayerAdded/PlayerRemoving print hooks.
8. If both placeId and url present: `wait()` once ("yield so that file load happens in the heartbeat thread"), then `game:Load(url .. "/asset/?id=" .. placeId)`.
9. `ns:Start(port)` — begins accepting player connections on the supplied port (53640 from `_tmain`).
10. `scriptContext:SetTimeout(10)`; `ScriptsDisabled = false`.
11. `game:GetService("RunService"):Run()`.

## Usage

Deployed next to RCCService.exe for developer console runs:

```
RCCService.exe -Console -PlaceId:1818
```

## Gotchas

- The file is *prefixed* to the generated call line — trailing content in the buffer is `start(...)`, so the function must stay named exactly `start`.
- Hardcoded starter-script asset id `37801172`; port constant 53640 comes from `_tmain`, not this file.
- Because of the `parsePlaceId` pointer-comparison quirk (RCCService.cpp:288), even an absent `-PlaceId:` yields id 0 → `start(0, ...)` still runs against this file.
- `LoadPlaceInfo` fetch failure is swallowed by pcall; badge-legality URL intentionally set empty.
- Script assumes server-only environment (`NetworkServer`, no client UI).
