# util/CellID.h

## Purpose
Identifies a terrain cell: nil flag + 3D location + optional terrain part instance. Used by (legacy) voxel/terrain systems to address cells, optionally tied to a specific `Instance` part.

## Declared API
```cpp
class CellID {
public:
    CellID();                                                   // presumably nil
    CellID(bool isNil, const RBX::Vector3& location, shared_ptr<Instance> terrainPart);
    CellID(bool newIsNil, float newLocation[3], shared_ptr<Instance> newTerrainPart);
    ~CellID();

    bool operator==(const CellID& other) const;   // all three fields

    bool getIsNil() const;               void setIsNil(bool);
    G3D::Vector3 getLocation() const;    void setLocation(RBX::Vector3);
    shared_ptr<Instance> getTerrainPart() const; void setTerrainPart(shared_ptr<Instance>);

    static CellID fromParameters(bool newIsNil, float newLocation[3], shared_ptr<Instance> newTerrainPart);
private:
    bool isNil;
    RBX::Vector3 location;
    shared_ptr<Instance> terrainPart;
};
```

## Gotchas
- Equality compares the shared_ptr identity of `terrainPart` (pointer comparison), not part contents.
- Default ctor's initialization state is defined in the .cpp — likely nil with zero location and null part (UNKNOWN: exact values).
- No `operator!=`, no hash — not usable as an unordered key without adding one.
- Holds a strong `shared_ptr` to an Instance: keeps the referenced part alive as long as the CellID exists.

## UNKNOWN
- Consumers (terrain streaming / hit-test paths outside this slice).
