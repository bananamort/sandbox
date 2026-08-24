# util/StreamRegion.h

## Purpose
Streaming-region coordinate math: fixed 16×16×16-voxel (4-bit shift) cubic regions aligned to the contact-manager spatial hash's top-level buckets. Provides `Id` (Vector3int32 handle with documented stability/ordering constraints), `IdExtents`, voxel↔region conversions, world-position→region, stud-space extents, and change detection against the ContactManagerSpatialHash.

## Declared API
```cpp
namespace RBX::StreamRegion {

namespace Constants {
    const int kMinNumPlayableRegion = 3*3*3;   // minimum playable region count
}

namespace _PrivateConstants {
    const int kRegionSizeInVoxelsAsBitShift = 4;                       // 16 voxels/axis
    const int kRegionSizeInStudsAsBitShift =
        kRegionSizeInVoxelsAsBitShift + Voxel::kCELL_SIZE_AS_BIT_SHIFT;
    const Vector3int32 kRegionDimensionInVoxelsAsBitShifts(4,4,4);
    const Vector3int32 kRegionDimensionInStudsAsBitShifts(...);        // voxels + cell size
    const int kRegionDimensionInVoxels = 1 << 4;
    const int kMaxVoxelOffsetInsideRegion = 15;
}

// Id constraints: equal area ⇔ equal vector; ordering preserved per axis; adjacency ⇒
// sequential ids; consistent between runs and client/server.
class Id {
public:
    Id();                                        // 0,0,0
    explicit Id(const Vector3int32& internalValue);
    Id(int x, int y, int z);

    const Vector3int32& value() const;
    Id operator+(const Vector3int32&) const;
    Id operator+(const Id&) const;
    bool operator==(const Id&) const;   bool operator!= /* likewise */;

    static int streamGridCellSizeInStuds();
        // == SpatialHashStatic::hashGridSize(CONTACTMANAGER_MAXLEVELS-1)
    static int getRegionLongestAxisDistance(Id r1, Id r2);
    bool isRegionInTerrainBoundaries() const;    // vs Voxel::getTerrainExtentsInCells()
    struct boost_compatible_hash_value {         // x*11 + (y*7)<<10 + (z*3)<<20
        size_t operator()(const Id& key) const;
    };
};
std::size_t hash_value(const Id& key);

class IdExtents {
public:
    Id low, high;                                // inclusive extents
    bool operator==(const IdExtents&) const;
    template<class Container>
    bool intersectsContainer(const Container& container, Id* optionalFoundId = NULL) const;
        // brute-force triple loop over the box; container needs find(key)->cend()
};

const Vector3int32& gridCellDimension();       // cached statics
const Vector3int32& gridCellHalfDimension();

Id regionContainingWorldPosition(const Vector3& worldPos);
Extents extentsFromRegionId(const Id& id);
Id regionContainingVoxel(const Vector3int16& voxelCoordinate);
Id regionContainingVoxel(const Vector3int32& voxelCoordinate);
Vector3int16 getMinVoxelCoordinateInsideRegion(const Id& id);
Vector3int16 getMaxVoxelOffsetInsideRegion();            // (15,15,15)
Vector3int16 getMaxVoxelCoordinateInsideRegion(const Id& id);
unsigned int getTotalVoxelVolumeOfARegion();             // 1 << (3*4) = 4096

IdExtents regionExtentsFromContactManagerLevelAndExtents(int level, ExtentsInt32 contactManagerExtents);
bool coarseMovementCausesStreamRegionChange(
    const ContactManagerSpatialHash::CoarseMovementCallback::UpdateInfo& info,
    IdExtents* oldExtents, IdExtents* newExtents);
}
```

## Gotchas
- Regions here are CUBIC 16³ voxels — different from SpatialRegion.md's 32×16×32! Two distinct streaming grids coexist.
- Stud-per-region depends on `Voxel::kCELL_SIZE_AS_BIT_SHIFT` (voxel cell size) and on the contact-manager hash top level (`streamGridCellSizeInStuds`).
- Header comments acknowledge deliberate float precision loss in `regionContainingWorldPosition` (>2^31 studs) and `extentsFromRegionId` (>2^25 studs).
- The custom hash `(x*11) + ((y*7)<<10) + ((z*3)<<20)` collides for large |coords| — fine within terrain bounds.
- `coarseMovementCausesStreamRegionChange` asserts update type is Change or Insert; it computes new extents always and old extents only for Change.
- Depends on v8world/ContactManagerSpatialHash.h and Voxel/Util.h — couples util to those slices.

## UNKNOWN
- Numeric stud shift value (depends on Voxel cell size constant, defined in Voxel slice).
