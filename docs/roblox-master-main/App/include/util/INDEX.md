# App/include/util — Documentation Index

Docs cover the `util/` slice of `App/include` (~136 headers + 2 `.inl`). Each `<Name>.md` documents Purpose / Declared API / Gotchas / UNKNOWN markers, derived from a full read of the header. Implementation files live mainly under `App/util/*.cpp` (+ platform subfolders `Android/`, `Darwin/`, `Durango/`, `Unix/`, `Win/`, and `App/util/Shared/`); where a doc exists the behavior details live there, otherwise an `impl:` pointer is given.

**Pre-existing docs (written before this pass):** `Http.md`, `ProtectedString.md`.
**Folded `.inl` coverage:** `Math.inl` → covered by `Math.md`; `Quaternion.inl` → covered by `Quaternion.md` (no separate docs).
**Priority tier completed first:** `standardout.h`, hash/crypto-adjacent (`md5.h`, `MD5Hasher.h`, `xxhash.h`), plus `ObscureValue.h`, `rbxrandom.h`.

## Roster

| Header | Doc | Notes |
|---|---|---|
| Action.h | Action.md | enum-only scope class |
| Analytics.h | Analytics.md | EphemeralCounter + GoogleAnalytics + InfluxDb namespaces |
| AnimationId.h | AnimationId.md | ContentId subtype, active:// check |
| AsyncHttpCache.h | AsyncHttpCache.md | LRU cache over AsyncHttpQueue |
| AsyncHttpQueue.h | AsyncHttpQueue.md | impl: App/util/AsyncHttpQueue.cpp |
| Average.h | Average.md | ring-buffer average |
| Axes.h | Axes.md | impl: App/util/Axes.cpp |
| base64.hpp | base64.md | vendored codec, header-only |
| Base64BinaryInputStream.h | Base64BinaryInputStream.md | impl: App/util/Base64BinaryInputStream.cpp |
| Base64BinaryOutputStream.h | Base64BinaryOutputStream.md | impl: App/util/Base64BinaryOutputStream.cpp |
| BiMultiMap.h | BiMultiMap.md | header-only multimap pair set |
| BinaryString.h | BinaryString.md | binary-safe property wrapper |
| BrickColor.h | BrickColor.md | impl: App/util/BrickColor.cpp |
| CameraSubject.h | CameraSubject.md | impl: App/util/CameraSubject.cpp |
| CellID.h | CellID.md | impl: App/util/CellID.cpp |
| CheatEngine.h | CheatEngine.md | anti-cheat toolkit, Windows-only |
| ClusterCellIterator.h | ClusterCellIterator.md | voxel chunk iteration |
| Color.h | Color.md | 16-color palette; impl: App/util/Color.cpp |
| CompactEnum.h | CompactEnum.md | header-only small-enum storage |
| ComputeProp.h | ComputeProp.md | header-only cached property |
| ConcurrencyValidator.h | ConcurrencyValidator.md | debug-only RW discipline asserts |
| ContentFilter.h | ContentFilter.md | service; impl: App/util/ContentFilter.cpp |
| ContentId.h | ContentId.md | core content URL type; impl: App/util/ContentId.cpp |
| ContentProviderJob.h | ContentProviderJob.md | impl: App/util/ContentProviderJob.cpp |
| ControlledLRUCache.h | ControlledLRUCache.md | pinned+evictable two-tier cache, header-only |
| Cursors.h | Cursors.md | empty placeholder |
| DoubleEndedVector.h | DoubleEndedVector.md | ring-buffer deque, header-only |
| Exception.h | Exception.md | empty RBX namespace |
| ExponentialRunningAverage.h | ExponentialRunningAverage.md | floatERA / Vector3EMA |
| Extents.h | Extents.md | AABB core type; impl: App/util/Extents.cpp |
| ExtentsInt32.h | ExtentsInt32.md | integer AABB |
| Face.h | Face.md | quad face geometry; impl: App/util/Face.cpp |
| Faces.h | Faces.md | NormalId bitmask; impl: App/util/Faces.cpp |
| FileSystem.h | FileSystem.md | user/cache/log dirs |
| FixedArray.h | FixedArray.md | capped stack array (operator[] BY VALUE!) |
| FixedSizeCircularBuffer.h | FixedSizeCircularBuffer.md | tiny history buffer |
| G3DCore.h | G3DCore.md | G3D→RBX typedef umbrella |
| GameMode.h | GameMode.md | session mode enum |
| gpc.h | gpc.md | polygon clipper; impl: App/util/gpc.c |
| Guid.h | Guid.md | scoped guid + registry; impl: App/util/Guid.cpp |
| Handle.h | Handle.md | InstanceHandle; impl: App/util/Handle.cpp |
| Hash.h | Hash.md | Sedgewick-style hash; impl: App/util/Hash.cpp |
| HeapValue.h | HeapValue.md | heap-stored obscured value, header-only |
| HeartbeatInstance.h | HeartbeatInstance.md | mixin; impl: App/util/HeartbeatInstance.cpp |
| HitTest.h | HitTest.md | gizmo picking; impl: App/util/HitTest.cpp |
| HitTestFilter.h | HitTestFilter.md | traversal predicate interface |
| Http.h | Http.md | **pre-existing doc**; implementation: App/util/Shared/Http.cpp (+WinHttp.cpp/WinInet.cpp/XboxHttp2.cpp platform layers), HttpCacheEntry.cpp |
| HttpAsync.h | HttpAsync.md | future-based HTTP; impl: App/util/HttpAsync.cpp |
| HttpAux.h | HttpAux.md | AdditionalHeaders typedef |
| HttpPlatformImpl.h | HttpPlatformImpl.md | disk-cache format + perform(); impl: App/util/Shared/HttpPlatformImpl.cpp |
| HTW3C.h | HTW3C.md | libwww PARSE_ANCHOR #undef shield |
| IHasLocation.h | IHasLocation.md | virtual-location interface |
| IMetric.h | IMetric.md | metrics interface |
| IndexArray.h | IndexArray.md | intrusive index pointer-array |
| IndexBox.h | IndexBox.md | indexed box topology; impl: App/util/IndexBox.cpp |
| IndexedMesh.h | IndexedMesh.md | Primitive/Clump/Assembly graph; impl: App/util/IndexedMesh.cpp |
| IndexedTree.h | IndexedTree.md | parent/child tree mixin; impl: App/util/IndexedTree.cpp |
| InsertMode.h | InsertMode.md | insertion enums |
| KeyCode.h | KeyCode.md | SDL1.2 keysyms + gamepad; impl: App/util/KeyCode.cpp |
| KeywordFilter.h | KeywordFilter.md | include/exclude enum |
| Lcmrand.h | Lcmrand.md | LCG PRNG (no include guard!) |
| LegacyContentTable.h | LegacyContentTable.md | legacy URL map; impl: App/util/LegacyContentTable.cpp |
| LRUCache.h | LRUCache.md | LRU family, header-only |
| LuaWebService.h | LuaWebService.md | web-request service; impl: App/util/LuaWebService.cpp |
| MachineIdUploader.h | MachineIdUploader.md | MAC-based ban check; impl: App/util/MachineIdUploader.cpp (+_Windows.cpp) |
| MachOBaseAddr.h | MachOBaseAddr.md | mach-o slide/textsize (32-bit) |
| Math.h | Math.md | math toolbox; **covers Math.inl**; impl: App/util/Math.cpp |
| Math.inl | *(folded into Math.md)* | vectorToObjectSpace |
| md5.h | md5.md | public-domain MD5; impl: App/util/md5.c |
| MD5Hasher.h | MD5Hasher.md | RBX MD5 facade; impl: App/util/MD5Hasher.cpp |
| Memory.h | Memory.md | forwards to rbx/memory.h |
| MemoryStats.h | MemoryStats.md | system memory queries; impl: App/util/MemoryStats.cpp (+MemoryStatsCommon.cpp) |
| MeshId.h | MeshId.md | ContentId subtype |
| MovementHistory.h | MovementHistory.md | delta-compressed motion history |
| Name.h | Name.md | interned-name registry; impl: App/util/Name.cpp |
| NamedMutex.h | NamedMutex.md | Win32 named-mutex RAII |
| NavKeys.h | NavKeys.md | input-state struct (+1 left convention) |
| NormalId.h | NormalId.md | face enum + conversions; impl: App/util/NormalId.cpp |
| Object.h | Object.md | factory backbone (Creatable/FactoryProduct) |
| ObscureValue.h | ObscureValue.md | XOR-obscured value, header-only |
| PartMaterial.h | PartMaterial.md | material enum |
| PathInterpolatedCFrame.h | PathInterpolatedCFrame.md | network pose smoothing |
| PhysicalProperties.h | PhysicalProperties.md | density/friction/elasticity |
| PhysicsCoord.h | PhysicsCoord.md | translation+quaternion solver vector |
| Profiling.h | Profiling.md | Mark/CodeProfiler buckets; impl: App/util/Profiling.cpp |
| ProgramMemoryChecker.h | ProgramMemoryChecker.md | self-integrity hashing |
| ProgressIndicator.h | ProgressIndicator.md | progress/cancel interface |
| ProtectedGeneric.h | ProtectedGeneric.md | hash-checked value wrapper |
| ProtectedString.h | ProtectedString.md | **pre-existing doc** |
| PV.h | PV.md | position+velocity state |
| quadedge.h | quadedge.md | Delaunay quad-edge; impl: App/util/quadedge.cpp |
| Quaternion.h | Quaternion.md | **covers Quaternion.inl**; impl: App/util/Quaternion.cpp |
| Quaternion.inl | *(folded into Quaternion.md)* | += and *= operators |
| rbxrandom.h | rbxrandom.md | randomSeed(); impl: App/util/rbxrandom.cpp |
| RbxStringTable.h | RbxStringTable.md | obfuscated string ids |
| Rect.h | Rect.md | y-down 2D rect; impl: App/util/Rect.cpp |
| Region2.h | Region2.md | weighted pick region |
| Region3.h | Region3.md | oriented region (Lua Region3); impl: App/util/Region3.cpp |
| Region3Int16.h | Region3Int16.md | int16 region |
| Region3int32.h | Region3int32.md | int32 region; impl: App/util/Region3int32.cpp |
| RobloxGoogleAnalytics.h | RobloxGoogleAnalytics.md | Studio GA singleton; impl: App/util/RobloxGoogleAnalytics.cpp |
| Rotation2d.h | Rotation2d.md | cached sin/cos 2D rotation |
| RunningAverage.h | RunningAverage.md | RunningAverageState; impl: App/util/RunningAverage.cpp |
| RunStateOwner.h | RunStateOwner.md | RunService run loop; impl: App/util/RunStateOwner.cpp |
| ScopedAssign.h | ScopedAssign.md | save/restore RAII |
| ScriptInformationProvider.h | ScriptInformationProvider.md | script asset url/access service |
| Selectable.h | Selectable.md | selection marker interface |
| SimSendFilter.h | SimSendFilter.md | replication send filter record |
| Sound.h | Sound.md | Soundscape::Sound refcounted FMOD wrapper |
| SoundChannel.h | SoundChannel.md | Sound Instance; impl: App/util/SoundChannel.cpp |
| SoundService.h | SoundService.md | FMOD service + SoundJob; impl: App/util/SoundService.cpp |
| SoundWorld.h | SoundWorld.md | stock sound enums |
| SpanningEdge.h | SpanningEdge.md | weighted tree edge |
| SpanningNode.h | SpanningNode.md | spanning tree node |
| SpanningTree.h | SpanningTree.md | rebalancing tree controller |
| SpatialRegion.h | SpatialRegion.md | 32×16×32 voxel region math |
| standardout.h | standardout.md | output singleton; impl: App/util/standardout.cpp |
| Statistics.h | Statistics.md | stats/settings fetch; impl: App/util/Statistics.cpp |
| SteppedInstance.h | SteppedInstance.md | stepped-signal mixin |
| StlExtra.h | StlExtra.md | fast vector removal helpers |
| StreamRegion.h | StreamRegion.md | 16³ voxel stream regions |
| SurfaceType.h | SurfaceType.md | part surface enum |
| SystemAddress.h | SystemAddress.md | IPv4 endpoint; impl: App/util/SystemAddress.cpp |
| TextureId.h | TextureId.md | ContentId subtype |
| ThreadPool.h | ThreadPool.md | FIFO/priority pools |
| TouchType.h | TouchType.md | touch query result |
| UDim.h | UDim.md | GUI scale+offset types; impl: App/util/UDim.cpp |
| UintSet.h | UintSet.md | bitset uint set |
| Units.h | Units.md | SI↔stud conversion; impl: App/util/Units.cpp |
| URL.h | URL.md | RFC3986 Url class; impl: App/util/URL.cpp |
| UserInputBase.h | UserInputBase.md | input device abstraction |
| Utilities.h | Utilities.md | sha1/rot13/copy_on_write_ptr |
| VarInt.h | VarInt.md | bit-stream varint, header-only |
| Vector3int32.h | Vector3int32.md | int32 vector w/ bit shifts; impl: App/util/Vector3int32.cpp |
| Vector6.h | Vector6.md | fixed 6-array, global ns |
| Velocity.h | Velocity.md | linear+angular velocity |
| WinHeap.h | WinHeap.md | Windows LFH setup; impl: App/util/WinHeap.cpp |
| xxhash.h | xxhash.md | fast 32-bit hash; impl: App/util/xxhash.c |

