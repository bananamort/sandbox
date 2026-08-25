# App/include/tool/ToolsArrow.h

## Purpose

Arrow-tool hierarchy: `ArrowToolBase` (selection hover + decal picking), `AdvArrowToolBase` (advanced manipulation parent — static tool-mode flags, manual-joint helper, transparency ghost registry) and concrete `AdvArrowTool`, plus `BoxSelectCommand` (rubber-band selection). Defines `STUDIO_CAMERA_CONTROL_SHORTCUTS 1`.

## Declared API

- `class ArrowToolBase : public MouseCommand`
  - `ArrowToolBase(Workspace*)` / virtual dtor, both FASTLOG1 on `FLog::MouseCommandLifetime`.
  - Private: `bool altKeyDown;` Protected: `Decal* findDecal(PartInstance*, inputObject);` virtual `onMouseIdle/onMouseHover/onMouseDown/getCursorName/onPeekKeyDown/render3dAdorn`; `void renderHoverOver(Adorn*, bool drillDownOnly = true);` `PartInstance* overInstance;`
  - Public static: `static bool showDraggerGrid;`
- `class AdvArrowToolBase : public ArrowToolBase`
  - Private: `ManualJointHelper manualJointHelper;` (V8DataModel/ManualJointHelper.h). Protected: `typedef std::map<boost::weak_ptr<PartInstance>, float> PartsTransparencyCollection;` **static** `originalPartsTransparency;`
  - Public enum: `JointCreationMode { WELD_ALL = 0, SURFACE_JOIN_ONLY = 1, NO_JOIN = 2 }`.
  - Virtuals: `onMouseDown/onMouseMove/onMouseUp/getCursorName`; non-virtual `onKeyDown`.
  - `void determineManualJointConditions(void);`
  - Static mode flags: `advGridMode` ([DragTypes.md](DragTypes.md)), `advManualJointMode`, `advManualJointType`, `advManipInProgress`, `advCollisionCheckMode`, `advLocalTranslationMode`, `advLocalRotationMode`, `advCreateJointsMode`.
  - Static transparency helpers: `restoreSavedPartsTransparency()`, `savePartTransparency(shared_ptr<PartInstance>)`; `static JointCreationMode getJointCreationMode();`
  - Extension points: `virtual void getSelectedTargetPrimitives(std::vector<Primitive*>&) {}` and `virtual void setCursor(std::string) {}` (empty defaults).
- `extern const char* const sAdvArrowTool; class AdvArrowTool : public Named<AdvArrowToolBase, sAdvArrowTool>` — ctor + `isSticky()` self-recreate + another empty `setCursor` override.
- `extern const char* const sBoxSelectCommand; class BoxSelectCommand : public Named<MouseCommand, sBoxSelectCommand>`
  - State: `ServiceClient<Selection> selection; bool reverseSelecting; Vector2int16 mouseDownView, mouseCurrentView; std::set<shared_ptr<Instance>> previousItemsInBox;` private `getMouseInstances(set&, inputObject, Rect2D selectBox, const Camera*, Instance* currentInstance)`, `selectAnd(newItems)`, `selectReverse(newItems)`.
  - Overrides: `onMouseDown`, `onMouseMove`, `render2d`.

## Gotchas

- All adv-tool mode state is static → global across every advanced tool instance and persists between activations; Studio UI toggles write these directly.
- Transparency ghost map keyed by weak_ptr with static storage — parts deleted mid-manipulation leave stale entries until restore runs.
- `AdvArrowTool::setCursor` re-overrides the base's empty virtual with another empty body — cursor routing for the plain arrow tool is a no-op by design.
