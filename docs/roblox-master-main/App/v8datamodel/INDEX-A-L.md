# INDEX-A-L.md — v8datamodel A–L doc roster

Per-file docs for every `roblox-sandbox/App/v8datamodel` source with basename starting A–L.
Format: `Source.cpp` → doc link — one-line purpose. Coverage verified `EXACT_1TO1_MATCH` against sources at index time (2026-08 session, A–L finisher pass); every entry below was written against a full tool-call read of its source.
Boundary note: `factoryregistration.cpp` and `legacy.cpp` sort under A–L (f/l) and are rostered here, as [INDEX-M-Z.md](INDEX-M-Z.md) itself directs.

## A

- Accoutrement.md → [Accoutrement](Accoutrement.md) — Hat/Accessory wearables: Handle weld-to-character, server five-state touch-equip machine, legacy HeadWeld vs attachment-matched AccessoryWeld path behind DFFlag.
- Adornment.md → [Adornment](Adornment.md) — PartAdornment/PVAdornment bases anchoring GuiBase3d overlays to a part or any PVInstance.
- AdService.md → [AdService](AdService.md) — touch-device video-ad pipeline: client play request, server web validation, impression/close reporting.
- AnimatableRootJoint.md → [AnimatableRootJoint](AnimatableRootJoint.md) — non-Instance IAnimatableJoint adapter letting animation pose the root part while physics stays active.
- Animation.md → [Animation](Animation.md) — thin asset-reference object resolving its KeyframeSequence via the provider.
- AnimationController.md → [AnimationController](AnimationController.md) — legacy non-Humanoid animation host forwarding ticks to a lazily created child Animator.
- AnimationTrack.md → [AnimationTrack](AnimationTrack.md) — Lua-facing handle over one playing animation wrapping AnimationTrackState.
- AnimationTrackState.md → [AnimationTrackState](AnimationTrackState.md) — DescribedNonCreatable engine object doing fade/weight/phase math plus remote replication of track operations.
- Animator.md → [Animator](Animator.md) — per-character animation engine: priority-ordered stepping, mask-weighted pose folding onto Motor joints, play/stop replication.
- ArcHandles.md → [ArcHandles](ArcHandles.md) — rotate-gizmo HandlesBase subclass with per-axis arc handles around an adornee.
- AssetService.md → [AssetService](AssetService.md) — server-side place/asset management web API surface (create/save/revert/permissions/list).
- Attachment.md → [Attachment](Attachment.md) — named pivot + orientation frame on parts with CFrame/World* reflection; entire TU inside an `#if 1` joint-schema gate.

## B

- Backpack.md → [Backpack](Backpack.md) — per-player carried-items container; one policy function encoding the BaseScript/LocalScript × local/backend run matrix.
- BadgeService.md → [BadgeService](BadgeService.md) — server badge award/query over injected web URLs with per-session caches.
- BaseRenderJob.md → [BaseRenderJob](BaseRenderJob.md) — TaskScheduler render-job base: cyclic-executive vs standard scheduling + FPS error policy (renders early for stability).
- BasicPartInstance.md → [BasicPartInstance](BasicPartInstance.md) — TWO classes: FormFactorPart (FormFactor enum owner) + BasicPartInstance (legacy Shape→geometry mapping).
- BevelMesh.md → [BevelMesh](BevelMesh.md) — DataModelMesh carrying Bevel/Roundness/Bulge scalars; pure data holder.
- BillboardGui.md → [BillboardGui](BillboardGui.md) — camera-facing quad GUI anchored to parts/models: placement math, ray hit-testing with occlusion, hide-from filtering, VR flag path.
- Bindable.md → [Bindable](Bindable.md) — BindableFunction/BindableEvent same-server-script pair (queued Invoke before callback; commented-out Property design under `#if 0`).
- BlockMesh.md → [BlockMesh](BlockMesh.md) — one-line TU: the sBlockMesh constant only; behavior header-side.

## C

