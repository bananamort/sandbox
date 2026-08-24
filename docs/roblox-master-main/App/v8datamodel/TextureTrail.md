# TextureTrail.cpp

## Purpose

Implements `TextureTrail` ("TextureTrail"), a GuiBase3d adornment streaming billboarded textured quads along the line from one part to another, animating with time+velocity and camera-facing billboarding (with a negative-X Y-flip compensation). The classic "flowing arrow" decoration.

## Key types and API

Descriptors (all cap STANDARD, **Security::RobloxPlace**):
- `prop_From("From")` / `prop_To("To")` — RefPropDescriptor PartInstance.
- `prop_Texture("Texture")` — TextureId, category_Appearance.
- `prop_TextureSize("TextureSize")` — Vector2 default (1,1).
- `prop_Velocity("Velocity")` — float default 2.0 (studs/second).
- `prop_StudsBetweenTextures("StudsBetweenTextures")` — float default 4.0.
- `prop_CycleOffset("CycleOffset")` — float default 0 (fraction of spacing, −1..1).

Setters are RAW stores — no change-tracked raises except From/To (setPartInstance raises). Rendering reads live values each frame so that's sufficient.

Rendering (`render3dAdorn` → static-ish `renderInternal`):
- Requires both endpoints alive, non-null texture, Workspace + Camera; color = base color with 1−transparency alpha.
- Builds CoordinateFrame at From looking at To; distance between; camera in trail space.
- Animation offset: `spacing * fmod((velocity/spacing)*gameTimeSeconds + cycleOffset, 1)`.
- Quads spawned every spacing studs anchored counting from TO end ("stream looks anchored on that end"); each quad lookAts the camera with unitZ up; when camera x<0 the sprite UVs flip vertically to un-mirror (comment explains left-right directionality preserved).
- Blocking texture proxy creation (`createTextureProxy(..., true /*blocking*/, ...)`); texture slot 0 explicitly cleared afterward "if this is not done, other adorns may accidentally gain a texture".

## Usage / reflection touchpoints

Script-facing at RobloxPlace security. Pairs with SelectionLasso.md (similar tether rendering), GuiBase3d family in this folder.

## Gotchas

- All appearance setters skip raisePropertyChanged — property replication/UI won't observe Texture/Velocity/etc. changes directly (rendering still updates).
- Blocking proxy creation inside render can hitch on first use of an uncached texture.
- Zero/negative StudsBetweenTextures would infinite-loop the for loop (no guard).
- gameTime comes from Time::now timestamp — velocity animation is wall-clock, not game-time pausable.
