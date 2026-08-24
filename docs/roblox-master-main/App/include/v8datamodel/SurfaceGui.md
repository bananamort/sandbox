# App/include/v8datamodel/SurfaceGui.h

## Purpose

`SurfaceGui` — creatable `GuiLayerCollector` rendered ONTO a part face in 3D (sorted-adorn path): adornee part + face, canvas size, active/enabled gating, tool punch-through distance, 3D input processing by world-space ray hit, and a StarterGui-duplication disambiguation hack.

## Declared API

`class SurfaceGui : public DescribedCreatable<SurfaceGui, GuiLayerCollector, sAdornmentSurfaceGui>`

- Header comment: "Ugh: this component is also a 'PartAdornment', but we can't easily derive from both Adornment and GuiBase2d, resolve later."
- Static helper: `static SurfaceGui* findSurfaceGui(PartInstance* pi, NormalId surf)` — "given a part and part side, finds a surface gui object attached to it" (backed by PartInstance::surfaceGuiCookies).
- Ctor/virtual dtor; `askSetParent` override; inline `bool processMeAndDescendants() const {return false;}`.
- Adornee: inline `Instance* getAdornee()` over weak_ptr / `setAdornee(Instance*)`.
- Flags: inline `getActive()/getEnabled()` + setters.
- Canvas: `setCanvasSize(Vector2)` / inline getter.
- Input: `GuiResponse process3d(const shared_ptr<InputObject>& event, Vector3 point3d, bool ignoreMaxDistance)` — "point3d contains world space position of the ray hitting SG's parent"; `void unProcess()` ("notification when mouse leaves this particular GUI"); overrides `process(InputObject)`, `canProcessMeAndDescendants()`.
- Face: `setFace(NormalId)` / inline `getFace()`.
- Punch-through: inline `float getToolPunchThroughDistance()` / setter — "<= 0 means unlimited".
- Statics/counters: `static int numInstances()` over `static int s_numInstances`.
- Private: `boost::shared_ptr<Instance> getPart() const`; state (`enabled`, `active`, `canvasSize`, `faceID`, weak adornee, `toolPunchThroughDistance`); `buildGuiMatrix(Adorn*, CoordinateFrame* partFrame, CoordinateFrame* projectionFrame)`; Instance overrides `onAncestorChanged`, `onDescendantAdded`; IAdornable overrides `shouldRender3dSortedAdorn/render3dSortedAdorn/render3dSortedPosition/isVisible{true}`; **`isYetAnotherSpecialCase()`** with long in-header comment: returns true unless the SG is under StarterGui in-game — because StarterGui contents are COPIED per player, two SG instances attach to the same part and only one may take input, so the original is effectively disabled.

## Gotchas

- The StarterGui double-attach problem is handled by convention (see comment) — input routing depends on it.
- Adornee is a WEAK ref; a destroyed part leaves the gui orphaned but alive.
- processMeAndDescendants=false at the collector level while canProcessMeAndDescendants is a separate virtual — two gates on input flow.
- Per project recon: decoy hackFlag usage is associated with this file's cluster (hackFlag0/6/7 decoys live in SurfaceSelection/PhysicsInstructions/TouchTransmitter); treat any flag semantics near here as anti-tamper noise until verified against the certified doc.

## UNKNOWN

- Max-distance policy for process3d when ignoreMaxDistance=false (value source out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/SurfaceGui.md](../../v8datamodel/SurfaceGui.md).
- Base chain: [GuiLayerCollector.md](GuiLayerCollector.md), [GuiBase2d.md](GuiBase2d.md); attachment side: [PartInstance.md](PartInstance.md) (surfaceGuiCookies); sibling viewport gui: [ScreenGui.md](ScreenGui.md).
