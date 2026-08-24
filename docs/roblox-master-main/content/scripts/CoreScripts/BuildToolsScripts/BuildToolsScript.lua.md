# BuildToolsScript.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/BuildToolsScripts/BuildToolsScript.lua` (214 lines)

## Purpose

Client-side build-mode loader: "responsible for loading in all build tools for build mode" — InsertService-loads the seven PBS tools straight into the local Backpack (unlike BuildToolManager's shared-container model), strips old loadout first, shows a one-time tutorial.

## API / Behavior

- GLOBAL tool-id variables set by BaseUrl sniffing (same id families as BuildToolManager: 730891xx prod/gametest1, 703533xx gametest2, classic 58921588 both).
- Local helpers: `waitForProperty` (Changed:wait), `waitForChild` (ChildAdded:wait).
- Guest guard: `LocalPlayer.userId < 1` → script:Destroy() + return.
- Globals: `getLatestPlayer` (re-resolve player+Backpack), `waitForCharacterLoad` (pcall AppearanceDidLoad poll via Changed:wait; property missing → returns false and SKIPS wait), `showBuildToolsTutorial` (UserSettings tutorial state "BuildToolsTutorial"; RbxGui.CreateTutorial/CreateImageTutorialPage/AddTutorialPage with asset image 59162193; GuiService AddCenterDialog UnsolicitedDialog), `clearLoadout` (stash ALL Backpack+Character Tool/HopperBin aside), `giveToolsBack`, `backpackHasTool` (identity compare), `getToolAssetID` (LoadAsset → first Tool child), `removeBuildToolTag` (destroys legacy RobloxBuildTool child), `giveAssetId/loadBuildTools` (order: PartSelection, Delete, Clone, Rotate, Wiring, Config, then deprecated classic), `givePlayerBuildTools/takePlayerBuildTools`.
- Main flow: getLatestPlayer → waitForCharacterLoad → givePlayerBuildTools; CharacterAdded re-grants; tutorial shown LAST, once ever.

## Usage

Runs on the client in PBS/build sessions alongside PersonalServerScript (server) + BuildToolManager.

## Gotchas
- clearLoadout temporarily UNEQUIPS everything including user's own gear; restored after load.
- Duplicate-load guard is identity-based on the freshly loaded instance — backpackHasTool ALWAYS false for a just-loaded clone, so repeated runs duplicate tools unless takePlayerBuildTools ran.
- waitForCharacterLoad silently proceeds when AppearanceDidLoad doesn't exist (pcall false) — tools can land before appearance loads.
- All functions are globals — name-collision hazard in shared CoreScript env.
