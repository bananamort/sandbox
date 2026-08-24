# PersonalServerScript.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/BuildToolsScripts/PersonalServerScript.lua` (206 lines)

## Purpose

PBS (Personal Build Server) autosave + rank persistence: counts workspace edits and calls `game:ServerSave()` on thresholds/interval with cooldowns; syncs each player's PersonalServerRank from the roleset API on join and writes it back on leave.

## API / Behavior

- Constants: CHANGES_PER_PLAYER=100, SAVE_CHECK_INTERVAL=1800 s, MIN_SAVE_TIME=900 s.
- URL derivation: BaseUrl matched by Lua pattern `^http://www\.(.-)/?$` → UrlBase (e.g. gametest1.robloxlabs.com); ApiProxyUrl = https://api.<base>; DataFarmUrl = http|https://data.<base> (FFlag `DataFarmUsesHttps`, pcall-guarded). NOTE pattern only matches http:// URLs — https base yields nil → ApiProxyUrl becomes 'https://api.nil'.
- `GetRbxUtil()` lazy LoadLibrary("RbxUtility").
- `IsArchivable(instance)` recursive up to workspace (workspace itself treated archivable).
- Player lifecycle:
  - Join: GET `/RoleSets/GetRoleSetForUser?placeId&userId` via HttpGetAsync+DecodeJSON (pcall), sets `player.PersonalServerRank` from table data.Rank, records StartingPlayerRanks.
  - Leave: if rank CHANGED, POST `/RoleSets/PrivilegedSetUserRoleSetRank?...&newRank=N` with body 'SetPersonalServerRank' (ypcall).
- Save machinery:
  - `OnEdit(descendant)` — fires for BOTH DescendantAdded AND DescendantRemoving of Workspace; counts archivable changes; TrySave at threshold (#players×100).
  - `TrySave` enforces MIN_SAVE_TIME; else schedules delayed DoSave at cooldown expiry.
  - `DoSave` → `game:ServerSave()` guarded by GameRunning.
  - Interval loop every 1800 s saves if ≥1 change since last save.
- Setup tail: sets `game.IsPersonalServer = true` (pcall), creates non-Archivable BoolValue "PSVariable" in workspace, SetServerSaveUrl(<saveUrlBase>/Data/AutoSave.ashx?assetId=<PlaceId>) (FFlag UseNewSubdomainsInCoreScripts picks data farm), game.Close → final ServerSave, `RunService:Run()`.

## Usage

Server CoreScript under PBS games; pairs with BuildToolManager (rank consumer) and BuildToolsScript.

## Gotchas
- OnEdit double-counts structural edits (add+remove both count).
- Rank write-back happens ONLY on ChildRemoved — crash loses rank changes.
- The http-only URL regex breaks https BaseUrls (nil-concat bug latent).
- `RunService:Run()` in a script is a legacy server-loop idiom.
- Threshold scales with player COUNT but never shrinks below one player's worth.
