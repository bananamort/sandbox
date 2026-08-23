# AppDraw/include/appdraw/DrawAdorn.h

## Purpose

Header for `RBX::DrawAdorn` (see DrawAdorn.cpp.md): the static Studio gizmo/grid/shape drawing utility class over the renderer-agnostic `Adorn` interface.

## API

Namespace RBX, class DrawAdorn. Public statics:
- `resizeColor()` — inline, Color3(0.1f,0.6f,1.0f).
- Handle system: `handlePosInObject`, `scaleHandleRelativeToCamera`, `handles3d(size, position, adorn, handleType, cameraPos, color, useAxisColor=true, normalIdMask=NORM_ALL_MASK, normalIdTohighlight=NORM_UNDEFINED, highlightColor=cornflowerblue)`, `handles2d(...)` ("Must be in 2d Mode").
- Grids: `surfaceGridOnFace(prim(V8World::Primitive), adorn, surfaceId, color, boxesPerStud)`, `zeroPlaneGrid(adorn, camera, studsPerBox, yLevel, smallGridColor, largeGridColor)`, `surfaceGridAtCoord`, `circularGridAtCoord`.
- Shapes: `cylinder(adorn, worldC, axis, length, radius, color, cap=true)`, `torus(adorn, worldC, axis(NormalId), radius, thicknessradius, color)`, `faceInWorld(adorn, face(Util::Face), thickness, color)`, `partSurface(part, surfaceId, adorn, color=orange, thickness=0.2f)`, `star(adorn, center, size=1, colorX/Y/Z=white)`, `outlineBox(AABox|Extents overloads)`, `selectionBox(AABox|Extents overloads)` ("similar to 3DS" corner ticks).
- Lines/polygons: `lineSegmentRelativeToCoord`, `verticalLineSegmentSplit(cF, pt0, pt1, delta, magicParam, level, color, lineThickness)`, `polygonRelativeToCoord`, `surfacePolygon(PartInstance&, surfaceId, color, lineThickness)`.
- 2D UI: `partInfoText2D(size, position, camera, adorn, text, color, fontSize=18, mask)`, `chatBubble2d(adorn, rect, pointer, cornerradius, linewidth, quarterdivs, color)`.
- Colors: static const Color3 beige, darkblue, powderblue, skyblue, violet, slategray, aqua, tan, wheat, cornflowerblue, limegreen, magenta, pink, silver; `axisColors[3]`.
- Private: `surfaceBorder`, `scaleRelativeToCamera`.

## Usage

Included wherever Studio draws handles/grids (Draggers, DraggableSurface tools, chat rendering, Studio main render). Pulls in V8World/Primitive.h and V8DataModel/PartInstance.h and Tool/DragTypes.h — heavy header; prefer forward decls in new code.

## Gotchas

- Include is written as `"appDraw/HandleType.h"` here but `"AppDraw/HandleType.h"` elsewhere — case-insensitive filesystems only.
- Parameter named `normalIdTohighlight` (lowercase h) is part of the public signature.
