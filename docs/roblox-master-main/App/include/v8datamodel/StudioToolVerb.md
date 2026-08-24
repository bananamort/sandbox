# App/include/v8datamodel/StudioToolVerb.h

## Purpose

`StudioToolVerb` — `Verb` adapter that binds a StudioTool to the verb/accelerator system: enabled/checked state mirrors the tool, and doIt toggles equip.

## Declared API

`class StudioToolVerb : public Verb`

- Protected: `Workspace* workspace; StudioTool* studioTool; bool toggle;`
- Ctor `StudioToolVerb(const char* name, StudioTool* studioTool, Workspace* workspace, bool toggle = true)`.
- Overrides: `bool isEnabled() const`, `bool isChecked() const`, `void doIt(RBX::IDataState* dataState)`.

## Gotchas

- Holds RAW StudioTool*/Workspace* pointers — no ownership; tool must outlive its verbs.
- toggle=true default means doIt equips OR unequips depending on current state.

## UNKNOWN

- Whether any in-tree code constructs with toggle=false (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/StudioToolVerb.md](../../v8datamodel/StudioToolVerb.md).
- Tool: [StudioTool.md](StudioTool.md); verb infra: V8Tree Verb.h; command peer: [StudioToolMouseCommand.md](StudioToolMouseCommand.md).
