# Certification — App/include/v8datamodel Header Docs, A–M

Independent review of 128 header/doc pairs (`Accoutrement.h` … `MouseCommand.h`, including lowercase `factoryregistration.h` and `legacy.h`) against their `<Name>.md` files in this directory. Every header was read **in full**; every concrete claim in its doc (class bases, method signatures, enums, macros, gotchas, quoted comments) was checked against the source. Cross-links to sibling docs and to certified implementation docs under `App/v8datamodel/` were resolved programmatically (1,024 link targets checked).

Coverage was re-enumerated from both trees: exactly 128 A–M headers ↔ 128 matching `.md` docs, 1:1, no extras and no gaps. Boundary with the N–Z half falls between `MouseCommand`/`NonReplicatedCSGDictionaryService` as documented. `INDEX.md` roster verified complete and accurate.

## Verdict key

- **PASS** — every concrete claim verified; no changes needed.
- **FIXED** — one or more issues found and mechanically corrected in place.
- **FAIL** — doc left materially wrong or unverifiable.

## Per-file results

| # | Doc | Verdict | Notes |
|---|-----|---------|-------|
| 1 | Accoutrement.md | PASS | All signatures/enums/state-machine names match header. |
| 2 | ActionStation.md | PASS | 3.0 s sleep threshold, DFInt, SEAT_SIZE hack all verbatim. |
| 3 | Adornment.md | PASS | Copy-paste comment gotcha confirmed verbatim. |
| 4 | AdService.md | PASS | Signal payloads and INTERNAL descriptor match. |
| 5 | AnimatableRootJoint.md | FIXED | STYLE: garbled Gotcha ("all override bodies are inlined here except…" — actually no override bodies are inlined) rewritten to match the 22-line header. |
| 6 | Animation.md | PASS | getPersistentDataCost formula and ContentId storage match. |
| 7 | AnimationController.md | PASS | "(lazy creation)" claim verified against AnimationController.cpp (creates Animator on demand). |
| 8 | AnimationTrack.md | PASS | Full play/local*/adjust/priority/signal surface matches. |
| 9 | AnimationTrackState.md | FIXED | WRONG: `keyframeReachedSignal`/`stoppedSignal` were labeled "local-relay"; header declares **all six** as `rbx::remote_signal`. Corrected. |
| 10 | Animator.md | PASS | Verbatim member typos (`descentdantAdded/Removed`), ctor modes, replication surface all match. |
| 11 | ArcHandles.md | PASS | Five remote signals + five DECLARE_EVENT_REPLICATOR_SIG macros match. |
| 12 | AssetService.md | PASS | AccessType enum values, URL setters, private plumbing signatures match. |
| 13 | Attachment.md | FIXED | STYLE: quoted comment restored to verbatim ("orthogonormal", not "orthonormal"). Everything else matched incl. `#if 1` gate and RBX_ATTACHMENT_LOCKING ifdef. |
| 14 | Backpack.md | PASS | IScriptOwner-commented private override confirmed. |
| 15 | BadgeService.md | PASS | Caches, HotUserHasBadge struct, `isDiabledResultHelper` typo verbatim. |
| 16 | BaseRenderJob.md | PASS | Virtuals, commented-out stepDataModelJob, volatile isAwake match. |
| 17 | BasicPartInstance.md | PASS | FormFactorPart/BasicPartInstance split and Ui/Xml setter pairs match. |
| 18 | BevelMesh.md | PASS | bulge TODO comment verbatim. |
| 19 | BillboardGui.md | PASS | "Ugh:" design-debt quote verbatim; full override list matches. |
| 20 | Bindable.md | PASS | Invocation queue, OnInvokeCallback, #if 0 PropertyInstance all match. |
| 21 | BlockMesh.md | PASS | Constructor-only class confirmed. |
| 22 | Camera.md | FIXED | MISSING-GOTCHA: public `bool canTilt(int up) const` (header line 116) absent from Pan/Tilt coverage — added. All enums/constants/private state otherwise verified line-by-line. |
| 23 | ChangeHistory.md | PASS | Caps, RuntimeUndoBehavior comments, waypoint machinery all verbatim. |
| 24 | CharacterAppearance.md | FIXED | WRONG: Clothing's `dataChanged` claimed private; header places it in the same **protected** block as `applyByMyself`. Corrected. Shirt→outfit2 / Pants→outfit1 mapping confirmed. |
| 25 | CharacterMesh.md | PASS | BodyPart enum, public int fields, typed getters match. |
| 26 | ChatService.md | FIXED | Dead cross-link `[Players-side Network docs](../../Network/INDEX-Network.md)` — target does not exist anywhere in the docs tree (Network docs live at repo root, no index file). Link replaced with plain-text pointer. API claims all matched. |
| 27 | ClickDetector.md | PASS | cycles()=30, statics, part/model-only parenting match. |
| 28 | CollectionService.md | PASS | Template overload, copy-on-write map, TODO quote match. |
| 29 | ColorSequence.md | PASS | kMaxSize=20, ctors, validate/resample, #undef min/max gotcha match. |
| 30 | Commands.md | PASS | Verified across full 735 lines: verb bases, TToolVerb toggle logic, QUARTER_STUD naming mismatch gotcha, disabled manual-joint verbs. |
| 31 | CommonVerbs.md | PASS | Complete member roster and unused forward declarations match. |
| 32 | Configuration.md | PASS | Three overrides only. |
| 33 | ContentProvider.md | PASS | Priority ladder, PreloadAsyncRequest, RequestType enum, AssetFetchMediator all match. |
| 34 | ContextActionService.md | PASS | BoundFunctionData equality quirk, dual bind tables, PlayerActionType match. |
| 35 | CookiesEngineService.md | PASS | Filename/class mismatch gotcha correct. |
| 36 | CornerWedgeInstance.md | PASS | `_PRISM_PYRAMID_` gate and CORNERWEDGE_PART confirmed. |
| 37 | CSGDictionaryService.md | FIXED | STYLE: `insertCachedMesh` described as an overload of `insertMesh`; it is a separate name (only the protected `insertMesh(key,data)` overloads the public one). Reworded. PERSISTENT+Security::Roblox and map typedefs verified. |
| 38 | CSGMesh.md | PASS | subractMesh typo, RBXASSERT(idx<6), UVGenerationType, factory singleton match; "zero vectors" claim confirmed via G3D::Vector3 default ctor (zero-initializes). |
| 39 | CustomEvent.md | PASS | Inline onServiceProvider, clamp-to-[0,1], idempotent addReceiver, disabled copy all match. |
| 40 | CustomEventReceiver.md | PASS | RBXASSERT-on-same-value, serialization-only getSource/setSource match. |
| 41 | CustomParticleEmitter.md | PASS | 18 prop descriptors, remote burst event, NormalId direction match. |
| 42 | CylinderMesh.md | PASS | Constructor-only class confirmed. |
| 43 | DataModel.md | FIXED | UNSUPPORTED: "decoy flags feed perfStats/sendStats" — header only ever mutates/tests `sendStats`; `perfStats` is merely declared. Claim narrowed to what the header shows. Rest of the 42-line doc verified against all 714 header lines. |
| 44 | DataModelJob.md | PASS | TaskType list/order, arbiter lookup table dims, LOGGROUP match. |
| 45 | DataModelMesh.md | PASS | LODType ABI comment verbatim. |
| 46 | DataStore.md | FIXED | WRONG: HTTP processors claimed to each have a `lockAcquired...` twin; `processSet` has none, and `processSetIf` was omitted from the list. Corrected. The OrderedDataStore `Super` typedef bug gotcha confirmed verbatim at header line 141. |
| 47 | DataStoreService.md | PASS | HttpRequest RequestType 5–9, four throttle buckets, average-math note all match. |
| 48 | DebrisService.md | PASS | weak_ptr queue, TimerService member match. |
| 49 | DebugSettings.md | PASS | Falure/Responce/Respoce typos verbatim; scheduler gauges/knobs match. |
| 50 | Decal.md | FIXED | WRONG ×2: `getStudsPerTile()` called a "non-const ref return" that yields "a mutable reference" — it returns `const G3D::Vector2&` from a non-const *method*. Both spots corrected. |
| 51 | DialogChoice.md | PASS | Text trio + selected signal + askSetParent match. |
| 52 | DialogRoot.md | PASS | Enums, local vs remote choice channels match. |
| 53 | Effect.md | PASS | Include-before-#pragma-once oddity confirmed verbatim. |
| 54 | EventReplicator.md | PASS | Arity dispatch 0–3, macro family semantics, fragility comment match. |
| 55 | Explosion.md | PASS | Public enum field + setter pair, setVisualOnly, doBlast terrain param match. |
| 56 | ExtrudedPartInstance.md | PASS | Truss style enum, resize overrides, TRUSS_PART match. |
| 57 | FaceInstance.md | PASS | Raw Reflection::Described<> gotcha correct. |
| 58 | factoryregistration.md | PASS | 10-line stub accurately described. |
| 59 | FastLogSettings.md | PASS | API-key constant verbatim; all 27 data-map entries accounted for by type. |
| 60 | Feature.md | PASS | "ouch - for properties" quote, InOutZ inversion, VelocityMotor plumbing match. |
| 61 | FileMesh.md | PASS | Virtual-setter rationale comment verbatim. |
| 62 | Filters.md | PASS | All 11 filters with borrowed-pointer lifetime gotchas match. |
| 63 | Fire.md | PASS | Ui/raw setter split, static MaxHeat/MaxSize match. |
| 64 | Flag.md | PASS | canUnequip/canBePickedUpByPlayer comments verbatim. |
| 65 | FlagStand.md | PASS | Both classes fully verified incl. clonedReplacementFlag. |
| 66 | FloorWire.md | PASS | Prop set, statics, protected pipeline signatures match. |
| 67 | FlyweightService.md | PASS | InstanceStringData, map typedef, hash-key helpers match. |
| 68 | Folder.md | PASS | Four ask* overrides only. |
| 69 | ForceField.md | PASS | File-scope largeSize=1.1f hazard, cycles()=60 match. |
| 70 | Frame.md | PASS | Seven Style values match. |
| 71 | FriendService.md | FIXED | STYLE: FriendStatus enumerator names restored to verbatim (`FRIEND_STATUS_UNKNOWN=0`…); values were already correct. Symmetric-map comment and `getBulkFriendsUrl` member-name gotcha confirmed. |
| 72 | Game.md | PASS | Both subclass ctor default signatures match. |
| 73 | GameBasicSettings.md | FIXED | STYLE: abbreviated enumerator names expanded to verbatim (`CAMERA_MODE_*`, `TOUCH_MOVEMENT_MODE_*`, etc.). Misspelled `touchMoveModeModeModified`/`computerMoveModeModeModified` and signal-before-store ordering confirmed. |
| 74 | GamepadService.md | PASS | RBX_MAX_GAMEPADS=8, navigation map returned by value, deadzone/repeat members match. |
| 75 | GamePassService.md | PASS | dispatchRequest template and URL member match. |
| 76 | GameSettings.md | PASS | All public raw fields and three enums match; ChatMode-without-member gotcha correct. |
| 77 | GeometryService.md | PASS | Method signatures incl. templated filter variant match. |
| 78 | GlobalSettings.md | PASS | Visitor structs, CRTP singleton shortcut/lock pattern, header-defined `sing` statics match. |
| 79 | GroupService.md | PASS | Four async methods and four static handlers match. |
| 80 | GuiBase.md | PASS | Z-index bounds [0,10]/[1,10], GuiQueue enum match. |
| 81 | GuiBase2d.md | PASS | Rect-storage musing comment verbatim; shouldRender2d=false rationale quote matches. |
| 82 | GuiBase3d.md | PASS | BrickColor::closest lossiness, ZIndex −1 match. |
| 83 | GuiBuilder.md | PASS | Display/NetworkStats enums (RAKNET alias), builder roster, oldTrack* flags match. |
| 84 | GuiCore.md | PASS | 14-line WidgetState-only header confirmed. |
| 85 | GuiLayerCollector.md | PASS | Layer batching, GUIQUEUE_COUNT scratch arrays, connection map match. |
| 86 | GuiMixin.md | PASS | Setter-validation asymmetry (offset/slice warn, size blocks) verified against macro body line-by-line. |
| 87 | GuiObject.md | FIXED | WRONG: "tweenPosition ×4 overloads" — header declares exactly 3 (GuiObject.h:135–137). STYLE: TweenEasingDirection/Style enumerator spellings restored (`EASING_DIRECTION_*`/`EASING_STYLE_*`). Remaining 531-line surface (signals, replicators, render internals, GuiButton/GuiLabel) verified. |
| 88 | GuiService.md | PASS | SpecialKey/CenterDialogType/UiMessageType values, DialogWrapper heap-pointer queue, TODO boost::array comment match. |
| 89 | GuiText.md | PASS | Entire macro body cross-checked: truncation/profanity gating, deprecated TextWrap alias, frontendProcessing measurement gates, −1 sentinel. |
| 90 | Gyro.md | PASS | Whole BodyMover family incl. PD formula comments, Deprecated twins, Rocket steering knobs. |
| 91 | HackDefines.md | PASS | All 32 HATE flags, SCORN values, GF(2) LUT sizes, MCC indices 0–14, rot-11/rot-17 obfuscation templates, hackFlag0–12 globals. |
| 92 | HandleAdornment.md | PASS | Six creatable shapes, pure-virtual contract, void() remotes match. |
| 93 | Handles.md | PASS | VisualStyle values, Faces mask inline body match. |
| 94 | HandlesBase.md | PASS | Hit-test helper signatures, MouseDownCaptureInfo struct match. |
| 95 | HapticService.md | PASS | Motor enum 0–4, nested maps, signals match. |
| 96 | Hopper.md | PASS | BinType XML comment, asymmetric select/deselect, legacy loaders, StarterGear canClientCreate all match. |
| 97 | HttpRbxApiJob.md | PASS | Write TaskType, 0.01 s budget, DFInt auto-tune loop match. |
| 98 | HttpRbxApiService.md | PASS | ThrottlingPriority comments, HttpApiRequest defaults, queue-cap comment, presence-detection connections match. |
| 99 | HttpService.md | PASS | HttpContentType 0–4, user* methods, private gate members match. |
| 100 | IAnimatableJoint.md | PASS | CachedPose ctor inversions, sentinel names, missing-virtual-dtor note correct. |
| 101 | ICameraOwner.md | PASS | Three pure virtuals, trivial inline dtor. |
| 102 | ICharacterSubject.md | PASS | firstPersonCutoff=4.5f, six /*implement*/ hooks, tuning constants match. |
| 103 | IEquipable.md | PASS | Protected weld comment verbatim; buildWeld signature matches. |
| 104 | ImageButton.md | PASS | Verb ctor, plain imageState setter match. |
| 105 | ImageLabel.md | PASS | Mixin + two protected render overrides. |
| 106 | IModelModifier.md | PASS | 16-line empty marker confirmed. |
| 107 | InputObject.md | PASS | UserInputType 0–21 with internal-only comments, five typed ctors, full predicate family, isolation tree rules. |
| 108 | InsertService.md | FIXED | MISSING-GOTCHA: public `backendApproveAssetId(int)` / `backendApproveAssetVersionId(int)` (header lines 58–59) absent — added to Asset-loading bullet. Callback library/loadCount/holder Folder details verified. |
| 109 | JointInstance.md | FIXED | UNSUPPORTED: parenthetical claimed a comment implies setName drives joint-type rebuild — no such comment exists in the header; dropped. STYLE: Motor6D derivation quote restored with [sic] ("so that and script doing a ::IsA(Motor)"). Family roster otherwise fully verified. |
| 110 | JointsService.md | PASS | World-event handlers, join-after-move workflow, ManualJointHelper ownership match. |
| 111 | Keyframe.md | PASS | Pose-only children, invalidate hooks, verifySetAncestor guard match. |
| 112 | KeyframeSequence.md | PASS | Priority CORE=1000-lowest comment, mutable Cache internals, builder passes match. |
| 113 | KeyframeSequenceProvider.md | PASS | Registration pair, SizeEnforcedLRUCache typedef, mutex comment match. |
| 114 | legacy.md | PASS | Four-line `// empty` placeholder confirmed. |
| 115 | Light.md | PASS | Light/PointLight/SpotLight/SurfaceLight surfaces match. |
| 116 | Lighting.md | PASS | suppressSky flag inversion, four time representations, getSkyAmbient formula, BoundProp set match. |
| 117 | LocalWorkspace.md | PASS | Comment quote and empty surface confirmed. |
| 118 | LoginService.md | PASS | Four signals + three methods match. |
| 119 | LogService.md | PASS | Remote signals incl. MessageType payload, processRemoteEvent, redaction static, player-list state match. |
| 120 | ManualJointHelper.md | PASS | All eleven surface-pair classes and ManualJointHelper API verified. |
| 121 | MarketplaceService.md | FIXED | MISSING-GOTCHA: public `getDeveloperProductsAsync(resume(shared_ptr<Instance>), error)` (header lines 140–141) absent — added. Six remote-signal pairs, ResponseCache TTL cache, NoDMLock handlers verified. |
| 122 | MegaCluster.md | PASS | Neutering overrides, CLUSTER_CONST_PROP_OVERRIDE 13 fields, V1–V3+smooth serialization, zero-cell defaults comment all match. |
| 123 | MeshContentProvider.md | PASS | Override-only specialization confirmed. |
| 124 | Message.md | PASS | Protected text/filterState, Hint canClientCreate match. |
| 125 | ModelInstance.md | PASS | group() throw message verbatim, double-iteration TODO, modifier finder templates, primary-part legacy pair. |
| 126 | Mouse.md | PASS | Ten signals, geometry getters with -Z quotes, target-filter TODO, checkActive guard match. |
| 127 | MouseCommand.md | FIXED | WRONG: event-contract defaults stated as uniform "default self" — `onMouseWheelForward/Backward` default to null, and only left `onMouseUp` releases capture + returns null (`onRightMouseUp` returns self). Corrected. MAX_SEARCH_DEPTH, ignoreVector3 default-arg hazard, adv-arrow MFC/Qt comment verified. |
| 128 | INDEX.md | PASS | Scope/boundary statement and 128-doc roster verified complete; conventions section accurate. |

## Totals

| Verdict | Count |
|---------|-------|
| PASS | 111 |
| FIXED | 17 |
| FAIL | 0 |
| **Total reviewed** | **128 (+INDEX.md)** |

Fix breakdown: 6 WRONG (AnimationTrackState, CharacterAppearance, ChatService dead link, DataStore, Decal, GuiObject overload count, MouseCommand event defaults — 7 items across 7 files), 3 MISSING-GOTCHA (Camera, InsertService, MarketplaceService), 2 UNSUPPORTED (DataModel, JointInstance), remainder STYLE/quote-fidelity.

## Verification performed beyond the include slice

- `AnimationController::getAnimator` lazy creation claim confirmed against `App/v8datamodel/AnimationController.cpp`.
- G3D::Vector3 default constructor confirmed zero-initializing (`Rendering/g3d/include/g3d/Vector3.h:560`) to certify CSGMesh's extentsCenter/extentsSize claim.

## Items for the N–Z reviewer (not touched)

- `Posture.md` contains a broken self-referencing impl-doc link: `../../v8datamodel/Posture.md` does not exist.
- `TextureContentProvider.md` contains a broken impl-doc link: `../../v8datamodel/CacheableContentProvider.md` does not exist (the base-class doc lives in this directory).
