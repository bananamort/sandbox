# v8kernel Header Docs — Independent Review Certification

**Reviewer**: ox-alpha (independent re-verification; all prior in-flight edits treated as untrusted)
**Date**: full re-read of every source header and every doc file — no sampling.
**Sources**: `roblox-sandbox/App/include/v8kernel/*.h` (19 headers) ↔ this directory's `*.md` (19 + INDEX.md = 20). Coverage confirmed 1:1 by enumeration.

## Key cross-cutting claims (protocol-mandated)

| Claim | Verdict | Evidence |
|---|---|---|
| `fakeDeceptiveSolverIterations()` / `fakeDeceptiveMatrixSize()` are anti-tamper decoy telemetry | SUPPORTED | `Kernel.h:116-117`; `Kernel.cpp:575-587`: matrix size = topology-derived decoy (`numConnectors() + 6*numBodies()`), iterations = doubly-square-rooted decoy; neither reads real solver state (`numLastIterations`) |
| SimBody force-reset gravity seeding | SUPPORTED | `SimBody.h:64-67`: `clearForceAccumulators()` sets `force = getWorldGravityForce()`, not zero |
| Body PV threading ladder: Fast = step-only, Unsafe = external lock, Spin_Lock = self-locking | SUPPORTED | `Body.h:254-274` (+ fishing asserts on all Fast variants); documented correctly in Body.md after caller-list fix |

## Per-file results

| File | Verdict | Findings & actions |
|---|---|---|
| Body.md | FIXED | WRONG: claimed Fast-variant callers were "all step-pipeline code" — `HumanoidState.cpp:1221,1227` also calls `getPvFast()`. Caller list corrected. All other signatures/claims verified. |
| BodyPvSetter.md | FIXED | WRONG mechanism attribution: guard is the `const BodyPvSetter&` parameter type on Body's setter quartet, not "friendship". Corrected; noted implicit-default-ctor weakness. |
| BulletShapeConnectors.md | FIXED | WRONG access specifier: `updateBulletCollisionObjects()` is private (header L35), was listed under protected ops. Moved. Everything else verified incl. ctor forwarding `(b0,b1,params,0,0)` and both static `match` overloads. |
| BuoyancyConnector.md | PASS | Full signature/member verification incl. by-value `getWorldPosition()`, water-band mapping, "SubMerge" sic spellings. |
| Cofm.md | PASS | Incl. correct doc-drift catch (`void updateIfDirty(); // true if was dirty`). |
| Connector.md | FIXED | WRONG access specifier: `baseRotation` is private (header L96-97), was lumped into protected state. Split out. Spring-math quote and enum/index lists verified exact. |
| Constants.md | PASS | In-flight file fully verified: exactly three in-header definitions (`uiStepsPerSec`=60 composite, `longUiStepsPerSec`=30, `getKmsGravity`=−9.81f); all declared-elsewhere signatures match. |
| ContactConnector.md | PASS | Both `getReordedSimBody` overloads, POINT_PLANE assert in `isIntersecting`, sign conventions, subclass member lists all verified. |
| ContactParams.md | PASS | Four floats w/ verbatim comments (incl. `* -0.5;???`), zeroing ctor, 14 GeoPairType enumerators in order. |
| Debug.md | PASS | Macro gate, commented-out define w/ verbatim rationale, include-case gotcha accurate. |
| INDEX.md | PASS | 19 rows = 19 headers; notes spot-checked against sources; "no .inl files" true. |
| IStage.md | PASS | 16-stage enum counted; dtor-deletes-downstream; null-guard-less `findStageImpl`. |
| Kernel.md | PASS | Every declaration verified; fakeDeceptive* characterization supported by Kernel.cpp implementation. |
| KernelData.md | PASS | Full routing ladder, dt ladder (contact-only @ freeFallDt L325), remove-path symmetry unwind at −1.0f, verbatim comments. |
| KernelIndex.md | PASS | Trivial mixin; dtor assert semantics accurate. |
| Link.md | PASS | Members, pure virtual, both concrete links, validation asymmetry, allocator split. |
| Pair.md | PASS | Union layout, verbatim polarity comments, dispatcher uses `computeEdgeEdgePlane2`, match asymmetry. |
| Point.md | PASS | Protected-ctor-with-"private"-comment nuance handled; sic spellings preserved. |
| PolyConnectors.md | PASS | Six concrete types, enum mapping, literal-0 param forwarding for ball pairs. |
| SimBody.md | FIXED | MISSING: six declared members absent from API list (`getPV`, `getOwnerPV`, `updateMomentRecipWorld`, `computeRotationVelocityFromMomentum(+Fast)`, `getInverseInertiaInWorld`, private `update()`). Added. Gravity seeding + buoyancy-omitting `validateBodyLists` claims independently confirmed. |

## Totals

- **PASS**: 15
- **FIXED**: 5 (Body, BodyPvSetter, BulletShapeConnectors, Connector, SimBody)
- **FAIL**: 0
- **Files reviewed**: 20 of 20

## Residual notes

- Severity taxonomy applied: 4× WRONG (all fixed mechanically in place), 1× MISSING-GOTCHA (fixed), 0× UNSUPPORTED remaining, 0× STYLE-blocking.
- All writes confined to this docs directory; source tree untouched.
- Interpretive gotchas that could not be falsified from headers alone (e.g., water-band semantics, worldBody singleton lifecycle) were retained as consistent-with-evidence rather than altered.
