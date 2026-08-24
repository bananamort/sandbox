# App/include/v8datamodel/TextureTrail.h

## Purpose

`TextureTrail` — creatable `GuiBase3d` adornment drawing a textured strip between two parts (From/To refs) with texture tiling parameters (size, velocity, studs-between, cycle offset); also exposes `renderInternal` static reused by [FloorWire.md](FloorWire.md) ("For floor wire").

## Declared API

`class TextureTrail : public DescribedCreatable<TextureTrail, GuiBase3d, sTextureTrail>`

- Private typedef: `PartProp = Reflection::RefPropDescriptor<TextureTrail, PartInstance>`; static descriptors `prop_From/prop_To (PartProp)`, `prop_Texture(TextureId)`, `prop_TextureSize(Vector2)`, `prop_Velocity(float)`, `prop_StudsBetweenTextures(float)`, `prop_CycleOffset(float)`.
- Get/set pairs (all out-of-line): From/To (`PartInstance*`), Texture, TextureSize(Vector2), Velocity(float), StudsBetweenTextures(float), CycleOffset(float).
- IAdornable: `/*override*/ void render3dAdorn(Adorn*)`.
- Static shared renderer: `static void renderInternal(const Workspace*, const Camera*, const Vector3& fromPosition, const Vector3& toPosition, const TextureId&, std::string context, const Vector2& textureSize, float velocity, float studsBetweenTextures, float cycleOffset, const Color4& color, Adorn*)` — comment: "For floor wire".
- Protected helpers: `setPartInstance(weak_ptr<PartInstance>& data, PartInstance* newValue, const PartProp&)`, `static bool getPosition(const weak_ptr<PartInstance>&, Vector3* out)`.
- State: `weak_ptr<PartInstance> from/to; TextureId texture; Vector2 textureSize; float velocity/studsBetweenTextures/cycleOffset;`

## Gotchas

- From/To are WEAK part refs — a destroyed endpoint silently stops rendering (getPosition returns false path).
- renderInternal takes an explicit Color4 while the instance API exposes no color property — FloorWire supplies its own.

## UNKNOWN

- Default parameter values from ctor (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/TextureTrail.md](../../v8datamodel/TextureTrail.md).
- Base: [GuiBase3d.md](GuiBase3d.md); consumer of renderInternal: [FloorWire.md](FloorWire.md).
