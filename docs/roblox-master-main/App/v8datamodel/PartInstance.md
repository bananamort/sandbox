# PartInstance.cpp

## Purpose

Implements `PartInstance`, the engine class behind the script-facing `BasePart` (`sPart = "BasePart"`, display/serialization name "Part"; `DescribedNonCreatable<PartInstance, PVInstance, "BasePart">` — you never create a bare BasePart, only subclasses like Part/WedgePart via BasicPartInstance). Owns one V8World `Primitive` (GEOMETRY_BLOCK by default) and is the junction of appearance (Color/BrickColor/Material/Transparency/Reflectance), physics state (CFrame/Velocity/Size/Anchored/CanCollide/Friction/Elasticity), network ownership, the Touched event machinery, render interpolation, and Studio debug adorn rendering. This TU also registers the `Material`, `FormFactor`, and `NetworkOwnership` reflection enums and the CoordinateFrame XML serializer (X/Y/Z + R00…R22 tags).

## Key types and API

### Descriptor-registered Lua surface (real names; security tier in parens)

Methods:
- `BreakJoints()` (None) — `destroyJoints`: kills auto AND manual joints via `World::destroyAutoJoints`. Deprecated twin `breakJoints` marked deprecated → BreakJoints.
- `MakeJoints()` / deprecated legacy `makeJoints` (None) — `World::createAutoJoints`.
- `GetMass()` + legacy `getMass` (CustomBoundFunc, None) — with DFFlag MaterialPropertiesEnabled returns `getCalculateMass(workspace->getUsingNewPhysicalProperties())`, else body mass.
- `IsGrounded()` (None) — `Primitive::computeIsGrounded`.
- `GetConnectedParts(recursive: bool = false)` (None) — non-recursive = kinematic-joint neighbors; recursive walks the ungrounded assembly, or (grounded case) kinematic joints recursively excluding terrain.
- `GetRootPart()` (None) — PartInstance of assembly root primitive.
- `GetRenderCFrame()` (None) — interpolated rendering CFrame.
- `SetNetworkOwner(playerInstance: Player? = nil)` (None) — sets Manual rule + owner address (player's remote address or Server for nil); no-op in play-solo; throws on invalid conditions (see canSetNetworkOwnership).
- `GetNetworkOwner()` (None) — Player instance or nil (server-side only).
- `SetNetworkOwnershipAuto()` / `GetNetworkOwnershipAuto()` (None) — rule on the ROOT MOVING primitive; throw `std::runtime_error(statusMessage)` when disallowed.
- `CanSetNetworkOwnership()` (None) — returns `(bool[, reason])` tuple instead of throwing.
- `Resize(normalId, deltaAmount)` + deprecated `resize` (None) — int grid resize; destroys joints, tries, reverts on intersection with world/others, rejoins.
- `GetTouchingParts()` (None) — ContactManager part collisions.

Properties (category in parens):
- `CFrame` (Data) — get primitive CF; **setter `setCoordinateFrameRoot` retargets writes from scripts to the MECHANISM ROOT part** when `currentSecurityIdentityIsScript()` (identities LocalGUI_, GameScript_, GameScriptInRobloxPlace_, RobloxGameScript_, StudioPlugin [RBX_STUDIO_BUILD], CmdLine_) — moving any welded part moves the whole assembly.
- `Position` (Data, UI flag), `Rotation` (Data, UI) — euler-degrees accessors; UI setters do destroyJoints→set→safeMove→join.
- `Velocity` (Data), `RotVelocity` (Data) — linear/rotational velocity; setters also mechanism-root-retargeted for scripts.
- `SpecificGravity` (Data, UI-only descriptor with NULL setter) — density readout driven by Material.
- `size` (Part, STREAMING) + write-prep legacy `"siz"` (LEGACY) + UI `Size`; sphere-type parts clamp to uniform `.xxx()`. DFFlag FixShapeChangeBug changes ordering so uniform-size parts still raise size change.
- `Elasticity` (Part) clamped [0,1]; `Friction` (Part) clamped [-FLT_MIN, FLT_MAX]; `CustomPhysicalProperties` (Part, PhysicalProperties).
- `BrickColor` (Appearance) + deprecated `brickColor`; `Color` (Appearance, Functionality(UI)); `Transparency` (Appearance); `Reflectance` (Appearance); `Material` enum (Appearance) — setting updates specific gravity then material, raises both SpecificGravity and Material changes.
- `LocalTransparencyModifier` (Data, HIDDEN_SCRIPTING) — camera-proximity fade; `onCameraNear` maps <cameraTransparentDistance→1.0, <translucent→0.5, else 0.0.
- `Anchored` (Behavior) — anchoring gathers future mechanism roots and propagates ownership/rule to them (flag-ladder SetNetworkOwnerFixAnchoring2 > FixAnchoring > legacy); FFlag AnchoredSendPositionUpdate sends one final CFrame update on anchor so clients agree.
- `CanCollide` (Behavior) — inverted onto Primitive::preventCollide; `Locked` (Behavior); `DraggingV1` (Behavior, REPLICATE_ONLY); `ReceiveAge` (Part, HIDDEN_SCRIPTING, read-only interpolation sample interval); `ResizeableFaces`/`ResizeIncrement` (Behavior, UI-only, NULL setters); `NetworkOwnershipRuleBool` (Behavior, REPLICATE_ONLY) — bool stand-in for the NetworkOwnershipRule enum replication hack (enum variant commented out as unsafe).
- `NetworkOwnerV3` (Data, REPLICATE_ONLY) — SystemAddress ownership property used by replication; `NetworkIsSleeping` (Data, REPLICATE_ONLY).

Events:
- `Touched(otherPart)` (+ deprecated `touched`) — fired via TouchTransmitter gating; `TouchEnded(otherPart)` (+ deprecated `StoppedTouching` aliasing it); `LocalSimulationTouched(part)`; `OutfitChanged()`; `NetworkOwnerChanged(systemAddress)` — RemoteEventDesc, **Security::LocalUser**, REPLICATE_ONLY CLIENT_SERVER (its `getOrCreateNetworkOwnerChangedSignal` returns NULL here — signal resolved through the base-class path); `OwnershipChange` exists only under RBX_TEST_BUILD.

Enums registered: `Material` (Plastic…Neon, Air/Water/Rock/Glacier/Snow/Sandstone/Mud/Basalt/Ground/CrackedLava; legacy names "Corroded Metal"→CorrodedMetal, "Aluminum"→Foil), `FormFactor` (Symmetric/Brick/Plate/Custom, legacy "Block"→Brick), `NetworkOwnership` (Automatic/Manual). Statics debug toggles: showContactPoints, showJointCoordinates, highlightSleepParts, highlightAwakeParts, showBodyTypes, showAnchoredParts, showPartCoordinateFrames, showUnalignedParts, showSpanningTree, showMechanisms, showAssemblies, showReceiveAge, disableInterpolation, showInterpolationPath.

FastFlags DECLARED here: SetUpdateTimeOnClumpChanged, SetNetworkOwnerFixAnchoring(2), NetworkOwnershipRuleReplicates, LocalScriptSpawnPartAlwaysSetOwner, MaterialPropertiesEnabled, SYNCHRONIZED MaterialPropertiesNewIsDefault/NewPhysicalPropertiesForcedOnAll, STATIC FFlag AnchoredSendPositionUpdate, FormFactorDeprecated, FixShapeChangeBug, FixFallenPartsNotDeleted (referenced: HumanoidFloorPVUpdateSignal, HumanoidCookieRecursive, CleanUpInterpolationTimestamps). LOGGROUP(PartInstanceLifetime).

### Notable internals
- Ctor defaults: top NORM_Y=STUDS, bottom NORM_Y_NEG=INLET surfaces; friction/elasticity from defaults; specific gravity per-material table (`toSpecificGravity`, sourced simetric.co.uk; Plastic/Neon=0.7 … metals 7.85, Air=0, Water=1).
- `setName` hack: naming a part "HumanoidRootPart" sets primitive size multiplier ROOT_SIZE, "Torso"→TORSO_SIZE, anything else DEFAULT_SIZE.
- `setCoordinateFrame`: NaN/Inf CFrame silently teleports part to (0,-FLT_MAX,0) ("Put the part way down so that Workspace will delete it") — comment admits scripts should ideally throw; rotations orthonormalized.
- `updatePrimitiveState` (on ancestor change): removes/inserts primitive in World; reports untouch for all live contacts on removal; initial ownership: unassigned parts owned by local player if it has a character head (or always under LocalScriptSpawnPartAlwaysSetOwner), else ServerUnassigned; grounded parts force-sleeped on insert.
- Ownership bookkeeping: `cachedNetworkOwnerIsSomeoneElse` cached on the mechanism root; `notifyNetworkOwnerChanged` matrix notifies old/new owners per server/client transition; `processRemoteEvent` applies replicated NetworkOwnerV3 and (FixFallenPartsNotDeleted) resets 3-second takeover timeout so fallen parts aren't handed back to the client before deletion.
- Touched machinery: connecting scripts bumps touchedSlotCount; 0→1 adds a TouchTransmitter child, 1→0 removal removes it; reportTouch/reportUntouch pass through transmitter checkTouch/checkUntouch de-dup.
- Interpolation: optional `PathInterpolatedCFrame`; `calcRenderingCoordinateFrame` honors humanoid floor attachment under HumanoidFloorPVUpdateSignal; mechanism-root-relative computation for non-root parts.
- `isProjectile` heuristic: linear speed ≥ 25 studs/s AND single-primitive Clump AND single-Clump Assembly AND single-Assembly Mechanism.
- Anchoring/unanchoring propagates consistent owner+manual rule to newly-rooted neighbor primitives, skipping player-character parts (`isPlayerCharacterPart`).

## Usage

Consumers: everything. Workspace inserts/removes primitives via updatePrimitiveState; Humanoid relies on IS_HUMANOID_PART cookie (`updateHumanoidCookie` — recursive ancestor scan under DFFlag HumanoidCookieRecursive, else direct-parent check); PartCookie::compute preserves the bit; MouseCommand raycasts resolve hits back to PartInstance via fromPrimitive/fromConstPrimitive (`rbx_static_cast` of Primitive::getOwner); JointInstance co-parent processing happens on ancestry change because joints effectively have two parents. Cross-references: replication side documented in ../Network/Players.cpp.md and ../Network/NetworkOwnerJob.cpp.md; terrain geometry pairs with MegaCluster.md in this folder.

## Gotchas

- Script CFrame/Velocity writes move the WHOLE MECHANISM (root part), not just the addressed part — direct C++ callers writing setCoordinateFrame bypass this; the retarget depends on Security::Context identity, so engine-internal writers keep per-part control.
- Invalid CFrame does NOT throw — the part is teleported to -FLT_MAX Y and falls out of the world.
- GetMass changes meaning entirely under MaterialPropertiesEnabled (new vs legacy mass calculation depending on workspace mode).
- CanSetNetworkOwnership failure reasons are exact strings: not-in-Workspace, client-caller ("can only be called from the Server"), Terrain, anchored-or-welded-to-anchored; Set*/Get* variants THROW these messages while Can* returns them.
- Resize reverts silently (returns false) if the new size intersects; joints are destroyed/recreated around every resize either way.
- The 3-second networkOwnerTime takeover clock is server-side only ("does NOTHING on the Client").
- Multiple mesh/decal children: see PartCookie.md last-wins semantics; IS_HUMANOID_PART survives compute but mesh flags don't.
- UNKNOWN: header-side members (prop_Size extern usage sites, OnDemandPartInstance full struct, RootPrimitiveOwnershipData layout, PathInterpolatedCFrame algorithm) live in V8DataModel/PartInstance.h and Util headers outside this TU.
