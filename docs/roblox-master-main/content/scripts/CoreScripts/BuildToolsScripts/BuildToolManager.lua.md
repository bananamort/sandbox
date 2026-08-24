# BuildToolManager.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/BuildToolsScripts/BuildToolManager.lua` (174 lines)

## Purpose

"Responsible for giving out tools in personal servers": lazily materializes the PBS build-tool set by InsertService-loading asset IDs into shared ReplicatedStorage models (`BuildToolsModel`, `OwnerToolsModel`), then clones tools into the local Backpack based on `HasBuildTools` / `PersonalServerRank`.

## API / Behavior

- Globals (not local!): `getIds(idTable, assetTable)` — InsertService:LoadAsset each id, harvest Tool children; `storeInContainer(modelName, assetTable)` — non-Archivable Model race-guard insert; `giveBuildTools/giveOwnerTools/removeBuildTools`.
- Asset ID sets are BASE-URL dependent:
  - www.roblox.com or gametest1 → 73089166 PartSelection, 73089190 Delete, 73089204 Clone, 73089214 Rotate, 73089229 RecentPart, 73089239 Config, 73089259 Wiring.
  - gametest2 → 70353315..70353320 equivalents.
  - ALWAYS +58921588 ClassicTool; owner gets 65347268 OwnerCameraTool.
- Rank logic: `PersonalServerRank >= 255` grants OwnerCameraTool; `<= 0` on rank change → `player:Kick()` + `Game:SetMessage("You're banned from this PBS")`.
- player.Changed handler with a 0.5s-poll debounce loop gates HasBuildTools give/remove; CharacterAdded resets hasBuildTools and re-grants.

## Usage

Part of CoreScripts/BuildToolsScripts trio (with BuildToolsScript + PersonalServerScript); runs on PBS servers.

## Gotchas
- Uses capital-G `Game:` calls (lines 27, 161) — legacy alias, breaks under strict Luau globals.
- `waitForProperty` uses instance.Changed:wait() — deprecated Changed-with-name semantics; hangs if property never appears.
- Debounce loop can interleave badly (multiple waiters all proceed after debounce clears).
- Kick path also calls Game:SetMessage — engine-version specific API pair.
