# AppDraw/include/appdraw/DrawPrimitives.h

## Purpose

Declares `RBX::DrawPrimitives` — lowest-level immediate helpers that push raw geometry (box/sphere/cylinder along X) or 2D primitives straight through a `G3D::RenderDevice*`, bypassing the Adorn layer.

## API

Namespace RBX, all static: `rawBox(const AABox&, RenderDevice*)`, `rawSphere(float radius, RenderDevice*)`, `rawCylinderAlongX(radius, axisLength, RenderDevice*, bool cap)`, and 2D-mode-only helpers `rect2d(RBX::Rect, rd, color=white)`, `line2d(p0, p1, rd, color=white)`, `outlineRect2d(rect, thick, rd, color=blue)`.

## Usage / Gotchas

- **No corresponding DrawPrimitives.cpp exists under Rendering/AppDraw** — the implementation lives in a platform/renderer TU elsewhere (UNKNOWN exact location; grep for `DrawPrimitives::rawBox`). CMake/vcxproj list only the header.
- Callers must already have RenderDevice in the right transform/shade mode ("must be in 2d mode" for the rect/line helpers).