## Cross-cutting notes

- **Cache family:** LRUCache.md ← SizeEnforcedLRUCache/MemEnforcedLRUCache ← ControlledLRUCache.md ← AsyncHttpCache.md ← (LuaWebService.md uses `AsyncHttpCache<...>` directly).
- **HTTP stack:** Http.md (sync/core) → HttpAsync.md (futures) → AsyncHttpQueue.md (priority queue) → HttpPlatformImpl.md (per-platform perform + disk cache); Statistics.md and LuaWebService.md build on these.
- **Geometry spine:** G3DCore.md → NormalId.md / Extents.md / Region*.md / Math.md; PV.md + Velocity.md feed physics-facing headers (PhysicsCoord.md, PathInterpolatedCFrame.md, MovementHistory.md).
- **Object model:** Object.md (factory) + Name.md (interned names) underpin IndexedTree.md → IndexedMesh.md → SpanningNode/SpanningEdge/SpanningTree.
- **Anti-tamper cluster:** CheatEngine.md, ProgramMemoryChecker.md, HeapValue.md, ObscureValue.md, ProtectedGeneric.md, MachineIdUploader.md (Windows-centric; several use HeapValue obscuring).
- **Recurring gotchas worth promoting:** FixedArray `operator[]` returns by value; Quaternion `magnitude()` is squared; Lcmrand.h lacks include guards; UDim offset is int16; Region3int16 default ctor leaves members uninitialized; Math.inl's non-inline definition is an ODR hazard.
