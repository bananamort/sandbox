# App/include/v8datamodel/GuiLayerCollector.h

## Purpose

`GuiLayerCollector` (non-creatable; descriptor "LayerCollector") — base for full-screen GUI containers (ScreenGui family): owns z-index layering ("Controls the rendering order of GUI elements"), batches descendants into per-queue render vectors, routes input/gesture processing to children, and tracks per-descendant property connections for invalidation.

## Declared API

`class GuiLayerCollector : public DescribedNonCreatable<GuiLayerCollector, GuiBase2d, sLayerCollector>`

- `GuiLayerCollector(const char* name); ~GuiLayerCollector();`
- Input: GuiTarget overrides `GuiResponse process(const shared_ptr<InputObject>&, bool sinkIfMouseOver = true)` and `processGesture(gesture, touchPositions, args)`.
- Rendering: `void render2d(Adorn* adorn); void render2dContext(Adorn*, const Instance* context);` private batch renderers `render2dStandardGuiElements(...)` / `render2dTextGuiElements(adorn, context, batch, viewport)`.
- Tree hooks: `onDescendantAdded(Instance*)`, `onDescendantRemoving(const shared_ptr<Instance>&)`; per-object property watcher `descendantPropertyChanged(shared_ptr<GuiBase>, const PropertyDescriptor*)`.
- Selection: `void getGuiObjectsForSelection(std::vector<GuiObject*>& guiObjects);`
- Private machinery: `typedef std::vector<shared_ptr<GuiBase>> GuiVector; typedef std::vector<GuiVector> GuiLayers;` dirty flag `rebuildGuiVector`; static z-loader `LoadZ(instance, guiVectors[])` + `loadZVectors()`; input helpers `tryReleaseLastButtonDown`, `processDescendants`, `doProcessGesture`; pre-sized per-queue scratch `GuiLayers mGuiVectors[GUIQUEUE_COUNT]` ("never realloc, always fast clear"); connection map `boost::unordered_map<Instance*, scoped_connection> propertyConnections`.

## Gotchas

- Layer rebuild is lazy: flagged by property/tree changes, executed at next render.
- The mGuiVectors arrays are member scratch — not re-entrant across threads.
- Property connections are keyed by raw Instance* and cleaned in onDescendantRemoving.

## UNKNOWN

- Exact z-index bucketing into layers within a queue (.cpp — see [GuiLayerCollector.md](../../v8datamodel/GuiLayerCollector.md)).

## Cross-links

- Implementation: [App/v8datamodel/GuiLayerCollector.md](../../v8datamodel/GuiLayerCollector.md).
- Base: [GuiBase2d.md](GuiBase2d.md); children: [BillboardGui.md](BillboardGui.md), [ScreenGui.md] (S–Z half).
