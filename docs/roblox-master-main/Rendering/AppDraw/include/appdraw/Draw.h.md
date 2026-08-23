# AppDraw/include/appdraw/Draw.h

## Purpose

Header for `RBX::Draw` (see Draw.cpp.md): static selection-box/hover drawing plus rotate-surface constraint adornments.

## API

Namespace RBX, class Draw: private statics `adornSurfaces`, `frameBox` (declared but no implementation found in this directory — UNKNOWN/dead), `constraint`, color state (`m_showHoverOver`, `m_hoverOverColor`, `m_selectColor`). Public: `selectColor()/hoverOverColor()/setSelectColor/setHoverOverColor`, `showHoverOver(bool)/isHoverOver()`, `partAdorn(part, adorn, controllerColor)`, three `selectionBox` overloads ((Part,Adorn,color,thickness), (ModelInstance,...), (Part,Adorn,SelectState,...), default thickness 0.15f), declared `selectionSquare(const Rect2D&, float)` "assumes 2D mode".

## Usage

Include via `"AppDraw/Draw.h"`; consumers are Studio adornment render passes. Depends on SelectState.h, Util/G3DCore.h, V8DataModel/ModelInstance.h.

## Gotchas

- Note include-path case sensitivity: sources use `include/appdraw/Draw.h` while vcxproj lists `include\AppDraw\Draw.h` — fine on Windows, matters on macOS/Linux builds.
