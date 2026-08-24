# GfxBase/include/GfxBase/Type.h

## Purpose

Declares the `RBX::Text` namespace enums shared by every text-rendering call site: the font face list and 2D alignment options. "Font drawing params - copied from G3D" per the comment.

## API

```cpp
namespace RBX { namespace Text {
enum Font { FONT_LEGACY, FONT_ARIAL, FONT_ARIALBOLD, FONT_SOURCESANS,
            FONT_SOURCESANSBOLD, FONT_SOURCESANSLIGHT, FONT_SOURCESANSITALIC,
            FONT_LAST };
enum XAlign { XALIGN_RIGHT, XALIGN_LEFT, XALIGN_CENTER };
enum YAlign { YALIGN_TOP, /*YALIGN_BASELINE,*/ YALIGN_CENTER, YALIGN_BOTTOM };
}}
```

Header-only.

## Lua globals and events

These enums back the Lua `Font` enum on TextLabels/etc.: `App/v8datamodel/TextService.cpp:85–110` maps between `Text::Font*` and the reflection-exposed `FONT_*` values in both directions (unknown → FONT_LEGACY fallback).

## Usage (who loads it)

- `GfxBase/Adorn.h` uses `Text::Font` as the default parameter of its `drawFont2D` overloads (`font = Text::FONT_LEGACY`, Adorn.h:151/162).
- `GfxRender/VisualEngine.cpp:101–123` iterates `FONT_LEGACY..FONT_LAST` to build one `Typesetter` per font (with hardcoded font file paths) and applies a special 1.5× height scale for FONT_LEGACY; `VisualEngine.h:156` stores the `typesetters[Text::FONT_LAST]` array.
- Draw sites across App: humanoid name tags (FONT_SOURCESANS/SOURCEANSBOLD), ChatOutput, GUI, VehicleSeat, UserController, Message, SkateboardPlatform, PhysicsReceiver health bars, HumanoidState legacy text.

## Gotchas

- `YALIGN_BASELINE` is commented out — baseline alignment is not available even though G3D's original enum had it.
- Ordinals are load-bearing: arrays are sized by `FONT_LAST` and loops iterate by integer increment, so inserting a font mid-list shifts every later value (TextService's bidirectional mapping keeps them in lockstep).
