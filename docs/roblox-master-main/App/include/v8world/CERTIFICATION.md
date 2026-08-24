# v8world Documentation Certification — Independent Review

**Reviewer**: independent re-review (prior reviewer instance died before writing anything; review redone from scratch).
**Date**: 2026-02-27 (review session)
**Scope**: all sources in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/v8world/` vs docs in `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/v8world/`.

## Method

- Every source file (.h and the folded .inl) was **read in full via tool calls** — no sampling. Every .md was read in full immediately after its source.
- Every concrete claim (class bases, member names, enum orders, inline formulas, constants, in-header comments/typos quoted as such, bug claims) was checked against the source text.
- Cross-file claims spot-checked at target (`v8kernel/IStage.h` pipeline order, `ContactParams.h` kFriction comment, existence of every relative cross-link target — 30/30 resolve).
- Severity tags: WRONG / UNSUPPORTED / MISSING-GOTCHA / STYLE. Mechanically-certain fixes applied in place (docs tree only; `roblox-sandbox/` untouched).

## Coverage arithmetic (re-enumerated independently)

- Sources: **89 `.h` + 1 `.inl` = 90 files**.
- Docs: **89 source-derived `.md` + `INDEX.md` = 90 files**; `SpatialHashMultiRes.md` folds `SpatialHashMultiRes.inl` (1,736 lines — count verified exactly).
- Note for orchestrator: the writer's summary phrase "89 headers ↔ 88 .md" is off-by-one on both operands; correct statement is **89 .h + 1 .inl ↔ 89 .md + INDEX.md = 90 files**. INDEX.md's own accounting ("89 of 89 headers documented, 1 .inl folded") is correct.

## Per-file certification

| # | Source | Doc | Verdict | Notes |
|---|--------|-----|---------|-------|
| 1 | Assembly.h | Assembly.md | PASS | All API, FilterPhase order, visitor stop-at-root semantics verified. |
| 2 | AssemblyHistory.h | AssemblyHistory.md | PASS | Members/statics exact; constants correctly deferred to .cpp. |
| 3 | AssemblyStage.h | AssemblyStage.md | PASS | No-sim-root→fixed aliasing verified. |
| 4 | Ball.h | Ball.md | PASS | 6 fake surfaces, assert stubs, solid inertia verified. |
| 5 | BallCellContact.h | BallCellContact.md | PASS | Three-tier feature search matches. |
| 6 | BallPolyContact.h | BallPolyContact.md | PASS | Near-clone of cell variant confirmed. |
| 7 | BasicSpatialHashPrimitive.h | BasicSpatialHashPrimitive.md | PASS | Dtor −2 sentinel, debug switch claims exact. |
| 8 | Block.h | Block.md | PASS | Both claimed bugs re-derived mechanically: `ccwEdge+1 % 4` precedence → inner-array OOB read; `edgeId > 12` off-by-one for clockwise edge 12. Correctly documented. |
| 9 | BlockCorners.h | BlockCorners.md | PASS | vertices[0] = all-positive corner trace confirmed; stale-comment gotcha valid. |
| 10 | BlockMesh.h | BlockMesh.md | PASS | |
| 11 | BulletContact.h | BulletContact.md | PASS | FixedArray<...,4>, embedded btCollisionObject, `Paremeters` sic all verified. |
| 12 | BulletGeometryPoolObjects.h | BulletGeometryPoolObjects.md | PASS | USE_GIMPACT toggle + margin 0.05f + global-scope constant verified. |
| 13 | BulletShapeCellContact.h | BulletShapeCellContact.md | PASS | Asserted-out findClosestFeatures trap documented correctly. |
| 14 | BulletShapeContact.h | BulletShapeContact.md | PASS | `/*implement*/` findClosestFeatures(BulletConnectorArray&) signature verified. |
| 15 | Buoyancy.h | Buoyancy.md | PASS | MAX_CONNECTORS=8, mutable waterViscosity, computeIsCollidingUi≡false quote verified. |
| 16 | CellContact.h | CellContact.md | PASS | Offset table + oppositeSideOffset table + internal-linkage const array gotcha verified. |
| 17 | CleanStage.h | CleanStage.md | PASS | In-header contract quote + leftover `<map>` include verified. |
| 18 | Clump.h | Clump.md | PASS | |
| 19 | Contact.h | Contact.md | PASS | CONTACT/BULLET macros=40, SAT formula, hysteresis fields, feature encoding comment all verbatim-verified. |
| 20 | ContactManager.h | ContactManager.md | FIXED (minor) | STYLE fix: CullableSceneNode dead-end overloads are "assert, no-op, or return false" (checkTerrainContact overload is an empty body). |
| 21 | ContactManagerSpatialHash.h | ContactManagerSpatialHash.md | PASS | MAXLEVELS=4 instantiation verified. |
| 22 | ContactStage.h | ContactStage.md | PASS | |
| 23 | Controller.h | Controller.md | PASS | 13 inputs + NUM_INPUT_TYPES counted; string-matrix comment verified. |
| 24 | CornerWedgeMesh.h | CornerWedgeMesh.md | PASS | |
| 25 | CornerWedgePoly.h | CornerWedgePoly.md | PASS | isGeometryOrthogonal false verified. |
| 26 | Cylinder.h | Cylinder.md | PASS | Geometry-not-Poly + COLLIDE_BULLET-only verified. |
| 27 | DistributedPhysics.h | DistributedPhysics.md | PASS | All four values + both comments verbatim. |
| 28 | Edge.h | Edge.md | PASS | (&prim0)[i] trick, dtor asserts + badMemory stamping verified. |
| 29 | EdgeBuffer.h | EdgeBuffer.md | PASS | DEBUG ONLY BiMultiMap + spring/kinematic gating verified. |
| 30 | EdgeStage.h | EdgeStage.md | PASS | |
| 31 | Enum.h | Enum.md | PASS | Stale `// namespace WORLD`, _WIN32 unsigned char only, NUM-before-UNDEFINED verified. |
| 32 | Feature.h | Feature.md | PASS | Name collisions + stale closing comment verified. |
| 33 | Geometry.h | Geometry.md | PASS | 12 GeometryTypes / 4 CollideTypes, zero-moment default trap verified. |
| 34 | GeometryPool.h | GeometryPool.md | PASS | SAFE_STATIC per-instantiation, spin mutex, move-only Token, operator void* comment verbatim. |
| 35 | GlueJoint.h | GlueJoint.md | PASS | PGS constraints member + ManualGlueJoint defaults verified. |
| 36 | GroundStage.h | GroundStage.md | PASS | All private machinery names match. |
| 37 | HumanoidStage.h | HumanoidStage.md | PASS | |
| 38 | IMoving.h | IMoving.md | PASS | stepsToSleep==0 sleeping, `Continous` sic, notifyMoved comment verbatim. |
| 39 | IPipelined.h | IPipelined.md | PASS | >=/> enum comparisons, findWorld upstream-of-kernel trick verified. |
| 40 | IWorldStage.h | IWorldStage.md | PASS | MetricType pass-through verified. |
| 41 | Joint.h | Joint.md | PASS | Full JointType order, all range-arithmetic classifiers incl. MANUAL_GLUE exclusion, getNormalId side-1-opposite verified. |
| 42 | JointBuilder.h | JointBuilder.md | PASS | makeJoint commented out; commented include verified. |
| 43 | JointStage.h | JointStage.md | PASS | BiMultiMap mirror + incompleteJoints verified. |
| 44 | KDTree.h | KDTree.md | PASS | Bitfield layout, axis==3 leaf marker, RayResult defaults verified. |
| 45 | KernelJoint.h | KernelJoint.md | PASS | getBody body0-only behavior verified. |
| 46 | MaterialProperties.h | MaterialProperties.md | PASS | Fastflag + weighted-average helper signatures verified. |
| 47 | Mechanism.h | Mechanism.md | PASS | isComplexMovingMechanism comment verbatim. |
| 48 | MechToAssemblyStage.h | MechToAssemblyStage.md | PASS | Distinct fixed/sim/no-sim entry points verified. |
| 49 | MegaClusterMesh.h | MegaClusterMesh.md | PASS | LocalCofM never written by ctor — verified. |
| 50 | MegaClusterPoly.h | MegaClusterPoly.md | PASS | MC_* constants, extended hitTest signature loss via Geometry*, identity moment verified. |
| 51 | Mesh.h | Mesh.md | PASS | numFaces()==edges.size() quirk, winding swap, Varonoi sic, all builders verified. |
| 52 | Motor6DJoint.h | Motor6DJoint.md | PASS | Legacy-script shim comments verbatim. |
| 53 | MotorJoint.h | MotorJoint.md | PASS | poseDuration=32 + tweak comment verbatim. |
| 54 | MovingAssemblyStage.h | MovingAssemblyStage.md | PASS | uiStepJoints vs animatedJoints distinction sound. |
| 55 | MovingStage.h | MovingStage.md | PASS | |
| 56 | MultiJoint.h | MultiJoint.md | PASS | point[8]/connector[4] capacities verified. |
| 57 | ParallelRampMesh.h | ParallelRampMesh.md | PASS | |
| 58 | ParallelRampPoly.h | ParallelRampPoly.md | PASS | setUpBulletCollisionData≡false inline verified. |
| 59 | Poly.h | Poly.md | PASS | surfaceId=face-index mapping story consistent with subclasses. |
| 60 | PolyCellContact.h | PolyCellContact.md | PASS | swapPrims/myPCContact/pairIsValid + commented size-8 archaeology verified. |
| 61 | PolyContact.h | PolyContact.md | PASS | CONTACT_ARRAY_SIZE typedef + TODO + commented size-12 predecessor verified. |
| 62 | PolyPolyContact.h | PolyPolyContact.md | PASS | match() keys on primitive[0] only — verified. |
| 63 | Primitive.h | Primitive.md | PASS | Every listed member/quirk verified (flyweight, CompactEnums, hasGetFirstContact, SizeMultiplier comment, unsafe-CF lock contract). |
| 64 | PrismMesh.h | PrismMesh.md | PASS | Vestigial-setter observation correct. |
| 65 | PrismPoly.h | PrismPoly.md | PASS | Only parameter-accepting Geometry family claim consistent w/ base RBXASSERT(0). |
| 66 | PyramidMesh.h | PyramidMesh.md | PASS | |
| 67 | PyramidPoly.h | PyramidPoly.md | PASS | |
| 68 | RightAngleRampMesh.h | RightAngleRampMesh.md | PASS | |
| 69 | RightAngleRampPoly.h | RightAngleRampPoly.md | PASS | Face remap override present. |
| 70 | RigidJoint.h | RigidJoint.md | PASS | jointIsRigid duplication + TODO quote verified. |
| 71 | RotateJoint.h | RotateJoint.md | PASS | 4-class hierarchy + per-level kernel overrides verified. |
| 72 | SendPhysics.h | SendPhysics.md | PASS | reportSimJobs resume/skip/-1 semantics + ReadOnlyValidator verified. |
| 73 | SimJob.h | SimJob.md | PASS | Tracker back-pointer vector + transferTrackers verified. |
| 74 | SimulateStage.h | SimulateStage.md | PASS | `#if 0` std::map choice + ex-SimJobStage note verified. |
| 75 | SleepStage.h | SleepStage.md | PASS | State sets, IndexArray on steppingIndexFunc, metrics override verified. |
| 76 | SmoothClusterGeometry.h | SmoothClusterGeometry.md | PASS | btDbvt tree, GC cursors, material-from-triangle API verified. |
| 77 | SnapJoint.h | SnapJoint.md | PASS | `// WeldJoint` copy-paste artifact verified. |
| 78 | SpatialFilter.h | SpatialFilter.md | PASS | Policy matrix reproduced faithfully incl. N0 typo + mojibake byte. |
| 79 | SpatialHashMultiRes.h + .inl (FOLDED) | SpatialHashMultiRes.md | PASS | Full 435-line header + full 1,736-line .inl read. Verified: numBuckets≡65536 ignoring arg; hashGridSize shift; TreeNode.children[8]=bucket hashes (lossless @65536); rootLevel=MAX_LEVELS−1; computeLevel slack/thin-object buffer + ×8 ladder + anchored cap; level pinned at insert with grow-always/shrink-if-delta<−1 hysteresis; pair gen gated on hasGetFirstContact + getContact==NULL; addContactFromChildren; plain new/delete despite object_pool members (vestigial); doStats #if 0'd; getNextGrid 2-cell pad w/ exact comment; overlapping queries' 0.01 max-shrink + cache-miss comment; __if_exists(Primitive::getFirstContact); fastClear releaseMemory(); NodeBase −2 sentinels. Dead-code syntax error at .inl line 1324 (`...extentsDistance)));` under `#else /* PRECISE_SORTING */`) confirmed by paren count. Doc accurate on all counts. |
| 80 | StepJointsStage.h | StepJointsStage.md | PASS | |
| 81 | SurfaceData.h | SurfaceData.md | PASS | Include-before-#pragma-once quirk + −0.5/0.5 asymmetric defaults verified. |
| 82 | TerrainPartition.h | TerrainPartition.md | PASS | Mega cell-granularity vs smooth chunk-granularity, slice masks, masksHor/Ver precompute verified. |
| 83 | Tolerance.h | Tolerance.md | PASS | Obfuscated maxExtents formula (fuzzyMil expr + rand()%65536 jitter + static local + "cds" comment) verbatim; derived-tolerance couplings verified. |
| 84 | TreeStage.h | TreeStage.md | PASS | SpanningTree overrides + swapTree + assemble/isAssembled verified. |
| 85 | TriangleMesh.h | TriangleMesh.md | PASS | PHYSICS_SERIAL_VERSION=3, bbox-owned dragger fakes, hollow-bbox inertia, Block friend verified. |
| 86 | WedgeMesh.h | WedgeMesh.md | PASS | No LocalCofM member — verified. |
| 87 | WedgePoly.h | WedgePoly.md | PASS | Real Bullet hull token vs ramps verified. |
| 88 | WeldJoint.h | WeldJoint.md | PASS | Terrain-cell accessors + World cleanup cross-ref consistent. |
| 89 | World.h | World.md | FIXED (minor) | STYLE fix: groundPrimitive quote corrected to actual in-header text "for now, only used by kernel joints". Pipeline-order claim independently verified against v8kernel/IStage.h enum (exact match). |
| 90 | (fold accounting) | INDEX.md | PASS | 89/89 rows, fold noted, 1,736-line count exact; all row notes consistent with reviewed sources. |

## Totals

- **PASS**: 87
- **FIXED**: 2 (both minor STYLE-level verbatim-quote/dead-end-description corrections: ContactManager.md, World.md)
- **FAIL**: 0
- **WRONG claims found**: 0
- **UNSUPPORTED claims found**: 0
- **MISSING-GOTCHA findings**: none of substance (all significant traps — Block indexing bugs, Tolerance obfuscation, SpatialHash PRECISE_SORTING syntax error, vestigial pools, MegaClusterMesh uninitialized CoFm, worldStepId wraparound, etc. — are already documented)
- **Cross-link integrity**: 30/30 relative targets resolve; pipeline-order and kFriction cross-file claims verified at their sources.

## Residual risk

- Claims explicitly scoped to .cpp implementations (threshold values, hash function, wire formats) are marked UNKNOWN in the docs and were not verifiable from App/include — appropriately hedged.
- The two FIXED edits are confined to `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/v8world/`; no file under `roblox-sandbox/` was modified.
