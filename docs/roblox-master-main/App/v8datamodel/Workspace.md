# Workspace.cpp

## Purpose

Implements `Workspace`, the world container and physics stepping facade: owns the V8World World, camera replenishment, Terrain (MegaClusterInstance) lifecycle, the MouseCommand state machine (sticky tools, plugin overrides, arrow/null defaults), per-step physics with fallen-part deletion and touch-pair reporting, raycast/region query script API, FilteringEnabled/StreamingEnabled/PGS solver toggles, mouse-pan/wrap mode negotiation, SurfaceGui 3D input hit-testing, WorkspaceStatsItem metrics tree, and the classic script-run rules.

## Key types and API

Descriptors:
- "DistributedGameTime" double, cap STANDARD_NO_REPLICATE (server transmits via dedicated path; clients setDistributedGameTimeNoTransmit).
- "StreamingEnabled" bool cap STANDARD_NO_REPLICATE; "PGSPhysicsSolverEnabled" PUBLIC_SERIALIZED; "ExpSolverEnabled_Replicate" STREAMING (mirror raised in tandem); "FilteringEnabled" STANDARD_NO_REPLICATE (server-only GA ping once; CreatePlayerGuiLocal flag pre-creates PlayerGui); "FallenPartsDestroyHeight" float clamp ±50000, STANDARD_NO_SCRIPTING; "AllowThirdPartySales" STANDARD_NO_REPLICATE; "PhysicalPropertiesMode" enum {Default, Legacy, New} — STANDARD_NO_SCRIPTING in release, STANDARD in test builds, runtime changes WARN-rejected ("Cannot change PhysicalPropertiesMode during Runtime").
- Plugin tier: GetPhysicsAnalyzerIssue(index):Instances / Set+GetPhysicsAnalyzerBreakOnIssue / PhysicsAnalyzerIssuesFound(count) event — PGS inconsistent-body island introspection.
- **Security::Plugin**: MakeJoints/BreakJoints(objects), ZoomToExtents.
- **Security::None**: FindPartsInRegion3(+deprecated lowercase, +WithIgnoreList), IsRegion3Empty(+WithIgnoreList), FindPartOnRay(+deprecated, +WithIgnoreList) returning Tuple{part, point, normal, material}; Terrain read-only RefProp (cap UI); GetRealPhysicsFPS():double / GetPhysicsThrottling():int / GetNumAwakeParts():int; PGSIsEnabled(); JoinToOutsiders(objects, jointType)/UnjoinFromOutsiders; ExperimentalSolverIsEnabled (**Security::TestLocalUser**).
- "CurrentCamera" RefProp STANDARD_NO_REPLICATE — getCurrentCameraDangerous breaks const; setCurrentCamera client/cloud-edit only, destroys other child cameras, raises currentCameraChangedSignal.

Statics: serverIsPresent/clientIsPresent/findWorkspace/getWorkspaceIfInWorkspace/getWorldIfInWorkspace/getContactManagerIfInWorkspace/contextInWorkspace/findTopInstance helpers used across the engine. Debug statics showWorldCoordinateFrame/showHashGrid/showEPhysicsOwners/etc., gridSizeModifier 4.0.

Stepping (`physicsStep`): asserts assembled; longStep updates DistributedGameTime + deferred terrain changes; PGS solver file-dump user id under flag; world->step returns adjusted interval; PhysicsAnalyzer issue event when FFlag on; TOUCH REPORTING copies world touch info into shared_ptr TouchPairs FIRST (comment: prevents PartInstance collection during event firing) — FixTouchEndedReporting switches from primitive-derived to stored PartInstance refs; handleFallenParts (DPHYS clients hand fallen parts to server ownership with resetNetworkOwnerTime(3) unless fix-flag, otherwise delete + clearEmptiedModels cascade removing emptied models/accoutrements/backpack items, notifying onCharacterDied under UseStarterPlayerCharacter); then reportTouch/Untouch + localSimulationTouched/deprecatedStoppedTouching signals + stepTouch into PhysicsService.md pipeline.

MouseCommand machine: setMouseCommand rejects NULL/clearing when an active tool-plugin holds override (unless allowPluginOverride); NULL result pulls stickyCommand->isSticky() re-instantiation (HingeTool-style persistence); still-NULL defaults to AdvArrowTool for no-local-player/cloud-edit else NewNullTool; switching deactivates competing tool plugins; updatePlayerMouseCommand re-points player's Mouse workspace. setNullMouseCommand forces NewNullTool; setDefaultMouseCommand clears sticky + command (hooked to allPluginsDeactivatedSignal). process() routes events: plugin Mouse update first, SurfaceGui hit-test (handleSurfaceGui: tool-wielding characters get punch-through distance limits, terrain + close-up character ignored in rays, unProcess on last active gui), idleMouseEvent synthesis for heartbeat-driven onMouseIdle, then keyboard peek/down/up, right-button pan bookkeeping (setRightMousePan honors LuaControlsDisableMouse2Lock excluding CUSTOM_CAMERA), left down/up, middle track, wheel, move/delta dispatch by captured() vs hover.

Camera/misc: replenishCamera clones utilityCamera when no Camera descendant (heartbeat "slop"); createTerrain instantiates MegaClusterInstance at (−2, h/2, −2) locked; setImageServerView ThumbnailCamera hunt + triple-hop HopperBin fullscreen hack; getRealPhysicsFPS reports GA once-per-threshold (>65/70/80/90/100) for elevated physics rates, masking to 60 under PreventReturnOfElevatedPhysicsFPS; WorkspaceStatsItem builds the Stats tree including intentionally DECEPTIVE SolverIterations/MatrixSize kernel metrics ("to throw off the competition").

Scripts: scriptShouldRun — BaseScript backend-only, LocalScript only inside LOCAL character (sets LocalPlayer).

## Usage / reflection touchpoints

The central world service. Pairs with Camera docs, MegaCluster.md/TerrainRegion.md, PhysicsService.md, MouseCommand.md family, RootInstance.md, UserInputService.md, Stats.md in this folder; [Network](../../Network/) for DPHYS/fallen-part ownership.

## Gotchas

- FallenPartsDestroyHeight setter clamps but the WORLD stores whatever; mismatch window between property read-back and actual.
- GetRealPhysicsFPS LIES by design under its flags (returns 60) — telemetry consumers must use RunService directly.
- The two fake Kernel stats metrics are deliberate disinformation.
- handleSurfaceGui ignores the CHARACTER only within 0.5 studs of camera focus — mid-distance self-hits still block clicks.
- process() falls through MOUSEBUTTON3 into MOUSEWHEEL handling (no break after middle-mouse cases) — wheel handlers see middle-button events' fall-through only because of explicit isMouseWheel checks.
- clearEmptiedModels recursion detaches parents bottom-up; a model containing ONLY empty submodels collapses level by level in one call chain.
