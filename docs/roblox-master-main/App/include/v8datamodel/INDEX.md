# App/include/v8datamodel — Header Docs Index (A–M)

Per-header documentation of the v8datamodel public/data-model headers (basenames A through M). Each `<Name>.md` documents the header's declared API surface as read from source; behavior summaries link to the certified implementation docs under [App/v8datamodel/](../../v8datamodel/) where they exist. The N–Z half is covered by a sibling index in this directory.

**Scope**: 128 headers, `Accoutrement.h` … `MouseCommand.h` (includes lowercase `factoryregistration.h`, `legacy.h`). Boundary with the N–Z half falls between `MouseCommand.h` and `NonReplicatedCSGDictionaryService.h`.

## Roster

### A
- [Accoutrement](Accoutrement.md) — wearable base (state machine + attachment frame); Hat/Accessory creatables.
- [ActionStation](ActionStation.md) — header-only seat mixin: sleep/debounce timers, forced SEAT_SIZE primitive.
- [Adornment](Adornment.md) — PartAdornment/PVAdornment bases for 3D adornment overlays.
- [AdService](AdService.md) — INTERNAL video-ad verification/impression remote-signal service.
- [AnimatableRootJoint](AnimatableRootJoint.md) — IAnimatableJoint adapter for a character root part.
- [Animation](Animation.md) — asset-id handle resolving to a KeyframeSequence.
- [AnimationController](AnimationController.md) — legacy Lua wrapper owning an internal Animator.
- [AnimationTrack](AnimationTrack.md) — Lua-facing playback controller around an AnimationTrackState.
- [AnimationTrackState](AnimationTrackState.md) — engine-side fade/speed/priority state; per-frame pose stepping.
- [Animator](Animator.md) — animation coordinator: joint discovery, track blending, replication signals.
- [ArcHandles](ArcHandles.md) — rotation-handle adornment with per-axis replicated mouse events.
- [AssetService](AssetService.md) — place create/save/revert/permissions web client.
- [Attachment](Attachment.md) — part-space pivot/axis frame ("new joint schema"), editor adornments.

### B
- [Backpack](Backpack.md) — Hopper subclass adding a script-run policy filter.
- [BadgeService](BadgeService.md) — badge award/query web client with cached + "hot" results.
- [BaseRenderJob](BaseRenderJob.md) — base class for rendering jobs (frame-rate bounds, wake tracking).
- [BasicPartInstance](BasicPartInstance.md) — FormFactorPart layer + the classic `Part` (legacy shape enum).
- [BevelMesh](BevelMesh.md) — bevel/roundness/bulge mesh-parameter base.
- [BillboardGui](BillboardGui.md) — screen-space GUI billboarded over an adornee.
- [Bindable](Bindable.md) — BindableFunction (queued invoke) + BindableEvent (signal fire).
- [BlockMesh](BlockMesh.md) — beveled-block mesh decoration (no added state).
- [BodyMover family → Gyro](Gyro.md) — BodyMover/BodyGyro/BodyForce/BodyThrust/BodyPosition/BodyVelocity/BodyAngularVelocity/Rocket live in Gyro.h (listed under G).

### C
- [CacheableContentProvider](CacheableContentProvider.md) — LRU+failure-cached async content fetch base.
- [Camera](Camera.md) — full 3D view controller: focus/position interpolation, zoom/pan/tilt, projection math.
- [ChangeHistory](ChangeHistory.md) — ChangeHistoryService: Studio undo/redo waypoints incl. terrain.
- [CharacterAppearance](CharacterAppearance.md) — appearance apply() family: ShirtGraphic, Shirt/Pants (Clothing), BodyColors, Skin.
- [CharacterMesh](CharacterMesh.md) — per-body-part asset mesh overlay appearance.
- [ChatService](ChatService.md) — INTERNAL chat broadcast + server-side string filtering.
- [ClickDetector](ClickDetector.md) — distance-gated click/hover events on parts/models.
- [CollectionService](CollectionService.md) — tag-based instance collections with copy-on-write lists.
- [ColorSequence](ColorSequence.md) — value-type RGB gradient (≤20 keypoints) for particles.
- [Commands](Commands.md) — Studio verb catalog: base verb classes + menu commands + TToolVerb launcher.
- [CommonVerbs](CommonVerbs.md) — aggregator instantiating the standard verb/tool set per DataModel.
- [Configuration](Configuration.md) — plain named container Instance.
- [ContentProvider](ContentProvider.md) — central content pipeline: URL config, preload, blocking loads, signature checks.
- [ContextActionService](ContextActionService.md) — named action↔input binding (dev + core tables), touch buttons.
- [CookiesEngineService](CookiesEngineService.md) — CookiesService key/value cookie store.
- [CornerWedgeInstance](CornerWedgeInstance.md) — corner-wedge part (`_PRISM_PYRAMID_`-gated).
- [CSGDictionaryService](CSGDictionaryService.md) — solid-meshing flyweight store (hash-keyed CSGMesh maps).
- [CSGMesh](CSGMesh.md) — CSG vertex/mesh value types + factory singleton hook.
- [CustomEvent](CustomEvent.md) — legacy 0..1 float event source with weak receiver list.
- [CustomEventReceiver](CustomEventReceiver.md) — partner receiving CustomEvent values as script events.
- [CustomParticleEmitter](CustomParticleEmitter.md) — ParticleEmitter: sequences/ranges/emission props + burst remote.
- [CylinderMesh](CylinderMesh.md) — beveled-cylinder mesh decoration.