- Camera.md → [Camera](Camera.md) — viewport camera: seven legacy CameraType behaviors, zoom/pan machinery, projection math, history stack, VR head-lock compositing.
- ChangeHistory.md → [ChangeHistory](ChangeHistory.md) — ChangeHistoryService undo/redo: instance deltas + terrain snapshots into named Waypoints with count/memory budgets and replay.
- CharacterAppearance.md → [CharacterAppearance](CharacterAppearance.md) — appearance family painting Humanoid bodies (ShirtGraphic/Clothing templates/Skin/BodyColors) with R15 name mapping.
- CharacterMesh.md → [CharacterMesh](CharacterMesh.md) — layers a mesh asset (base+overlay textures) onto one named R6/R15 body part.
- ChatService.md → [ChatService](ChatService.md) — registered "Chat": validated message broadcast + FilterStringForPlayerAsync web moderation call.
- ClickDetector.md → [ClickDetector](ClickDetector.md) — distance click/hover remote events on ancestor parts, gated by MaxActivationDistance.
- CollectionService.md → [CollectionService](CollectionService.md) — EARLY class-name-keyed bucket variant with copy-on-write lists — NOT the later tag-based service.
- ColorSequence.md → [ColorSequence](ColorSequence.md) — keyframed RGB gradient value type with strict validation and full reflection plumbing.
- Commands.md → [Commands](Commands.md) — dozens of Studio Verb subclasses driving toolbar/menu actions; pure verb plumbing, no Instance descriptors.
- CommonVerbs.md → [CommonVerbs](CommonVerbs.md) — aggregate struct that constructs the entire standard Studio verb set in one initializer list.
- Configuration.md → [Configuration](Configuration.md) — folder-like holder accepting ONLY IValue children, max one per parent, self-registering into CollectionService buckets.
- ContextActionService.md → [ContextActionService](ContextActionService.md) — client action-binding service: developer/core BindAction namespaces, touch-button metadata, PlayerActions enum.
- CookiesEngineService.md → [CookiesEngineService](CookiesEngineService.md) — "CookiesService" engine cookie jar Set/Get/Delete over the platform CookiesEngine file.
- CornerWedgeInstance.md → [CornerWedgeInstance](CornerWedgeInstance.md) — CornerWedgePart variant (_PRISM_PYRAMID_-gated, ctor-only).
- CSGDictionaryService.md → [CSGDictionaryService](CSGDictionaryService.md) — REPLICATED flyweight dictionary deduping union MeshData/PhysicsData blobs; CDN-strip path under CSGLoadFromCDN.
- CSGMesh.md → [CSGMesh](CSGMesh.md) — in-memory union triangle mesh + obfuscated "CSGMDL" serialization (XOR-scrambled, MD5+salt, VMProtect-wrapped hashing) + factory singleton.
- CustomEvent.md → [CustomEvent](CustomEvent.md) — source half of the legacy float-event pair: streaming value pushed to attached receivers.
- CustomEventReceiver.md → [CustomEventReceiver](CustomEventReceiver.md) — sink half of the pair; hosts anti-tamper decoy Security::hackFlag4 at file scope.
- CustomParticleEmitter.md → [CustomParticleEmitter](CustomParticleEmitter.md) — modern "ParticleEmitter" state bag (sequences/rates/motion/Emit bursts); simulation lives renderer-side.
- CylinderMesh.md → [CylinderMesh](CylinderMesh.md) — one-line TU: the sCylinderMesh constant only.

## D

