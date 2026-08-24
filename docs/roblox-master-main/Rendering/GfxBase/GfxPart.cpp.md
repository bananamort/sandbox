# GfxPart.cpp

Source: `roblox-sandbox/Rendering/GfxBase/GfxPart.cpp` (313 lines)

## Purpose

Implements `GfxBinding`'s full event plumbing: one combinedSignal subscription fans out to property/child/ancestry/outfit/humanoid handlers that translate data-model changes into graphics invalidations, keeping the part's `PartCookie` fresh. Also `GfxAttachment::unbind` override.

## API

- (anon ns) `void updateCookie(RBX::PartInstance* part)` — `part->setCookie(PartCookie::compute(part))`.
- `GfxBinding::~GfxBinding()` — `RBXASSERT(!isBound())`.
- `bindProperties(part)` — updateCookie + connect `part->combinedSignal` → onCombinedSignal + `visitChildren(onChildAdded)` for existing children.
- `zombify()` — unbind() + invalidateEntity().
- `unbind()` — `partInstance->setGfxPart(NULL)`, disconnect+clear all connections.
- `isBound()` — `!connections.empty()`.
- `onChildAdded/onChildRemoved(Instance*)` — react to DataModelMesh / DecalTexture / Decal children: subscribe propertyChangedSignal (add path), updateCookie + invalidate. Removal paths carry `// todo: need a disconnect for propertyChangedEvents...` — connections to removed children are NOT disconnected.
- `isInWorkspace(Instance*)` — `Workspace::findWorkspace(part)` + isDescendantOf check.
- `onAncestorChanged` — leaves Workspace → zombify; else cookie refresh + invalidate.
- `onPropertyChanged(descriptor)` — dispatch table by descriptor identity: CFrame→onCoordinateFrameChanged; Anchored→**commented out no-op**; Size→onSizeChanged; Transparency/LocalTransparencyModifier→onTransparencyChanged; renderMaterial, Reflectance, shapeXml, styleXml, surface descriptors, Color, PartOperation MeshData/UsePartColor/FormFactor→invalidateEntity. Prism/Pyramid sidesXML branches behind `#ifdef _PRISM_PYRAMID_`.
- `onTexturePropertyChanged` / `onDecalPropertyChanged` — Face/Texture changes also refresh cookie; Specular/Shiny/StudsPerTileU/V/Transparency just invalidate.
- `onCombinedSignal(type,data)` — switch: OUTFIT_CHANGED, HUMANOID_CHANGED, CHILD_ADDED, CHILD_REMOVED, ANCESTRY_CHANGED, PROPERTY_CHANGED (polymorphic_downcast per case).
- `cleanupStaleConnections()` — reverse-erase dead connections.
- `GfxAttachment::unbind()` — deliberately SKIPS base impl (no setGfxPart call), just disconnects.

## Usage

Includes 16 v8datamodel/humanoid/v8world headers. This TU is where "graphics reacts to data model" is fully enumerated.

## Gotchas
- Child-REMOVED paths leak live signal connections (todo comments in source) until cleanupStaleConnections runs or binding dies.
- Anchored property change intentionally does nothing (dead branch with commented body).
- `polymorphic_downcast`s assume combinedSignal always pairs type tag with matching data class — UB on mismatch (debug-only assert).
