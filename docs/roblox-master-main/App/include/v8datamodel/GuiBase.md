# App/include/v8datamodel/GuiBase.h

## Purpose

Root of the GUI class hierarchy: a non-creatable Instance+IAdornable defining the input-processing contract (`process`, gesture handling), z-index/queue ordering, and the GuiResponse sink model every GUI element implements.

## Declared API

`enum GuiQueue { GUIQUEUE_GENERAL = 0, GUIQUEUE_TEXT, GUIQUEUE_COUNT };`

`class GuiBase : public DescribedNonCreatable<GuiBase, Instance, sGuiBase>, public IAdornable`

- `GuiBase(const char* name);`
- Statics: `minZIndex() = 0`, `maxZIndex() = 10`; 2D window `minZIndex2d() = min+1`, `maxZIndex2d() = max`.
- Input: `virtual GuiResponse process(const shared_ptr<InputObject>& event) { return GuiResponse::notSunk(); }`; pure virtual `bool canProcessMeAndDescendants() const = 0;`
- Gestures: `virtual GuiResponse processGesture(const UserInputService::Gesture&, const shared_ptr<const Reflection::ValueArray>& touchPositions, const shared_ptr<const Reflection::Tuple>& args)` — default notSunk.
- Ordering contract: pure virtuals `int getZIndex() const` and `GuiQueue getGuiQueue() const`.

## Gotchas

- Z-index is bounded to [0,10] globally (2D uses [1,10]) — hard engine limit of the era.
- Default responses are "notSunk": subclasses opt in by overriding.

## Cross-links

- Implementation: [App/v8datamodel/GuiBase.md](../../v8datamodel/GuiBase.md).
- Children: [GuiBase2d.md](GuiBase2d.md), [GuiBase3d.md](GuiBase3d.md); input kin [InputObject.md](InputObject.md).
