# ToolsPart.cpp

## Purpose

Implements THREE legacy paint Studio MouseCommands extending PartTool: `FillTool` ("Fill", applies a STATIC process-wide color), `MaterialTool` ("Material", applies static material, default PLASTIC), and `DropperTool` ("Dropper", samples the clicked part's color into FillTool then hands control to a fresh FillTool). All single-shot (release capture after click).

## Key types and API

Extends MouseCommand via PartTool (hover stores hit part, render3dAdorn SELECT_NORMAL highlight). Constants sFillTool/sMaterialTool/sDropperTool.

- `FillTool::color` — STATIC FillToolColor wrapping BrickColor::defaultColor(); shared across all FillTool instances.
- `MaterialTool::material` — STATIC PartMaterial default PLASTIC_MATERIAL.
- FillTool/MaterialTool onMouseDown: apply to hovered part → ChangeHistory waypoint named by tool → workspace dataState dirty → return NULL command (release).
- DropperTool: copies clicked part color into FillTool::color, returns a NEWLY CREATED FillTool as the next command ("enable FillTool").

## Usage / reflection touchpoints

Studio-only. Pairs with MouseCommand.md, Surface.md (color/material storage on PartInstance), ChangeHistory docs.

## Gotchas

- Static color/material persist across tool instances AND DataModels — Studio-wide state, not per-document.
- DropperTool creates the successor FillTool even when nothing was clicked.
- No SoundService use despite include (vestigial).
