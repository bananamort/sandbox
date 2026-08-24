# App/include/v8datamodel — Headers Index, N–Z (part 2 of 2)

Per-header documentation for the N–Z slice of `App/include/v8datamodel/*.h`. Every entry below had its header FULLY read via tool call before its `.md` was written. Same-named implementation docs at [App/v8datamodel/](../../v8datamodel/) are linked rather than re-derived. Part 1 (A–M) is covered by the sibling index.

Legend: ⚠ = notable gotcha worth knowing before touching the class; 🔒 = no same-named certified implementation doc exists (header-only coverage).

## N

- [NonReplicatedCSGDictionaryService](NonReplicatedCSGDictionaryService.md) — non-replicated CSG blob store for PartOperations ([impl](../../v8datamodel/NonReplicatedCSGDictionaryService.md))
- [NotificationService](NotificationService.md) — scheduled-notification relay service (4 signals, methods just fire them)
- [NumberRange](NumberRange.md) — {min,max} float value type; `#undef min/max` on include
- [NumberSequence](NumberSequence.md) — ≤20-keypoint (time,value,envelope) animation curve; resample packs Vector2 as {min,max}
- [ParallelRampInstance](ParallelRampInstance.md) — PARALLELRAMP part tag; dead unless `_PRISM_PYRAMID_`

## P

- [ParametricPartInstance](ParametricPartInstance.md) — RBX::PART namespace base + creatable Wedge
- [PartCookie](PartCookie.md) — cached decoration bit-flags per part + inline mesh/humanoid helpers ("LAST child" rule)
- [PartDragger](PartDragger.md) 🔒 — Tool-derived dragger that is a hollow shell: everything commented out
- [PartInstance](PartInstance.md) ⚠ — THE core part class: Primitive-backed physics state, surfaces, network ownership, interpolation, touch signals, resize/grid logic
- [PartOperation](PartOperation.md) ⚠ — CSG result part (Union/Negate subclasses); BinaryString blobs + Bullet leakage (`static` file-scope helper)
- [PartOperationAsset](PartOperationAsset.md) — Instance container for saved CSG payloads + Studio publish helpers
- [PathfindingService](PathfindingService.md) ⚠ — voxel A* service (pool-allocated maps, public `emptyCutoff` member) + Path result object
- [PersonalServerService](PersonalServerService.md) — personal-server rank/role web calls
- [PhysicsInstructions](PhysicsInstructions.md) ⚠ — duty-cycle throttle computer for DPhysics players (decoy hackFlag cluster)
- [PhysicsService](PhysicsService.md) — intrusive part registry + touch-pair swap lists for network senders
- [PhysicsSettings](PhysicsSettings.md) — GlobalAdvancedSettingsItem driving PartInstance's static debug bools
- [Platform](Platform.md) ⚠ — PlatformImpl template: ride-on Motor6D mounting by literal name match; "we don't ship right now"
- [PlatformService](PlatformService.md) ⚠ — console-platform bridge: giant enum set + pure-virtual IPlatformAPI (blocking calls, volatile-long guards)
- [PlayerGui](PlayerGui.md) ⚠ — four classes: BasePlayerGui (input routing/gamepad selection), PlayerGui, StarterGuiService (setCore/getCore), CoreGuiService
- [PlayerMouse](PlayerMouse.md) — Mouse + Icon property
- [PlayerScripts](PlayerScripts.md) — per-player script containers + default-scripts request/confirm handshake
- [PluginManager](PluginManager.md) ⚠ — Studio plugin singleton: Button/Toolbar/Plugin classes, per-DataModel state map, Lua entry point
- [PluginMouse](PluginMouse.md) — Mouse + dragEnterEventSignal
- [PointsService](PointsService.md) — rate-limited, batched legacy points awarding
- [Pose](Pose.md) — Keyframe joint transform node; self-including header
- [Posture](Posture.md) — CharacterActionType enum only
- [PrismInstance](PrismInstance.md) — prism part (sides 3–20); `_PRISM_PYRAMID_`-gated; PascalCase setters
- [PVInstance](PVInstance.md) — abstract spatial base: hitTest/extents/primaryPart contract + moveToPoint trio

## R

