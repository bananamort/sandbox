# App/include/v8kernel/Link.h

## Purpose

Parent↔child transform link used by joints to place a child body relative to its parent: caches `childInParent` from (parentCoord, childCoord) and recomputes lazily when dirtied. Concrete flavors: `RevoluteLink` (single joint angle) and `D6Link` (full offset CoordinateFrame).

## Declared API

- `class RBXBaseClass Link` (friend `Body`)
  - Protected: `Body* body;` ("body I'm affiliated with (child)" — "affilliated" sic), `CoordinateFrame parentCoord, childCoord, childCoordInverse, childInParent; unsigned int stateIndex;`
  - Pure virtual: `void computeChildInParent(CoordinateFrame& answer) const = 0;`
  - Protected: `void dirty(); void setBody(Body*)`.
  - Public: ctor/dtor; **`const CoordinateFrame& getChildInParent()`** (lazy recompute); `Body* getBody() const`; `void reset(const CoordinateFrame& parentC, const CoordinateFrame& childC)`.
- `class RevoluteLink : public Link, public Allocator<RevoluteLink>`
  - Private `float jointAngle;` ctor zero; override of computeChildInParent; inline `setJointAngle(float)` → dirty.
- `class D6Link : public Link, public Allocator<D6Link>`
  - Private `CoordinateFrame offsetCFrame;` override; inline `setJointOffsetCFrame(const CoordinateFrame&)` → asserts `!Math::hasNanOrInf(value)`, then dirty.

## Gotchas

- `stateIndex` pairs with the kernel's state caching — bump semantics live in Body/kernel code.
- D6Link validates NaN/Inf on set but RevoluteLink does not validate its angle.
- Both concrete links use pooled `Allocator<>`; Link itself does not.
- `childCoordInverse` is maintained alongside the others by `reset`/dirty machinery — treat all four CFrames as one atomic cache.
