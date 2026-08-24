# App/include/v8world/Feature.h

## Purpose

Lightweight (primitive, index) handles naming a geometric feature — vertex, edge, or face — on a primitive's mesh. Used by contact/GeoPair machinery to identify which feature of which primitive a connector refers to.

## Declared API

- `namespace RBX::GEO`
  - `class RBXBaseClass Feature` — members `Primitive* primitive; int index;`
    - `typedef enum {VERTEX, EDGE, FACE} FeatureType;`
    - `Feature(Primitive*, int index);` `virtual FeatureType getFeatureType() const = 0;`
  - `class Vertex : public Feature`, `class Edge : public Feature`, `class Face : public Feature` — each just fixes the returned type.

## Gotchas

- `RBX::GEO::Edge` collides by name with [Edge.md](Edge.md) (the pipeline edge) and `POLY::Edge` (mesh edge) — always qualify.
- Features are non-owning raw handles; no lifetime management, index validity is the caller's burden.
- Closing comment says `// namespace Feature` but the namespace is `GEO` — stale comment.

## Cross-links

- Consumers: [Contact.md](Contact.md) GeoPair loading, [Poly.md](Poly.md) mesh features (`POLY::Face/Edge/Vertex`).
