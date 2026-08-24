# App/include/v8datamodel/BillboardGui.h

## Purpose

`BillboardGui` Instance ("AdornmentGui" descriptor name) — a screen-space GUI layer that billboards over a 3D adornee (part or attachment-style instance), with studs/extents offsets, UDim2 size, always-on-top and per-player hiding. Header notes the design debt: "Ugh: this component is also a 'PartAdornment', but we can't easily derive from both Adornment and GuiBase2d, resolve later."

## Declared API

`class BillboardGui : public DescribedCreatable<BillboardGui, GuiLayerCollector, sAdornmentGui>, public IStepped`

- Adornee: `const Instance* getAdornee() const / Instance* getAdornee() / void setAdornee(Instance*) / Instance* getAdorneeDangerous() const` — all `adornee.lock().get()` on a `boost::weak_ptr<Instance>`.
- Offsets: `const Vector3& getStudsOffset()/setStudsOffset(const Vector3&)`; `getExtentsOffset()/setExtentsOffset(...)`; `const Vector2& getSizeOffset()/setSizeOffset(...)`.
- Size: `UDim2 getSize() const; void setSize(UDim2);`
- Flags: `bool getAlwaysOnTop()/setAlwaysOnTop(bool)`; `bool getActive() const { return active; } / setActive(bool)`; `bool getEnabled() const { return enabled; } / setEnabled(bool)`.
- Hiding: `Instance* getPlayerToHideFrom() const / setPlayerToHideFrom(Instance*)` — weak ref `playerToHideFrom`.
- Engine hook: `void setRenderFunction(boost::function<void(BillboardGui*, Adorn*)> func);` stored as private `adornFunc`.
- Overrides: `askSetParent(const Instance*) const`; `processMeAndDescendants() const { return false; }`; `onAncestorChanged(const AncestorChanged&)`; `onServiceProvider(old,new)` chaining Super + `onServiceProviderIStepped`; IAdornable `shouldRender3dSortedAdorn()`, `render3dSortedAdorn(Adorn*)`, `Vector3 render3dSortedPosition() const`, `isVisible(const Rect2D&) const { return true; }`; GuiTarget `canProcessMeAndDescendants() const`, `GuiResponse process(const shared_ptr<InputObject>&)`; IStepped `void onStepped(const Stepped& event);`
- Private helpers/state: `boost::shared_ptr<Instance> getPart() const;` `void calcAdornPlacement(Instance* part, CoordinateFrame& cframe, Vector3& size) const;` reflected `partExtentRelativeOffset`, `partStudsOffset`, `billboardSizeRelativeOffset`, `billboardSize`, `alwaysOnTop`, `enabled`, `active`; dynamic `visibleAndValid`, `projectionFrame`, `viewport` (`Rect2D`); member `std::auto_ptr<ViewportBillboarder> viewportBillboarder`.

## Gotchas

- Descriptor/class name mismatch: Lua class is "BillboardGui" but descriptor string is `sAdornmentGui` ("AdornmentGui").
- Adornee/player refs are weak — destroying the target silently unanchors the billboard.
- Input processing is gated by both `processMeAndDescendants() → false` at this level and `canProcessMeAndDescendants()` logic in .cpp.
- `isVisible(rect)` hard-codes true — culling happens elsewhere.

## UNKNOWN

- ViewportBillboarder internals (projection/clipping math, .cpp-only class).

## Cross-links

- Implementation: [App/v8datamodel/BillboardGui.md](../../v8datamodel/BillboardGui.md).
- Base: [GuiLayerCollector.md](GuiLayerCollector.md), [GuiBase2d.md](GuiBase2d.md); kin: [SurfaceGui.md](SurfaceGui.md).
