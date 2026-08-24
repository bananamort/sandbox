# ImageButton.cpp

## Purpose

Implements `GuiImageButton` ("ImageButton") — a GuiButton whose visual is a GuiImageMixin image: renders button background then image, temporarily forcing DOWN_OVER gui state when an attached verb is selected (studio toolbar buttons), syncing `active` from the verb.

## Key types and API

Descriptors: none in TU — mixin + [GuiButton](GuiObject.md) inheritance. Constants: `sGuiImageButton = "ImageButton"`; imageState starts GuiDrawImage::ALL. Optional Verb-taking ctor wires `verb`.

Behavior:
- render2d — render2dButtonImpl background; if verb selected → save guiState, set Gui::DOWN_OVER + active=verb->isEnabled(); renderImage; restore guiState.
- IMPLEMENT_GUI_IMAGE_MIXIN expands Image property plumbing.

## Usage / reflection touchpoints

Image sibling of [ImageLabel](ImageLabel.md); verb-driven variant used by legacy studio toolbars ([Commands](Commands.md) verbs).

## Gotchas

- The verb-selected visual override is per-frame state juggling — any exception mid-render would leak the forced state (practically safe).
- active follows ONLY verb-enabled while a verb is selected; otherwise normal button semantics apply.