- [Remote](Remote.md) ⚠ — RemoteEvent/RemoteFunction + LatchedSignal (queues fires until first connect, replays them)
- [RenderHooksService](RenderHooksService.md) — renderer bridge interfaces (metrics/adorn/queue/shader reload)
- [ReplicatedFirst](ReplicatedFirst.md) ⚠ — early-replication container; two getters share one flag; unparentable
- [ReplicatedStorage](ReplicatedStorage.md) — shared client/server storage (hidden, replicated)
- [RightAngleRampInstance](RightAngleRampInstance.md) — ramp tag part; `_PRISM_PYRAMID_`-gated
- [RobloxReplicatedStorage](RobloxReplicatedStorage.md) — RobloxScript-security replicated container
- [RootInstance](RootInstance.md) ⚠ — game root owning V8World World; ALL insert-placement policy (RAW/TREE/3D_View modes)
- [Remote](Remote.md) — see above (alphabetical anchor)

## S

- [SafeChat](SafeChat.md) — safe-chat option tree singleton (not an Instance despite includes)
- [Scale9Frame](Scale9Frame.md) — 9-slice GuiObject (non-creatable)
- [ScreenGui](ScreenGui.md) ⚠ — top-level 2D window: buffered-viewport discipline, modal-button tracking, deprecated GuiMain
- [ScriptMouseCommand](ScriptMouseCommand.md) — MouseCommand adapter feeding a scriptable Mouse
- [ScriptService](ScriptService.md) — empty marker service
- [ScrollingFrame](ScrollingFrame.md) ⚠ — scrollable canvas: dual CanvasPosition setters, ScrollingDirection.XY ≠ X|Y, touch inertia buffers
- [Seat](Seat.md) ⚠ — SeatImpl template: SeatWeld-by-name seating, DFFlag-gated math variants, remote weld signals
- [Selection](Selection.md) ⚠ — selection service (copy-on-write list) + FilteredSelection<C> template + iterator adapters
- [SelectionBox](SelectionBox.md) — box outline PVAdornment
- [SelectionLasso](SelectionLasso.md) — lasso family; real getter typo `getHunanoid`
- [SelectionSphere](SelectionSphere.md) — sphere PVAdornment
- [ServerScriptService](ServerScriptService.md) — server script container + LoadStringEnabled toggle
- [ServerStorage](ServerStorage.md) — server-only storage container
- [SkateboardController](SkateboardController.md) — Lua-facing skateboard throttle/steer floats
- [SkateboardPlatform](SkateboardPlatform.md) ⚠ — Instance+KernelJoint hybrid skateboard: wheels, MoveState machine, gyro, BoundProp tuning
- [Sky](Sky.md) — skybox cube + celestial bodies (public TextureId fields)
- [SleepingJob](SleepingJob.md) — wake/sleep DataModelJob base with desired-FPS cadence
- [Smoke](Smoke.md) — legacy particle effect; Ui/raw setter pairs + clamps; Part-only parenting
- [SocialService](SocialService.md) — friends/group web queries over settable URLs
- [SolidModelContentProvider](SolidModelContentProvider.md) — CacheableContentProvider for SolidModel content
- [Sparkles](Sparkles.md) — legacy sparkle effect (+legacy color mapping)
- [SpawnLocation](SpawnLocation.md) ⚠ — spawn pad (PUBLIC mirrored fields) + SpawnerService player placement
- [SpecialMesh](SpecialMesh.md) ⚠ — SpecialShape: MeshType enum IS the XML encoding ("only append")
- [StarterPlayerService](StarterPlayerService.md) ⚠ — per-game default player/camera settings copied at spawn; GA telemetry hook
- [Stats](Stats.md) ⚠ — Stats::Item tree + StatsService reporting; hardcoded countersApiKey GUID, disabled POST path, bypass-throttle escape hatch
- [StudioPluginHost](StudioPluginHost.md) 🔒 — IStudioPluginHost/IHostNotifier pure interfaces (void* handles, `butonId` typo)
- [StudioTool](StudioTool.md) — Studio toolbar tool base (equip/activate signals)
- [StudioToolMouseCommand](StudioToolMouseCommand.md) — ScriptMouseCommand bound to a StudioTool
- [StudioToolVerb](StudioToolVerb.md) — Verb adapter toggling tool equip
- [Surface](Surface.md) ⚠ — per-face value object + static descriptor registry (friends of PartInstance)
- [SurfaceGui](SurfaceGui.md) ⚠ — GUI rendered onto a part face; StarterGui double-attach disambiguation hack
- [SurfaceSelection](SurfaceSelection.md) ⚠ — face-highlight adornment (decoy hackFlag site)

## T

