# DataModel.cpp

## Purpose

Implements `DataModel` ("DataModel", Super name "Game") — the root Instance/ServiceProvider/place container: service bootstrap, the LegacyLock task-marshaling machinery over GenericJob queues, place/universe identity, save/load pipelines, HTTP endpoints, the full input event waterfall (accelerators → gui target → core gui → gamepad → ContextActionService → player gui → camera → workspace), render passes 2D/3D-adorn + mouse cursor, physics stepping with cyclic-executive throttles, metrics/stats string formatting (including deliberate decoys), and shutdown sequencing.

## Key types and API

Descriptors:
- `func_loadPlugins("LoadPlugins", Security::Roblox)` — body THROWS "load plugins not supported".
- `event_ItemChanged("ItemChanged", "object","descriptor")` on itemChangedSignal.
- Studio/RCC/test-only: `getContentFunctionOld("get", Security::LocalUser)` and `getContentFunction("GetObjects", Security::Plugin)` → fetchAsset; `sanitizeFunction("ClearContent", Security::LocalUser)`.
- `savePlaceAsyncFunction("SavePlace", "saveFilter"[SAVE_ALL], Security::None)` — server-script gated at runtime.
- LocalUser: `LoadWorld(assetID)`, `LoadGame(assetID)`, `Load(url)`, `SetRemoteBuildMode`, `SetServerSaveUrl`, `ServerSave`, `SetMessage/ClearMessage/SetMessageBrickCount`, `SetScreenshotInfo/SetVideoInfo`, `AddStat/RemoveStat/SaveStats`, `SetVIPServerId/SetVIPServerOwnerId`, `Shutdown` (close), `ToggleTools`, `SetJobsExtendedStatsWindow`.
- `kHttpPermission = Security::RobloxScript`: `HttpGetAsync`, `HttpPostAsync(url,data,contentType["*/*"])`, `HttpGet(url, synchronous[false])`, `HttpPost(url,data,synchronous[false],contentType["*/*"])`.
- Plugin: `GetJobsInfo`, `GetJobsExtendedStats`, `GetJobTimePeakFraction(jobname,greaterThan)`, `GetJobIntervalPeakFraction(jobname,greaterThan)`, `SetPlaceVersion`, `SetPlaceId`+deprecated `SetPlaceID`, `SetGameInstanceId`, `SetUniverseId`, `SetCreatorId`+deprecated `SetCreatorID(creatorId,creatorType)`, `SetGenre`, `SetGearSettings(genreRestriction,allowedGenres)`.
- RobloxScript: `ReportMeasurement`, `ReportInGoogleAnalytics(category,action,label,value[0])`, `prop_isPersonalServer("IsPersonalServer", SCRIPTING)`, `prop_canSaveLocal("LocalSaveEnabled", UI, read-only)`, `SaveToRoblox`, callback `requestShutdownCallback("RequestShutdown")`, `FinishShutdown(localSave)`.
- Props: prop_Workspace("Workspace", UI, read-only) + deprecated lowercase alias; DataModel::prop_lighting("lighting", deprecated); prop_placeId("PlaceId"), prop_placeVersion("PlaceVersion"), prop_creatorId("CreatorId"), `prop_forceR15("ForceR15", REPLICATE_ONLY, **Security::Roblox**)`; enum props CreatorType/Genre/GearGenreSetting; prop_getJobId("JobId"); desc_VIPServerId/VIPServerOwnerId read-only.
- Events: allowedGearTypeChanged, graphicsQualityChangeRequest(betterQuality), event_GameLoaded("Loaded"), IsLoaded(), onClose callback ("OnClose" — second assignment throws "OnClose is already set").

Enums registered: CreatorType {User, Group}; Genre {All, TownAndCity, Fantasy, SciFi, Ninja, Scary, Pirate, Adventure, Sports, Funny, WildWest, War, SkatePark, Tutorial}; GearGenreSetting {AllGenres, MatchingGenreOnly}; GearType {MeleeWeapons…Transport ×9}; SaveFilter {SaveAll, SaveWorld, SaveGame}.

Statics/tunables: `throttleAt30Fps(true)` static, `sendStats/perfStats` anti-cheat flips, exe `hash`, `loaderFunc`, `BlockingDataModelShutdown(true)`, DFInt OnCloseTimeoutInSeconds(30), SavePlacePerMinute throttle; flags UserBetterInertialScrolling(false), AllowHideHudShortcut(false)+Default(true), ProcessAcceleratorsBeforeGUINavigation, DontProcessMouseEventsForGuiTarget, CloseStatesBeforeChildRemoval, MaterialPropertiesEnabled, DataModelProcessHttpRequestResponseOnLockUseSubmitTask(true), RelativisticCameraFixEnable(true).

