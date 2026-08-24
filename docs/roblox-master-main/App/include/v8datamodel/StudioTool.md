# App/include/v8datamodel/StudioTool.h

## Purpose

`StudioTool` — non-creatable base for Studio toolbar tools (select/move/etc.): enable flag, equip/unequip against a Workspace, activate/deactivate, and four lifecycle signals. Subclasses supply behavior; a Mouse is minted on equip.

## Declared API

`class StudioTool : public DescribedNonCreatable<StudioTool, Instance, sStudioTool>`

- Protected: `shared_ptr<Mouse> onEquipping(Workspace* workspace)` — creates the tool's Mouse during equip; `bool enabled`.
- Ctor; inline `bool getEnabled() const`; `void setEnabled(bool)`.
- `void activate(); void deactivate();`
- `void equip(Workspace*); void unequip();`
- Signals: `equippedSignal<void(shared_ptr<Instance>)>`, `activatedSignal<void()>`, `unequippedSignal<void()>`, `deactivatedSignal<void()>`.

## Gotchas

- Not the game-side [Tool.md](Tool.md) — this is the Studio UI twin (Instance-based, no HopperBin semantics).
- Mouse lifetime: shared_ptr handed out by onEquipping; command wiring lives in [StudioToolMouseCommand.md](StudioToolMouseCommand.md).

## UNKNOWN

- Which concrete tools derive from this in-tree (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/StudioTool.md](../../v8datamodel/StudioTool.md).
- Command layer: [StudioToolMouseCommand.md](StudioToolMouseCommand.md), [ScriptMouseCommand.md](ScriptMouseCommand.md); verb bridge: [StudioToolVerb.md](StudioToolVerb.md); game twin: [Tool.md](Tool.md).
