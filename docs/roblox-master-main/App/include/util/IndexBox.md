# util/IndexBox.h

## Purpose
Box with **indexed** corner/face/edge topology: 8 corners plus static lookup tables mapping faces→vertices, faces→normals, edges→(vertex, normal) pairs. Supports frustum culling, face-corner enumeration (CCW, outward), edge traversal with left/right normals, and texture-coordinate corners for centered/grid UV layouts.

## Declared API
```cpp
class IndexBox {
public:
    IndexBox();
    IndexBox(const Vector3& min, const Vector3& max);
    virtual ~IndexBox() {}

    Vector3 getCenter() const;
    Vector3 getCorner(int i) const;             // 0..7; layout in header comment:
        // looking from +X toward -X, z left, y up:
        // front quad 0 1 / 2 3, back quad 4 5 / 6 7
    Vector3 getFaceNormal(int f) const;         // via INDEXBOX_FACE_TO_NORMAL[f]
    Vector3 getEdgeNormal(int f, int e) const;

    void getFaceCorners(int f, Vector3& v0, Vector3& v1, Vector3& v2, Vector3& v3) const;
        // four corners of a face (0<=f<6), CCW quad facing outwards

    void getEdge(int e, Vector3& v0, Vector3& v1, Vector3& nL, Vector3& nR) const;
        // edge travels v0->v1; nR to the right, nL to the left
    void getEdge(int e, Vector4& v0, Vector4& v1, Vector3& nL, Vector3& nR) const;

    static void getTextureCornersCentered(int f, const Vector3& halfSize,
        Vector2& t0, Vector2& t1, Vector2& t2, Vector2& t3);
    static void getTextureCornersGrid(int f, const Vector3& halfSize,
        Vector2& t0, Vector2& t1, Vector2& t2, Vector2& t3);

    bool culledBy(const Plane* plane, int numPlanes) const;
        // true if ALL of the box is outside at least one plane's halfspace
    bool contains(const Vector3& point) const;

    // Public static topology tables:
    static const int   INDEXBOX_FACE_TO_VERTEX[6][4];
    static const float INDEXBOX_FACE_TO_NORMAL[6][3];
    static const int   INDEXBOX_FACE_EDGE_TO_NORMAL[6][4];
    static const int   INDEXBOX_EDGE_TO_VERTEX_AND_NORMALS[12][4]; // normals index into FACE_TO_NORMAL
private:
    Vector3 corner[8];
};
```

## Gotchas
- Corner ordering convention is documented only in the private comment block — preserve it when constructing from min/max.
- `culledBy` semantics: returns true when the box can be discarded by ANY plane (standard frustum cull).
- Tables are defined in the .cpp (extern constants here).
- Has a virtual destructor but no other virtuals — polymorphic deletion supported.

## UNKNOWN
- Difference contract between `getTextureCornersCentered` vs `getTextureCornersGrid` beyond naming (.cpp-side).
