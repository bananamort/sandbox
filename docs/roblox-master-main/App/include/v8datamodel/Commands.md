# App/include/v8datamodel/Commands.h

## Purpose

Studio command/verb catalog: base verb classes (RunStateVerb, EditSelectionVerb, BoolPropertyVerb, CameraVerb) plus the concrete edit/view/format/run/test menu commands and the templated tool launcher `TToolVerb` that binds MouseCommand tools to verbs.

## Declared API (highlights — 735 lines, dozens of small verb classes)

Free functions: `void AddChildToRoot(XmlElement* root, shared_ptr<Instance> wsi, const boost::function<bool(Instance*)>& isInScope, RBX::CreatorRole creatorRole);` `void AddSelectionToRoot(XmlElement* root, Selection* sel, RBX::CreatorRole creatorRole);` Flag: `DYNAMIC_FASTFLAG(UseRemoveTypeIDTricks)`.

Base classes:
- `RunStateVerb : Verb` — holds `DataModel* dataModel`, `ServiceClient<RunService> runService`; ctor `(name, dataModel, blacklisted=false)`; `playActionSound()`.
- `EditSelectionVerb : Verb` — "only enabled when the workspace is at Frame 0 and when something is selected"; holds workspace/selection/dataModel; `virtual bool isEnabled() const`.
- `BoolPropertyVerb : EditSelectionVerb` — toggles a bool property by `const Name& propertyName`; overrides `doIt`, `isChecked`.
- `CameraVerb : Verb` — always enabled; holds `Workspace*`; `Camera* getCamera()`; `doIt`.

Representative concretes: `DeleteBase/DeleteSelectionVerb/PlayDeleteSelectionVerb` (`rewardHopper` flag; play-mode delete), `SelectAllCommand`, `SelectChildrenVerb`, `SnapSelectionVerb`, `UnlockAllVerb`, camera set `CameraTiltUp/Down/PanLeft/PanRight/ZoomIn/ZoomOut/ZoomExtents/CenterCommand`, `FirstPersonCommand` (empty doIt), `ToggleViewMode`, stats family (`Stats/RenderStats/SummaryStats/CustomStats/NetworkStats/PhysicsStats/EngineStatsCommand`), `JoinCommand`, `ChatMenuCommand(menu1..3)` with `static getChatString(int,int,int)`.

Tool launcher:
- `template <class MouseCommandClass, class ParentClass = RunStateVerb> class TToolVerb : public ParentClass` — verb name = `MouseCommandClass::name().toString() + "Tool"`; `sameType(MouseCommand*)` switches between Name comparison (`DFFlag::UseRemoveTypeIDTricks`) and `typeid` matching; `doIt` toggles off via `setNullMouseCommand()`/`setDefaultMouseCommand()` (adv-arrow aware) or installs `newMouseCommand()`; `isChecked()` compares current workspace mouse command.

Format/build: `AnchorVerb`, `MaterialVerb` (static current material + `parseMaterial(std::string)`), `ColorVerb` (static current BrickColor), `TranslucentVerb("Transparent")`, `CanCollideVerb`, select-policy pair `AllCanSelectCommand/CanNotSelectCommand`, movers `MoveUpPlateVerb(0.4f)/MoveUpBrickVerb(1.2f)/MoveDownSelectionVerb`, rotation pair via abstract `RotateAxisCommand::getRotationAxis()` → `RotateSelectionVerb/TiltSelectionVerb`, `CharacterCommand`.
Run menu: `RunCommand/StopCommand/ResetCommand`.
Adv build: `TurnOnManualJointCreation`, drag-grid trio (`SetDragGridToOne/OneFifth/Off` → `AdvArrowTool::advGridMode`), grid sizes `SetGridSizeToTwo/Four/Sixteen` (write static `Workspace::gridSizeModifier`), manual-joint strength trio (`SetManualJointToWeak/Strong/Infinite`; Weak+Infinite report isEnabled/isChecked false).

## Gotchas

- Grid-size verbs write a *static* `Workspace::gridSizeModifier` — process-global side effect.
- `SetDragGridToOneFifth` checks against `DRAG::QUARTER_STUD` — name/value mismatch in source.
- ManualJoint weak/infinite verbs are permanently disabled (`isEnabled() == false`) yet keep their doIt bodies.
- TToolVerb's toggle behavior depends on `MouseCommand::isAdvArrowToolEnabled()` global state.
- Most doIt implementations live in Commands.cpp; header shows signatures only.

## UNKNOWN

- Full enable/disable matrix per run state (see implementation doc [Commands.md](../../v8datamodel/Commands.md)).

## Cross-links

- Implementation: [App/v8datamodel/Commands.md](../../v8datamodel/Commands.md).
- Aggregator: [CommonVerbs.md](CommonVerbs.md); kin: [MouseCommand.md](MouseCommand.md), [Workspace.md](Workspace.md), [DataModel.md](DataModel.md).
