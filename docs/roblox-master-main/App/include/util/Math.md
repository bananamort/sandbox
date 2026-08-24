# util/Math.h (+ Math.inl)

## Purpose
The engine's math toolbox under `RBX::Math` plus free helpers: fast floor/ceil, constants (pi/inf), MSB, rounding/polarity/sign, NaN/Inf/denormal detection & fixing, fuzzy equality for floats/vectors/matrices/CFrames, parity helpers, vector/matrix utilities, rotation composition and byte-angle packing, 36-orientation axis-aligned ids, moment-of-inertia transforms, heading/elevation, angle wrapping/wound rotations, ray/plane/polygon intersections, trajectory solving, and fast atan2. `Math.inl` (folded here) defines the inline `vectorToObjectSpace`.

## Declared API (selected; ~120 functions total)
```cpp
// Free functions:
int fastFloorInt(float);        // value<0 ? int(value-0.999f) : int(value)
int fastCeilInt(float);
Vector3int16 fastFloorInt16(const Vector3&);
typedef enum { AXIS_X = 0, AXIS_Y = 1, AXIS_Z = 2 } AxisIndex;

namespace RBX::Math {
    // Constants:
    double pi(), piHalf(), twoPi();  float pif(), piHalff(), twoPif();
    const float& inf();
    size_t computeMSB(size_t v);                 // 0-based MSB; -1 if v==0

    // Rounding / sign:
    int iRound(float);  int iFloor(float);
    float polarity(float);   // >=0 ? +1 : -1   (0 -> +1!)
    float sign(float);       // -1/0/+1

    // Denormal / NaN / Inf:
    bool isDenormal(float); bool isNan(float); bool isNan(const Vector3&);
    bool isNanInf(float); bool isNanInfDenorm(float);
    bool isNanInfVector3(const Vector3&); bool isNanInfDenormVector3(const Vector3&);
    bool isNanInfDenormMatrix3(const Matrix3&);
    bool hasNanOrInf(const CoordinateFrame&); bool hasNanOrInf(const Matrix3&);
    bool fixDenorm(float&); bool fixDenorm(Vector3&);   // sets denormals to 0

    // Fuzzy equality (relative epsilon: |a-b| <= (|a|+1)*eps):
    float epsilonf();                       // 1e-6
    bool fuzzyEq(float,double overloads, eps);
    bool fuzzyEq(const Vector3&, const Vector3&, float epsilon = 1e-5f);
    bool fuzzyEq(const Matrix3&, const Matrix3&, float epsilon = 1e-5f);
    bool fuzzyEq(const Matrix4&, const Matrix4&, float epsilon = 1e-5f);
    bool fuzzyEq(const CoordinateFrame&, const CoordinateFrame&, float epsT=1e-5f, float epsRad=1e-5f);
    bool fuzzyAxisAligned(const Matrix3&, const Matrix3&, float radTolerance);

    // Parity:
    bool isEven(int); bool isOdd(int); int nextEven(int); int nextOdd(int);

    // Vector2:
    Vector2 expandVector2(const Vector2&, int expand);
    Vector2 roundVector2(const Vector2&);

    // Vector3:
    size_t hash(const Vector3&);  bool isIntegerVector3(const Vector3&);
    Vector3 iRoundVector3(const Vector3&);
    float angle(v0,v1);  float smallAngle(v0,v1);  float elevationAngle(look);
    Vector3 vector3Abs(const Vector3&);  float volume(const Vector3&);
    float maxAxisLength(const Vector3&);  Vector3 sortVector3(const Vector3&);
    Vector3 safeDirection(const Vector3&);          // zero-safe direction
    Velocity calcTrajectory(launch, target, speed); // ballistic launch velocity
    Vector3 toGrid(v, grid);  bool lessThan(min,max);
    float longestVector3Component(v); float planarSize(v); float taxiCabMagnitude(v);
    float sumDeltaAxis(r0,r1);
    const Plane& yPlane();
    Vector3 closestPointOnRay(const RbxRay&, const RbxRay&);

    // Matrix3 / CFrame manipulation:
    Vector3 rotateAboutYGlobal(const Vector3&, float radians);
    Vector3 toSmallAngles(const Matrix3&);
    Matrix3 snapToAxes(const Matrix3&);
    bool isOrthonormal(const Matrix3&);
    bool orthonormalizeIfNecessary(Matrix3&);       // true if needed re-orthonormalization
    Vector3 toFocusSpace(goal, focus);  Vector3 fromFocusSpace(goal, focus);
    Vector3 toDiagonal(const Matrix3&);  Matrix3 fromDiagonal(const Vector3&);
    Matrix3 toSkewSymmetric(const Vector3&);        // a.cross(b) == A_* b
    Matrix3 fromVectorToVectorRotation(from,to);
    Matrix3 fromRotationAxisAndAngle(axis, rads);
    Matrix3 fromShortestPlanarRotation(targetX, targetY);
    Matrix3 fromDirectionCosines(fromX..toZ);
    Vector3 getColumn(const Matrix3&, int iCol);
    void mulMatrixDiagVector(mat, vec, answer);
    void mulMatrixMatrixTranspose(m0,m1,answer);  void mulMatrixTransposeMatrix(m0,m1,answer);

    // Byte angles (quantized rotation):
    unsigned char rotationToByte(float angle);
    float rotationFromByte(unsigned char);

    // Axis-aligned orientations (36 canonical matrices):
    static const int maxOrientationId = 36, minOrientationId = 0;
    bool isAxisAligned(const Matrix3&);
    int getOrientId(const Matrix3&);  void idToMatrix3(int, Matrix3&);
    const Matrix3& matrixRotateX/Y(); matrixRotateNegativeY();
    const Matrix3& matrixTiltZ/NegativeZ(); Matrix3 matrixTiltQuadrant(int);
    void rotateMatrixAboutX90(Matrix3&, int times=1); Y90(...); Z90(...);
    Matrix3 rotateAboutZ(const Matrix3&, float radians);
    Matrix3 getWellFormedRotForZVector(const Vector3&);
    Matrix3 momentToObjectSpace(iWorld, rot); momentToWorldSpace(iBody, rot);
    Matrix3 getIWorldAtPoint(cofmPos, worldPos, iWorldAtCofm, mass);
    Matrix3 getIBodyAtPoint(pos, iBody, mass);

    // CoordinateFrame:
    void rotateAboutYLocal(CoordinateFrame&, float); rotateAboutYGlobal(CoordinateFrame&, float);
    CoordinateFrame snapToGrid(snap, float grid); snapToGrid(snap, Vector3 grid);
    float atan2Fast(float y, float x);              // vlfeat polynomial approx
    float zAxisAngle(const Matrix3&);               // uses std atan2 (fast variant commented out)
    void pan(focusPosition, camera&, radians);

    // Arrays / pitch-yaw / heading:
    void lerpArray(before, after, answer, alpha);
    int radiansToQuadrant(float); int radiansToOctant(float);
    float radiansToDegrees(float); float degreesToRadians(float);
    float getHeading(const Vector3& look);   // north=-z is 0, west=+pi/2
    float getElevation(const Vector3& look); // asin(look.y)
    void getHeadingElevation(c, heading&, elevation&);
    void setHeadingElevation(c&, heading, elevation);
    CoordinateFrame getFocusSpace(const CoordinateFrame& focus);
    int toYAxisQuadrant(const CoordinateFrame&);    // 0..3
    Matrix3 alignAxesClosest(align, target);

    // NormalId helpers:
    NormalId getClosestObjectNormalId(worldV, objectR);
    Vector3 getWorldNormal(NormalId objId, const Matrix3& objectR);   // polarity * column
    Vector3 getWorldNormal(NormalId objId, const CoordinateFrame&);

    // Angle wrapping ("wound" rotations beyond ±pi):
    float deltaRotationClose(aRot,bRot);     // aRot - bRot, undoing wrap
    float averageRotationClose(aRot,bRot);
    double advanceWoundRotation(currentWound, newNotWound);
    float clampRotationClose(rot, lo, hi);
    double windingPart(double rad);          // -3pi..-pi:-1, -pi..pi:0, pi..3pi:+1
    float radWrap(double rad);

    const Matrix3& getAxisRotationMatrix(int face);

    // Ray / line / polygon intersection:
    bool clipRay(origin&, dir&, Vector3 box[], endPoint&);
    bool intersectLinePlane(line, plane, hit&);
    bool intersectRayPlane(ray, plane, hit&);
    bool intersectRayConvexPolygon(ray, poly, hit&, oneSided);
    bool lineSegmentDistanceIfCrossing(p1,p2,p3,p4, distance&, adjustEdgeTol=0.f);
    std::vector<Vector3> spatialPolygonIntersection(polyA, polyB);
    std::vector<Vector2> planarPolygonIntersection(poly1, poly2);

    // Misc:
    float computeLaunchAngle(v, x, y, g);
    Vector2 polygonStartingPoint(numSides, maxWidth);
    bool evenWholeNumber(float); bool evenWholeNumberFuzzy(float);
}
```
From **Math.inl** (included at bottom of Math.h):
```cpp
// == mat.transpose() * vec — manual transpose multiply:
Vector3 vectorToObjectSpace(const Vector3& _vec, const Matrix3& _mat);
```

