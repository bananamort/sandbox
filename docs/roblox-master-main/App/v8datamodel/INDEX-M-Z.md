# INDEX-M-Z.md — v8datamodel M–Z doc roster

Per-file docs for every `roblox-sandbox/App/v8datamodel` source with basename starting M–Z.
Format: `Source.cpp` → doc link — one-line purpose. Docs marked *(pre-existing)* were written by an earlier wave; all others completed in the M–Z completion pass (2026-08 session, g5 resume #3).
A–L half is rostered separately (partial; separate writer). Note: `factoryregistration.cpp` and `legacy.cpp` sort under A–L (f/l) and belong to that half.

## M

- ManualJointHelper.md → [ManualJointHelper](ManualJointHelper.md) *(pre-existing)* — Studio manual-joint drag helper: contacting-pair discovery/classification overlays, ManualWeld/ManualGlue creation.
- MarketplaceService.md → [MarketplaceService](MarketplaceService.md) *(pre-existing)* — legacy purchase/prompt pipeline.
- MegaCluster.md → [MegaCluster](MegaCluster.md) *(pre-existing)* — classic voxel terrain part + grid serialization.
- Message.md → [Message](Message.md) *(pre-existing)* — legacy chat message instance.
- ModelInstance.md → [ModelInstance](ModelInstance.md) *(pre-existing)* — model container with primary-part semantics.
- Mouse.md → [Mouse](Mouse.md) *(pre-existing)* — legacy script mouse object.
- MouseCommand.md → [MouseCommand](MouseCommand.md) *(pre-existing)* — raycasting/cursor engine behind tools and Mouse.

## N

- NonReplicatedCSGDictionaryService.md → [NonReplicatedCSGDictionaryService](NonReplicatedCSGDictionaryService.md) *(pre-existing)* — local-only CSG blob dictionary.
- NotificationService.md → [NotificationService](NotificationService.md) *(pre-existing)* — notification surface.
- NumberRange.md → [NumberRange](NumberRange.md) *(pre-existing)* — min/max value type wrapper.
- NumberSequence.md → [NumberSequence](NumberSequence.md) *(pre-existing)* — keyframed numeric sequence type.

## P

- ParallelRampInstance.md → [ParallelRampInstance](ParallelRampInstance.md) *(pre-existing)* — ramp part variant (_PRISM_PYRAMID_-gated family).
- ParametricPartInstance.md → [ParametricPartInstance](ParametricPartInstance.md) *(pre-existing)* — parametric geometry part base.
- PartCookie.md → [PartCookie](PartCookie.md) *(pre-existing)* — bitflag cookies on parts (humanoid etc.).
- PartInstance.md → [PartInstance](PartInstance.md) *(pre-existing)* — the BasePart workhorse (surfaces, joints, sizing, touched signals).
- PartOperation.md → [PartOperation](PartOperation.md) — CSG union/negate base: mesh/physics data blobs, CollisionFidelity, Bullet lifecycle.
- PartOperationAsset.md → [PartOperationAsset](PartOperationAsset.md) — serialized union web asset + publishAll/publishSelection upload flows.
- PathfindingService.md → [PathfindingService](PathfindingService.md) — voxel A* ComputeRaw/SmoothPathAsync + Path object, throttled PathfindingJob.
- PersonalServerService.md → [PersonalServerService](PersonalServerService.md) — personal-server rank ladder (PrivilegeType), Promote/Demote, URL-configured web queries.
- PhysicsInstructions.md → [PhysicsInstructions](PhysicsInstructions.md) — cyclic-executive physics duty/throttle controller (+hackFlag6 decoy).
- PhysicsService.md → [PhysicsService](PhysicsService.md) — E-physics assembly tracking + touch send/receive buffering.
- PhysicsSettings.md → [PhysicsSettings](PhysicsSettings.md) — "Physics" debug-settings singleton fanning onto statics in other classes.
- Platform.md → [Platform](Platform.md) — Motor6D create/destroy replicated remote events only.
- PlatformService.md → [PlatformService](PlatformService.md) — console bridge: auth/friends/party/store/voice via injected IPlatformAPI.
- PlayerGui.md → [PlayerGui](PlayerGui.md) — FOUR classes: BasePlayerGui (input/nav/adorn), PlayerGui, StarterGuiService (SetCore bridge), CoreGuiService (RobloxGui).
- PlayerMouse.md → [PlayerMouse](PlayerMouse.md) — DescribedNonCreatable Mouse subclass for players (near-empty TU).
- PlayerScripts.md → [PlayerScripts](PlayerScripts.md) — THREE classes: per-player script container + StarterPlayerScripts default-script handshake + StarterCharacterScripts.
- PluginManager.md → [PluginManager](PluginManager.md) — FOUR classes: plugin singleton/Plugin/Toolbar/Button; CreatePlugin, CSG ops, settings persistence.
- PluginMouse.md → [PluginMouse](PluginMouse.md) — plugin mouse with DragEnter event.
- PointsService.md → [PointsService](PointsService.md) — batched server award-points API with rate limiting + PointsAwarded broadcast.
- Pose.md → [Pose](Pose.md) — animation pose tree node (CFrame/Weight/MaskWeight; easing flag-gated invisible).
- PrismInstance.md → [PrismInstance](PrismInstance.md) — "PrismPart" N-gon prism variant (_PRISM_PYRAMID_ gated).
- PVInstance.md → [PVInstance](PVInstance.md) — placeable-instance base: moveToPoint helpers, Feature-tag format shim, CoordinateFrame trap property.
- PyramidInstance.md → [PyramidInstance](PyramidInstance.md) — "PyramidPart" twin of prism (_PRISM_PYRAMID_ gated).

## R

- Remote.md → [Remote](Remote.md) — RemoteFunction + RemoteEvent client↔server transport, invocation ids, delayed queues, address validation.
- RenderHooksService.md → [RenderHooksService](RenderHooksService.md) — LocalUser render debug hooks (shader reload, queues, metrics, timing getters).
- ReplicatedFirst.md → [ReplicatedFirst](ReplicatedFirst.md) — early-replication container: loading-GUI removal, first LocalScripts, teleport arrival relay.
- ReplicatedStorage.md → [ReplicatedStorage](ReplicatedStorage.md) — shared-content container (ctor-only TU).
- RightAngleRampInstance.md → [RightAngleRampInstance](RightAngleRampInstance.md) — right-angle ramp variant (_PRISM_PYRAMID_ gated).
- RobloxReplicatedStorage.md → [RobloxReplicatedStorage](RobloxReplicatedStorage.md) — RobloxLocked engine storage twin.
- RootInstance.md → [RootInstance](RootInstance.md) — Studio root owning World: insert pipelines, insert-point math, service routing, waypoints.
- Remote cross-ref: none.

## S

- SafeChat.md → [SafeChat](SafeChat.md) — safechat.xml canned-chat tree singleton + code→utterance resolution.
- Scale9Frame.md → [Scale9Frame](Scale9Frame.md) — 9-slice prefix-rendered GuiObject (legacy ImageLabel slicing predecessor).
- ScreenGui.md → [ScreenGui](ScreenGui.md) — top-level 2D layer + GuiMain alias: viewport buffering, replicating absolute size/pos, modal registry.
- ScriptMouseCommand.md → [ScriptMouseCommand](ScriptMouseCommand.md) — MouseCommand wrapper feeding a Mouse instance for legacy scripts.
- ScriptService.md → [ScriptService](ScriptService.md) — name constant only (empty shell).
- ScrollingFrame.md → [ScrollingFrame](ScrollingFrame.md) — scrollable GuiObject: canvas model, bars, wheel accel, touch inertia, gamepad scroll, selection auto-scroll.
- Seat.md → [Seat](Seat.md) — sittable part: Occupant, Disabled, client weld replication debounce.
- Selection.md → [Selection](Selection.md) — Studio ordered selection service with ancestry auto-eviction + Get/Set/SelectionChanged.
- SelectionBox.md → [SelectionBox](SelectionBox.md) — wireframe+fill box adornment for parts/models.
- SelectionLasso.md → [SelectionLasso](SelectionLasso.md) — THREE classes: humanoid-tether cylinder lassos (Part/Point variants).
- SelectionSphere.md → [SelectionSphere](SelectionSphere.md) — sphere outline/fill adornment.
- ServerScriptService.md → [ServerScriptService](ServerScriptService.md) — server script container + LoadStringEnabled flag.
- ServerStorage.md → [ServerStorage](ServerStorage.md) — server-only content container (client add-child forbidden).
- SkateboardController.md → [SkateboardController](SkateboardController.md) — Throttle/Steer axes from touch/keyboard for SkateboardPlatform.
- SkateboardPlatform.md → [SkateboardPlatform](SkateboardPlatform.md) — rideable board: wheel hinges, force model, MoveState replication, mount/dismount camera flow.
- Sky.md → [Sky](Sky.md) — skybox cubemap faces, stars, sun/moon textures+sizes.
- SleepingJob.md → [SleepingJob](SleepingJob.md) — wake/sleep TaskScheduler job base with synthetic post-wake stats.
- Smoke.md → [Smoke](Smoke.md) — particle effect instance with UI/XML descriptor pairs and clamps.
- SocialService.md → [SocialService](SocialService.md) — configurable-endpoint social web queries + Stuff catalog enum.
- SolidModelContentProvider.md → [SolidModelContentProvider](SolidModelContentProvider.md) — 32 MB LRU cache parsing union asset blobs into render meshes.
- Sparkles.md → [Sparkles](Sparkles.md) — sparkle effect with lossy legacy Color mapping.
- SpawnLocation.md → [SpawnLocation](SpawnLocation.md) — TWO classes: spawn part (teams/forcefield/touch-team-change) + SpawnerService respawn selection & placement.
- SpecialMesh.md → [SpecialMesh](SpecialMesh.md) — MeshType enum mesh with auto-FILE_MESH on id assignment.
- Stats.md → [Stats](Stats.md) — StatsService reporting (post path deprecated/no-op!) + Stats::Item bound tree; signed remote gather-script bootstrap; hardcoded Influx creds.
- StarterPlayerService.md → [StarterPlayerService](StarterPlayerService.md) — "StarterPlayer" place defaults (camera/movement modes, zoom bounds), player stamping, GA recording.
- Surface.md → [Surface](Surface.md) — face-view struct + custom descriptors exposing 24 per-face properties on PartInstance.
- SurfaceGui.md → [SurfaceGui](SurfaceGui.md) — 3D face-projected GUI: per-face matrix, unprojected input, cookie lookup, StarterGui special case.
- SurfaceSelection.md → [SurfaceSelection](SurfaceSelection.md) — single-face highlight adornment (+hackFlag0 decoy).

## T

- Team.md → [Team](Team.md) — team entry (TeamColor/AutoAssignable; deprecated Score/AutoColorCharacters).
- Teams.md → [Teams](Teams.md) — team container: least-populated assignment, membership queries, GetTeams mirror (RebalanceTeams dead code).
- TeleportService.md → [TeleportService](TeleportService.md) — multi-place teleport API, PlaceLauncher polling thread, reserved servers, loading-gui sanitization, carryover statics.
- TerrainRegion.md → [TerrainRegion](TerrainRegion.md) — standalone terrain chunk (voxel OR smooth grid) with packaged binary blobs + ConvertToSmooth.
- Test.md → [Test](Test.md) — TWO classes: TestService harness (Run/assertions/macro rewriter/client result collection) + FunctionalTest shim.
- TextBox.md → [TextBox](TextBox.md) — editable text: buffered editing, focus lifecycle, repeat-key machine, paste, gamepad/touch interop.
- TextButton.md → [TextButton](TextButton.md) — clickable text label button (ContentFilter gated).
- TextLabel.md → [TextLabel](TextLabel.md) — static text label (transparency-fix background path behind flag).
- TextService.md → [TextService](TextService.md) — Font/FontSize enums registry + Typesetter provider + GetTextSize.
- TextureTrail.md → [TextureTrail](TextureTrail.md) — animated billboard texture stream between two parts.
- TimerService.md → [TimerService](TimerService.md) — heartbeat delay queue for engine callbacks.
- Tool.md → [Tool](Tool.md) — held-item state machine: handle touch pickup, RightGrip welds (R6/R15), Grip hacks, replicated Activate/Deactivate, input recording quirks.
- ToolMouseCommand.md → [ToolMouseCommand](ToolMouseCommand.md) — tool input binding: activate ordering vs TargetPoint replication, ctrl-click ClickDetector route.
- ToolsModel.md → [ToolsModel](ToolsModel.md) — THREE classes: Anchor/Lock hover-toggle studio commands over top-level instances.
- ToolsPart.md → [ToolsPart](ToolsPart.md) — Fill/Material/Dropper paint commands (static color/material state).
- ToolsSurface.md → [ToolsSurface](ToolsSurface.md) — twelve surface-paint tools rewriting face types/params + DecalTool drag placement.
- TouchInputService.md → [TouchInputService](TouchInputService.md) — platform-thread touch buffer marshaling into persistent InputObjects.
- TouchTransmitter.md → [TouchTransmitter](TouchTransmitter.md) — TouchInterest debounce of duplicate touch pairs (+hackFlag7 decoy).
- TweenService.md → [TweenService](TweenService.md) — legacy GuiObject tween stepping + completion callbacks.
- TweenService cross-ref: none.

## U

- UserController.md → [UserController](UserController.md) — FIVE classes: ControllerService, Controller BindButton API (broken Button string parser), Humanoid/Vehicle controllers, ButtonBindingWidget hints.
- UserInputService.md → [UserInputService](UserInputService.md) — central input hub: capability flags, queued event drain, core/gameplay split, gestures, keyboard state, gamepads, VR, crossed gamepad event wiring note.

## V

- Value.md → [Value](Value.md) — all twelve legacy Value objects (Int/Bool/Number/String/BinaryString/Vector3/Ray/CFrame/Color3/BrickColor/Object/×2 Constrained) in one TU.
- VehicleSeat.md → [VehicleSeat](VehicleSeat.md) — drivable seat: hinge discovery, torque lookup table, throttle/steer surface, HUD, CollectionService tag.
- VirtualUser.md → [VirtualUser](VirtualUser.md) — test input injection via virtual hardware device swap + Lua recorder (emits broken SetKeUp call).
- Visit.md → [Visit](Visit.md) — upload URL holder + silent keep-alive ping worker thread.

## W

- Workspace.md → [Workspace](Workspace.md) — world container: physics step facade, fallen-part deletion, touch reporting, MouseCommand machine, camera/terrain lifecycle, query API, network toggles, deceptive kernel stats.
