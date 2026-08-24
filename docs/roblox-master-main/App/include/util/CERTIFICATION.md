# App/include/util — Independent Review Certification

**Reviewer:** independent review pass (full-read of every source + every doc; no sampling).
**Scope verified:** `roblox-sandbox/App/include/util/` — 135 `.h` + 1 `.hpp` (base64.hpp) + 2 `.inl` (Math.inl, Quaternion.inl) ↔ 137 `.md` (136 header docs + INDEX.md), at `docs/roblox-master-main/App/include/util/`.
**Coverage:** mechanically diffed basename sets — exactly 1:1; `.inl` files fold into `Math.md` / `Quaternion.md` per ruling; INDEX.md extra. No orphan docs, no missing docs.
**Method:** every source file read in full via tool calls; every concrete doc claim (signatures, enum values, macros, defaults, gotchas) checked against source. Known traps explicitly re-verified.

## Verdict totals

| Status | Count |
|---|---|
| PASS (all claims verified, unchanged) | 128 |
| FIXED (WRONG/MISSING claims corrected in place) | 9 |
| FAIL (unresolvable factual errors) | **0** |

Total docs certified: **137 / 137** (136 headers + INDEX.md). Sources covered: 138 (incl. 2 folded `.inl`).

## Known-trap verification

| Trap | Verdict |
|---|---|
| FixedArray `operator[]` returns BY VALUE | ✅ correctly documented |
| Quaternion::magnitude() returns SQUARED magnitude | ✅ correctly documented (+ PhysicsCoord cross-ref) |
| Lcmrand.h missing include guard | ✅ correctly documented |
| UDim offset is int16 (`G3D::int16`) incl. UDim2 narrowing ctor | ✅ correctly documented |
| Region3int16 default ctor leaves members uninitialized | ✅ correctly documented |
| Math.inl non-inline function ODR hazard | ⚠️ writer's explanation was wrong ("not declared inline") → FIXED: Math.h declares it `inline` before the `.inl` definition, which makes the definition inline; hazard fires only if that decl is removed/reordered |
| StreamRegion vs SpatialRegion grid dims | ✅ both correct & explicitly contrasted (StreamRegion cubic 16³ voxels / 4-bit shift vs SpatialRegion 32×16×32 / 5-4-5 bit shifts) |
| Crypto tier md5.h / MD5Hasher.h / xxhash.h / ObscureValue.h / rbxrandom.h | ✅ all correct (HAVE_OPENSSL branch, `_MD5_H` guard, XXH32 state/free semantics, XOR-with-`this` obscuring, seed decl-only) |

## Per-file results

Legend: PASS = every concrete claim verified. FIXED = one or more WRONG/UNSUPPORTED/MISSING claims corrected (details below). All files passed after fixes — zero FAILs.

