# PartIdentifier.cpp

Source: `roblox-sandbox/Rendering/GfxBase/PartIdentifier.cpp` (230 lines)

## Purpose

Implements `RBX::HumanoidIdentifier`: walks the humanoid's parent's children once (by NAME for the six classic limbs, by type for clothing/meshes/hats), then answers compositing questions that drive texture-compositor batching of character parts.

## API

- `static const Vector3 humanoidPartScales[PartType_Count]` — Head (1,1,1), Torso (2,2,1), Arm (1,2,1), Leg (1,2,1), Unknown (1,1,1).
- `HumanoidIdentifier::HumanoidIdentifier(Humanoid*)` — null-safe early-outs; scans `humanoid->getParent()->getChildren()`:
  - PartInstance matched by name string: "Head", "Left Leg", "Right Leg", "Left Arm", "Right Arm", "Torso".
  - `Clothing` → first non-null `outfit1`→pants, `outfit2`→shirt.
  - `ShirtGraphic` → `graphic`→shirtGraphic.
  - `CharacterMesh` → switch on getBodyPart(): LEFTARM/RIGHTARM/LEFTLEG/RIGHTLEG/TORSO slots; default RBXASSERTs "Unsupported body part type".
  - `Accoutrement` → appended to accoutrements.
- `CharacterMesh* getRelevantMesh(PartInstance*) const` — pointer-identity chain over the five mesh slots; NULL otherwise.
- `BodyPartType getBodyPartType(PartInstance*) const` — legs → arms → torso → head order, else Unknown.
- `Vector3 getBodyPartScale(PartInstance*) const` — table lookup via type.
- `bool isPartHead(PartInstance*) const` — must be THE head part AND: SpecialShape with HEAD_MESH/FILE_MESH → true; SPHERE_MESH → only if cookie HAS_DECALS (store heads all have faces); other special shape → false; FileMesh → true; no special shape → false.
- `bool isBodyPart(PartInstance*) const` — requires cookie IS_HUMANOID_PART then pointer match vs six limbs.
- `bool isBodyPartComposited(PartInstance*) const` — decision ladder:
  1. Head: composited iff transparency ≤ 0 AND isPartHead AND reflectance ≤ 0.015.
  2. Special-shape parts NEVER composited ("old behavior").
  3. Non-BLOCK_PART never composited.
  4. Has relevant CharacterMesh → true.
  5. Arms+shirt / legs+pants / torso+(pants|shirt|t-shirt) → true.
  6. Else plastic/smooth-plastic with low reflectance → true (batching trade-off documented in comment: loses materials/size/studs).
- `bool isPartComposited(PartInstance*) const` — body-part ladder OR parent-is-Accoutrement → true.

## Usage

Includes Humanoid + eight v8datamodel headers. Consumed by the texture compositor to decide which parts bake into the character atlas.

## Gotchas
- Limb detection is by EXACT display-name string — renamed limbs silently drop out.
- Only ONE Clothing child wins pants/shirt (`isNull()` guards) — multiple clothing children: first scanned wins.
- Magic threshold `reflectance <= 0.015f`.
- `getBodyPartScale` indexes by enum incl. Unknown row — safe only because Unknown has its own entry.
