# AppDraw/include/appdraw/HitTest.h

## Purpose

Header for `RBX::HitTest` — analytic ray/part intersection dispatch (see HitTest.cpp.md).

## API

Namespace RBX, class HitTest: public `static bool hitTest(const Part&, RbxRay& rayInPartCoords, Vector3& hitPointInPartCoords, float gridToReal)`; private helpers `hitTestBox`, `hitTestBall`, `hitTestCylinder`. Forward-declares Part; pulls Util/G3DCore.h.

## Usage / Gotchas

Ray and hit point are both in **part-local** space; callers transform first. Only covers block/ball/cylinder legacy shapes.
