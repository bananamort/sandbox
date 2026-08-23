# AppDraw/include/appdraw/Draw.h

## Purpose

Header for `RBX::Draw` (see Draw.cpp.md): static selection-box/hover drawing plus rotate-surface constraint adornments.

## API

Namespace RBX, class Draw: private statics `adornSurfaces`, `frameBox`, `constraint`, color state (`m_showHoverOver`, `m_hoverOverColor`, `m_selectColor`). Public: `selectColor()/hoverOverColor()/setSelectColor/setHoverOverColor`, `showHoverOver(bool)/isHoverOver()`, `partAdorn(part, adorn, controllerColor)`, three `selectionBox` overloads ((Part,Adorn,color,thickness), (ModelInstance,...), (Part,Adorn,SelectState,...), default thickness 0.15f), declared `selectionSquare(const Rect2D&, float)` "assumes 2D mode".

## Usage

Include via `"AppDraw/Draw.h"`. Live callers tree-wide: `PartInstance.cpp` (the main render path, lines 1027–1269), `SelectionBox.cpp`, `ModelInstance.cpp`, `ClickDetector.cpp`, `HumanoidState.cpp`, `AdvRunDragger.cpp`. Depends on SelectState.h, Util/G3DCore.h, V8DataModel/ModelInstance.h.

## Gotchas

- **Dead declarations (verified by grep)**: `frameBox` and `selectionSquare` are declared here but defined nowhere in the tree and never called. Only `adornSurfaces`, `constraint`, `partAdorn`, and the three `selectionBox` overloads have implementations (in Draw.cpp).
- Note include-path case sensitivity: sources use `include/appdraw/Draw.h` while vcxproj lists `include\AppDraw\Draw.h` — fine on Windows, matters on macOS/Linux builds.
