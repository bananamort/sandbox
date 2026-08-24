# util/SpatialRegion.h

## Purpose
Fixed-size, globally-aligned voxel region ("SpatialRegion") coordinate math: regions are 32×16×32 voxels (5/4/5 bit shifts), origin-aligned so the world origin is the meeting point of 8 regions. Provides `Id` (a Vector3int16 region handle with documented ordering/stability guarantees) and conversions between global voxel coordinates, region-relative offsets, and stud-space corners/centers.

## Declared API
```cpp
namespace RBX::SpatialRegion {

namespace Constants {
    const int kRegionXDimensionInVoxelsAsBitShift = 5;   // 32 voxels
    const int kRegionYDimensionInVoxelsAsBitShift = 4;   // 16 voxels
    const int kRegionZDimensionInVoxelsAsBitShift = 5;   // 32 voxels
    const int kRegionInVoxelsAsBitShift = 14;            // sum
    const int kRegionXDimensionInVoxels = 1 << 5;  // etc.
    const int kMaxX/Y/ZVoxelOffsetInsideRegion = dimension - 1;
}

namespace _PrivateConstants {
    extern const Vector3int16 kRegionDimensionInStudsAsBitShifts;   // studs per region (per axis)
}

// Id constraints (from header comment):
// * equal areas => equal Vector3int16
// * component-wise > on ids implies > on spatial axis
// * adjacent regions differ by 1 on the shared axis
// * stable across runs and client/server
class Id {
public:
    explicit Id(const Vector3int16& internalValue);
    Id(int x, int y, int z);
    const Vector3int16& value() const;
    Id operator+(const Vector3int16& other) const;
    bool operator==(const Id&) const;    bool operator!= /* likewise */;
    struct boost_compatible_hash_value { size_t operator()(const Id&) const; };
};
std::size_t hash_value(const Id& key);

Vector3int16 getRegionDimensionsInVoxels();              // (32,16,32)
Vector3int16 getRegionDimensionInVoxelsAsBitShifts();    // (5,4,5)
Vector3int16 getMaxVoxelOffsetInsideRegion();            // (31,15,31)

Id regionContainingVoxel(const Vector3int16& globalVoxelCoordinate);          // coord >> shifts
Vector3int16 voxelCoordinateRelativeToEnclosingRegion(const Vector3int16& g); // coord & maxOffset
Vector3int16 globalVoxelCoordinateFromRegionAndRelativeCoordinate(const Id&, const Vector3int16&);

Region3int16 inclusiveVoxelExtentsOfRegion(const Id& id);
Vector3int32 smallestCornerOfRegionInGlobalCoordStuds(const Id& id);   // id << studShifts
Vector3int32 centerOfRegionInGlobalCoordStuds(const Id& id);
Vector3int32 largestCornerOfRegionInGlobalCoordStuds(const Id& id);
}
```

## Gotchas
- Region size is NOT cubic: 32×16×32 voxels (Y differs).
- Stud dimensions come from `_PrivateConstants::kRegionDimensionInStudsAsBitShifts` (defined in .cpp; UNKNOWN numeric value here — historically 4 studs/voxel ⇒ 128×64×128 studs).
- All conversions assume two's-complement shift/mask semantics for negative voxel coords.
- `Id` is explicitly constructible only — avoids accidental mixing of region ids with raw vectors.

## UNKNOWN
- The stud-per-voxel constant value (in _PrivateConstants, .cpp-side).