### D
- [DataModel](DataModel.md) — game container: services, arbiter/write-lock discipline, identity, save/load, hack-flag telemetry.
- [DataModelJob](DataModelJob.md) — scheduler job contract (TaskType access classes) + DataModelArbiter exclusivity table.
- [DataModelMesh](DataModelMesh.md) — mesh-decoration base: scale/vertColor/offset/LOD.
- [DataStore](DataStore.md) — GlobalDataStore get/set/increment/updateAsync + OrderedDataStore + DataStorePages.
- [DataStoreService](DataStoreService.md) — store factory + throttled request scheduler + analytics.
- [DebrisService](DebrisService.md) — delayed-destruction queue (AddItem/lifetime).
- [DebugSettings](DebugSettings.md) — DebugSettings machine/perf introspection + TaskSchedulerSettings live knobs.
- [Decal](Decal.md) — per-face texture w/ specular/shiny/transparency; DecalTexture tiling.
- [DialogChoice](DialogChoice.md) — NPC dialog tree branch node.
- [DialogRoot](DialogRoot.md) — conversation root: purpose/tone, prompt, choice replication.
- [Effect](Effect.md) — marker base for graphical effect nuggets.

### E–F
- [EventReplicator](EventReplicator.md) — replicate-events-only-while-listened machinery + macro family.
- [Explosion](Explosion.md) — one-shot blast effect: pressure/joint-break/kill radii + hitSignal.
- [ExtrudedPartInstance](ExtrudedPartInstance.md) — TrussPart: visual style + strict resize rules.
- [FaceInstance](FaceInstance.md) — face-attached Instance base (NormalId selector).
- [factoryregistration](factoryregistration.md) — empty FactoryRegistrator stub header.
- [FastLogSettings](FastLogSettings.md) — ClientAppSettings JSON config + FastLogJSON bridge (+ hard-coded API key).
- [Feature](Feature.md) — Feature/MotorFeature/Hole snap anchors + VelocityMotor joint.
- [FileMesh](FileMesh.md) — mesh-by-asset-id decoration (virtual setters; SpecialMesh retypes).
- [Filters](Filters.md) — HitTestFilter predicate library (unlocked, character, descendants, occlusion…).
- [Fire](Fire.md) — classic flame effect (colors, size/heat clamps).
- [Flag](Flag.md) — CTF flag Tool: no unequip, same-team pickup refusal.
- [FlagStand](FlagStand.md) — capture stand + FlagStandService registry/stepper.
- [FloorWire](FloorWire.md) — animated surface-hugging wire trail between two parts.
- [FlyweightService](FlyweightService.md) — hash-keyed BinaryString flyweight base (parent of CSG dictionary).
- [Folder](Folder.md) — organizational container Instance.
- [ForceField](ForceField.md) — spawn-shield bubble effect + partInForceField query.

### G
- [Frame](Frame.md) — rectangular GUI container with Style skins.
- [FriendService](FriendService.md) — friendship graph storage/replication + friends-online fetch.
- [Game](Game.md) — app bootstrap around a DataModel (SecurePlayerGame / UnsecuredStudioGame).
- [GameBasicSettings](GameBasicSettings.md) — user preferences hub (control/camera modes, quality, volume, tutorials).
- [GamepadService](GamepadService.md) — ≤8 gamepads state + gamepad GUI navigation.
- [GamePassService](GamePassService.md) — player-has-pass web query.
- [GameSettings](GameSettings.md) — engine game options (chat/sound/bubble/video capture), mostly public fields.
- [GeometryService](GeometryService.md) — filtered raycasts + extents-touching queries.
- [GlobalSettings](GlobalSettings.md) — Settings provider + GlobalBasic/Advanced singletons + item CRTP helpers.
- [GroupService](GroupService.md) — group info/allies/enemies/groups web client.
- [GuiBase](GuiBase.md) — GUI hierarchy root: process contract, z-index bounds, queues.
- [GuiBase2d](GuiBase2d.md) — 2D GUI base: absolute placement cache, rect math, render traversal.
- [GuiBase3d](GuiBase3d.md) — 3D adornment GUI base (color/transparency/visible).
- [GuiBuilder](GuiBuilder.md) — HUD builder: chat/stats/network overlays, safe-chat menus, Lua-GUI injection.
- [GuiCore](GuiCore.md) — Gui::WidgetState enum only.
- [GuiLayerCollector](GuiLayerCollector.md) — layered GUI container: z-bucketed render batches + input routing.
- [GuiMixin](GuiMixin.md) — GuiImageMixin + DECLARE/IMPLEMENT_GUI_IMAGE_MIXIN macro surface.
- [GuiObject](GuiObject.md) — core 2D element base (+GuiButton/+GuiLabel): layout, tweens, input events, scale-9.
- [GuiService](GuiService.md) — global GUI coordination: inset, keys, center dialogs, selection groups.
- [GuiText](GuiText.md) — GuiTextMixin + DECLARE/IMPLEMENT_GUI_TEXT_MIXIN (Text property surface, filtering).
- [Gyro](Gyro.md) — BodyMover physics family (see B note above).

