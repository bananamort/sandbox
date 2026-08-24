# PlayerGui.cpp

## Purpose

Implements FOUR classes: `BasePlayerGui` (abstract GUI root owning an IAdornableCollector, 2D input routing, gamepad selection navigation, and script-run rules), `PlayerGui` ("PlayerGui", per-player container parented only under a Player, with topbar transparency API and teleport loading-GUI carryover), `StarterGuiService` ("StarterGui", ShowDevelopmentGui/ResetPlayerGuiOnSpawn + CoreGui enable state + the SetCore/GetCore registration bridge to CoreScripts), and `CoreGuiService` ("CoreGui", RobloxLocked root holding the "RobloxGui" ScreenGui with on-screen message slots).

## Key types and API

### BasePlayerGui
No descriptors. Owns `IAdornableCollector` (adornable add/remove on descendant events; `render3dAdorn`/`append3dSortedAdorn`/`render2d` delegate to it), a default `ImageLabel` selection image (`rbxasset://textures/ui/SelectionBox.png`, 9-slice via SCALE_SLICED, slice center 19,19→43,43), and `selectedGuiObject` weak ref.
- `setSelectedObject(GuiObject*)`: fires selectionLost/Gained on transition; raises GuiService's prop_selectedGuiObject or prop_selectedCoreGuiObject depending on whether `this` is PlayerGui or CoreGuiService.
- Gamepad navigation: `selectNewGuiObject(direction)` — honors per-object NextSelectionUp/Down/Left/Right overrides first (`checkGuiObjectForNextDirection`, visibility-checked), then GuiService selection group Tuple membership (`checkForTupleSelection`) or full-tree scan restricted to the group ancestor (`checkForDefaultGuiSelection`). Candidate scoring in `isCloserGuiObject`: intersecting rects compare center distance within ±45° cone (piHalf/4); non-intersecting use projection onto direction ×100000 with tie-break by closer center.
- Input: `process(InputObject)` walks children REVERSE order, sinks on first sunk response tracking mouseWasOverGui/target; `processGesture` forward order over GuiBase2d children; `processChildren(func)` generic sink loop.
- Scripting: `scriptShouldRun(BaseScript*)` — LocalScript runs iff it sits under the LOCAL player's copy of this gui (sets script->setLocalPlayer); other scripts run iff backendProcessing(server).
- `askAddChild` always true.

### PlayerGui (sPlayerGui)
- `prop_PlayerGuiSelectionImageObject("SelectionImageObject")` — RefPropDescriptor GuiObject, category_Appearance, cap STANDARD (no security tier ⇒ default).
- `func_setTopbarTransparency("SetTopbarTransparency(transparency)")`, `func_getTopbarTransparency("GetTopbarTransparency")`, `event_topbarTransparencyChangedSignal("TopbarTransparencyChangedSignal")` — all **Security::None** but BOTH accessors throw std::runtime_error unless `Network::Players::frontendProcessing` ("can only be set from a local script"); value clamped [0,1], finite-checked; default 0.5.
- `askSetParent`: only Network::Player parents allowed; askForbidParent is its negation.
- `onServiceProvider`: after teleport, re-parents TeleportService's custom loading ScreenGui when creator id/type match, destroys temp holder.

### StarterGuiService (sStarterGuiService)
- `prop_showGui("ShowDevelopmentGui")` — bool, no cap/security args; false suppresses render2d/render3dAdorn/append3dSortedAdorn AND input process (returns notSunk).
- `prop_ResetPlayerGui("ResetPlayerGuiOnSpawn")` — bool, cap STANDARD, **Security::None**; default true.
- `func_setCoreGuiEnabled("SetCoreGuiEnabled(coreGuiType, enabled)")` / `func_getCoreGuiEnabled("GetCoreGuiEnabled")` — **Security::None**; warns MESSAGE_WARNING when called server-side; enum CoreGuiType {PlayerList, Health, Backpack, Chat, All}; ALL writes fan out to every key, single writes recompute the ALL aggregate.
- `event_coreGuiChangedSignal("CoreGuiChangedSignal(coreGuiType, enabled)")` — **Security::RobloxScript**.
- SetCore bridge: `RegisterSetCore/RegisterGetCore(parameterName, setFunction:WeakFunctionRef)` **Security::RobloxScript** store maps; `SetCore(parameterName, value)` / yield `GetCore(parameterName)` **Security::None** invoke registered CoreScript callbacks via `ScriptContext::callInNewThread`; unregistered name → throw/error "%s has not been registered by the CoreScripts".

### CoreGuiService (sCoreGuiService)
- Ctor: `setRobloxLocked(true)`, reserves MAX_ON_SCREEN_MESSAGES(3) slots.
- `prop_CoreSelectionImageObject("SelectionImageObject")` — like PlayerGui's but **Security::RobloxScript**; `prop_Version("Version")` read-only int returning constant 0.
- `createRobloxScreenGui/getRobloxScreenGui`: lazily builds "RobloxGui" ScreenGui (RobloxLocked). `onDescendantAdded` force-locks every new descendant. addChild routes under screenGui; removeChild/findGuiChild by pointer or name; setGuiVisibility toggles all GuiObjects.
- `displayOnScreenMessage(slot<3, message, duration)`: creates TextLabel (SIZE_12, white text, black 0.5 bg) parented under "BottomRightControl" frame if present (anchored bottom-right, stacked −1.05 rows/slot) else absolute-positioned fallback; duration≠0 → Debris addItem under `Security::Impersonator(LocalGUI_)`. `clearOnScreenMessage(slot)` = Debris with 0.

DFFlags declared: SetCoreDisableNotifications(false), SetCoreSendNotifications(false), SetCoreMoveChat(false), SetCoreDisableChatBar(false) — none read in this TU body.

## Usage / reflection touchpoints

The heart of the legacy client GUI stack; pairs with `ScreenGui.md`, `GuiObject.md` family, `ScrollingFrame.md`, `TeleportService.md`, `DebrisService.md` in this folder; ScriptContext docs at [App/script](../../script/); Players checks at [Network](../../Network/).

## Gotchas

- BasePlayerGui::process iterates children in REVERSE while gesture/input helpers iterate FORWARD — hit-test priority differs between paths.
- Topbar functions are Security::None yet runtime-gated to frontend (client) processing; server calls throw rather than being permission-blocked.
- StarterGui SetCore silently does NOTHING when the registered WeakFunctionRef expired (lock fails, no error raised).
- CoreGui displayOnScreenMessage indexes onScreenMessages[slot] without slot<0 check; clear path same.
- Selection-image property security differs between classes: PlayerGui default-tier vs CoreGuiService RobloxScript.
- The four SetCore* DFFlags are declared here but consumed elsewhere (UNKNOWN where).