| Doc | Result |
|---|---|
| Action | PASS |
| Analytics | PASS |
| AnimationId | PASS |
| AsyncHttpCache | **FIXED** — (1) invented base `AsyncHttpCacheBase` w/ inline correction → now `public AsyncHttpQueue`; (2) false claim "`renameCacheItem` not atomic against concurrent inserts" → source holds `contentCacheMutex` across fetch/remove/insert, so it IS atomic; gotcha rewritten |
| AsyncHttpQueue | PASS |
| Average | PASS |
| Axes | PASS |
| base64 | PASS |
| Base64BinaryInputStream | **FIXED** — ctor declared `explicit`, source has no `explicit`; corrected + gotcha added |
| Base64BinaryOutputStream | PASS |
| BiMultiMap | **FIXED** — added omitted `InternalMapIt` typedef (minor completeness) |
| BinaryString | PASS |
| BrickColor | PASS |
| CameraSubject | PASS |
| CellID | PASS |
| CheatEngine | PASS |
| ClusterCellIterator | PASS |
| Color | PASS |
| CompactEnum | PASS |
| ComputeProp | **FIXED** — garbled/invalid typedef line (`typedef Type (O::*GetFunc)() GetFunc_t`) → restored valid declaration matching source |
| ConcurrencyValidator | PASS |
| ContentFilter | PASS |
| ContentId | **FIXED** — `operator==(const ContentId&, const ContentId*)` param typo → `const ContentId&` |
| ContentProviderJob | PASS |
| ControlledLRUCache | PASS |
| Cursors | PASS |
| DoubleEndedVector | PASS |
| Exception | PASS |
| ExponentialRunningAverage | PASS |
| Extents | PASS (style polish: clampToOverlap gotcha de-muddled; mechanics were already correct) |
| ExtentsInt32 | PASS |
| Face | PASS |
| Faces | PASS |
| FileSystem | PASS |
| FixedArray | PASS |
| FixedSizeCircularBuffer | PASS |
| G3DCore | PASS |
| GameMode | PASS |
| gpc | PASS |
| Guid | PASS |
| Handle | PASS |
| Hash | PASS |
| HeapValue | PASS |
| HeartbeatInstance | PASS |
| HitTest | PASS |
| HitTestFilter | PASS |
| Http | PASS (pre-existing doc; fully verified against Http.h) |
| HttpAsync | PASS |
| HttpAux | PASS |
| HttpPlatformImpl | PASS |
| HTW3C | PASS |
| IHasLocation | PASS |
| IMetric | PASS |
| IndexArray | PASS |
| IndexBox | PASS |
| IndexedMesh | **FIXED** — added omitted private static `computeConstUpper(const IndexedMesh*)` declaration |
| IndexedTree | PASS |
| InsertMode | PASS |
| KeyCode | PASS |
| KeywordFilter | PASS |
| Lcmrand | PASS |
| LegacyContentTable | PASS |
| LRUCache | PASS |
| LuaWebService | PASS |
| MachOBaseAddr | PASS |
| MachineIdUploader | PASS |
| Math | **FIXED** — ODR gotcha was factually wrong ("It is NOT declared inline"): Math.h line ~367 declares `vectorToObjectSpace` `inline`, making the keyword-less `.inl` definition inline (weak/COMDAT). Rewritten with the precise mechanism and the actual hazard condition. Also cleaned self-questioning fastFloorInt note (facts kept). |
| md5 | PASS |
| MD5Hasher | PASS |
| Memory | PASS |
| MemoryStats | PASS |
| MeshId | PASS |
| MovementHistory | PASS |
| Name | PASS |
| NamedMutex | PASS |
| NavKeys | PASS |
| NormalId | PASS |
| Object | PASS |
| ObscureValue | PASS |
| PartMaterial | PASS |
| PathInterpolatedCFrame | PASS |
| PhysicalProperties | PASS |
| PhysicsCoord | PASS |
| Profiling | PASS |
| ProgramMemoryChecker | PASS |
| ProgressIndicator | PASS |
| ProtectedGeneric | **FIXED** — ctor declared `explicit`, source has none; corrected (and flagged implicit conversion) |
| ProtectedString | PASS (pre-existing doc; fully verified) |
| PV | PASS |
| quadedge | PASS |
| Quaternion | PASS |
| rbxrandom | PASS |
| RbxStringTable | PASS |
| Rect | PASS |
| Region2 | PASS (style polish: default-state gotcha wording) |
| Region3 | PASS (style polish: no-mutator gotcha wording) |
| Region3Int16 | PASS |
| Region3int32 | PASS |
| RobloxGoogleAnalytics | PASS |
| Rotation2d | PASS (style polish: `Rotation2D()` default-state comment; equality gotcha scoped to RotationAngle vs Rotation2D) |
| RunningAverage | PASS |
| RunStateOwner | PASS |
| ScopedAssign | PASS |
| ScriptInformationProvider | PASS |
| Selectable | PASS |
| SimSendFilter | PASS |
| Sound | PASS |
| SoundChannel | PASS |
| SoundService | PASS |
| SoundWorld | PASS |
| SpanningEdge | PASS |
| SpanningNode | PASS |
| SpanningTree | PASS |
| SpatialRegion | PASS |
| standardout | PASS |
| Statistics | PASS |
| SteppedInstance | PASS |
| StlExtra | PASS |
| StreamRegion | PASS |
| SurfaceType | PASS |
| SystemAddress | PASS |
| TextureId | PASS |
| ThreadPool | PASS |
| TouchType | PASS |
| UDim | PASS |
| UintSet | PASS |
| Units | PASS |
| URL | PASS |
| UserInputBase | PASS |
| Utilities | PASS |
| VarInt | PASS |
| Vector3int32 | PASS |
| Vector6 | PASS |
| Velocity | PASS |
| WinHeap | PASS |
| xxhash | PASS |
| INDEX.md | PASS — roster/fold notes/cross-cutting gotcha list verified against this review's findings (its trap list matches source reality post-fix) |

## Fixes applied (files touched by reviewer)

1. `AsyncHttpCache.md` — base class corrected; renameCacheItem atomicity corrected; recency gotcha upgraded from hedged to verified fact (`fetch` defaults `touch=true`).
2. `Base64BinaryInputStream.md` — removed invented `explicit`; added implicit-conversion gotcha.
3. `BiMultiMap.md` — added `InternalMapIt` typedef.
4. `ComputeProp.md` — repaired invalid typedef block.
5. `ContentId.md` — fixed `operator==` signature typo.
6. `IndexedMesh.md` — added omitted `computeConstUpper`.
7. `Math.md` — rewrote ODR-hazard gotcha with the correct mechanism (forward `inline` declaration rescues the `.inl` definition).
8. `ProtectedGeneric.md` — removed invented `explicit`.
9. Style-only clarifications (no factual change): `Extents.md`, `Region2.md`, `Region3.md`, `Rotation2d.md`.

No source files under `roblox-sandbox/` were modified.
