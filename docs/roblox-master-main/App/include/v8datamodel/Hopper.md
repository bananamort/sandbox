# App/include/v8datamodel/Hopper.h

## Purpose

Backpack plumbing: `BackpackItem` (common root of Tool and HopperBin — "stuff that can go in the hopper and on the player", a Gui Widget with texture), `HopperBin` (script/tool bin with BinType enum + selected/deselected replication), `Hopper` (container panel base), `StarterPackService`, `LegacyHopperService`, and `StarterGear`.

## Declared API

`class BackpackItem : public DescribedNonCreatable<BackpackItem, Widget, sBackpackItem>`

- Texture: `void setTextureId(const TextureId&); const TextureId getTextureId() const;`
- Virtual UI hooks: `bool drawEnabled() const { return true; }`, `bool drawSelected() const { return false; }`, `void onLocalClicked() {}`, `void onLocalOtherClicked() {}`.
- Protected: `setName` override, GuiItem `Vector2 getSize(Canvas) const`, `isEnabled() { return inBackpack(); }`, `int getBinId() const;` private draw helpers + `inBackpack()`; tree rules askSetParent/askAddChild.

`class HopperBin : public DescribedCreatable<HopperBin, BackpackItem, sHopperBin>`

- `enum BinType { SCRIPT_BIN=0, GAME_TOOL=1, GRAB_TOOL=2, CLONE_TOOL=3, HAMMER_TOOL=4 };` — "affect XML read - only append".
- Public field `bool active; // I have a pending deselect event to fire`.
- Signals: remote `replicatedSelectedSignal<void()>`, `selectedSignal<void(shared_ptr<Instance>)>`; local `deselectedSignal<void()>`; selection shim connection + helpers.
- API: `BinType getBinType()/setBinType(...)`; `void disable();` overrides onLocalClicked/onLocalOtherClicked/onAncestorChanged/getCursor/drawSelected(=active); legacy loaders `setLegacyCommand(std::string)`, `setLegacyTextureName(std::string)`; `dataChanged(descriptor)`.

`class Hopper : public RelativePanel` — container base ("Generic / tree view of the hopper ... Draws dim"); ctor + tree-rule overrides.

`class StarterPackService : public DescribedNonCreatable<StarterPackService, Hopper, sStarterPackService>, public Service` — ctor only.
`class LegacyHopperService : public DescribedNonCreatable<..., sLegacyHopperService>, public Service` — legacy twin (comment: renamed-to-StarterPack history note), onServiceProvider override, ctor/dtor.
`class StarterGear : public DescribedCreatable<StarterGear, Instance, sStarterGear>` — "the gear I bring with me in game"; tree-rule overrides + `bool canClientCreate() { return true; }`.

## Gotchas

- HopperBin's deselect is signaled locally while select replicates — asymmetric path guarded by the `active` pending flag.
- BinType enum order is XML-load-bearing.
- Legacy* members exist purely to read old saves.

## UNKNOWN

- How StarterPack contents clone into player Backpacks (.cpp — see [Hopper.md](../../v8datamodel/Hopper.md)).

## Cross-links

- Implementation: [App/v8datamodel/Hopper.md](../../v8datamodel/Hopper.md).
- Kin: [Tool.md](Tool.md), [Backpack.md](Backpack.md).
