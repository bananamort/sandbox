# util/NormalId.h

## Purpose
The six-face enum for box parts (`NORM_X/Y/Z` and negatives, plus `NORM_UNDEFINED`) with bit masks and the conversion toolbox: enum↔mask, opposite face, U/V tangents, unit normal Vector3 / orientation Matrix3, Vector3/Matrix3→face classification, UVW↔object-space mapping (runtime + template specializations), and legacy mapping shims.

## Declared API
```cpp
enum NormalIdMask {
    NORM_NONE_MASK  = 0x00,
    NORM_X_MASK     = 0x01, NORM_Y_MASK  = 0x02, NORM_Z_MASK  = 0x04,
    NORM_X_NEG_MASK = 0x08, NORM_Y_NEG_MASK = 0x10, NORM_Z_NEG_MASK = 0x20,
    NORM_ALL_MASK   = 0x3f
};

enum NormalId { NORM_X = 0, NORM_Y, NORM_Z, NORM_X_NEG, NORM_Y_NEG, NORM_Z_NEG, NORM_UNDEFINED };

bool validNormalId(NormalId normalId);

NormalIdMask normalIdToMask(NormalId normal);
NormalId normalIdOpposite(NormalId normalId);
NormalId normalIdToU(NormalId normalId);      // tangent axis
NormalId normalIdToV(NormalId normalId);      // second tangent axis

const Vector3& normalIdToVector3(NormalId normalId);   // unit vector along the normal
const Matrix3& normalIdToMatrix3(NormalId normalId);   // Z axis points away from the face

NormalId Vector3ToNormalId(const Vector3& v);
NormalId Matrix3ToNormalId(const Matrix3& m);
NormalId intToNormalId(int i);

Vector3 uvwToObject(const Vector3& uvwPt, NormalId faceId);
Vector3 objectToUvw(const Vector3& objectPt, NormalId faceId);
template<NormalId faceId> Vector3 uvwToObject(const Vector3& v);
template<NormalId faceId> Vector3 objectToUvw(const Vector3& v);

// LEGACY - Deprecated ("need to inspect and see if it is really objectToUvw or uvwToObject"):
Vector3 mapToUvw_Legacy(const Vector3& ptInObject, NormalId normalId);
template<NormalId normalId> Vector3 faceMap_Legacy(const Vector3& v);       // == uvwToObject<nid>(v)
template<NormalId normalId> Vector3 faceMap_Legacy(float x, float y, float z);
```

## Gotchas
- Face order convention is X, Y, Z then negatives — matches Extents' face ordering comment.
- Mask bits: positive faces occupy low 3 bits, negatives high 3; `NORM_ALL_MASK=0x3F`.
- `normalIdToMatrix3`: Z of the returned basis is the outward normal — U/V complete a right-handed frame per face.
- `uvwToObject/objectToUvw` directionality confusion is acknowledged in-header as legacy risk — verify against call sites when touching texture-mapping code.
- `intToNormalId` presumably maps 0..5 to faces (out-of-range → NORM_UNDEFINED, UNKNOWN exact).

## UNKNOWN
- Exact U/V assignment per face in .cpp (needed to interpret uvw results precisely).
