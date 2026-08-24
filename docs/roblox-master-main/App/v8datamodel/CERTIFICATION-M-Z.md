# CERTIFICATION-M-Z.md — v8datamodel M–Z independent review

Reviewer: independent subagent, separate session from writer g38.
Method: **all 98 sources tool-call READ IN FULL** (no sampling), each paired .md read in full, every concrete claim checked against source text (descriptor names, verbatim Security:: tiers, event/signal wiring, defaults, throw strings). Dead-code / "not compiled" / "no caller" style claims machine-checked with grep before acceptance (notably StarterPlayerService's alleged wrong-template bug — retracted after grep proved the template argument correct).
Scope boundary verified: `factoryregistration.cpp` and `legacy.cpp` belong to the A–L half and are correctly excluded here; INDEX-A-L cross-check performed.

## Coverage reconciliation

- Sources M–Z in `roblox-sandbox/App/v8datamodel`: **98** (.cpp each).
- Docs on disk: **98/98**, exact 1:1 by name (`diff` clean, EXACT_1TO1).
- 83 new docs (g38 pass) + 15 pre-existing (ManualJointHelper, MarketplaceService, MegaCluster, Message, ModelInstance, Mouse, MouseCommand, NonReplicatedCSGDictionaryService, NotificationService, NumberRange, NumberSequence, ParallelRampInstance, ParametricPartInstance, PartCookie, PartInstance) — all 98 reviewed identically regardless of provenance.
- INDEX-M-Z.md was missing 3 rows (StudioTool, StudioToolMouseCommand, StudioToolVerb) despite docs existing on disk, and carried two stray `- X cross-ref: none.` artifact lines. Both fixed this review; roster now diffs EXACT_1TO1 against sources.

## Totals

| Verdict | Count |
|---|---|
| PASS   | 80 |
| FIXED  | 18 |
| FAIL   | 0 |

Overall: **98/98 CERTIFIED (80 PASS, 18 FIXED, 0 FAIL)**. All fixes were mechanically certain from source text; no judgment-call rewrites.

## Severity findings applied (FIXED files)

| File | Severity | Fix |
|---|---|---|
| ManualJointHelper.md | MISSING-GOTCHA | Added: SmoothTerrain pair duplicate-check condition `prim(0)==p0 \|\| prim(1)==p1` is asymmetric — any manual joint with p1 in slot 1 suppresses creation regardless of other side. |
| MegaCluster.md | WRONG | `onAncestorChanged` does NOT unregister (early return on NULL parent); it claims/silently REPLACES the Workspace terrain slot; unregistration lives in dtor/onServiceProvider. |
| NonReplicatedCSGDictionaryService.md | WRONG | store/retrieveAllDescendants is POST-order (children before self), not pre-order. |
| PartInstance.md | WRONG ×2 | (1) `makeJoints` carries NO deprecated attribute (unlike `breakJoints`); (2) `StoppedTouching` registers via its own accessor `getOrCreateDeprecatedStoppedTouchingSignal`, not literally TouchEnded's signal. |
| PVInstance.md | UNSUPPORTED | Removed unverifiable '"PVInstance" = Position-Velocity Instance' expansion. |
| PyramidInstance.md | WRONG | Shared-base-class complaint lives in PrismInstance.cpp, not this TU; attribution corrected. |
| PointsService.md | STYLE | Draft artifact ("— wait, it does") rewritten; over-limit entries errored then dropped by final clear(). |
| Remote.md | WRONG | `RemoteOnInvokeError` second descriptor param is literally named `"arguments"` despite carrying the error string. |
| RootInstance.md | STYLE | Frustum-loop gotcha self-correction collapsed into the verified fact (breaks at FIRST off-screen part). |
| ScriptMouseCommand.md | WRONG | onMouseHover/onMouseIdle are VOID — no keep-capture return; only the 8 pointer-returning overrides capture. |
| ScreenGui.md | WRONG | `setBufferedViewport` unchanged-value path is a COMPLETE no-op (handleResize only runs inside the changed branch). |
| ScrollingFrame.md | WRONG ×2 | touchInputPositions is an UNCAPPED per-gesture list (ctor size 4 is just initial capacity; inertia averages ALL samples), not a "4-slot ring". |
| Stats.md | UNSUPPORTED | `data.size()>256` bool arg to Http::post is not verifiably "gzip" from this TU; meaning deferred to Http signature. |
| StarterPlayerService.md | WRONG | Claimed wrong-template-type bug RETRACTED after grep: line 341 uses `findFirstChildOfType<RBX::StarterCharacterScripts>()` correctly; only the local variable's declared type is the base class. |
| TeleportService.md | WRONG | Script-strip split across two sites: sanitizer strips ORIGINAL only; clone stripped separately in TeleportImpl (client path); SERVER path replicates an UNSTRIPPED clone. |
| Test.md | STYLE | Require/Fail→done()→stop()→stopScripts kills sibling scripts immediately (draft aside removed, fact kept). |
| UserController.md | WRONG | Button StringConverter exact mapping established: "Jump"-prefixed strings parse as DISMOUNT; everything else (incl. literal "Dismount", garbage) parses as JUMP — fully inverted both ways. |
| UserInputService.md | MISSING-GOTCHA | Added: on INPUT_STATE_BEGIN touches fan to coreTouchMovedEvent (not a started event); gameplay channel gets touchStartedEvent — core-channel TouchStarted never fires from this path. |
| INDEX-M-Z.md | MISSING/STYLE | +StudioTool/StudioToolMouseCommand/StudioToolVerb rows; removed 2 stray cross-ref artifacts; verified EXACT_1TO1. |

## Per-file results

M: ManualJointHelper **FIXED** · MarketplaceService PASS · MegaCluster **FIXED** · Message PASS · ModelInstance PASS · Mouse PASS · MouseCommand PASS

N: NonReplicatedCSGDictionaryService **FIXED** · NotificationService PASS · NumberRange PASS · NumberSequence PASS

P: ParallelRampInstance PASS · ParametricPartInstance PASS · PartCookie PASS · PartInstance **FIXED** · PartOperation PASS · PartOperationAsset PASS · PathfindingService PASS · PersonalServerService PASS · PhysicsInstructions PASS · PhysicsService PASS · PhysicsSettings PASS · Platform PASS · PlatformService PASS · PlayerGui PASS · PlayerMouse PASS · PlayerScripts PASS · PluginManager PASS · PluginMouse PASS · PointsService **FIXED** · Pose PASS · PrismInstance PASS · PVInstance **FIXED** · PyramidInstance **FIXED**

R: Remote **FIXED** · RenderHooksService PASS · ReplicatedFirst PASS · ReplicatedStorage PASS · RightAngleRampInstance PASS · RobloxReplicatedStorage PASS · RootInstance **FIXED**

S: SafeChat PASS · Scale9Frame PASS · ScreenGui **FIXED** · ScriptMouseCommand **FIXED** · ScriptService PASS · ScrollingFrame **FIXED** · Seat PASS · Selection PASS · SelectionBox PASS · SelectionLasso PASS · SelectionSphere PASS · ServerScriptService PASS · ServerStorage PASS · SkateboardController PASS · SkateboardPlatform PASS · Sky PASS · SleepingJob PASS · Smoke PASS · SocialService PASS · SolidModelContentProvider PASS · Sparkles PASS · SpawnLocation PASS · SpecialMesh PASS · Stats **FIXED** · StarterPlayerService **FIXED** · StudioTool PASS · StudioToolMouseCommand PASS · StudioToolVerb PASS · Surface PASS · SurfaceGui PASS · SurfaceSelection PASS

T: Team PASS · Teams PASS · TeleportService **FIXED** · TerrainRegion PASS · Test **FIXED** · TextBox **FIXED** · TextButton PASS · TextLabel PASS · TextService PASS · TextureTrail PASS · TimerService PASS · Tool PASS · ToolMouseCommand PASS · ToolsModel PASS · ToolsPart PASS · ToolsSurface PASS · TouchInputService PASS · TouchTransmitter PASS · TweenService PASS

U: UserController **FIXED** · UserInputService **FIXED**

V: Value PASS · VehicleSeat PASS · VirtualUser PASS · Visit PASS

W: Workspace PASS

## Notable verified catches already correct in writer output (spot list)

- Stats postReportWithUrl body fully commented out (reports go nowhere) + hardcoded Influx creds `te$tu$3r`; signed gather-script chain (VMProtect mutation, RobloxGameScript identity).
- UserInputService GamepadConnected/GamepadDisconnected descriptors crossed relative to their signal variables (lines 248–249).
- Tool 0.2 s multi-equip timer binds raw `this` (use-after-free window); special Equipped signal throws on generic fireEvent.
- PartInstance script CFrame/Velocity writes retarget to MECHANISM ROOT under script security identities; NULL getOrCreateNetworkOwnerChangedSignal returns NULL.
- Workspace MOUSEBUTTON3 case falls through to MOUSEWHEEL (no break); deceptive Kernel SolverIterations/MatrixSize stats ("to throw off the competition").
- MegaCluster GetNumSlices reads "NumSides"; PathfindingService OUTSIDE halts A* expansion; doProcessMouseEvent wheel branch scrolls anywhere over frame.
