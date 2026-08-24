# content/ — Module Index

## Module purpose

Roblox client **CoreScripts**: the Lua half of the engine's built-in UI and services, loaded by `ScriptContext:AddCoreScriptLocal` / `require(RobloxGui.Modules.X)` at join time. Subtrees: `scripts/` (entry points, CoreScripts, Modules, Libraries), `fonts/` (legacy signed loader variant). These scripts run with core-script privileges (`GuiService`, `GetFriendStatus`, `GetTopbarTransparency`, `RobloxLocked`, etc.) and are NOT ordinary game scripts.

## Completion status

**34 of 38 .lua documented.** REMAINING (large files, next resume): `scripts/Libraries/RbxStamper.lua`, `scripts/Modules/Chat.lua`, `scripts/Modules/DeveloperConsoleModule.lua`, `scripts/Libraries/RbxGui.lua`.

## File roster

### scripts/ root (3)

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| StarterScript.lua | 69 | [StarterScript.lua.md](scripts/StarterScript.lua.md) | Client bootstrap: FFlag-gated AddCoreScriptLocal/spawn-require of every UI core script in load order. |
| ServerStarterScript.lua | 56 | [ServerStarterScript.lua.md](scripts/ServerStarterScript.lua.md) | Server bootstrap: waits IsRunning, wires followers path or legacy NewFollower remote + SetDialogInUse relay. |
| LoadingScript.lua | 775 | [LoadingScript.lua.md](scripts/LoadingScript.lua.md) | Generic loading screen: tiled bg, spinner/dots, place info, error banner, ReplicatedFirst teardown handshake. |

### fonts/ (1)

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| LoadingScript.lua | 814* | [fonts/LoadingScript.lua.md](fonts/LoadingScript.lua.md) | SIGNED (`--rbxsig%`) older loader w/ thumbnail showcase + block animation; capital-G `Game` globals; *double-spaced file. |

### scripts/CoreScripts/ (11)

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| Topbar.lua | 1263 | [Topbar.lua.md](CoreScripts/Topbar.lua.md) | New top bar: settings/chat/backpack icons, username+health (Shepard-interpolated), leaderstats columns, SetCore TopbarEnabled. |
| NotificationScript2.lua | 629 | [NotificationScript2.lua.md](CoreScripts/NotificationScript2.lua.md) | Toast queue (max 3+overflow): badges, points, friend requests, followers, quality change, SendNotification SetCore, gamepad browse. |
| PurchasePromptScript2.lua | 1506 | [PurchasePromptScript2.lua.md](CoreScripts/PurchasePromptScript2.lua.md) | Purchase dialog state machine: validation ladder, Buy/Free/BuyR$/BC-upsell, native store products, dev-product receipts. |
| HealthScript.lua | 316 | [HealthScript.lua.md](CoreScripts/HealthScript.lua.md) | Legacy health bar fallback w/ capped fill colors + hurt overlay flash (pre-Topbar HUD generation). |
| VehicleHud.lua | 160 | [VehicleHud.lua.md](CoreScripts/VehicleHud.lua.md) | VehicleSeat speed bar + numeric readout, HeadsUpDisplay gating, CameraSubject fallback. |
| BubbleChat.lua | 656 | [BubbleChat.lua.md](CoreScripts/BubbleChat.lua.md) | Per-character billboard chat bubbles: LOD near/far/"...", filter-probe via TextLabel, blocked/muted suppression. |
| MainBotChatScript2.lua | 728 | [MainBotChatScript2.lua.md](CoreScripts/MainBotChatScript2.lua.md) | Dialog NPC conversations: prompt billboards, choice UI, timeout killswitch (coroutine or cloned scripts), InUse locking. |
| GamepadMenu.lua | 652 | [GamepadMenu.lua.md](CoreScripts/GamepadMenu.lua.md) | Start-button radial quick menu: thumbstick-angle wedge selection, A/B confirm/cancel, CoreGui enablement greying. |
| ContextActionTouch.lua | 268 | [ContextActionTouch.lua.md](CoreScripts/ContextActionTouch.lua.md) | On-screen buttons for CAS-bound touch actions (7 fixed slots), Begin/Change/End forwarding via CallFunction. |
| DeveloperConsole.lua | 1433 | [DeveloperConsole.lua.md](CoreScripts/DeveloperConsole.lua.md) | F9 toggle shim → new module OR full legacy console: log tabs+filters, stats charts, creator-only command bar. |
| BuildToolsScripts/BuildToolsScript.lua | 214 | [BuildToolsScripts/BuildToolsScript.lua.md](CoreScripts/BuildToolsScripts/BuildToolsScript.lua.md) | Client PBS tool loader: InsertService fetch by BaseUrl-dependent ids, loadout clear/restore, one-time tutorial. |
| BuildToolsScripts/BuildToolManager.lua | 174 | [BuildToolsScripts/BuildToolManager.lua.md](CoreScripts/BuildToolsScripts/BuildToolManager.lua.md) | PBS shared-tool containers in ReplicatedStorage + HasBuildTools/rank-driven give/remove, rank≤0 kick. |
| BuildToolsScripts/PersonalServerScript.lua | 206 | [CoreScripts/BuildToolsScripts/PersonalServerScript.lua.md](CoreScripts/BuildToolsScripts/PersonalServerScript.lua.md) | PBS autosave (edit-count + interval + cooldown) and rank persistence via roleset API; sets IsPersonalServer. |

