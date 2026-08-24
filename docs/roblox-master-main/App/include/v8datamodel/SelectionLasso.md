# App/include/v8datamodel/SelectionLasso.h

## Purpose

Three-class lasso family over `GuiBase3d`: abstract `SelectionLasso` (holds a weak Humanoid target + pure-virtual anchor position), creatable `SelectionPartLasso` (anchors to a PartInstance), and creatable `SelectionPointLasso` (anchors to a fixed Vector3). Legacy selection-visualization adornments.

## Declared API

`class SelectionLasso : public DescribedNonCreatable<SelectionLasso, GuiBase3d, sSelectionLasso>`
- Ctor takes `const char* name`.
- Humanoid access: inline const `getHumanoid()`, **misspelled non-const getter `Humanoid* getHunanoid()`** (real name in source), `setHumanoid(Humanoid*)`, `getHumanoidDangerous()`.
- Pure virtual: `virtual bool getPosition(Vector3& output) const = 0`.
- IAdornable overrides: `shouldRender3dAdorn()`, `render3dAdorn(Adorn*)`; protected helper `getHumanoidPosition(Vector3&) const`; member `weak_ptr<Humanoid> humanoid`.

`class SelectionPartLasso : public DescribedCreatable<SelectionPartLasso, SelectionLasso, sSelectionPartLasso>`
- `/*override*/ bool getPosition(Vector3&) const` (out-of-line).
- Part access: const/non-const `getPart()`, `setPart(PartInstance*)`, `getPartDangerous()`; protected `weak_ptr<PartInstance> part`; `shouldRender3dAdorn()` override.

`class SelectionPointLasso : public DescribedCreatable<SelectionPointLasso, SelectionLasso, sSelectionPointLasso>`
- `setPoint(Vector3)`; inline `Vector3 getPoint() const`; inline `getPosition` writes the point and returns true.

## Gotchas

- `getHunanoid` typo is in the actual header — grep for it when auditing callers.
- All "Dangerous" getters just lock() the weak_ptr — they can still return NULL; naming is about lock cost, not safety.
- Base is NON-creatable; only Part/Point variants are user-creatable.

## UNKNOWN

- Render style details (rope drawing) out-of-line.

## Cross-links

- Implementation: [App/v8datamodel/SelectionLasso.md](../../v8datamodel/SelectionLasso.md).
- Base: [GuiBase3d.md](GuiBase3d.md); siblings: [SelectionBox.md](SelectionBox.md), [SelectionSphere.md](SelectionSphere.md).
