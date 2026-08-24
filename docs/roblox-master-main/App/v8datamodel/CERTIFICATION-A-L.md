# CERTIFICATION-A-L.md

Independent review of all 109 `roblox-sandbox/App/v8datamodel` sources with basenames A–L (incl. `factoryregistration.cpp`, `legacy.cpp`) against their `.md` docs in this folder. Every source was read IN FULL via tool calls (no sampling); every concrete doc claim (descriptor names/tiers, defaults, event wiring, flow, gotchas) was checked against source text. "Dead code"/"zero callers"/"not compiled" style claims were machine-checked with grep across `roblox-sandbox` before acceptance. M–Z files and INDEX-M-Z.md were not touched.

## Coverage reconciliation

- Source side (`ls | grep ^[a-lA-L]`): **109** files.
- Doc side (non-INDEX `.md` starting A–L): **109** files. Normalized basename diff: EXACT_1TO1_MATCH.
- INDEX-A-L.md: **109 entries**, machine-diffed 1:1 against both lists. E-section contains exactly Effect, Enums, Explosion, ExtrudedPartInstance between D and F (correct). LoginService row present and well-formed (line 149).

## Verdicts

| # | File | Verdict | Notes |
|---|------|---------|-------|
| 1 | Accoutrement | PASS | |
| 2 | Adornment | PASS | |
| 3 | AdService | PASS | |
| 4 | AnimatableRootJoint | PASS | |
| 5 | Animation | PASS | |
| 6 | AnimationController | PASS | |
| 7 | AnimationTrack | PASS | |
| 8 | AnimationTrackState | PASS | |
| 9 | Animator | PASS | ErrorOnFailedToLoadAnim declared-unused verified |
| 10 | ArcHandles | FIXED | Gotcha claimed failed `findTargetHandle` leaves NORM_UNDEFINED; HitTest.cpp shows output written only on success → value is INDETERMINATE. Corrected. |
| 11 | AssetService | PASS | httpPostHelper null-response double-resume path re-verified verbatim |
| 12 | Attachment | PASS | |
| 13 | Backpack | PASS | |
| 14 | BadgeService | PASS | DebrisService include vestigial — grep-verified |
| 15 | BaseRenderJob | PASS | |
| 16 | BasicPartInstance | PASS | |
| 17 | BevelMesh | PASS | |
| 18 | BillboardGui | PASS | rayQuad/getBillboardHit/2048-stud occlusion all verified |
| 19 | Bindable | PASS | |
| 20 | BlockMesh | PASS | |
| 21 | Camera | FIXED | Gotcha said SetCameraPanMode is gated/no-op outside Scriptable — it has NO type gate in TU (stores unconditionally, lines 1226–1229). Corrected. |
| 22 | ChangeHistory | FIXED | Replicated-change scan described as "base-first"; source walks NEWEST→OLDEST (--iter from end()), creations go straight to base waypoint. Corrected. |
| 23 | CharacterAppearance | PASS | |
| 24 | CharacterMesh | PASS | |
| 25 | ChatService | PASS | |
| 26 | ClickDetector | PASS | Strict `<` distance compare verified in both paths |
| 27 | CollectionService | PASS | |
| 28 | ColorSequence | PASS | NumberSequence copy-paste error message verified |
| 29 | Commands | PASS | parseMaterial maps exactly 20 strings; unknown→PLASTIC |
| 30 | CommonVerbs | FIXED | Manual-joint+grid group stated 9 members; actual is 10 (incl. turnOnManualJointCreationVerb). Corrected. |
| 31 | Configuration | PASS | |
| 32 | ContextActionService | FIXED | WRONG: doc reversed input-override direction. Source: CORE binds checked against BOTH vectors; DEV binds only dev vector. Corrected. |
| 33 | CookiesEngineService | PASS | Unused sleep() helper verified |
| 34 | CornerWedgeInstance | PASS | |
| 35 | CSGDictionaryService | FIXED | StudioCSGAssets listed as "consumed" but is declared-and-unused in TU. Corrected. |
| 36 | CSGMesh | PASS | xorBuffer PRNG symmetry, badMesh flagging, CSG_KERNEL_OLD gate verified |
| 37 | CustomEvent | PASS | |
| 38 | CustomEventReceiver | PASS | hackFlag4 block verified verbatim |
| 39 | CustomParticleEmitter | PASS | setDampening flag-off raise-without-store verified |
| 40 | CylinderMesh | PASS | |
| 41 | DataModel | FIXED | Plugin func list duplicated GetJobTimePeakFraction and omitted GetJobIntervalPeakFraction. Corrected. All other claims (waterfall order, accelerator map, GenericJob "IS GARBAGE" comment, metric decoys, LegacyLock commented-out main-thread assert) verified. |
| 42 | DataModelJob | PASS | Exclusivity tables incl. Empirical dead-equivalence verified |
| 43 | DataModelMesh | PASS | |
| 44 | DataStore | PASS | CAS loop, "Request rejected" FASTLOG-only detail, throttle formula verified |
| 45 | DataStoreService | PASS | Budget formulas match DFInt knobs |
| 46 | DebrisService | PASS | Message-vs-code mismatch on MaxItems documented correctly |
| 47 | DebugSettings | PASS | All typos ("RobloxFalureCount", "RobloxRespoceTime", "EnviromentalPhysicsThrottle") verified verbatim; AddDummyJob empty body confirmed |
| 48 | Decal | FIXED | Claimed Specular rejects ≤0; source rejects only <0 (0 accepted via `value>=0.0`). Shiny does require >0. Both spots corrected. |
| 49 | DialogChoice | PASS | FilteringEnabledDialogFix declared-unused here verified |
| 50 | DialogRoot | PASS | US31006 RCC breakpoint block verified |
| 51 | Effect | PASS | |
| 52 | Enums | PASS | PrismSides missing-4 comment verified verbatim |
| 53 | Explosion | PASS | Inverted enum names, impulse /4560 factor verified |
| 54 | ExtrudedPartInstance | PASS | Non-finite z-branch fallback assert verified |
| 55 | FaceInstance | PASS | |
| 56 | factoryregistration | FIXED | Doc claimed "~40/~330/~130" registrations; machine count is 47 TYPE / 289 CLASS / 122 ENUM (~330 was 14% off). Corrected in doc AND INDEX-A-L.md row. |
| 57 | FastLogSettings | PASS | Prefix dispatcher first-char routing + AB-in-static-branch-only verified |
| 58 | Feature | PASS | canJoin/join, "is this dangerous?..." comment verified |
| 59 | FileMesh | PASS | |
| 60 | Filters | PASS | UseFixedTransparencyNonCollidableBehaviour ClickDetector exception verified |
| 61 | Fire | PASS | UI clamp-before-compare re-raise path verified |
| 62 | Flag | PASS | Unconditional TeamColor raise verified |
| 63 | FlagStand | PASS | Clone-on-first-sight watch logic verified |
| 64 | FloorWire | PASS | Most-setters-don't-raise verified |
| 65 | FlyweightService | FIXED | GA event name given as "UsingCS"; source fires "UsingCSG" (line 39). Corrected. |
| 66 | Folder | PASS | |
| 67 | ForceField | FIXED | WRONGLY claimed cyclic-path locals reach the render call ("harmless"). They are block-scoped shadows that die before line 124, which passes stale MEMBERS → bubble never animates in cyclic mode. Corrected. |
| 68 | Frame | PASS | Scale9 insets and forced transparency verified |
| 69 | FriendService | PASS | %% doubling bug, canonical swap storage verified |
| 70 | Game | PASS | |
| 71 | GameBasicSettings | FIXED | "Every mode setter: perm→GA→raise→Modified" overgeneralized (ControlMode has no GA/Modified; CameraMode descriptor-gated, no Modified); GA event count is 4+4 not "4-6". Corrected. |
| 72 | GamepadService | PASS | Constants 0.14/500/120ms and separate 0.6 quantizer grep-verified |
| 73 | GamePassService | PASS | |
| 74 | GameSettings | PASS | "Game Options" name trap verified |
| 75 | GeometryService | PASS | Miss-sentinel origin+direction verified |
| 76 | GlobalSettings | PASS | verifySetParent asymmetry (flag-gated advanced vs unconditional basic) verified |
| 77 | GroupService | PASS | hackFlag9 block verified |
| 78 | GuiBase | PASS | |
| 79 | GuiBase2d | FIXED | Final gotcha contradicted itself and concluded rendering visits ALL children; RecursiveRenderChildren only descends into GuiBase2d casts, so Folder subtrees are resized but NEVER rendered. Corrected. |
| 80 | GuiBase3d | PASS | |
| 81 | GuiBuilder | PASS | Missing-break STREAMING case, read-lock mutation debt, statics, WriteFile trailing comma all verified |
| 82 | GuiLayerCollector | FIXED | Legacy getGuiObjectsForSelection clause "unrelated to the candidate's own chain" was wrong (it checks the candidate's own ancestor; unrelated to the SELECTED object's frame). Corrected. |
| 83 | GuiObject | PASS | ZIndex clamp asymmetry, 2°-free tween math, redundant nested public guard, render-time setBackgroundTransparency side effect all verified |
| 84 | GuiService | FIXED | WRONGLY claimed deprecated ErrorMessage trio is "aliased onto the same storage" — implementations write a SEPARATE errorMessage member and fire their own signal; Attributes::deprecated only marks supersession. Corrected. |
| 85 | HandleAdornment | PASS | Missing-break fallthrough and silent ZIndex rejection verified verbatim |
| 86 | Handles | PASS | Same leave-to-nothing stale-NormalId bug correctly described here |
| 87 | HandlesBase | PASS | |
| 88 | HapticService | PASS | |
| 89 | Hopper | PASS | Descriptor surface grep-verified (LEGACY write-only Command/TextureName, RobloxScript ToggleSelect/Disable) |
| 90 | HttpRbxApiService | PASS | Unguarded https-strip replace(), 503+429 comment, budget formula, 256-byte compression threshold grep-verified |
| 91 | HttpService | PASS | Gate order and empty-data-to-space coercion verified |
| 92 | ICharacterSubject | PASS | maxMouseLockOffset 1.5f, 11-stud reset, "Ugly" cast grep-verified |
| 93 | IEquipable | PASS | FISHING assert, humanoid-part parenting verified |
| 94 | ImageButton | PASS | |
| 95 | ImageLabel | PASS | |
| 96 | InputObject | PASS | Copy-ctor field drops verified line-by-line |
| 97 | InsertService | PASS | GetLastestAssetVersion typo split (C++ symbol vs Lua name), serverplaceid omission comment verified |
| 98 | JointInstance | PASS | 2-degree debounce raising CurrentAngle "only local" verified |
| 99 | JointsService | PASS | Five Security::None funcs verified |
| 100 | Keyframe | PASS | |
| 101 | KeyframeSequence | PASS | AnimationPriority pairs and flags verified |
| 102 | KeyframeSequenceProvider | FIXED | Gotcha said ById path "always uses cache"; call site hardcodes useCache=FALSE so it always SKIPS the cache read. Corrected. |
| 103 | legacy | PASS | Empty legacy.h literally "// empty" cat-verified; SurfaceConstraint references grep-limited to this TU + REGISTER_ENUM + header |
| 104 | Light | PASS | Brightness floor-only clamp verified |
| 105 | Lighting | PASS | Fog setters skip LightingChanged; GetMoonDirection→getMoonPosition divergence verified |
| 106 | LocalWorkspace | PASS | Zero-consumer claim grep-verified (only factoryregistration + manifests) |
| 107 | LoginService | PASS | Swapped event names verified |
| 108 | LogService | PASS | Kill-flag comment verbatim, redaction keywords, GameScript_ identity, CanManage URL verified. (STYLE note: final gotcha trails into self-questioning prose but reaches the correct conclusion — left unchanged.) |
| 109 | Gyro | PASS | 7 REGISTER_CLASS, 1/19 scale, typeid duplicate check, BodyGyro Y-zeroed MaxTorque default, deprecated lowercase aliases all verified |

