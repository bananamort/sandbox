# BillboardGui.cpp

## Purpose

Implements `BillboardGui` ("BillboardGui") — a GuiLayerCollector rendered as a camera-facing quad anchored to a Part/Model (Adornee or parent): placement math each render step, size in studs via UDim2, optional AlwaysOnTop 2D path, ray-quad input hit-testing with world occlusion, PlayerToHideFrom filtering, and a VR mode behind FFlag `BillboardGuiVR`.

## Key types and API

Descriptors:
- `prop_adornee("Adornee", category_Data)` — RefPropDescriptor<Instance>, get `getAdorneeDangerous`.
- `prop_studsOffset("StudsOffset")`, `prop_extentsOffset("ExtentsOffset")` — Vector3; `prop_sizeOffset("SizeOffset")` — Vector2 (all category_Data).
- `prop_Size("Size")` — UDim2; `prop_Enabled("Enabled", default true)`, `prop_Active("Active", default false)`, `prop_AlwaysOnTop("AlwaysOnTop", default false)` — bool.
- `prop_LocalPlayerVisible("PlayerToHideFrom", category_Data)` — RefPropDescriptor<Instance>; setter throws `"HideFromPlayer can only be of type Player"` for non-Players. No Security:: arguments.

Flag: `FASTFLAGVARIABLE(BillboardGuiVR, false)`; constant `kBillboardGuiPixelsPerStudInVR = 20`; class registered as `sAdornmentGui = "BillboardGui"`. IStepped(StepType_Render).

Behavior:
- `getPart()` — adornee weak ref, else PARENT fallback ("allows for easy insertion of billboard guis in the world that replicate and show for everyone").
- `calcAdornPlacement` — PartInstance → rendering CF + PartSizeXml; ModelInstance → calculated model CF/size; else identity/zero.
- Non-VR path: ViewportBillboarder computes projection per step (`onStepped`), `handleResize` on valid frames.
- VR path: own `getBillboardFrame` math — camera-space extents, ExtentsOffset mapped to bounding box, StudsOffset added; fixed 20 px/stud in VR else perspective depth (reject z ≤ 0 or > 1000); head-look billboard orientation above adornment when VREnabled.
- `render3dSortedAdorn` — non-VR delegates to injected `adornFunc` if set; hides entirely from the player named by PlayerToHideFrom; AlwaysOnTop && !VR renders through AdornBillboarder2D with screen offset, else AdornBillboarder 3D quad.
- `process(InputObject&)` — requires enabled + active (+ visibleAndValid in VR); mouse events hit-test the quad: `rayQuad` (Möller–Trumbore adapted, barycentric u,v ≤ 1) then — unless AlwaysOnTop — occlusion check against world contact hit within 2048 studs (`FilterInvisibleNonColliding`); hits re-issue a CLONED InputObject with remapped local position into Super::process.
- `askSetParent` — any parent EXCEPT GuiBase2d; `canProcessMeAndDescendants()` false (input flows only via explicit process path).

## Usage / reflection touchpoints

Renders through the sorted-adornment pipeline like [SelectionBox](SelectionBox.md)/[SurfaceGui](SurfaceGui.md); input interop mirrors [MouseCommand](MouseCommand.md) handling; camera math shared with [Base](../../Base/) viewport code.

## Gotchas

- With no Adornee set the PARENT becomes the anchor — moving the BillboardGui under another instance silently moves every on-screen label.
- Active defaults false: Enabled alone does NOT enable click-through processing.
- Occlusion test uses a 2048-stud clamped ray — billboards beyond that distance are treated as unoccluded.
- The two flag-gated code paths duplicate nearly all logic (render + process + step); behavior fixes must be applied twice.
