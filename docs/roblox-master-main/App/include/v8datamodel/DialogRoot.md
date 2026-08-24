# App/include/v8datamodel/DialogRoot.h

## Purpose

`DialogRoot` Instance — the entry point of a legacy NPC conversation: purpose/tone enums for UI presentation, initial prompt + goodbye text, conversation distance gating, public-chat flag, and replication of the player's choice back through `dialogChoiceSelected`.

## Declared API

`class DialogRoot : public DescribedCreatable<DialogRoot, Instance, sDialogRoot>`

- Enums: `DialogPurpose { QUEST_PURPOSE, HELP_PURPOSE, SHOP_PURPOSE }`; `DialogTone { NEUTRAL_TONE, FRIENDLY_TONE, ENEMY_TONE }`.
- Props: purpose/tone get+set; `bool getPublicChat()/setPublicChat(bool)`; `bool getInUse()/setInUse(bool)` (conversation lock); `float getConversationDistance()/setConversationDistance(float)`; strings `getInitialPrompt()/setInitialPrompt(...)`, `getGoodbyeDialog()/setGoodbyeDialog(...)`.
- Choice flow: `void signalDialogChoice(shared_ptr<Instance> player, shared_ptr<Instance> dialogChoice);` local signal `rbx::signal<void(shared_ptr<Instance>)> dialogChoice;` remote signal `rbx::remote_signal<void(shared_ptr<Instance>, shared_ptr<Instance>)> dialogChoiceSelected;`
- Overrides: `onServiceProvider(old,new)`, `askSetParent(const Instance*) const`.

## Gotchas

- `inUse` gates concurrent conversations — engine-managed, scripts should not force it.
- Two choice channels exist: local `dialogChoice` signal vs remote `dialogChoiceSelected` (server/client split).

## UNKNOWN

- Which side fires signalDialogChoice vs replicates dialogChoiceSelected (.cpp — see [DialogRoot.md](../../v8datamodel/DialogRoot.md)).

## Cross-links

- Implementation: [App/v8datamodel/DialogRoot.md](../../v8datamodel/DialogRoot.md).
- Children: [DialogChoice.md](DialogChoice.md).
