# PartIdentifier.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/PartIdentifier.h` (61 lines)

## Purpose

Snapshot descriptor of a Humanoid's body layout for rendering code: given a `Humanoid*`, captures its six body parts, accoutrements, clothing texture ids, and per-limb CharacterMeshes, then answers "is this part part of the character / which limb is it / what scale should it render at". Lets adornment/compositor code reason about character structure without reaching back into game logic.

## API

```cpp
class RBX::HumanoidIdentifier {
public:
    explicit HumanoidIdentifier(RBX::Humanoid* humanoid);

    Humanoid* humanoid;
    PartInstance* head; leftLeg; rightLeg; leftArm; rightArm; torso;
    std::vector<Accoutrement*> accoutrements;
    TextureId pants, shirt, shirtGraphic;
    CharacterMesh* leftLegMesh; rightLegMesh; leftArmMesh; rightArmMesh; torsoMesh;

    bool isBodyPart(RBX::PartInstance* part) const;
    bool isBodyPartComposited(RBX::PartInstance* part) const;
    bool isPartComposited(RBX::PartInstance* part) const;
    bool isPartHead(RBX::PartInstance* part) const;
    CharacterMesh* getRelevantMesh(RBX::PartInstance* bodyPart) const; // helper

    enum BodyPartType { PartType_Head, PartType_Torso, PartType_Arm,
                        PartType_Leg, PartType_Unknown, PartType_Count };
    BodyPartType getBodyPartType(RBX::PartInstance* bodyPart) const;
    Vector3 getBodyPartScale(RBX::PartInstance* bodyPart) const;
};
```

## Usage

Implemented in `PartIdentifier.cpp` (same dir, 230 lines). Forward-declares `PartInstance`, `Humanoid`, `CharacterMesh`, `Accoutrement`; includes only `Util/TextureId.h` and `Util/G3DCore.h`.

## Gotchas

- All pointers are raw and captured at construction — a snapshot: if limbs are re-parented after construction the identifier goes stale.
- `getBodyPartType` returns `PartType_Unknown` for non-body parts; callers must handle it before indexing by type.
- Clothing ids (`pants/shirt/shirtGraphic`) are `TextureId`, not ContentIds — compositor-side handles.
