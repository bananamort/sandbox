# App/include/v8datamodel/PlayerGui.h

## Purpose

Four-class GUI stack header: `BasePlayerGui` — non-creatable base implementing per-player GUI input routing (GuiTarget `process`/gesture), 2D/3D adorn rendering, gamepad UI selection, and the IScriptFilter gate; creatable `PlayerGui` (INTERNAL_PLAYER, adds topbar transparency); `StarterGuiService` — the service holding StarterGui core-toggle state + setCore/getCore Lua registration; and `CoreGuiService` — INTERNAL_LOCAL Plugin-security service owning the Roblox ScreenGui and on-screen messages.

## Declared API

`class BasePlayerGui : public DescribedNonCreatable<BasePlayerGui, Instance, sBasePlayerGui>, public IScriptFilter`
- Private helpers: `processChildren(boost::function<GuiResponse(GuiBase2d*)>)`, `processInputOnChild(GuiBase2d*, shared_ptr<InputObject>)`, gamepad selection math (`checkForDefaultGuiSelection`, `checkForTupleSelection`, `isCloserGuiObject`), state `mouseWasOverGui`, `weak_ptr<GuiObject> selectedGuiObject`, `shared_ptr<ImageLabel> defaultSelectionImage`.
- Ctor/dtor; `virtual void append3dSortedAdorn(std::vector<AdornableDepth>& sortedAdorn, const Camera* camera) const`.
- `bool findModalGuiObject()`; `bool getMouseWasOverGui() const`; `/*override*/ bool askAddChild(const Instance*) const`.
- IAdornable overrides: `shouldRender2d/shouldRender3dAdorn/shouldRender3d/shouldRender3dSortedAdorn {return true}`, `render2d(Adorn*)`, `render3dAdorn(Adorn*)`, plus `tryRenderSelectionFrame(Adorn*)`.
- GuiTarget: `/*override*/ GuiResponse process(const shared_ptr<InputObject>& event)`; `GuiResponse processGesture(UserInputService::Gesture gesture, shared_ptr<const ValueArray> touchPositions, shared_ptr<const Tuple> args)` (+private processGestureOnChild).
- IScriptFilter: `/*override*/ bool scriptShouldRun(BaseScript* script)`.
- Instance: `onDescendantAdded/onDescendantRemoving` overrides.
- Gamepad selection: `GuiObject* selectNewGuiObject(const Vector2& direction)`, `getSelectionImageObject()` inline, pure `virtual void setSelectionImageObject(GuiObject*) = 0`, `shared_ptr<GuiObject> getSelectedObject()` / `setSelectedObject(GuiObject*)`.

`class PlayerGui : public DescribedCreatable<PlayerGui, BasePlayerGui, sPlayerGui, Reflection::ClassDescriptor::INTERNAL_PLAYER>`
- State: private `float topbarTransparency`; signal `rbx::signal<void(float)> topbarTransparencyChangedSignal`; `void setTopbarTransparency(float)` / `float getTopbarTransparency(void)`; `onServiceProvider` override; implements `setSelectionImageObject`; parent guards `askSetParent/askForbidParent`.

`class StarterGuiService : public DescribedNonCreatable<StarterGuiService, BasePlayerGui, sStarterGuiService>, public Service`
- `enum CoreGuiType { COREGUI_PLAYERLISTGUI=0 ("ALWAYS first"), COREGUI_HEALTHGUI=1, COREGUI_BACKPACKGUI=2, COREGUI_CHATGUI=3, COREGUI_ALL=4 ("ALWAYS last") }`.
- Signal: `rbx::signal<void(CoreGuiType,bool)> coreGuiChangedSignal`; `static PropDescriptor<StarterGuiService,bool> prop_ResetPlayerGui`.
- Core toggles: `setCoreGuiEnabled(CoreGuiType,bool)/getCoreGuiEnabled(CoreGuiType)` over unordered_map.
- Lua bridge: `registerSetCore/registerGetCore(std::string parameterName, Lua::WeakFunctionRef)`, `void setCore(std::string, Reflection::Variant)`, `void getCore(std::string, resume(Variant), error(std::string))` — FunctionMap typedef of WeakFunctionRefs.
- Flags: `bool showGui/resetPlayerGui` with getters/setters.
- Overrides: `canClientCreate() {return true;}` but `scriptShouldRun() {return false;}`, render2d/render3dAdorn/append3dSortedAdorn/process overrides, `setSelectionImageObject(GuiObject*) {}` no-op.

`class CoreGuiService : public DescribedNonCreatable<CoreGuiService, BasePlayerGui, sCoreGuiService, Reflection::ClassDescriptor::INTERNAL_LOCAL, Security::Plugin>, public Service`
- `createRobloxScreenGui()`; on-screen messages: `displayOnScreenMessage(int slot, const std::string& message, double duration)` ("duration == 0 for infinite"), `clearOnScreenMessage(int slot)`; `setGuiVisibility(bool)`; manual child mgmt `addChild(Instance*)`, `removeChild(Instance*)`, `removeChild(const std::string& Name)`, `Instance* findGuiChild(Name)`, `int getGuiVersion() const`, `shared_ptr<ScreenGui> getRobloxScreenGui()`.
- Overrides: `onDescendantAdded`, `canClientCreate() {return false;}`, `scriptShouldRun() {return false;}`, real `setSelectionImageObject`.
- Private: `shared_ptr<Instance> screenGui`, `RBX::Instances onScreenMessages`.

## Gotchas

- StarterGuiService accepts client-created GUI (`canClientCreate=true`) yet refuses to run scripts inside itself; CoreGuiService is the inverse (no client create). Both refuse scriptShouldRun.
- Gamepad selection logic lives here in full (rect-distance heuristics) — selection is BasePlayerGui behavior, not UserInputService.
- CoreGuiService is Security::Plugin-gated INTERNAL_LOCAL — only plugin-security code may touch it.
- setCore/getCore use WeakFunctionRef maps: expired Lua functions are a live failure mode; getCore is callback-based.

## UNKNOWN

- Where topbarTransparency is consumed downstream (rendering side out-of-line).
- Slot count/range policy for displayOnScreenMessage.

## Cross-links

- Implementation: [App/v8datamodel/PlayerGui.md](../../v8datamodel/PlayerGui.md).
- GUI family: [ScreenGui.md](ScreenGui.md), [GuiObject.md](GuiObject.md), [GuiBase2d.md](GuiBase2d.md), [GuiService.md](GuiService.md); scripts: [Script.md] via App/v8datamodel docs; input: [UserInputService.md](UserInputService.md), [InputObject.md](InputObject.md).
