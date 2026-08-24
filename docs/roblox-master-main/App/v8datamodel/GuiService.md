# GuiService.cpp

## Purpose

Implements `GuiService` ("GuiService") — the client UI hub service: global GUI inset management, keyboard hotkey subscription (KeyPressed/SpecialKeyPressed/EscapeKeyPressed), center-dialog priority stack with show/hide Lua callbacks, screen-resolution query (heartbeat-retried), selection groups for gamepad navigation, SelectedObject/SelectedCoreObject bridging to PlayerGui/CoreGuiService, UiMessage/error text plumbing, dev-console/stat toggle strings, closest-dialog lookup over CollectionService "Dialog" tags, and VMProtect-guarded fullscreen verb invocation.

## Key types and API

Flags: FFlag::NewInGameDevConsole(false), UseNewSubdomainsInCoreScripts(false), DFFlag::EnableShowStatsLua (extern ref), UseGameLoadedInLoadingScript(true), UseUserListMenu(false), EnableSetCoreTopbarEnabled(false), Durango3DBackground(true) ("Xbox flag... accessible in studio and xbox client").

Descriptors:
- Deprecated props (getter-only): IsModalDialog, IsWindows.
- Key API (all Security::RobloxScript): events KeyPressed(key,modifiers)/SpecialKeyPressed(key,modifiers)/EscapeKeyPressed/BrowserWindowClosed; funcs AddKey(key)/RemoveKey/AddSpecialKey(SpecialKey)/RemoveSpecialKey; SpecialKey enum {Insert,Home,End,PageUp,PageDown,ChatHotkey}.
- Center dialogs (RobloxScript): `AddCenterDialog(dialog Instance, centerDialogType, showFunction, hideFunction)` — dialog must be a GuiObject; `RemoveCenterDialog(dialog)`. CenterDialogType enum {UnsolicitedDialog, PlayerInitiatedDialog, ModalDialog, QuitDialog}.
- `SetGlobalGuiInset(x1,y1,x2,y2)` — RobloxScript; stores Vector4 consumed by [GuiObject](GuiObject.md).getAbsolutePosition etc. NO descriptor validation.
- `GetScreenResolution() -> Vector2` — RobloxScript yield func; retries once after next RunService heartbeat if zero ("we haven't done a heartbeat yet").
- OpenBrowserWindow(url) — RobloxScript; silently warns+no-ops for non-Roblox urls (Http::isRobloxSite) or non-frontend contexts.
- GetClosestDialogToPosition(position Vector3) -> Instance — RobloxScript; scans CollectionService tag "Dialog", DialogRoots parented under PartInstances, nearest within ConversationDistance.
- GetBrickCount() -> int — RobloxScript; DataModel::getNumPartInstances.
- Ui messaging: SetUiMessage(msgType,uiMessage) Security::LocalUser; GetUiMessage / UiMessageChanged event — RobloxScript. Deprecated trio SetErrorMessage(LocalUser)/GetErrorMessage/ErrorMessageChanged are marked `Attributes::deprecated(SetUiMessage…)` but are NOT aliases — they read/write a SEPARATE `errorMessage` member and fire their own ErrorMessageChanged signal.
- ShowLeaveConfirmation event, ToggleFullscreen(), IsTenFootInterface() — RobloxScript. ToggleFullscreen resolves Workspace whitelist verb "ToggleFullScreen" inside VMProtectBeginMutation; a secured verb triggers `RBX::Tokens::simpleToken |= HATE_VERB_SNATCH` and nulls it.
- Selection groups (Security::None): AddSelectionParent(name,selectionParent GuiObject), AddSelectionTuple(name,selections Tuple), RemoveSelectionGroup(name).
- Props: SelectedObject (RefPropDescriptor→GuiObject, public static prop_selectedGuiObject; setter routes into local player's [PlayerGui](PlayerGui.md)::setSelectedObject, getter reads back), SelectedCoreObject (UI attribute + Security::RobloxScript; bridges CoreGuiService::getSelectedObject), AutoSelectGuiEnabled (delegates GamepadService::get/setAutoGuiSelectionAllowed), GuiNavigationEnabled, CoreGuiNavigationEnabled (defaults true), MenuIsOpen (getter-only prop_menuOpen) + SetMenuIsOpen(open) RobloxScript firing MenuOpened/MenuClosed events (Security::None).
- SendCoreBoundAsyncCallback "SendCoreUiNotification(title,text)" — BoundAsyncCallbackDesc, Security::RobloxScript.
- `ShowStatsBasedOnInputString(input)` — RobloxScript; gated by DFFlag::EnableShowStatsLua; matches exact-case "Genstats/Renstats/Netstats/Phystats/Sumstats/Cusstats" → [GuiBuilder](GuiBuilder.md) toggles, or case-insensitive "/console" → invokes BindableFunction ToggleDevConsole under RobloxGui(/ControlFrame).

Behavior notes:
- Dialog stack: shouldPreemptCurrentDialog — higher enum value preempts; equal type preempts only for PlayerInitiated/Modal/Quit (Unsolicited never displaces peer); preempted current is hidden via DataModel Write-task and pushed FRONT of its queue. removeCenterDialog pops Quit>Modal>PlayerInitiated>Unsolicited order. InvokeCallback falls back to setVisible(true/false) on the dialog if the callback can't run.
- processKeyDown: text keys (or TYPE_KEYBOARD under IsUsingNewKeyboardEvents) minus Alt/Ctrl — '/' (or SDLK_SLASH) dispatches ChatHotkey; other subscribed chars lowercased fire keyPressed; non-text keys map Insert/Home/End/PageUp/PageDown. Returns true when sunk.

## Usage / reflection touchpoints

Service discovered via ServiceProvider::find<GuiService> from [GuiLayerCollector](GuiLayerCollector.md), [GuiObject](GuiObject.md), ContextActionService; depends on GamepadService, CollectionService, DialogRoot ([DialogRoot](DialogRoot.md)), CoreGuiService, RunService heartbeat, Workspace verbs.

## Gotchas

- SetGlobalGuiInset has no bounds/sign validation — callers own correctness; inset affects absolute positions, drag-stop coordinates, and visibility culling asymmetrically (see GuiObject gotchas).
- addCenterDialog throws on type change for an already-registered dialog but re-registering same type silently re-adds (remove+insert).
- DialogWrapper raw pointers: removed via delete in removeCenterDialog; queue holds pointers too — remove() keeps them consistent, but an exception between map insert and queue push would leak.
- getSelectedGuiObject prefers CORE selection over game selection when both set.
- KeyPressed fires only for single-char lowercase subscriptions; modifiers argument is always "" from processKeyDown.
- showStatsBasedOnInputString stats keywords are case-SENSITIVE while "/console" is not.
- UNKNOWN: where escapeKeyPressed signal is fired (input plumbing outside this file); notificationCallback consumer (core UI scripts).
