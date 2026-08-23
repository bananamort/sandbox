# AppDraw/Draw.cpp

## Purpose

Implementation of `RBX::Draw` — the small selection/highlight adornment layer used by Studio: part selection boxes (with distance-based switch from 3D boxes to screen-space lines), hover-over boxes, and legacy surface-constraint indicators (rotate-surface cylinders).

## API (RBX::Draw, all static)

- Static state: `m_showHoverOver=true`, `m_hoverOverColor = Color4(0.7,0.9,1.0)` (RGB ≈ 178,229,255), `m_selectColor = Color4(0.1,0.6,1.0)`; accessors `selectColor()/hoverOverColor()/setSelectColor/setHoverOverColor/showHoverOver/isHoverOver`.
- `partAdorn(part, adorn, controllerColor)` — draws rotate-surface constraint widgets (`adornSurfaces`) for faces whose SurfaceType is ROTATE / ROTATE_P / ROTATE_V: a yellow cylinder along the face axis plus a fatter controller-colored cylinder for P/V variants.
- `selectionBox(part, adorn, SelectState, lineThickness=0.15f)` — SELECT_HOVER draws hover color at double thickness (only if `m_showHoverOver`); other states draw selectColor or **orange** (SELECT_? non-normal path) — see Gotchas.
- `selectionBox(model(ModelInstance), adorn, color, thickness)` — delegates to `model.computePart()`.
- `selectionBox(part, adorn, color, thickness)` — the real work: if camera exists and distance² − size² exceeds `(1500·thickness)²`, switches to `DrawAdorn::outlineBox` lines (cheap far-field rendering); otherwise draws 12 edge "boxes" (thin AABox slabs) with corner overlap compensation using ±highlight offsets.
- Header also declares `selectionSquare(rect, thick)` (2D mode) — **dead**: no definition exists anywhere in the tree (verified by grep) and no call sites.

## Usage

Called by Studio's render/adornment passes whenever parts are selected/hovered in the 3D view and by legacy surface-type visualizers. Includes V8DataModel PartInstance/ModelInstance and GfxBase Adorn.

## Gotchas

- In `selectionBox(...SelectState...)`, any state that isn't HOVER or NORMAL renders orange — check SelectState enum before assuming only two states exist.
- `SelectionBoxLineThreshold = 1500` is tuned per lineThickness unit (thickness 0.15 ⇒ ~225 studs).
- Edge-box corner math assumes `lineThickness == highlight`; asymmetric x-axis sign handling (`c1==0 ? highlight : -highlight`) is intentional.