- [Team](Team.md) — BrickColor-keyed team node
- [Teams](Teams.md) ⚠ — Teams service; getUnusedTeamColor has known iterator-invalidation UB (certified)
- [TeleportCallback](TeleportCallback.md) 🔒 — embedder teleport interface (url/ticket/script)
- [TeleportService](TeleportService.md) ⚠ — cross-place teleports; thread-shared `url` member (certified race), mostly-static state
- [TerrainRegion](TerrainRegion.md) — portable voxel region (mega or smooth grid) with packaged BinaryStrings
- [Test](Test.md) ⚠ — TestService (BOOST-style assertions, physics-config snapshot/restore, multiplayer collect) + Lua::ArgumentParser + deprecated FunctionalTest
- [TextBox](TextBox.md) — editable text: focus API, key-repeat machine, buffered text commit semantics
- [TextButton](TextButton.md) — GuiButton + GuiTextMixin
- [TextLabel](TextLabel.md) — GuiLabel + GuiTextMixin
- [TextService](TextService.md) ⚠ — font enums (non-contiguous FontSize!) + typesetter registry + GetTextSize
- [TextureContentProvider](TextureContentProvider.md) 🔒 — image CacheableContentProvider with injectable Image allocator
- [TextureTrail](TextureTrail.md) — textured strip between two parts; renderInternal shared with FloorWire
- [TimerService](TimerService.md) — game-time one-shot delay queue (heartbeat-drained sorted list)
- [Tool](Tool.md) ⚠ — THE game tool: backend/frontend ToolState machine, grip replication, special_equipped_signal replay-on-connect
- [ToolMouseCommand](ToolMouseCommand.md) — ScriptMouseCommand bound to a Tool (ClickDetector interception)
- [ToolsModel](ToolsModel.md) — Anchor/Lock model tools (sticky via shared_from(this))
- [ToolsPart](ToolsPart.md) ⚠ — Fill/Dropper/Material tools; paint state in CLASS STATICS
- [ToolsSurface](ToolsSurface.md) — surface-type paint tools family (doAction pattern; DecalTool cancelable)
- [TouchInputService](TouchInputService.md) — mutex-guarded touch buffer draining into InputObjects
- [TouchTransmitter](TouchTransmitter.md) ⚠ — debounced Touched/TouchEnded transmitter (decoy hackFlag site)
- [TweenService](TweenService.md) — legacy GuiObject tween stepper (weak_ptr set + status callback queue)
- [UndoRedo](UndoRedo.md) — EMPTY header (forward decls only); real machinery is ChangeHistory

## U

- [UserController](UserController.md) ⚠ — ControllerService + Controller (SDLK-mapped Button enum, warned not to serialize) + Humanoid/VehicleController
- [UserInputService](UserInputService.md) ⚠ — central input hub: five category mutexes + static InputEventsMutex, dangerousFireInputEvent vs fireInputEvent lock split, gesture/gamepad/motion/VR/mouse-icon stack

## V

- [Value](Value.md) ⚠ — whole Value* family; NumericValue XOR-obfuscates int/double storage under RBX_SECURE_DOUBLE; ConstrainedValue is Configuration-only
- [VehicleSeat](VehicleSeat.md) — SeatImpl<PartInstance>+KernelJoint vehicle seat (lookupFunction drive policy, parallel hinge arrays)
- [VirtualUser](VirtualUser.md) — scripted input automation + input recording to Lua source
- [Visit](Visit.md) — background ping thread + upload URL holder

## W

- [Workspace](Workspace.md) ⚠ — world container + physics stepping + mouse-command dispatch + TouchPair pump; deceptive kernel stats (certified); booby-trapped computeExtentsWorld; admitted hacks (imageServerViewHack, doNothing)

---

## Slice notes

- **Coverage**: all 97 headers with basenames N…Z under `App/include/v8datamodel/` were read verbatim and documented. Files written: 97 individual `.md` + this index.
- **No certified impl doc** (🔒, 6): PartDragger, Posture (enum-only, none expected), StudioPluginHost, TeleportCallback, TextureContentProvider, UndoRedo (empty shim). These docs carry explicit UNKNOWN markers instead of speculation.
- **Compile-time dead zones**: the entire `_PRISM_PYRAMID_` family (ParallelRamp/Prism/Pyramid/RightAngleRamp) does not exist unless that macro is defined.
- **Cross-cutting hazards** (from this half): decoy hackFlag cluster (SurfaceSelection/PhysicsInstructions/TouchTransmitter), deceptive Workspace kernel stats, TeleportService thread-shared `url`, Teams getUnusedTeamColor UB, Stats hardcoded credential + disabled POST — all corroborated against project recon notes and flagged in the relevant docs.
