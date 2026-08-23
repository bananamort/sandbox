# AppDraw/include/appdraw/DrawPrimitives.h

## Purpose

Declares `RBX::DrawPrimitives` — lowest-level immediate helpers that push raw geometry (box/sphere/cylinder along X) or 2D primitives straight through a `G3D::RenderDevice*`, bypassing the Adorn layer.

## API

Namespace RBX, all static: `rawBox(const AABox&, RenderDevice*)`, `rawSphere(float radius, RenderDevice*)`, `rawCylinderAlongX(radius, axisLength, RenderDevice*, bool cap)`, and 2D-mode-only helpers `rect2d(RBX::Rect, rd, color=white)`, `line2d(p0, p1, rd, color=white)`, `outlineRect2d(rect, thick, rd, color=blue)`.

## Usage / Gotchas

- **Dead code, verified**: no `DrawPrimitives.cpp` exists under Rendering/AppDraw or anywhere else in the tree (tree-wide grep for `DrawPrimitives::` returns zero definitions), and there are also **zero call sites** of any of its six static methods. The header is nonetheless included by ~10 first-party TUs (`Draw.cpp`, `DrawAdorn.cpp`, `App/gui/GuiDraw.cpp`, `App/gui/Widget.cpp`, `App/v8datamodel/{DataModel,UserController,JointInstance,CommonVerbs,Hopper,Explosion,Message}.cpp`) — includes are harmless since nothing calls the statics, so no link error ever surfaces.
- Callers would need RenderDevice already in the right transform/shade mode ("must be in 2d mode" for the rect/line helpers).
