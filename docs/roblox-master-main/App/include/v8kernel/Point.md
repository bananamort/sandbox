# App/include/v8kernel/Point.h

## Purpose

Kernel attachment point on a [Body.md](Body.md): constant body-space position, per-frame world position, and a force accumulator flushed back to the body each step. Base of joint/contact anchor points; only the kernel constructs points (`KernelData`/`Kernel` are friends).

## Declared API

- `class Point : public KernelIndex` (see [KernelIndex.md](KernelIndex.md))
  - Friends: `KernelData`, `Kernel`.
  - Private: `int& getKernelIndex(); int numOwners;`
  - Protected: `Body* body; Vector3 localPos;` ("constant"), `Vector3 worldPos;` ("auxillary variables, computed on every frame" — sic), `Vector3 force;` ("accumulated quantities").
  - Protected ctor `Point(Body* _body = NULL)`; virtual dtor.
  - Public static: `bool sameBodyAndOffset(const Point& p0, const Point& p1)` — body pointer + localPos equality.
  - Per-step: **`void step();`** — "called by kernel every step // Updates World Position, Clears Accumulator"; `void forceToBody();` — "corresponds to 'for each Point, accumulate forces to Body'".
  - Force accumulation inline: `accumulateForce(const Vector3&)`.
  - Mutators: `setLocalPos(const Vector3&)`, `setWorldPos(const Vector3&)`, `void setBody(Body*)` inline.
  - Inquiry: `Body* getBody()`, `const Vector3& getWorldPos()`.

## Gotchas

- `worldPos` is stale between steps unless `step()` ran — reading it outside the step window gives last-frame data.
- `numOwners` tracks how many connectors/joints reference the point; ownership bookkeeping lives in kernel .cpps.
- Comment says "all points from same allocator, size of AttachPoint" — derived point classes must not add members beyond AttachPoint size if pooled as such.
- `localPos` is marked "constant" yet has a setter — const-by-convention only.