- DataModel.md → [DataModel](DataModel.md) — root Game container: service bootstrap, LegacyLock task marshaling, input waterfall, render/physics stepping, save/load pipelines.
- DataModelJob.md → [DataModelJob](DataModelJob.md) — TaskScheduler Job base + DataModelArbiter whose exclusivity tables decide which job pairs may run in parallel.
- DataModelMesh.md → [DataModelMesh](DataModelMesh.md) — decorative-mesh base (Scale/VertexColor/Offset/per-axis LOD enums); alpha derived from parent-part transparency.
- DataStore.md → [DataStore](DataStore.md) — GlobalDataStore/OrderedDataStore/DataStorePages key-value persistence client with caches, throttles, OnUpdate refetching.
- DataStoreService.md → [DataStoreService](DataStoreService.md) — store-family container running a budget-refilling Write-duty DataModelJob plus latency analytics.
- DebrisService.md → [DebrisService](DebrisService.md) — timed item destruction via TimerService with FIFO cap (default 1000).
- DebugSettings.md → [DebugSettings](DebugSettings.md) — "Diagnostics"/"Task Scheduler" singletons: profiles, counters, profiling toggles; scheduler enum setters mostly NO-OPS.
- Decal.md → [Decal](Decal.md) — face-texture overlay + DecalTexture tiling + the full TextureId reflection template specialization set.
- DialogChoice.md → [DialogChoice](DialogChoice.md) — NPC dialog tree node: 48-char-hard-truncated user text, response/goodbye refs, restricted parenting.
- DialogRoot.md → [DialogRoot](DialogRoot.md) — "Dialog" conversation root: prompt/icon/distance state + server-authoritative choice replication; RCC-only exploit debugging block.

## E

- Effect.md → [Effect](Effect.md) — empty base-class TU for the Smoke/Fire/Sparkles family.
- Enums.md → [Enums](Enums.md) — shared Reflection enum registrations for descriptors living in other TUs (PartType, Style, SizeConstraint, ScaleType…).
- Explosion.md → [Explosion](Explosion.md) — one-shot blast: radius collection, Hit event, joint unjoining, radial impulse, terrain cratering, self-removal.
- ExtrudedPartInstance.md → [ExtrudedPartInstance](ExtrudedPartInstance.md) — climbable TrussPart: all-UNIVERSAL surfaces, Style enum, size constraints forcing an extruded shape.

## F

- FaceInstance.md → [FaceInstance](FaceInstance.md) — base for part-face-attached instances: NormalId Face property, Part-only parenting, face-highlight adorn.
- factoryregistration.md → [factoryregistration](factoryregistration.md) — type-registry bootstrap TU: 47 RBX_REGISTER_TYPE + 289 RBX_REGISTER_CLASS + 122 RBX_REGISTER_ENUM entries and FactoryRegistrator one-time setup.
- FastLogSettings.md → [FastLogSettings](FastLogSettings.md) — client FastLog/FastFlag variable definitions (~90 LOGVARIABLEs) + ClientAppSettings web-config singleton + JSON prefix dispatcher.
- Feature.md → [Feature](Feature.md) — hole/axle feature markers (Hole/MotorFeature) + VelocityMotor joining axle to hole primitives.
- FileMesh.md → [FileMesh](FileMesh.md) — DataModelMesh subclass adding MeshId/TextureId; two compare-then-raise setters.
- Filters.md → [Filters](Filters.md) — HitTestFilter predicate family for ray/occlusion queries (invisible/unlocked/character/descendants/merged…).
- Fire.md → [Fire](Fire.md) — classic fire particle effect: clamped UI setters over raw STREAMING storage, blue-fire negative Heat.
- Flag.md → [Flag](Flag.md) — CTF flag Tool subclass with TeamColor; server touch logic returns own-team flags to stands.
- FlagStand.md → [FlagStand](FlagStand.md) — CTF capture pad + FlagStandService stepping registered stands and placing returned flags.
- FloorWire.md → [FloorWire](FloorWire.md) — ground-hugging textured wire/cable adornment routed by raycasts (max 7 segments) with animated texture flow.
- FlyweightService.md → [FlyweightService](FlyweightService.md) — content-dedup base interning MD5-keyed BinaryStringValues and rewriting PartOperation fields to "CSGK"+hash keys.
- Folder.md → [Folder](Folder.md) — pure organizational container delegating ALL parenting rules to whatever it is parented under.
- ForceField.md → [ForceField](ForceField.md) — spawn-protection bubble consulted via partInForceField; legacy pulsing-sphere render disabled under RenderNewParticles2Enable.
- Frame.md → [Frame](Frame.md) — rectangular GuiObject with Style skins: custom background plus six hardcoded 9-slice presets.
- FriendService.md → [FriendService](FriendService.md) — in-server friend-graph state machine over canonicalized status pairs + web mirroring + GetFriendsOnline query.

