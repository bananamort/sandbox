# App/include/v8world — Index

World-side rigid physics: Primitives grouped into Clump/Assembly/Mechanism spanning trees, the IStage pipeline from CleanStage to SimulateStage, joints (weld/snap/glue/motor/rotate), analytic contacts (ball/block/poly/cell) plus Bullet bridge contacts and buoyancy, geometry shapes with pooled meshes/Bullet hulls, terrain (legacy mega-cluster + smooth cluster), broadphase spatial hash, sleep/throttle/spatial-filter subsystems, and the World facade that drives it all.

| File | Doc | Notes |
|---|---|---|
| Assembly.h | [Assembly.md](Assembly.md) | Simulation unit (root primitive + rigid descendents); filter/sleep/simJob scratch state; motor-angle physics IO. |
| AssemblyHistory.h | [AssemblyHistory.md](AssemblyHistory.md) | Rolling-average motion memory for SleepStage decisions; thresholds in .cpp. |
| AssemblyStage.h | [AssemblyStage.md](AssemblyStage.md) | ASSEMBLY_STAGE; fixed/no-sim/simulate root+descendent transitions; no-sim roots alias fixed handlers. |
| Ball.h | [Ball.md](Ball.md) | Sphere geometry; solid inertia; fakes 6 dragger surfaces; face-overlap queries assert. |
| BallCellContact.h | [BallCellContact.md](BallCellContact.md) | Ball vs terrain-cell poly contact; plane→edge→vertex feature search. |
| BallPolyContact.h | [BallPolyContact.md](BallPolyContact.md) | Ball vs poly part contact; same three-tier search as cell variant. |
| BasicSpatialHashPrimitive.h | [BasicSpatialHashPrimitive.md](BasicSpatialHashPrimitive.md) | Mixin required by SpatialHash; cached extents + node level; debug-mode link tracking. |
| Block.h | [Block.md](Block.md) | Box Poly; hollow-box inertia; **2 latent indexing bugs**: getEdgeVertex `ccwEdge+1 % 4` precedence OOB, getEdgeNormal `>12` off-by-one for clockwise edges. |
| BlockCorners.h | [BlockCorners.md](BlockCorners.md) | Pooled 8-corner array keyed by size. |
| BlockMesh.h | [BlockMesh.md](BlockMesh.md) | Pooled block Mesh payload. |
| BulletContact.h | [BulletContact.md](BulletContact.md) | Legacy Bullet bridge: BulletConnector (4-pt cap), BulletContact, BulletCellContact (embedded btCollisionObject). |
| BulletGeometryPoolObjects.h | [BulletGeometryPoolObjects.md](BulletGeometryPoolObjects.md) | Pooled Bullet shapes (box/sphere/cylinder/wedge hulls + GIMPACT decomp); USE_GIMPACT build toggle; margin 0.05f. |
| BulletShapeCellContact.h | [BulletShapeCellContact.md](BulletShapeCellContact.md) | Terrain-cell Bullet manifold contacts w/ connector matching; findClosestFeatures asserts (compound-NP path only). |
| BulletShapeContact.h | [BulletShapeContact.md](BulletShapeContact.md) | Part↔part Bullet manifold contacts w/ cross-frame closest-feature matching. |
| Buoyancy.h | [Buoyancy.md](Buoyancy.md) | Water contacts per shape; box family subdivides into 8 voxel connectors; computeIsCollidingUi ≡ false (build underwater); mutable static waterViscosity. |
| CellContact.h | [CellContact.md](CellContact.md) | CellContact (grid-feature tag) + CellMeshContact base; kFaceDirectionToLocationOffset table; oppositeSideOffset. |
| CleanStage.h | [CleanStage.md](CleanStage.md) | CLEAN_STAGE; passes only edges with two distinct non-null primitives downstream. |
| Clump.h | [Clump.md](Clump.md) | Geometry-motivated grouping (IndexedMesh); clump-root predicate differs from assembly-root. |
| Contact.h | [Contact.md](Contact.md) | Edge-based contact base + BallBall/BallBlock/BlockBlock (SAT + witness hysteresis via BlockBlockContactData); CONTACT_ARRAY_SIZE 40 macros. |
| ContactManager.h | [ContactManager.md](ContactManager.md) | Broadphase owner + ray casts (getHit/getHitLegacy), extents queries, deferred terrain re-checks, ConcurrencyValidator. |
| ContactManagerSpatialHash.h | [ContactManagerSpatialHash.md](ContactManagerSpatialHash.md) | SpatialHash<Primitive, Contact, ContactManager, 4> instantiation. |
| ContactStage.h | [ContactStage.md](ContactStage.md) | CONTACT_STAGE plumbing toward TreeStage. |
| Controller.h | [Controller.md](Controller.md) | LegacyController::InputType enum only (13 inputs); string matrix lives in ControllerTypes.cpp. |
| CornerWedgeMesh.h | [CornerWedgeMesh.md](CornerWedgeMesh.md) | Pooled corner-wedge mesh + computed LocalCofM out-param. |
| CornerWedgePoly.h | [CornerWedgePoly.md](CornerWedgePoly.md) | GEOMETRY_CORNERWEDGE; off-center CoFm; isGeometryOrthogonal false. |
| Cylinder.h | [Cylinder.md](Cylinder.md) | Geometry (not Poly); COLLIDE_BULLET-only; full dragger surface API. |
| DistributedPhysics.h | [DistributedPhysics.md](DistributedPhysics.md) | Ownership range constants: client sim 10–1000 studs, client slop 1.05 vs server 1.00 hysteresis. |
| Edge.h | [Edge.md](Edge.md) | Joint/Contact base; (&prim0)[i] adjacency trick; dtor asserts clean unlink + badMemory stamping. |
| EdgeBuffer.h | [EdgeBuffer.md](EdgeBuffer.md) | Buffers incomplete edges until assemblies exist; debug BiMultiMap; spring/kinematic gating. |
| EdgeStage.h | [EdgeStage.md](EdgeStage.md) | EDGE_STAGE plumbing. |
| Enum.h | [Enum.md](Enum.md) | Sim::AssemblyState lifecycle + helpers; ThrottleType/EdgeState (unsigned char on _WIN32 only). Stale "WORLD" comment. |
| Feature.h | [Feature.md](Feature.md) | GEO::(Vertex\|Edge\|Face) = primitive+index handles; name-collides with Edge/POLY::Edge. |
| Geometry.h | [Geometry.md](Geometry.md) | Shape taxonomy (12 GeometryTypes, 4 CollideTypes); default getMoment = zero matrix trap; embedded btCollisionObject. |
| GeometryPool.h | [GeometryPool.md](GeometryPool.md) | Process-wide refcounted payload pools; spin-mutex; move-only Token; bit-exact float keys. |
| GlueJoint.h | [GlueJoint.md](GlueJoint.md) | Breakable surface-glue over quad Face; PGS Constraint vector; ManualGlueJoint variant. |
| GroundStage.h | [GroundStage.md](GroundStage.md) | GROUND_STAGE: synthesized ground joints; heaviest-rigid-to-ground selection. |
| HumanoidStage.h | [HumanoidStage.md](HumanoidStage.md) | HUMANOID_STAGE: moving-humanoid-assembly set + humanoid/dynamics transitions. |
| IMoving.h | [IMoving.md](IMoving.md) | Instance-layer motion interface (notifyMoved contract) + IMovingManager heartbeat sleeper; stepsToSleep==0 means sleeping. |
| IPipelined.h | [IPipelined.md](IPipelined.md) | Pipeline membership mixin; stage-order comparisons ride the IStage enum ordering. |
| IWorldStage.h | [IWorldStage.md](IWorldStage.md) | IStage + World back-pointer, typed neighbor casts, MetricType pass-through. |
| Joint.h | [Joint.md](Joint.md) | JointType precedence taxonomy + classifier statics (range arithmetic — enum order sensitive); AnchorJoint/FreeJoint single-prim joints. |
| JointBuilder.h | [JointBuilder.h](JointBuilder.md) | Near-empty factory; canJoin only; makeJoint commented out. |
| JointStage.h | [JointStage.md](JointStage.md) | JOINT_STAGE: holds joints until both primitives arrive; BiMultiMap mirror. |
| KDTree.h | [KDTree.md](KDTree.md) | Static kd-tree over triangle mesh (branch/leaf bitfield union); AABB + ray queries; caller owns vertex arrays. |
| KernelJoint.h | [KernelJoint.md](KernelJoint.md) | Joint ∥ Connector dual identity; answers getBody only for body0. |
| MaterialProperties.h | [MaterialProperties.md](MaterialProperties.md) | Material merge policy (weighted averages) behind DYNAMIC_FASTFLAG(MaterialPropertiesEnabled). |
| Mechanism.h | [Mechanism.md](Mechanism.md) | Top grouping level (assembly + spring-jointed children); isComplexMovingMechanism networking flag. |
| MechToAssemblyStage.h | [MechToAssemblyStage.md](MechToAssemblyStage.md) | MECH_TO_ASSEMBLY_STAGE relay; keeps fixed/sim/no-sim entry points distinct. |
| MegaClusterMesh.h | [MegaClusterMesh.md](MegaClusterMesh.md) | Dummy block mesh for legacy terrain clusters; LocalCofM never initialized by ctor. |
| MegaClusterPoly.h | [MegaClusterPoly.md](MegaClusterPoly.md) | Legacy voxel-terrain Poly; per-cell Bullet hulls; extended hitTest signature (extra params lost via Geometry*); MC_SEARCH_RAY_MAX 2048. |
| Mesh.h | [Mesh.md](Mesh.md) | POLY half-edge-style mesh (Vertex/Edge/Face) + builders incl. terrain cell variants; winding order matters. |
| Motor6DJoint.h | [Motor6DJoint.md](Motor6DJoint.md) | 6-DOF motor over D6Link; offset+axis-angle poses; maxZAngleVelocity/desiredZAngle are legacy-script shims. |
| MotorJoint.h | [MotorJoint.md](MotorJoint.md) | 1-DOF hinge over RevoluteLink; pose overlay expires after poseDuration=32 UI steps. |
| MovingAssemblyStage.h | [MovingAssemblyStage.md](MovingAssemblyStage.md) | MOVING_ASSEMBLY_STAGE: intrusive uiStepJoints list + animatedJoints set; grounded/animated moving-assembly sets. |
| MovingStage.h | [MovingStage.md](MovingStage.md) | MOVING_STAGE: mechanism add/remove notifications toward SpatialFilter. |
| MultiJoint.h | [MultiJoint.md](MultiJoint.md) | ≤8 Points + ≤4 NormalBreakConnectors base for weld/glue/snap/rotate families. |
| ParallelRampMesh.h | [ParallelRampMesh.md](ParallelRampMesh.md) | Pooled parallel-ramp mesh + LocalCofM. |
| ParallelRampPoly.h | [ParallelRampPoly.md](ParallelRampPoly.md) | GEOMETRY_PARALLELRAMP; analytic-only (setUpBulletCollisionData ≡ false). |
| Poly.h | [Poly.md](Poly.md) | Mesh-backed Geometry base; surfaceId = mesh face index; radius = worst-corner sphere. |
| PolyCellContact.h | [PolyCellContact.md](PolyCellContact.md) | Poly-vs-cell pair hypotheses (FaceFace/EdgeEdge) w/ epsilon hysteresis; buffers widened 8→CONTACT_ARRAY_SIZE. |
| PolyContact.h | [PolyContact.md](PolyContact.md) | Analytic poly contact base + connector matching machinery; pure findClosestFeatures. |
| PolyPolyContact.h | [PolyPolyContact.md](PolyPolyContact.md) | Part↔part analytic contact: PolyPair/FaceFacePair/EdgeEdgePair; match keys on primitive[0] only. |
| Primitive.h | [Primitive.md](Primitive.md) | The part object: geometry+body+edges+surfaces+ownership; SizeMultiplier spanning-tree weight hack; getCoordinateFrameUnsafe needs writer lock; hasGetFirstContact SFINAE constant. |
| PrismMesh.h | [PrismMesh.md](PrismMesh.md) | Pooled parametric prism (Vector3_2Ints key); SetNumSides/Slices appear vestigial. |
| PrismPoly.h | [PrismPoly.md](PrismPoly.md) | GEOMETRY_PRISM; parameter-driven shape (only Geometry subclass family accepting parameters). |
| PyramidMesh.h | [PyramidMesh.md](PyramidMesh.md) | Pooled parametric pyramid; same vestigial-setter pattern as prism. |
| PyramidPoly.h | [PyramidPoly.md](PyramidPoly.md) | GEOMETRY_PYRAMID; parameter-driven; analytic-only. |
| RigidJoint.h | [RigidJoint.md](RigidJoint.md) | Weld/Snap/ManualWeld base; getJointType asserts; jointIsRigid duplicates Joint::isRigidJoint logic. |
| RightAngleRampMesh.h | [RightAngleRampMesh.md](RightAngleRampMesh.md) | Pooled right-angle ramp mesh + LocalCofM. |
| RightAngleRampPoly.h | [RightAngleRampPoly.md](RightAngleRampPoly.md) | GEOMETRY_RIGHTANGLERAMP; legacy-face remap override. |
| RotateJoint.h | [RotateJoint.md](RotateJoint.md) | Hinge family: RotateJoint/DynamicRotate/RotateP/RotateV; axle-hole semantics; legacy connector vs PGS constraints dual paths. |
| SendPhysics.h | [SendPhysics.md](SendPhysics.md) | Round-robin SimJob replication scheduler; resumable reportSimJobs template; physics on/off signals. |
| SimJob.h | [SimJob.md](SimJob.md) | One moving Assembly per job; SimJobTracker cursor survives list mutations via transferTrackers. |
| SimulateStage.h | [SimulateStage.md](SimulateStage.md) | SIMULATE_STAGE (ex-SimJobStage): movingDynamic/realTime intrusive lists; feeds SendPhysics. std::map chosen over unordered via #if 0. |
| SleepStage.h | [SleepStage.md](SleepStage.md) | SLEEP_STAGE state machine: per-state assembly sets, IndexArray contact lists keyed on steppingIndexFunc, recursive wake, metrics impl. |
| SmoothClusterGeometry.h | [SmoothClusterGeometry.md](SmoothClusterGeometry.md) | Smooth terrain geometry: TerrainPartitionSmooth chunks, per-chunk btCollisionShape + btDbvt, incremental GC, material-from-triangle lookup. |
| SnapJoint.h | [SnapJoint.md](SnapJoint.md) | SNAP_JOINT auto-weld; copy-paste "// WeldJoint" comment artifact. |
| SpatialFilter.h | [SpatialFilter.md](SpatialFilter.md) | SPATIAL_FILTER: assigns FilterPhase per assembly (client/server/solo/dphysics matrix in-header); deferred MoveInstructions batching; filterAssembly may touch datamodel. |
| SpatialHashMultiRes.h | [SpatialHashMultiRes.md](SpatialHashMultiRes.md) | Multi-res hashed octree broadphase template. **SpatialHashMultiRes.inl folded here** (1736 lines of impls). Notable: PRECISE_SORTING dead branch has a syntax error; children[] store bucket hashes; level pinned at insert w/ shrink-by-2 hysteresis. |
| StepJointsStage.h | [StepJointsStage.md](StepJointsStage.md) | STEP_JOINTS_STAGE: world-step joint pass over intrusive list. |
| SurfaceData.h | [SurfaceData.md](SurfaceData.md) | Per-face legacy controller binding (InputType + 2 params); exact-equality isEmpty. |
| TerrainPartition.h | [TerrainPartition.md](TerrainPartition.md) | TerrainPartitionMega (bit-packed cell occupancy) + TerrainPartitionSmooth (8³ chunks, solid/water slice masks). |
| Tolerance.h | [Tolerance.md](Tolerance.md) | Joint/snap/rotate/glue tolerances; maxOverlapOrGap coupled to kernel overlapGoal; **maxExtents() = compile-date + rand() obfuscated no-clip cube**. |
| TreeStage.h | [TreeStage.md](TreeStage.md) | TREE_STAGE + SpanningTree: builds Mechanism/Assembly/Clump trees; swapTree re-rooting; assemble()/isAssembled(). |
| TriangleMesh.h | [TriangleMesh.md](TriangleMesh.md) | GEOMETRY_TRI_MESH (MeshParts): pooled convex decomposition + KDTree raycast; bbox-faked dragger surfaces; hollow-bbox inertia; PHYSICS_SERIAL_VERSION 3. |
| WedgeMesh.h | [WedgeMesh.md](WedgeMesh.md) | Pooled wedge mesh (no cofm member unlike corner/ramps). |
| WedgePoly.h | [WedgePoly.md](WedgePoly.md) | GEOMETRY_WEDGE; real pooled Bullet hull (unlike ramps/prisms/pyramids). |
| WeldJoint.h | [WeldJoint.md](WeldJoint.md) | WELD_JOINT + ManualWeldJoint with surface ids and terrain cell accessors. |
| World.h | [World.md](World.md) | Facade: stage pipeline ownership, step/uiStep loop, EThrottle adaptive skipping, auto-join/terrain-weld cleanup, touch reporting, signals, analytics. worldStepId wraps after ~2 years at 30 Hz. |

89 of 89 headers documented. **1 .inl folded into its parent doc** per orchestrator policy: `SpatialHashMultiRes.inl` (1736 lines) → [SpatialHashMultiRes.md](SpatialHashMultiRes.md).

Cross-references: kernel-side counterparts under [../v8kernel/INDEX.md](../v8kernel/INDEX.md), solver under [../solver/INDEX.md](../solver/INDEX.md), Base utilities under [../../../Base/INDEX.md](../../../Base/INDEX.md), terrain grids under [../voxel/INDEX.md](../voxel/INDEX.md) and [../voxel2/INDEX.md](../voxel2/INDEX.md).