## Totals

- **109 / 109 sources reviewed in full** (≈40.9k source lines + ≈3.3k doc lines read).
- **PASS: 93**
- **FIXED: 16** (ArcHandles, Camera, ChangeHistory, CommonVerbs, ContextActionService, CSGDictionaryService, DataModel, Decal, factoryregistration, FlyweightService, ForceField, GameBasicSettings, GuiBase2d, GuiLayerCollector, GuiService, KeyframeSequenceProvider)
- **FAIL: 0**

## Severity summary of applied fixes

- **WRONG (factually false, corrected):** ContextActionService override direction; ForceField cyclic shadowed-locals; GuiService ErrorMessage aliasing; KeyframeSequenceProvider useCache polarity; GuiBase2d Folder render conclusion; ChangeHistory scan direction; Camera SetCameraPanMode gate; Decal Specular 0-rejection; factoryregistration counts (doc + INDEX row); CommonVerbs member count; FlyweightService GA event name; DataModel duplicate/omitted Plugin func; GameBasicSettings setter generalization + GA count.
- **UNSUPPORTED (claim not supported by source, corrected):** ArcHandles "NORM_UNDEFINED after failed findTargetHandle" (value never written → indeterminate); CSGDictionaryService StudioCSGAssets "consumed".
- **STYLE (noted, not changed):** LogService.md final gotcha's unresolved-questioning prose (conclusion correct); GuiObject.md ZIndex gotcha's rhetorical phrasing (substance correct).

## Files modified by this review

All writes confined to `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/v8datamodel/`: the 16 FIXED `.md` docs above plus `INDEX-A-L.md` (one row: factoryregistration counts) and this `CERTIFICATION-A-L.md`. No `roblox-sandbox/` files touched.
