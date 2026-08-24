# App/include/v8datamodel/DataModel.h

## Purpose

`DataModel` — the game container ("game" tree root, non-creatable ServiceProvider): owns services (Workspace, GUI stack, run/user-input services), the job arbiter and write-lock discipline, place/creator identity, save/load pipeline, HTTP helpers, hack-flag telemetry sets, input processing, and render hooks. The central object every subsystem reaches via `DataModel::get(instance)`.

## Declared API

`class DataModel : public IMetric, public IDataState, public VerbContainer, public Diagnostics::Countable<DataModel>, public DataModelArbiter, public DescribedNonCreatable<DataModel, ServiceProvider, sDataModel>`

- Enums: `CreatorType {CREATOR_USER=0, CREATOR_GROUP=1}`; `Genre {GENRE_ALL..GENRE_TUTORIAL}` (bitmask test documented in comment); `GearGenreSetting {ALL, MATCH}`; `GearType {MELEE_WEAPONS..PERSONAL_TRANSPORT}`; `RequestShutdownResult {CLOSE_NOT_HANDLED, CLOSE_REQUEST_HANDLED, CLOSE_LOCAL_SAVE, CLOSE_NO_SAVE_NEEDED}`.
- Free helper: `robloxScriptModifiedCheck(Security::Permissions)` — non-studio builds require RobloxScript permission else throw.
- Lifecycle: `postCreate()`, `static createDataModel(bool startHeartbeat, Verb* lockVerb, bool shouldShowLoadingScreen)`, `static closeDataModel(shared_ptr<DataModel>)`, `~DataModel()`, `DataModel(Verb* lockVerb)`, `static DataModel* get(Instance*)` (+const), `loadGame(assetID)/loadWorld(assetID)/loadContent(ContentId)`, `processAfterLoad()`, `clearContents(bool resettingSimulation)`, `close()`, `raiseClose()`; `bool isClosed()` (= !isInitialized); statics `BlockingDataModelShutdown`.
- Identity: creatorID/creatorType, `placeID` (HeapValue<int>), `getPlaceIDOrZeroInStudio()`, `setPlaceID(int, bool robloxPlace)`, universeId (+promise `universeDataLoaded`), gameInstanceID, placeVersion, VIP server id/owner, genre/gear settings (`isGearTypeAllowed(GearType)`).
- Mode flags: `isStudio()/setIsStudio`, `isRunMode()/setIsRunMode`, remoteBuildMode, personal server, forceR15, gameLoaded state + signal.
- Concurrency: nested `scoped_write_request/scoped_read_request/scoped_write_transfer` RAII guards over volatile counters `write_requested/read_requested/writeRequestingThread`; `currentThreadHasWriteLock()` member+static; `class LegacyLock` with nested `Impersonator` and `static int mainThreadId`, `static bool hasLegacyLock(DataModel*)`; `submitTask(Task, DataModelJob::TaskType)`; GenericJob pool per TaskType (`tryGetGenericJob/getGenericJob` under mutexes).
- Jobs/metrics: `getJobsInfo()`, `setJobsExtendedStatsWindow(double)`, `getJobsExtendedStats()`, `getJobTimePeakFraction(name, greaterThan)`, `getJobIntervalPeakFraction(...)`; IMetric `getMetric/getMetricValue`; `getSmoothFps()`, `getGameTime()`.
- Hack telemetry (anti-tamper): mutex-guarded `hackFlagSet` + static bitmasks `perfStats`/`sendStats`; `__forceinline addHackFlag/removeHackFlag/isHackFlagSet(unsigned int)` ("important ... for security reasons... single point of attack"), `allHackFlagsOredTogether()`.
- Save/load: `canSaveLocal()`, `saveToRoblox(resume,error)`, `save(ContentId)`, `static canSave(const Instance*)`, `serializeDataModel(SaveFilter=SAVE_ALL)`, `serverSavePlace(SaveFilter, resume, error)`, `uploadPlace(url, filter, resume, error)`, `savePlaceAsync(...)` virtual, `setServerSaveUrl/serverSave`, internal save pair; nested `SerializationException`; `requestShutdown(useLuaShutdownForSave=true) → RequestShutdownResult`; `completeShutdown(bool saveLocal)`; `CloseCallback onCloseCallback` + change hook; `requestShutdownCallback`; `saveFinishedSignal`.
- HTTP: `httpGetAsync/httpPostAsync(url, data, optionalContentType, resume, error)`, sync `httpGet(url, bool synchronous)/httpPost(...)`, static `HttpHelper`, `processHttpRequestResponseOnLock`, private doHttpGet/doHttpPost pairs, `reportMeasurement(id,k1,v1,k2,v2)`, `luaReportGoogleAnalytics(category, action, label, value)`.
- Input/GUI: `processInputObject(shared_ptr<InputObject>)`, `processWorkspaceEvent`, protected `processEvent/processProfilerEvent/processDevGamepadEvent/processCoreGamepadEvent/processGuiTarget`, `GuiRoot* getGuiRoot()`, `guiTargetInstance`, mouse-over tracking (`getMouseOverInteractable`, `mouseOverGui`), `setForceArrowCursor`, `numChatOptions() {return 4;}`, accelerators/camera-command processors, screenshot trio of static tasks (`TakeScreenshotTask/ScreenshotReadyTask/ScreenshotUploadTask`), SEO info strings for screenshots/video, custom stats (`addCustomStat/removeCustomStat/writeStatsSettings`), UI message plumbing.
- Rendering passes: `renderPass2d(Adorn*, IMetric*)`, `renderPass3dAdorn(Adorn*)`, `renderMouse/renderPlayerGui/renderGuiRoot(Adorn*)`, `computeGuiInset`, `getRenderMouseCursor()`, physics/render stepping `float physicsStep(float timeInterval, double dt, double dutyDt, int numThreads)`, `void renderStep(float timeIntervalSeconds)`, `renderGuisActive`.
- Core scripts/plugins: `loadCoreScripts(const std::string& altStarterScript = "")`, `startCoreScripts(bool buildInGameGui, altStarterScript="")`, `loadPlugins()`, `checkFetchExperimentalFeatures()`, core-script-loaded flag; `static setLoaderFunction(function<void(DataModel*)>)`.
- Signals: screenshot set, graphics-quality shortcut, allowedGearTypeChanged, `InputObjectProcessed<void(const shared_ptr<InputObject>&)>`, workspaceLoaded/gameLoaded, itemChanged "fired anytime anything in the DataModel changes" `itemChangedSignal<void(shared_ptr<Instance>, const Reflection::PropertyDescriptor*)>`.
- Misc: `jobId`, `static std::string hash` ("hash of the client exe"), MouseStats averages, suppressNavKeys (delegates to Game when present), `physicsInstructions` (see [PhysicsInstructions.md](PhysicsInstructions.md)), GuiBuilder member, deprecated lighting ref prop, `fetchAsset` gated to Studio/RCC-security/test builds.

## Gotchas

- The class is simultaneously ServiceProvider, arbiter, verb container, metric source, and lock owner — nearly every engine path touches it.
- Anti-tamper surface lives here: hackFlag APIs are deliberately inlined + VMProtect-noted; decoy flags feed perfStats/sendStats (see certified M–Z findings on deceptive stats).
- `isShuttingDown`/`dirty` are plain volatile, not atomics.
- `placeID`/`creatorID` use HeapValue<int> sentinel semantics (unset vs 0).
- Static mutable globals: hash, loaderFunc, throttleAt30Fps, BlockingDataModelShutdown.

## UNKNOWN

- Exact TaskType exclusivity matrix contents (`DataModelArbiter::lookup` table populated in .cpp — see [DataModel.md](../../v8datamodel/DataModel.md)).

## Cross-links

- Implementation: [App/v8datamodel/DataModel.md](../../v8datamodel/DataModel.md).
- Job layer: [DataModelJob.md](DataModelJob.md), [BaseRenderJob.md](BaseRenderJob.md); identity/services: [Game.h](Game.md) (Game), [Workspace.md](Workspace.md), [ChangeHistory.md](ChangeHistory.md).
