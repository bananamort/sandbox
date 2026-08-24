# App/include/v8datamodel/DialogChoice.h

## Purpose

`DialogChoice` Instance — one branch of the legacy NPC dialog tree: user-facing prompt, response text, optional goodbye string, and a `selected` signal consumed by the dialog UI.

## Declared API

`class DialogChoice : public DescribedCreatable<DialogChoice, Instance, sDialogChoice>`

- Text: `getUserDialog()/setUserDialog(std::string)`; `getResponseDialog()/setResponseDialog(...)`; `getGoodbyeDialog()/setGoodbyeDialog(...)`.
- Signal: `rbx::signal<void(shared_ptr<Instance>)> selected;`
- Override: `bool askSetParent(const Instance*) const;`

## Gotchas

- Parenting restricted by askSetParent (.cpp — presumably Dialog/DialogChoice parents only).
- The class holds no child-order logic itself; tree traversal lives in the dialog system.

## UNKNOWN

- Where `selected` is fired from (dialog engine .cpp — see [DialogChoice.md](../../v8datamodel/DialogChoice.md)).

## Cross-links

- Implementation: [App/v8datamodel/DialogChoice.md](../../v8datamodel/DialogChoice.md).
- Root: [DialogRoot.md](DialogRoot.md).
