# PluginManager.cpp

## Purpose

Implements FOUR classes behind the Studio plugin system: `PluginManager` (process-wide singleton mapping DataModel → plugin/toolbar state; script entry `CreatePlugin`), `Plugin` (per-plugin facade: activation, settings persistence, CSG ops, wiki/script opening), `Toolbar` (named toolbar holding buttons), and `Button` (click event + active toggle backed by an IStudioPluginHost UI). Also runs plugin scripts with the `plugin` global injected.

## Key types and API

Descriptors (**Security::Plugin** throughout unless noted):
- PluginManager: `func_createPlugin("CreatePlugin():Instance")` — CustomBoundFuncDesc (raw lua_State entry, pushes via Lua::ObjectBridge).
- Plugin: OpenWikiPage(url); GetMouse():Instance (returns owned PluginMouse); Activate(exclusiveMouse); CreateToolbar(name):Toolbar; SetSetting(key,value)/GetSetting(key):Variant (host-persisted by assetId); GetStudioUserId():int (0 when logged out); Deactivation event; SaveSelectedToRoblox() → host uiAction "saveToRobloxAction"; Union(objects):Instance / Negate(objects) / Separate(objects) (CSG via host); yield PromptForExistingAssetId(assetType):int; OpenScript(script, lineNumber=0); GetJoinMode():AdvArrowTool::JointCreationMode.
- Plugin props (read-only, cap UI, NO security tier ⇒ default): "CollisionEnabled" ← static AdvArrowToolBase::advCollisionCheckMode; "GridSize" ← DragUtilities::getGrid().x.
- Toolbar: CreateButton(text, tooltip, iconname):Button.
- Button: SetActive(active); Click event. Both **Security::Plugin**.

Constants: sPluginManager/sPlugin/sToolbar/sButton.

Behavior highlights:
- `createPlugin(lua_State*)`: builds Plugin, registers in per-DataModel StateDataEntry, pushes to Lua. `addModelPlugin(dataModel, instances, assetId)`: wraps preloaded instances as "Plugin_%d" container (model plugins).
- `startModelPluginScripts`: under LegacyLock Write + mutex, runs every non-disabled Script descendant through `executeInNewThreadWithExtraGlobals(StudioPlugin, …)` with extraGlobals {script, plugin} — **RBX_STUDIO_BUILD only** (compiled out otherwise, silently doing nothing).
- Activation: `activate(plugin, dm)` resets all toolbars, deactivates every other plugin firing its Deactivation signal; NULL → deactivate current. `Activate(exclusiveMouse=true)` additionally sets Workspace null mouse command (tool-style capture). `DeactivatePlugins()` raises allPluginsDeactivatedSignal.
- Button::setActive(true) resets whole toolbar first (radio behavior); setActive(false) on active button triggers full plugin deactivation. Deleted buttons/toolbar ignore state changes. Icons: local path relative to plugin file dir; URL icons fetch async via ContentProvider (loading placeholder textures/chatBubble_bot_notifyGray_dotDotDot.png), failure paths call host->buttonIconFailedToLoad.
- buttonClick grabs DataModel LegacyLock Write before firing clickSignal (comment: click handlers may mutate datamodel). fireDragEnterEvent synthesizes InputObject(TYPE_MOUSEMOVEMENT) at drag location, updates UserInputService current mouse position, forwards to active plugin's PluginMouse.
- exportPlace/exportSelection → host->exportPlace with ExporterSaveType_Everything / _Selection.

## Usage / reflection touchpoints

Entire surface is Security::Plugin — Studio-only. Host abstraction IStudioPluginHost supplies real UI/persistence/CSG. Pairs with PluginMouse.md, Mouse.md in this folder; ScriptContext execution at [App/script](../../script/).

## Gotchas

- runAllPluginScriptsHelper is a NO-OP outside RBX_STUDIO_BUILD — plugin scripts never execute in non-studio builds even though registration still occurs.
- Plugin::getSetting returns default-constructed Variant when host lookup fails — no error channel.
- Buttons outliving their toolbar keep stale toolbar pointer (setActive dereferences it unconditionally after markDeleted guard only checks self).
- createToolbar name-collisions reuse the existing toolbar across DIFFERENT plugins sharing a DataModel (keyed by name only).
- fireButtonClick breaks after first matching button — duplicate void* ids would shadow.
- UNKNOWN: StateDataEntry layout details and studioHost lifetime management live header-side.