### scripts/CoreScripts/ServerCoreScripts/ (1)

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| ServerSocialScript.lua | 216 | [ServerCoreScripts/ServerSocialScript.lua.md](ServerCoreScripts/ServerSocialScript.lua.md) | Server follow-graph service: multi-follow API sync on join, delta pushes, GetFollowRelationships RemoteFunction. |

### scripts/Modules/ (7 of 10)

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| BackpackScript.lua | 1543 | [Modules/BackpackScript.lua.md](Modules/BackpackScript.lua.md) | Hotbar(10/3)+inventory grid: drag-swap slots, search, HopperBin support, gamepad LB/RB cycle + swap mode. |
| PlayerlistModule.lua | 1753 | [Modules/PlayerlistModule.lua.md](Modules/PlayerlistModule.lua.md) | Leaderboard: leaderstats columns, team score aggregation, social icons, dropdown popup, Tab toggle, top-bar stat feed. |
| PlayerDropDown.lua | 632 | [Modules/PlayerDropDown.lua.md](Modules/PlayerDropDown.lua.md) | Per-player context menu: friend lifecycle, follow/unfollow, block/mute utility, report, PBS rank buttons. |
| TenFootInterface.lua | 344 | [Modules/TenFootInterface.lua.md](Modules/TenFootInterface.lua.md) | Console (10-foot) mode flag + big health bar factory + single-leaderstat top display stack. |
| Settings/SettingsPageFactory.lua | 275 | [Modules/Settings/SettingsPageFactory.lua.md](Modules/Settings/SettingsPageFactory.lua.md) | Base settings page class: TabHeader/Page GUI, Displayed/Hidden events, slide animations, row registry. |
| Settings/Utility.lua | 2023 | [Modules/Settings/Utility.lua.md](Modules/Settings/Utility.lua.md) | Settings toolkit: styled buttons, Slider/Selector/DropDown classes, row builders, alerts, tweens, input handling. |
| Settings/SettingsHub.lua | 1110 | [Modules/Settings/SettingsHub.lua.md](Modules/Settings/SettingsHub.lua.md) | Escape-menu shell: shield+tab bar+page view, bottom hotkey bar, menu stack, Esc/F9 bindings, ReportPlayer deep link. |
| Chat.lua | 2654 | REMAINING | Legacy chat window module (window/channels/history). |
| DeveloperConsoleModule.lua | 2978 | REMAINING | New developer console implementation (tabs/stats/command bar) consumed via DeveloperConsole.lua shim. |
| Settings/Pages/* (8 pages) | see below | all done | Home, LeaveGame, ResetCharacter, Record, Help, GameSettings, Players, ReportAbuseMenu. |

### scripts/Modules/Settings/Pages/ (8 of 8)

| File | Lines | Doc |
|---|---|---|
| Home.lua | 82 | [Home.lua.md](Modules/Settings/Pages/Home.lua.md) — Resume/Reset/Leave buttons page. |
| LeaveGame.lua | 123 | [LeaveGame.lua.md](Modules/Settings/Pages/LeaveGame.lua.md) — Confirm dialog; Exit verb; B-cancel bind. |
| ResetCharacter.lua | 138 | [ResetCharacter.lua.md](Modules/Settings/Pages/ResetCharacter.lua.md) — Humanoid.Health=0 confirm flow. |
| Record.lua | 169 | [Record.lua.md](Modules/Settings/Pages/Record.lua.md) — Screenshot/video verbs + YouTube-vs-disk selector. |
| Help.lua | 488 | [Help.lua.md](Modules/Settings/Pages/Help.lua.md) — Input-type-switching control cheatsheets (PC table/gamepad diagram/touch gestures). |
| GameSettings.lua | 598 | [GameSettings.lua.md](Modules/Settings/Pages/GameSettings.lua.md) — Graphics slider/modes, camera+movement selectors, volume, mouse curve, overscan. |
| Players.lua | 307 | [Players.lua.md](Modules/Settings/Pages/Players.lua.md) — Sorted roster w/ friend buttons (has `table.remove(..., i)` typo bug). |
| ReportAbuseMenu.lua | 284 | [ReportAbuseMenu.lua.md](Modules/Settings/Pages/ReportAbuseMenu.lua.md) — Abuse report form (has self-indexing GetPlayerFromIndex bug). |

### scripts/Libraries/ (1 of 3)

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| RbxUtility.lua | 1117 | [Libraries/RbxUtility.lua.md](Libraries/RbxUtility.lua.md) | LoadLibrary impl: JSON encoder/decoder, terrain helpers, Signal class, Create{} builder, Help(). |
| RbxGui.lua | 4266 | REMAINING | Giant GUI library (CreateTutorial, style sheets, scrolling frames) used by BuildToolsScript etc. |
| RbxStamper.lua | 2207 | REMAINING | PBS stamping/placement tool library. |

## Cross-references

- Entry chain: engine → StarterScript/ServerStarterScript → (AddCoreScriptLocal paths relative to content/scripts/) → modules under RobloxGui.Modules.
- Shared infra: TenFootInterface sizing flags consulted by ~every UI; Settings.Utility MakeStyledButton/Create used across settings + backpack hints + notifications alert; PlayerDropDown blockingUtility shared by Chat/BubbleChat/Playerlist.
- Known cross-file bugs worth tracking: undefined `TWEEN_TIME` global in PlayerDropDown Hide(); `lastInputTypee` typo in Settings Utility MakeButton; ReportAbuse player-report no-op; Players.lua shrink-path crash.
