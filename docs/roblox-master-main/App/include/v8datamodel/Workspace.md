# App/include/v8datamodel/Workspace.h

## Purpose

`Workspace` — the non-creatable game world container: a `RootInstance` (so it owns the V8World `World`, insert placement, camera ownership) that is also the physics stepping service, mouse-command dispatcher, touch-pair pump (`TouchPair` + `stepTouch`), script filter, region/ray query surface for Lua, fallen-part cleanup, streaming/filtering/experimental-solver toggles, distributed-game-time broadcaster, and terrain holder. Defines `struct TouchPair` and free `hash_value`.

## Declared API

- `struct TouchPair { enum Type {Touch, Untouch}; shared_ptr<PartInstance> p1, p2; Type type; SystemAddress originator; inline ==; }` + `std::size_t hash_value(const TouchPair&)` — the unit pumped through [PhysicsService.md](PhysicsService.md) touch lists.
- Static debug flags: `showWorldCoordinateFrame, showHashGrid, showEPhysicsOwners, showEPhysicsRegions, showStreamedRegions, showPartMovementPath, showActiveAnimationAsset` (all "default is false"); `static float gridSizeModifier`.
- Descriptors: `prop_StreamingEnabled`, `prop_ExperimentalSolverEnabled`, `prop_ExpSolverEnabled_Replicate`, `prop_FilteringEnabled`, `prop_allowThirdPartySales`, `prop_physicalPropertiesMode(EnumPropDescriptor<PhysicalPropertiesMode>)`.
- Feature toggles: inline `getNetworkStreamingEnabled()` / setter; inline get/setExperimentalSolverEnabled + `bool experimentalSolverIsEnabled()` ("getter for script accessibility") + ExpSolverEnabled_Replicate pair; `getUsingNewPhysicalProperties()`; PhysicalPropertiesMode get/set + `setPhysicalPropertiesModeNoEvents(mode)`; FallenPartDestroyHeight get/set; inline get/setNetworkFilteringEnabled; inline get/setAllowThirdPartySales.
- Context helpers (statics): `findTopInstance(Instance*)` ("top level Instance ... right below the workspace"), `findWorkspace/findConstWorkspace`, `getWorldIfInWorkspace/getContactManagerIfInWorkspace/getWorkspaceIfInWorkspace`, inline-commented `contextInWorkspace(context)`; `serverIsPresent/clientIsPresent(const Instance*)` ("shortcut for Network::Players::...").
- Joining/drag: `joinToOutsiders(items, AdvArrowToolBase::JointCreationMode)`, `unjoinFromOutsiders(items)`; `startDecalDrag(Decal*, InsertMode)`, `startPartDropDrag(const Instances&, bool suppressPartsAlign=false)`; `joinAllHack()` ("Joins all primitives — called after a file read"); `makeJoints/breakJoints(instances)`.
- Terrain: `createTerrain()/clearTerrain()/setTerrain(Instance*)/getTerrain()`.
- Studio grid widgets: inline get/setShow3DGrid, get/setShowAxisWidget.
- Mouse commands ("TODO: refactor: Move into ToolManager Service"): inline `getCurrentMouseCommand()` (asserts non-null); `cancelMouseCommand()`; `setMouseCommand(shared_ptr<MouseCommand>, bool allowPluginOverride=false)`; `setDefaultMouseCommand()/setNullMouseCommand()`; private members currentCommand/stickyCommand/idleMouseEvent + `updatePlayerMouseCommand()`; `ContentId getCursor()` ("based on current mouse command").
- Input handling: override `GuiResponse process(const shared_ptr<InputObject>&)`; right/middle-mouse pan tracking with cancel/getters (in-header "UGLY place to put this" comment); `onWrapMouse(Vector2)`; `GuiResponse handleSurfaceGui(event)`; lastSurfaceGUI weak ref ("used by SG to track certain cases of mouse event processing").
- Camera: ICameraOwner overrides `getCamera()/getConstCamera()`; `getCurrentCameraDangerous()` ("internal pointer ... could be NULL"), `setCurrentCamera(Camera*)`; `requestFirstPersonCamera(bool firstPersonOn, bool cameraTransitioning, int controlMode)`; `replenishCamera()`; private currentCamera/utilityCamera ("not shown in tree"); thumbnail/video: `bool setImageServerView(bool bIsPlace)`, PUBLIC field `int imageServerViewHack` ("super hack - renders all hopper bins full screen"), `zoomToExtents()`.
- Queries/rendering: `findPartsInRegion3(Region3, ignoreDescendent|ignoreDescendents, int maxCount)` ×2 + matching `isRegion3Empty` ×2; template `getRayHit<IgnoreType>(RbxRay, ignore, bool terrainCellsAreCubes=false, bool ignoreWaterCells=false) → Tuple` (documented layout: result[0]=part, result[1]=intersection point); `append3dSortedAdorn(sortedAdorn)`; IAdornable render2d/render3dAdorn + EMPTY render3dSelect override ("override ModelInstance and do nothing"); `getAdornableCollector()`; `hasModalGuiObjects()`; `forceDrawConnectors()`; `selectAllTopLevelRenderable()`.
- Extents/scripts: IScriptFilter `scriptShouldRun(BaseScript*)`; `computeExtentsWorldSlow()` inline → RootInstance::computeExtentsWorld(); `computeExtentsWorldFast()`; PRIVATE override computeExtentsWorld asserts `computeNumParts() < 25` ("make sure nobody is calling this directly on the workspace?") then delegates; `getCameraOwnerModel() {return this;}`.
- Lifecycle/physics: ctor `Workspace(IDataState*)`, dtor; `getWorld()` const/non-const over inherited auto_ptr; `getDataState()`; heartbeat connection + `onHeartbeat`; `start()/stop()/reset()/assemble()`; `updatePhysicsStepsRequiredForCyclicExecutive(float timeInterval)`; `float physicsStep(bool longStep, float timeInterval, int numThreads)`; `handleFallenParts()/updateDistributedGameTime()` (private); `doNothing(bool value) {}` (public no-op!); `clearEmptiedModels/detachParent` (private).
- Stats/time: load-timing triple statsSyncHttpGetTime/statsXMLLoadTime/statsJoinAllTime with get+set pairs and `getStatsFileTimeTotal()`; `getDistributedGameTime()/setDistributedGameTime(double)/setDistributedGameTimeNoTransmit(double)` — in-header "Hack - replace with some Rackspace concept. Should only be broadcast from server to clients"; `getRealPhysicsFPS(void)`, `getPhysicsThrottling(void)`, `getNumAwakeParts(void)`.
- Signals/profilers/analyzer: PUBLIC profiler scoped_ptrs `profileDataModelStep/profileWorkspaceStep/profileWorkspaceAssemble`; signals `stepTouch<void(const TouchPair&)>` ("called for each touch on a step") and `currentCameraChangedSignal<void(shared_ptr<Camera>)>`; PUBLIC `float renderingDistance`; physics analyzer block: `setPhysicsAnalyzerBreakOnIssue(bool)/getPhysicsAnalyzerBreakOnIssue()`, signal `luaPhysicsAnalyzerIssuesFound<void(int)>`, `shared_ptr<const Instances> getPhysicsAnalyzerIssue(int group)`.
- Overrides: `askAddChild`, `onDescendantAdded/onDescendantRemoving`, `onServiceProvider`.

## Gotchas

- Per project recon: **Workspace ships deliberately deceptive kernel stats** — physics telemetry surfaces here are not trustworthy; verify against certified findings before consuming numbers from getRealPhysicsFPS/getNumAwakeParts paths.
- computeExtentsWorld on Workspace is deliberately booby-trapped with an assert (<25 parts) — use Slow/Fast variants.
- imageServerViewHack and doNothing are admitted cruft kept public.
- distributedGameTime is flagged in-header as a hack that should only be broadcast server→clients.
- Mouse-command stack supports plugin override flag and sticky commands — ordering rules live out-of-line.

## UNKNOWN

- Exact cyclic-executive step accounting in updatePhysicsStepsRequiredForCyclicExecutive (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Workspace.md](../../v8datamodel/Workspace.md).
- Base: [RootInstance.md](RootInstance.md), [ModelInstance.md](ModelInstance.md); touch pump consumer: [PhysicsService.md](PhysicsService.md); camera: [Camera.md](Camera.md); queries consumers: Lua surface docs; terrain: [TerrainRegion.md](TerrainRegion.md).
