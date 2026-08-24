# App/include/v8datamodel/ClickDetector.h

## Purpose

`ClickDetector` Instance — makes its Part/Model parent clickable from a distance: engine fires click/hover/hover-leave remote signals gated by `MaxActivationDistance`, with hover bookkeeping and adorn rendering.

## Declared API

`class ClickDetector : public DescribedCreatable<ClickDetector, Instance, sClickDetector>, public IAdornable`

- `void fireMouseClick(float distance, RBX::Network::Player* player);`
- `void fireMouseHover(RBX::Network::Player* player); void fireMouseHoverLeave(RBX::Network::Player* player);`
- Remote signals (payload = clicking Player Instance): `mouseClickSignal<void(shared_ptr<Instance>)>`, `mouseHoverSignal`, `mouseHoverLeaveSignal`.
- Reflection: `static Reflection::BoundProp<float> propMaxActivationDistance;` accessor `float getMaxActivationDistance() { return maxActivationDistance; }` (member comment: "max distance a character can be from the button and still raise events").
- Hover tracking: `shared_ptr<Instance> getLastHoverPart(); bool updateLastHoverPart(shared_ptr<Instance> newHover, RBX::Network::Player* player);`
- Statics: `static int cycles() { return 30; }`; `static bool isClickable(shared_ptr<PartInstance> part, float distanceToCharacter, bool raiseClickedEvent, RBX::Network::Player*);` `static bool isHovered(PartInstance*, float, bool raiseHoveredEvent, Player*);` `static void stopHover(shared_ptr<PartInstance> part, Player*);`
- Tree rules: `askSetParent` allows only PartInstance or ModelInstance parents; `askAddChild` → true.
- IAdornable: `shouldRender3dAdorn() { return true; }`, `render3dAdorn(Adorn*)`.
- State: `int cycle; float maxActivationDistance; shared_ptr<Instance> lastHoverPart;`

## Gotchas

- Signals carry the *player*, not the mouse/part — scripts identify which detector fired by connecting on that instance.
- `cycles()` returns a fixed 30 — likely an anti-spam/click-cycle budget (.cpp usage).
- Parenting restricted to parts/models only.

## UNKNOWN

- Exact distance metric (character origin vs nearest limb) in isClickable/isHovered (.cpp — see [ClickDetector.md](../../v8datamodel/ClickDetector.md)).

## Cross-links

- Implementation: [App/v8datamodel/ClickDetector.md](../../v8datamodel/ClickDetector.md).
- Input kin: [Mouse.md](Mouse.md), [UserInputService.md](UserInputService.md).