Core machinery:
- `GenericJob` per TaskType ("Write Marshalled"/"Read Marshalled"/"None Marshalled", non-cyclic): timestamped task queue; sleepTime 0 when queued else max; error = head_wait·(1+n)/2 marked urgent — source comment admits error calc "IS GARBAGE" for LegacyLock use.
- `LegacyLock::Implementation` — marshals a proxy task onto the job's queue, waits acquiredLock event, takes scoped_write_transfer for Write; re-entrancy via thread_specific_reference currentJob; Events pool recycled. Impersonator variant fakes currentJob for a scope.
- Lifecycle: createDataModel→doDataModelSetup (jobs, initializeContents, LoadingScript CoreScript executed ASAP in new thread under RobloxGameScript_ unless custom teleport loading GUI); closeDataModel waits onCloseCallback up to OnCloseTimeoutInSeconds (skipped when client present), then doCloseDataModel (disable ChangeHistory, raiseClose, remove players, clearContents, unlockParent all children, reset workspace/run/starter services/guiRoot, clearServices, remove generic jobs blocking-or-not).
- `initializeContents` pre-creates ~35 services incl. CSG dictionaries, LogService, ContentProvider(+Filter), KeyframeSequenceProvider, GuiService, Chat/Marketplace/Points/Ad/Notification, ReplicatedFirst, HttpRbxApiService, StarterPlayer/Pack/Gui, CoreGuiService (+RobloxScreenGui + teleport loading GUI clones), RunService, SoundService, default MouseCommand, then Joints/Collection/Physics/Badge/Geometry/Friend/RenderHooks/Insert/Social/GamePass/Debris/ScriptInformationProvider/Cookies/Teleport/PersonalServer/Players/UserInput/ContextAction/Script/Asset.
- Input waterfall (`processEvent` order, first sink wins): profiler → accelerators (before-GUI flag) → guiTarget (TextBox/GuiLayerCollector special-case) → legacy guiRoot → CoreGui → keyboard-as-gamepad-selection → core gamepad → ContextActionService core bindings → accelerators (default position) → PlayerGui (records mouseOverInteractable GuiButton/TextBox) → dev gamepad → ContextActionService dev bindings → camera commands (wheel zoom; inertial-scrolling path calls camera->zoom(position.z)) → workspace process for public non-touch events; returns wasSunk BEFORE workspace handoff; right-mouse-up cancels pan; idle detection pings Player::onLocalPlayerNotIdle; processInputObject additionally feeds local player's Mouse update/cacheInputObject.
- Accelerator keys: i/o zoom, ,/. pan, PgUp/Dn tilt, Backspace drop tools, "=" drop accoutrements, F1 Help/Shift-Stats, Shift-F2/F3/F4/F5/F6 Render/Network/Physics/Summary/Custom stats, F7 hide-HUD (first use notifies via GuiService), Ctrl-F8 kernel dump, Shift-F10 quality, F11 fullscreen, F12 record, PrintScreen screenshot, Alt freelook hold, Escape menu.
- Rendering: renderPass2d (gui inset → workspace 2D → PlayerGui/StarterGui → CoreGui → guiRoot debug → mouse cursor texture centered on pointer; hidden entirely under AllowHideHudShortcut toggle); renderPass3dAdorn (workspace + PlayerGui/CoreGui append3dSortedAdorn sorted by depth; ePhysics/streamed-region/part-movement-path debug overlays); getRenderMouseCursor falls back through UIS defaults/workspace cursor.
- Physics: physicsStep computes cyclic n-steps (30 fps throttle can return 0), long/even-step alternation, updatePhysicsInstructions per GameMode sets SimSendFilter mode + duty percents (CLIENT/WATCH zero duty false), DPHYS_CLIENT builds client region + checks bandwidth/buffer health; assemble before step; DPHYS_GAME_SERVER records movement history every 4th step.
- renderStep: earlyRenderSignal → RelativisticCameraFix double-step hack (camera->step(dt), UIS onRenderStep, camera->step(0) — DE9363 SurfaceGui raycast comment "perhaps for eternity") → renderStepped → camera stepSubject.
- Save/load: loadContent (re-entrancy guarded twice with GA error events, Serializer.load + linked scripts + joinAllHack + material migration + terrain create + workspaceLoadedSignal); loadWorld/loadGame wipe complementary containers; fetchAsset loads into fresh Instances list; saveToRoblox requires Visit uploadUrl starting "http"; serverSavePlace posts to ide/publish/UploadExistingAsset?assetId&isAppCreation=true.
- Metrics: getMetric/getMetricValue giant name-dispatch over tempMetric/runService/networkMetric/Stats tree (RakNet ping/kBps, In*/Out* composite strings, kernel counts, energies); final decoys: "solverIterations"/"matrixSize" return fakeDeceptiveSolverIterations/fakeDeceptiveMatrixSize ("these are here for fun and to throw off the competition!").
- Identity: setPlaceID runs PlaceFilter_ flag overrides via FLog::ForEachVariable, sets ScriptContext robloxPlace, statics Http::placeID/analytics; setUniverseId triggers R15 game-start-info fetch (r15Morphing JSON → setForceR15) gated backendProcessing.
- Hack-flag canary `allHackFlagsOredTogether()` VMProtect-wrapped OR of registered flags (non-studio only).
- scoped_write_request/read_request/write_transfer — debug-validated lock bookkeeping (asserts write_requested==1 etc.).

## Usage / reflection touchpoints

Root of every doc in this folder (services created here link their own pages); locks interop with [DataModelJob](DataModelJob.md)/[BaseRenderJob](BaseRenderJob.md); input consumers [UserInputService](UserInputService.md)/[ContextActionService](ContextActionService.md)/[Workspace](Workspace.md); GUI pipeline [PlayerGui](PlayerGui.md)/[GuiBuilder](GuiBuilder.md)-adjacent.

## Gotchas

- HttpGet/Post synchronous=false fires and DISCARDS results except logging errors — async-looking API that returns "" immediately.
- LegacyLock on the MAIN thread (mainThreadId captured at setup) is expected-but-unasserted (assert commented out) — recursive main-thread locking relies on thread-specific currentJob tracking only.
- The loading screen script executes OUTSIDE any game security context boundary noted here — RobloxGameScript_ identity from CoreScript::fetchSource("LoadingScript").
- getMetric returns "?" for unknown names but getMetricValue THROWS — inconsistent failure modes between the two stat surfaces.
- numInstances counting happens in onDescendantAdded/Removing — instances added while not under this DataModel root aren't tracked until reparented under it.