## G

- Game.md → [Game](Game.md) — Game application shell + SecurePlayerGame/UnsecuredStudioGame variants: one-time global init, per-game DataModel creation, shutdown.
- GameBasicSettings.md → [GameBasicSettings](GameBasicSettings.md) — "UserGameSettings" per-user control/camera/movement prefs singleton; hosts hackFlag5 decoy.
- GamepadService.md → [GamepadService](GamepadService.md) — gamepad GUI-navigation engine: persistent keymaps (8 pads × 18 buttons), thumbstick decoding with deadzones/repeats.
- GamePassService.md → [GamePassService](GamePassService.md) — legacy per-server PlayerHasPass URL-template check; server-only at runtime (clients get warning + false).
- GameSettings.md → [GameSettings](GameSettings.md) — legacy "Game Options" preferences singleton (chat lengths, sound, video quality, Xbox overscan).
- GeometryService.md → [GeometryService](GeometryService.md) — "Geometry" native query facade over ContactManager: extents-overlap queries + filtered ray casts. No script surface.
- GlobalSettings.md → [GlobalSettings](GlobalSettings.md) — Settings/GlobalAdvancedSettings("GlobalSettings")/GlobalBasicSettings("UserSettings") XML-persistence once-per-process singletons.
- GroupService.md → [GroupService](GroupService.md) — web group queries (GetGroupInfoAsync, allies/enemies pages); hosts Security::hackFlag9 decoy.
- GuiBase.md → [GuiBase](GuiBase.md) — GUI class-hierarchy root; the TU is a name-taking constructor only.
- GuiBase2d.md → [GuiBase2d](GuiBase2d.md) — 2D GUI base: absolute rect twins, cascading resize/layout, recursive rendering, only-descendants-may-nest rule.
- GuiBase3d.md → [GuiBase3d](GuiBase3d.md) — 3D-world adornment base (Color3 + deprecated BrickColor alias, Transparency, Visible dirty-marking).
- GuiBuilder.md → [GuiBuilder](GuiBuilder.md) — constructs the entire legacy client HUD (stats panels ×7, chat/safe-chat tree, RightPalette, ControlFrame) into CoreGuiService.
- GuiLayerCollector.md → [GuiLayerCollector](GuiLayerCollector.md) — "LayerCollector" base: per-GUIQueue×ZIndex visible-descendant matrix, back-to-front rendering, reverse-z input dispatch, gamepad candidates.
- GuiObject.md → [GuiObject](GuiObject.md) — interactive 2D element base (UDim2 layout, scale-9/text render, full input state machine, tweening, replication) + GuiButton + inert GuiLabel.
- GuiService.md → [GuiService](GuiService.md) — client UI hub: insets, hotkeys, center-dialog priority stack, selection groups, SelectedObject bridging, VMProtect-guarded fullscreen verb.
- Gyro.md → [Gyro](Gyro.md) — the whole BodyMover force family (BodyGyro/Position/Velocity/AngularVelocity/Force/Thrust/RocketPropulsion) with PGS constraint paths behind flags.

## H

