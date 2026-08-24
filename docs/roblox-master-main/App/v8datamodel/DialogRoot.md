# DialogRoot.cpp

## Purpose

Implements `DialogRoot` ("Dialog") — the NPC conversation root attached to a Part: InitialPrompt/Goodbye text, Purpose/Tone icons, ConversationDistance (25 default), InUse lock flag, and the server-authoritative SignalDialogChoiceSelected → broadcast DialogChoiceSelected replication path. Contains RCC-only write-breakpoint exploit debugging around InitialPrompt.

## Key types and API

Descriptors:
- `prop_InitialPrompt("InitialPrompt", category_Data)`, `prop_GoodbyeDialog("GoodbyeDialog", category_Data)` — strings.
- `prop_DialogPurpose("Purpose")` — enum "DialogPurpose" {Quest, Help, Shop}, default HELP.
- `prop_DialogTone("Tone")` — enum "DialogTone" {Neutral, Friendly, Enemy}, default NEUTRAL.
- `prop_ConversationDistance("ConversationDistance")` — float, default 25.
- `prop_InUse("InUse", SCRIPTING)` — bool conversation-lock.
- `func_signalDialogChoice("SignalDialogChoiceSelected", "player","dialogChoice", **Security::RobloxScript**)`.
- `event_DialogChoiceSelected("DialogChoiceSelected", "player","dialogChoice", Security::None, SCRIPTING, BROADCAST)`.
Commented-out: Public chat prop ("Public"). Flag: `FASTFLAGVARIABLE(US31006, false)` — RCC exploit debug only.

Behavior:
- `signalDialogChoice(player, dialogChoice)` — throws unless player is Network::Player, dialogChoice is DialogChoice AND descendant of this root; then fireAndReplicate.
- `setInitialPrompt` under RBX_RCC_SECURITY + US31006 removes/re-adds hardware write breakpoints when capacity >1000 / size >1000 ("debugging of an exploit").
- CollectionService bucket add/remove on provider change; `askSetParent` — PartInstance ONLY.

## Usage / reflection touchpoints

Root of [DialogChoice](DialogChoice.md) trees; registered into [CollectionService](CollectionService.md); selection UI consumes Purpose/Tone.

## Gotchas

- SignalDialogChoiceSelected validates ancestry but NOT that the choice is a DIRECT child — nested choices signal fine.
- The US31006 breakpoint code mutates hardware debug state on a production string setter when both build-flag and runtime flag are set.
- InUse has no engine-side enforcement visible in this TU (UNKNOWN who resets it on conversation end).
