# DialogChoice.cpp

## Purpose

Implements `DialogChoice` ("DialogChoice") — one node of the legacy NPC dialog tree: what the player says (UserDialog, hard-truncated to 48 chars "16 character per line, max of 3 lines"), the NPC's ResponseDialog, and GoodbyeDialog text. Parenting restricted to DialogChoice or Dialog roots.

## Key types and API

Descriptors (all category_Data, std::string, no Security:: arguments):
- `prop_UserDialog("UserDialog")` — setter truncates to 48 chars BEFORE comparing.
- `prop_ResponseDialog("ResponseDialog")`, `prop_GoodbyeDialog("GoodbyeDialog")` — unbounded.

Constants: `sDialogChoice = "DialogChoice"`. Flag: `DYNAMIC_FASTFLAGVARIABLE(FilteringEnabledDialogFix, false)` (declared here; consumed elsewhere — UNKNOWN where).

Behavior: compare-then-raise setters; `askSetParent` allows ONLY DialogChoice or [DialogRoot](DialogRoot.md) parents.

## Usage / reflection touchpoints

Tree children of Dialog instances on parts ([DialogRoot](DialogRoot.md)); selection flows back through SignalDialogChoiceSelected.

## Gotchas

- UserDialog truncation is silent and happens before dedupe-check — setting a >48-char string that shares a 48-char prefix with current value still raises changed.
- Choices can nest under choices arbitrarily deep; no cycle guard beyond parenting rules.