## Gotchas
- `polarity(0)` returns **+1** while `sign(0)` returns 0 — pick deliberately.
- `fastFloorInt` uses the `-0.999f` trick — exact only for values not extremely close to an integer from below within float precision (e.g., -1.0000001 floors to -2? no: -1.0000001-0.999 → truncates to -2? verify: it becomes -1.9999991 → truncates to -1... edge cases exist near integers).
- `fuzzyEq` is RELATIVE epsilon scaled by |a|+1 — absolute comparisons near zero use ~epsilon itself.
- `atan2Fast` is an approximation (quadrant-correct, ~max 0.01 rad error per vlfeat reference) — do not use where precision matters.
- `zAxisAngle` deliberately uses std `atan2`, with `atan2Fast` commented out.
- Orientation ids are 0..35 (`minOrientationId`/`maxOrientationId`) covering all 90° axis-aligned rotations of a part.
- `getHeading`: north is −Z at angle 0, west (+X?) at π/2 per comment — read carefully before using for compass logic.
- Math.inl defines a NON-inline-marked function in a header included by many TUs — it's `inline`-eligible only via being in an .inl included once per TU; ODR relies on it being implicitly inline? It is NOT declared inline — potential multiple-definition hazard unless compilers treat it as inline due to being defined in every TU... actually each TU gets its own definition → link errors unless something makes it inline. In practice it compiles because it's defined identically per TU without inline — this would violate ODR; presumably benign historically.

## UNKNOWN
- Exact launch-angle/tolerance formulas in .cpp-side functions (calcTrajectory, computeLaunchAngle).
