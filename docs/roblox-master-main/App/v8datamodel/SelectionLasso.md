# SelectionLasso.cpp

## Purpose

Implements THREE lasso adornments: `SelectionLasso` (abstract GuiBase3d drawing a cylinder "rope" from a Humanoid's torso to a target position), `SelectionPartLasso` ("SelectionPartLasso", DescribedCreatable — target is a PartInstance), and `SelectionPointLasso` ("SelectionPointLasso", DescribedCreatable — target is a raw Vector3). The classic visual tether from a character to a selected part/point.

## Key types and API

Descriptors (category_Data, no security tier ⇒ default):
- `prop_Humanoid("Humanoid")` — RefPropDescriptor Humanoid on SelectionLasso (getter named getHumanoidDangerous).
- `prop_Part("Part")` — RefPropDescriptor PartInstance on SelectionPartLasso.
- `prop_Point("Point")` — Vector3 PropDescriptor on SelectionPointLasso.

Rendering:
- Base requires BOTH Super::shouldRender3dAdorn() AND a live humanoid; `getHumanoidPosition` reads torso (`getTorsoSlow`) UI translation.
- `render3dAdorn`: unit direction torso→target; zero distance bails; builds CoordinateFrame via lookAt with a hand-written +x→−z rotation matrix (cylinderAlongX alignment comment preserved), positions cylinder midpoint at distance/2, draws radius-0.125 cylinder of the full length in `color`.
- Part variant: shouldRender requires live part weak_ptr; getPosition from part translation. Point variant: plain stored Vector3 (no render-dirty on set — only raise).

## Usage / reflection touchpoints

Script-creatable (Part and Point variants). Pairs with SelectionBox.md/SelectionSphere.md family here.

## Gotchas
- Humanoid property getter is the "Dangerous" flavor — returns raw pointer valid only during guarded access.
- setPoint does NOT call shouldRenderSetDirty — moving a point lasso may not repaint until another dirty trigger.
- Cylinder color uses base GuiBase3d `color`; lassos have NO SurfaceColor-style extras.
- UNKNOWN: getTorsoSlow fallback semantics (R6 vs R15 rigs) header-side.
