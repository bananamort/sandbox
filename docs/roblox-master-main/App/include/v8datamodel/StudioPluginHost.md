# App/include/v8datamodel/StudioPluginHost.h

## Purpose

Two pure-virtual interfaces decoupling [PluginManager.md](PluginManager.md) from the Studio UI shell: `IHostNotifier` — callbacks the host invokes INTO the manager (button clicks, drag-enters); `IStudioPluginHost` — the API the manager calls OUT to (toolbar/button CRUD, per-plugin settings by assetId, login lookup, script docs, wiki, export, CSG ops, asset prompts). No certified implementation doc exists for this header.

## Declared API

`class IHostNotifier`
- `virtual void buttonClick(DataModel* dataModel, void* id) = 0`
- `virtual void fireDragEnterEvent(DataModel*, shared_ptr<const RBX::Instances>, Vector2 location) = 0`

`class IStudioPluginHost`
- Notifier wiring: `virtual void setNotifier(IHostNotifier*) = 0`.
- Toolbar/button management (all void*-handle based): `createToolbar(const std::string& name)`, `createButton(void* tbId, text, tooltip, iconFilePath)`, `setButtonActive(void*, bool)`, `setButtonIcon_deprecated(void*, iconFilePath)`, `setButtonIcon(void* butonId /*sic*/, iconImage)`, `buttonIconFailedToLoad(void*)`, `hideToolbars(const std::vector<void*>&, bool)`, `disableToolbars(...)`, `deleteToolbars(...)`.
- Settings/persistence: `setSetting(int assetId, key, const Variant&)`, `getSetting(int assetId, key, Variant* result)`, `getLoggedInUserId(int* userIdOut) → bool`, `uiAction(std::string)`.
- Docs/export: `openScriptDoc(shared_ptr<Instance> script, int lineNumber)`, `exportPlace(std::string filePath, RBX::ExporterSaveType)`, `openWikiPage(url)`.
- CSG bridge (DataModel-passing variants of Plugin's methods): `csgUnion/csgNegate/csgSeparate(shared_ptr<const Instances>, DataModel*)`; `promptForExistingAssetId(assetType, resume(int), error(std::string))`.

## Gotchas

- Parameter typo `butonId` is in the actual header.
- All handles are void*; identity/lifetime owned entirely by the host shell.
- This header has NO certified implementation doc in App/v8datamodel/ — behavior verification depends on Studio-side code outside this drop's certified set.

## UNKNOWN

- Concrete IStudioPluginHost implementations (Studio shell binary, out-of-tree).

## Cross-links

- Consumer: [PluginManager.md](PluginManager.md), [Plugin.md within PluginManager.h](PluginManager.md).
