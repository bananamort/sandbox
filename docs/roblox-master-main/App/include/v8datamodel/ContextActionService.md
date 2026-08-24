# App/include/v8datamodel/ContextActionService.h

## Purpose

`ContextActionService` (non-creatable service) — binds named actions (Lua functions) to input tuples, separately for developer actions and ROBLOX core actions; drives touch buttons, exposes bound-action metadata signals, and simulates activation for non-mouse inputs.

## Declared API

Free types:
- `struct BoundFunctionData` — `std::string title/description/image; UDim2 position; bool hasTouchButton; shared_ptr<const Reflection::Tuple> inputTypes; boost::function<void(shared_ptr<Reflection::Tuple>)> luaFunction; weak_ptr<InputObject> lastInput;` four ctors + friend `operator==` (pointer-compares inputTypes tuples when both set).
- `typedef boost::unordered_map<std::string, BoundFunctionData> FunctionMap; FunctionVector = std::vector<std::pair<std::string, BoundFunctionData>>; FunctionPair = pair<function<void(shared_ptr<Instance>)>, function<void(std::string)>>; FunctionPairMap` (yield-function registry).
- `enum PlayerActionType { CHARACTER_FORWARD=0, BACKWARD=1, LEFT=2, RIGHT=3, JUMP=4 };`

Class: `class ContextActionService : public DescribedNonCreatable<ContextActionService, Instance, sContextActionService>, public Service`

- Signals: tool tracking (`equippedToolSignal`, `unequippedToolSignal<void(shared_ptr<Instance>)>`); action lifecycle (`boundActionChangedSignal<void(name, changeName, ValueTable)>`, `boundActionAddedSignal<void(name, bool, ValueTable)>`, `boundActionRemovedSignal<void(name, ValueTable)>`); button discovery (`getActionButtonSignal<void(std::string)>`, `actionButtonFoundSignal<void(std::string, shared_ptr<Instance>)>`).
- Binding API: dev — `bindActionForInputTypes(actionName, Lua::WeakFunctionRef, bool createTouchButton, shared_ptr<const Tuple> hotkeys)`, `unbindAction`, `unbindAll`; core — `bindCoreActionForInputTypes(...)`, `unbindCoreAction`; activate simulation — `bindActivate(InputObject::UserInputType, KeyCode)` / `unbindActivate`.
- Metadata setters: `setTitleForAction`, `setDescForAction`, `setImageForAction`, `setPositionForAction`.
- Data queries: `getBoundCoreActionData(name)`, `getBoundActionData(name)`, `getAllBoundActionData()` → ValueTable; `std::string getCurrentLocalToolIcon();`
- Buttons: `void getButton(actionName, resumeFn(shared_ptr<Instance>), errorFn)`; `fireActionButtonFoundSignal(name, button)`.
- Input processing: `GuiResponse processCoreBindings(const shared_ptr<InputObject>&)`, `processDevBindings(inputObject, bool menuIsOpen)`; `callFunction(...)` two overloads (direct luaFunction or map lookup by name/state/input).
- Overrides: `onServiceProvider(old,new)`; protected connections `characterChildAddConnection`, `characterChildRemoveConnection`, `localPlayerAddConnection`.
- Private machinery: user binds in `functionMap/functionVector`, core binds in `coreFunctionMap/coreFunctionVector`, `yieldFunctionMap`; activate state `activateGuid`, `boost::unordered_map<InputObject*, float> lastZPositionsForActivate`; tool plumbing `getCurrentLocalTool()`, `isTool(Instance*)`, `checkForToolRemoval/NewTool`, character/player connection setup; core helpers `bindActionInternal(...)`, `findAction(name)`, `tryProcess(inputObject, funcVector, menuIsOpen)`, `processActivateAction`, `fireBoundActionChangedSignal(iter, changeName)`, `checkForInputOverride(const Reflection::Variant& newInputType, const FunctionVector&)`.

## Gotchas

- Two parallel bind tables (dev vs core) with identical shapes — process order decides priority (.cpp tryProcess).
- `lastZPositionsForActivate` is keyed by raw `InputObject*` pointer — stale entries possible if objects die without unbind.
- Bound Lua callbacks are `WeakFunctionRef`/weak InputObject refs — dead functions silently no-op.
- Class comment scopes it: "right now this is just for tools, but could expand".

## UNKNOWN

- Exact hotkey-tuple schema accepted by bind*ForInputTypes (.cpp/Lua bridge — see [ContextActionService.md](../../v8datamodel/ContextActionService.md)).

## Cross-links

- Implementation: [App/v8datamodel/ContextActionService.md](../../v8datamodel/ContextActionService.md).
- Kin: [UserInputService.md](UserInputService.md), [InputObject.md](InputObject.md), [Tool.md](Tool.md), [HapticService.md](HapticService.md).