- HandleAdornment.md → [HandleAdornment](HandleAdornment.md) — scriptable 3D drag-handle base (adornee-relative placement, hit-testing, mouse replication) + six creatable shapes.
- Handles.md → [Handles](Handles.md) — classic face-based drag handles on a Part: Faces mask, four VisualStyles, drag-distance reporting.
- HandlesBase.md → [HandlesBase](HandlesBase.md) — PartAdornment base doing mouse-ray handle hit-testing and face-plane projection math for Handles/ArcHandles.
- HapticService.md → [HapticService](HapticService.md) — gamepad vibration: per-inputType/motor enable maps + Set/GetMotor Tuple state; actual actuation external.
- Hopper.md → [Hopper](Hopper.md) — legacy tool-bin family: BackpackItem/HopperBin (BinType, Active, replication shims) + Hopper/StarterGear/StarterPackService/LegacyHopperService containers.
- HttpRbxApiService.md → [HttpRbxApiService](HttpRbxApiService.md) — throttled API-proxy HTTP client with per-audience token buckets, queued over-budget requests, GA throttle telemetry.
- HttpService.md → [HttpService](HttpService.md) — user-facing HTTP + JSON service behind the HttpEnabled gate with per-minute throttling and a Roblox-Id place header.

## I

- ICharacterSubject.md → [ICharacterSubject](ICharacterSubject.md) — camera-subject interface mixin for characters: zoom bounds, first-person cutoff, mouse-lock offset.
- IEquipable.md → [IEquipable](IEquipable.md) — equip-weld mixin building the named Weld (humanoid part ↔ gadget) for Tool/Accoutrement.
- ImageButton.md → [ImageButton](ImageButton.md) — GuiButton rendering a GuiImageMixin image; forces DOWN_OVER gui state when a bound verb is selected.
- ImageLabel.md → [ImageLabel](ImageLabel.md) — GuiLabel rendering only its mixin image; separate background drawn only when BackgroundTransparency < 1.
- InputObject.md → [InputObject](InputObject.md) — input-event instance: UserInputType/KeyCode/Position/Delta reflection, dual old/new keyboard representations, key predicates.
- InsertService.md → [InsertService](InsertService.md) — asset-insertion pipeline: replicated insert requests, catalog queries, LoadAsset, deprecated legacy Insert().

## J

- JointInstance.md → [JointInstance](JointInstance.md) — Instance wrappers over V8World joints: Snap/Weld/ManualWeld/ManualGlue/Glue/Rotate/RotateP/RotateV/Motor/Motor6D.
- JointsService.md → [JointsService](JointsService.md) — mirrors world auto-joint lifecycle into JointInstance wrappers, maintains ownership across joint topology, implements studio drag-to-join.

## K

- Keyframe.md → [Keyframe](Keyframe.md) — time-positioned node holding a child Pose tree; invalidates the parent sequence cache on change.
- KeyframeSequence.md → [KeyframeSequence](KeyframeSequence.md) — animation clip container: sorted cache + pose interpolation engine with axis-angle lerping and flag-gated easing styles.
- KeyframeSequenceProvider.md → [KeyframeSequenceProvider](KeyframeSequenceProvider.md) — animation asset loader/cache: 100-entry LRU keyed by resolved URL + GetAnimations web query.

## L

- legacy.md → [legacy](legacy.md) — registers the SurfaceConstraint enum descriptor (None/Hinge/SteppingMotor/Motor); vocabulary otherwise unreferenced in the kept tree.
- Light.md → [Light](Light.md) — dynamic-light family (Light/PointLight/SpotLight/SurfaceLight): clamped Range/Angle setters, Part-only parenting, once-per-process GA tracking.
- Lighting.md → [Lighting](Lighting.md) — global lighting service: time-of-day clock, fog, ambient/outdoor model, Brightness/shadows, sun/moon direction queries, Sky-child tracking driving LightingChanged.
- LocalWorkspace.md → [LocalWorkspace](LocalWorkspace.md) — empty INTERNAL_LOCAL marker class whose contents never replicate; registered but unreferenced beyond build manifests.
- LoginService.md → [LoginService](LoginService.md) — thin frontend login prompts: PromptLogin/Logout firing internal signals; misnamed events carry username/error payloads.
- LogService.md → [LogService](LogService.md) — script-visible console pipe: 512-entry ring + MessageOut, sensitive-key redaction, server log streaming, kill-flagged ExecuteScript remote.
