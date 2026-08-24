# GuiBase.cpp

## Purpose

Implements `GuiBase` ("GuiBase") — the GUI class-hierarchy root. The entire TU is a name-taking constructor; all behavior (ZIndex, display order, hierarchy helpers) is header-side.

## Key types and API

- `const char* const sGuiBase = "GuiBase";`
- `GuiBase::GuiBase(const char* name) : Super(name) {}` — that's all. No descriptors, no Security:: tiers.

## Usage / reflection touchpoints

Ancestor of [GuiBase2d](GuiBase2d.md)/[GuiBase3d](GuiBase3d.md) and the whole 2D/3D GUI tree ([PlayerGui](PlayerGui.md)-registered family).

## Gotchas

- Don't look here for logic — see GuiBase.h for ZIndex/Visible plumbing shared by all GUI classes.
