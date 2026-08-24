# FaceInstance.cpp

## Purpose

Implements `FaceInstance` ("FaceInstance") — the base class for part-face-attached instances (Decal family ancestors): a single NormalId Face property (default NORM_Z_NEG = front), Part-only parenting, and a selection adorn that highlights the chosen face.

## Key types and API

Descriptors:
- `FaceInstance::prop_Face("Face", category_Data)` — EnumPropDescriptor<NormalId>, get/set change-tracked. No Security:: arguments.

Constants: `sFaceInstance = "FaceInstance"`.

Behavior: `askSetParent` — PartInstance only; `render3dSelect` draws `DrawAdorn::partSurface(parentPart, face, adorn)` overlay.

## Usage / reflection touchpoints

Ancestor of Decal/texture faces ([Decal](Decal.md)); face enumeration shared with [Surface](Surface.md) descriptors.

## Gotchas

- Default Face is the FRONT (−Z) face; multiple FaceInstances on the same face stack without dedupe.