### H
- [HackDefines](HackDefines.md) — HATE_/SCORN_ exploit flags, obfuscated flag setters, GF(2) LUTs, hackFlag0–12 globals.
- [HandleAdornment](HandleAdornment.md) — plugin handle adornments (Box/Cone/Cylinder/Sphere/Line/Image).
- [Handles](Handles.md) — linear resize/move handles (NormalId events, VisualStyle, Faces filter).
- [HandlesBase](HandlesBase.md) — shared handle hit-testing/capture base.
- [HapticService](HapticService.md) — vibration motor enable/set per input device.
- [Hopper](Hopper.md) — BackpackItem/HopperBin/Hopper/StarterPack/StarterGear backpack plumbing.
- [HttpRbxApiJob](HttpRbxApiJob.md) — Write-class job pumping HttpRbxApiService budgets/queues.
- [HttpRbxApiService](HttpRbxApiService.md) — throttled Roblox-API HTTP client (sync/async/Lua, retry queue).
- [HttpService](HttpService.md) — script-facing HTTP utility (JSON/GUID/urlEncode) behind HttpEnabled.

### I–J
- [IAnimatableJoint](IAnimatableJoint.md) — animatable-joint interface + CachedPose value type.
- [ICameraOwner](ICameraOwner.md) — interface exposing an owned Camera.
- [ICharacterSubject](ICharacterSubject.md) — character-follow camera subject contract (first person, distances).
- [IEquipable](IEquipable.md) — Tool/Accoutrement common weld ownership base.
- [ImageButton](ImageButton.md) — GuiButton + image mixin with imageState.
- [ImageLabel](ImageLabel.md) — GuiLabel + image mixin.
- [IModelModifier](IModelModifier.md) — empty marker interface for model modifiers.
- [InputObject](InputObject.md) — input event payload: types/states, position/delta, keys, classifier predicates.
- [InsertService](InsertService.md) — asset insert pipeline: catalog search, loadAsset, backend-approved safe inserts.
- [JointInstance](JointInstance.md) — joint family: Snap/Weld/Glue/Rotate(P/V)/Manual*/Motor/Motor6D over V8World joints.
- [JointsService](JointsService.md) — joint container service: world-event wiring, manual-joint helper, join-after-move.

### K–L
- [Keyframe](Keyframe.md) — time-stamped animation frame holding Poses.
- [KeyframeSequence](KeyframeSequence.md) — animation asset: keyframes + cached apply()/blend data.
- [KeyframeSequenceProvider](KeyframeSequenceProvider.md) — sequence registry/resolver (LRU + pinned active set).
- [legacy](legacy.md) — empty placeholder header.
- [Light](Light.md) — Light base + PointLight/SpotLight/SurfaceLight.
- [Lighting](Lighting.md) — place lighting model: sky params, fog, time-of-day, ambient/outlines knobs.
- [LocalWorkspace](LocalWorkspace.md) — never-replicated local container.
- [LoginService](LoginService.md) — login/logout signal hub.
- [LogService](LogService.md) — console log history/streaming + gated server script execution.

### M
- [ManualJointHelper](ManualJointHelper.md) — Studio manual/auto joint pair enumeration, drawing, creation.
- [MarketplaceService](MarketplaceService.md) — purchase flows (product/asset/native/third-party), receipts, product info cache.
- [MegaCluster](MegaCluster.md) — Terrain: dual voxel grids, cell API, fill/copy/paste, packaged-grid V1–V3.
- [MeshContentProvider](MeshContentProvider.md) — mesh-binary CacheableContentProvider specialization.
- [Message](Message.md) — legacy fullscreen text overlay + Hint subclass.
- [ModelInstance](ModelInstance.md) — Model container: primary-part placement, aggregate stats, group(), modifier lookup.
- [Mouse](Mouse.md) — legacy script-facing mouse object (cached InputObject + raycast getters).
- [MouseCommand](MouseCommand.md) — interactive tool state machine + static picking helpers.

## Conventions

- Doc-per-header at mirrored paths; `.h` stripped. `factoryregistration`/`legacy` keep lowercase names.
- UNKNOWN markers flag facts not determinable from the header alone (implementation-only details).
- Cross-links use relative paths: implementation docs two levels up (`../../v8datamodel/<Name>.md`), sibling headers by bare name.
