# App/include/v8datamodel/PluginManager.h

## Purpose

Studio plugin machinery in four classes: `Button` and `Toolbar` (non-creatable reflection instances representing plugin UI), `Plugin` — the per-plugin object handed to Lua (mouse, toolbar creation, settings, CSG ops, asset prompts, activation), and `PluginManager` — non-creatable singleton service tracking per-DataModel plugin/toolbar state, hosting via `IStudioPluginHost`, Lua `createPlugin(lua_State*)` entry, drag-enter dispatch, and place/selection export.

## Declared API

- `LOGGROUP(Plugins)`.

`class Button : public DescribedNonCreatable<Button, Instance, sButton>`
- Private: `void* id`, `IStudioPluginHost* host`, `Toolbar* toolbar`, `bool isDeleted`, `bool active`.
- `SetId(void*)` inline; `setToolbar(Toolbar*)`; `setHost(IStudioPluginHost*)`; `markDeleted()`; `void processIconLoaded(ContentId, AsyncHttpQueue::RequestResult, std::istream*, shared_ptr<const std::string>)` — async icon fetch completion; `setActive(bool)`; `rbx::signal<void()> clickSignal`.

`class Toolbar : public DescribedNonCreatable<Toolbar, Instance, sToolbar>`
- Private: host, `DataModel* dataModel`, void* id, isDeleted, `std::map<void*, shared_ptr<Button>> buttonsMap`.
- Id/host/dataModel setters+getters (inline); `reset()`, `markDeleted()`; `shared_ptr<Instance> createButton(std::string text, std::string tooltip, std::string iconName)`; `Button* getButton(void* id)`.

`class Plugin : public DescribedNonCreatable<Plugin, Instance, sPlugin>`
- Private: manager ptr, DataModel ptr, `shared_ptr<Instance> luaMouse`, `PluginMouse* mouse`, bools active/tool, `int assetId`.
- Wiring: `setPluginManager(PluginManager*)`, `setDataModel(DataModel*)`, inline `getDataModel()/isTool()/getMouse()`.
- UI/Lua surface: `shared_ptr<Instance> getMouseLua()`, `shared_ptr<Instance> createToolbar(std::string name)`, `saveSelectedToRoblox()`, settings `setSetting(std::string key, Reflection::Variant)/getSetting(std::string) → Variant`, `getStudioUserId()`, studio queries `isCollisionOn()/getGridSize()/AdvArrowToolBase::JointCreationMode getJoinMode()`.
- Activation: `activate(bool exclusiveMouse)`, `setActive(bool state)`, `rbx::signal<void()> deactivationSignal`, `setAssetId(int)`.
- Docs/web: `openScriptDoc(shared_ptr<Instance> script, int lineNumber)`, `openWikiPage(std::string url)`.
- CSG bridge: `csgUnion(shared_ptr<const Instances>) → shared_ptr<Instance>`, `csgNegate(...) → shared_ptr<const Instances>`, `csgSeparate(...)`; `promptForExistingAssetId(std::string assetType, resume(int), error(std::string))`.

`class PluginManager : public DescribedNonCreatable<PluginManager, Instance, sPluginManager>, public IHostNotifier`
- Nested `StateDataEntry` per DataModel: toolbars map by name, plugins list, `Plugin* active`, hidden flag, methods addPlugin/setActivePlugin/getToolbar/fireButtonClick(void* id)/disableStudioUI/hideStudioUI/deleteStudioUI.
- State store: `std::map<DataModel*, StateDataEntry> state` ("currently selected dataModel as in the selected tab").
- Public: ctor; `static shared_ptr<PluginManager> singleton()`; PUBLIC `boost::mutex mutex`; `rbx::signal<void()> allPluginsDeactivatedSignal`; virtuals `createToolbar(Plugin*, name)`, `activate(Plugin*, DataModel*)`, `DeactivatePlugins()`, `buttonClick(DataModel*, void* id)`; host wiring `setStudioHost(IStudioPluginHost*)` / `getStudioHost()`, `setCurrentDataModel(DataModel*)`; last-path get/set; model plugins `addModelPlugin(DataModel*, Instances, int assetId)`, `startModelPluginScripts(DataModel*)`; Lua entry `int createPlugin(lua_State* L)`; teardown `deletePlugins(DataModel*)`, `deleteStudioUI(DataModel*)`; `Plugin* getActivePlugin(DataModel*)`; UI toggles hideStudioUI/disableStudioUI(DataModel*, bool); export `exportPlace(filePath)/exportSelection(filePath)`; IHostNotifier `fireDragEnterEvent(DataModel*, shared_ptr<const Instances>, Vector2 location)`.

## Gotchas

- PluginManager is a process-wide singleton keyed per-DataModel — plugin state follows Studio tabs, so pointers into `state` die with tab close (deletePlugins).
- Button identity is a raw `void* id` — opaque handle from the host UI layer; collisions are the host's problem.
- Plugin holds BOTH a raw `PluginMouse*` and its `shared_ptr<Instance> luaMouse` wrapper — lifetime pairing matters.
- Public mutex + virtual dispatch on every activate/create path: reentrancy from Lua callbacks into these virtuals is expected.

## UNKNOWN

- Where setSetting/getSetting persist (registry? DataModel? out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PluginManager.md](../../v8datamodel/PluginManager.md).
- Mouse plumbing: [PluginMouse.md](PluginMouse.md), [Mouse.md](Mouse.md); host interface: [StudioPluginHost.md](StudioPluginHost.md); CSG targets: [PartOperation.md](PartOperation.md); change history: [ChangeHistory.md](ChangeHistory.md).
