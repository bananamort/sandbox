# App/include/v8datamodel/Tool.h

## Purpose

`Tool` — the creatable game tool (BackpackItem + IEquipable + IAdornable + IHasLocation): handle-based equipping onto characters, an explicit backend/frontend ToolState machine (NOTHING→HAS_HANDLE→IN_WORKSPACE→IN_CHARACTER→HAS_TORSO→EQUIPPED), grip CFrame + component accessors, activation replication, touch pickup, drop helpers, and a `special_equipped_signal` that replays the equipped state to late subscribers.

## Declared API

- `class special_equipped_signal : public rbx::signals::signal_with_args<1, void(shared_ptr<Instance>)>` — tracks `currentlyEquipped` + `lastArg` (weak); connect() fires the function immediately with lastArg if currently equipped; in-header comment: "operator() throws. See Implementation."; methods `equipped(instance)`, `unequipped()`.

`class Tool : public DescribedCreatable<Tool, BackpackItem, sTool>, public IEquipable, public IAdornable, public IHasLocation`
- Private enum `ToolState {NOTHING, HAS_HANDLE, IN_WORKSPACE, IN_CHARACTER, HAS_TORSO, EQUIPPED}`.
- Replicated state: `backendToolState` ("backend writes, frontend reads"), `int frontendActivationState` ("frontend writes, backend reads"), `CoordinateFrame grip` ("replicates, stores — the grip point on the tool"), bools enabled ("cooldown property")/droppable/requiresHandle/manualActivationOnly/ownWeld ("responsible for creating and deleting the weld"), `std::string toolTip`.
- Backend connections: logged handleTouched + character/torso/arm child add/remove watchers; handlers onEvent_AddedBackend/onEvent_RemovedBackend/onEvent_AddedToArmBackend/onEvent_HandleTouched.
- Pickup/drop: statics `moveAllToolsToBackpack(Network::Player*)`, `characterCanPickUpTool(Instance* touchingCharacter) → ToolState`, `characterCanUnequipTool(ModelInstance*)`; instance `moveOtherToolsToBackpack(weak_ptr<Player>)`, `setTimerCallback(weak_ptr<Player>)`.
- State machine: `computeDesiredState()` (+testParent overload), `setDesiredState(ToolState, const ServiceProvider*)`, `rebuildBackendState()`, `connectTouchEvent()`; climb ladder upTo_{Activated,Equipped,HasTorso,InCharacter,InWorkspace,HasHandle}; drop ladder downFrom_* (downFrom_Equipped takes `bool connectTouchEvent=true`); shortcuts fromNothingToEquipped(isBackend)/fromEquippedToNothing().
- Frontend: `shared_ptr<Mouse> onEquipping()/onUnequipped()` over `currentMouse` + `currentToolMouseCommand`; `createMouse()`; `workspaceForToolMouseCommand`; `setMousePositionForInputType()`.
- Overrides: Instance `onChildAdded/onChildRemoved/onAncestorChanged` + inline askSetParent/askAddChild true; IHasLocation `getLocation()`; BackpackItem `drawSelected() {return backendToolState >= EQUIPPED;}` / `onLocalClicked()/onLocalOtherClicked()`; IAdornable `render3dSelect(Adorn*, SelectState)`.
- Public signals: `special_equipped_signal equippedSignal`, `rbx::remote_signal<void()> activatedSignal`, `rbx::signal<void()> unequippedSignal`, `rbx::remote_signal<void()> deactivatedSignal`.
- Statics: `static void dropAll(Network::Player*)`; attachment finders `findFirstAttachmentByName(const Instance*, name)` / `...Recursive`.
- Accessors: inline isDroppable/setDroppable, getRequiresHandle/setRequiresHandle(bool), virtual `canUnequip() {true}`, virtual `canBePickedUpByPlayer(Player*) {true}`, `isSelectable3d()`, `getHandle()/getHandleConst()`.
- Replication API: `setFrontendActivationState(int)` / inline getter; inline getToolTip / `setToolTip(std::string)`; `setBackendToolState(int)` / inline getter; `static BoundProp<bool> prop_Enabled`; inline getGrip / setGrip(CoordinateFrame).
- Activation: `luaActivate()`, `activate(bool manuallyActivated=false)`, `deactivate()`, inline get/setManualActivationOnly.
- Grip components: getGripPos/Forward/Up/Right (const Vector3) and matching setters.

## Gotchas

- The state machine IS the tool: parenting a Tool under Workspace vs Character vs Torso drives backend transitions automatically via child/ancestor hooks — external weld/weld management must respect ownWeld.
- special_equipped_signal::connect invokes the delegate DIRECTLY (outside connection bookkeeping) when already equipped — exceptions/reentrancy hazards noted by "operator() throws".
- frontendActivationState is int-typed replication channel for click semantics.
- requiresHandle=false tools can equip without a Handle part.

## UNKNOWN

- Numeric encoding of frontendActivationState values (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Tool.md](../../v8datamodel/Tool.md).
- Base: [Hopper.md](Hopper.md) (BackpackItem), equip twin: [Accoutrement.md](Accoutrement.md); command layer: [ToolMouseCommand.md](ToolMouseCommand.md); container: [Backpack.md](Backpack.md); studio twin: [StudioTool.md](StudioTool.md).
