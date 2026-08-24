# App/include/v8datamodel/Explosion.h

## Purpose

`Explosion` Instance — one-shot stepped effect that blasts parts (and terrain) within `blastRadius`: applies pressure impulses, optionally breaks joints inside `destroyJointRadiusPercent`, kills unanchored small objects, fires `hitSignal` per affected part, and renders a brief visual.

## Declared API

`class Explosion : public DescribedCreatable<Explosion, Instance, sExplosion>, public IAdornable ("only here for G3D"), public IStepped, public Diagnostics::Countable<Explosion>, public Effect`

- Enum: `enum ExplosionType { NO_EFFECT, NO_DEBRIS, WITH_DEBRIS };` — member is a *public field* `explosionType` with getter/setter pair.
- Props: `static BoundProp<Vector3> propPosition; static BoundProp<float> propBlastPressure;`
- Geometry/force: `const Vector3& getPosition() const;` `void setBlastRadius(float)/getBlastRadius() const`; `void setDestroyJoints(float percent)/getDestroyJoints() const` (member comment: blastPressure units "RBX Force / RBX^2 approximately").
- Visuals: `float visualRadius() const;` private `renderTime() const { return 0.10f; } // seconds`.
- C++ only helper: `void setVisualOnly()` — zeroes propBlastPressure ("use for internal tools").
- Signal: `rbx::signal<void(shared_ptr<Instance>, float)> hitSignal;`
- Private machinery: radii math `killRadius()`, `blastMaxObjectRadius()`, `killMaxObjectRadius()`; actions `doKill()`, `doBlast(MegaClusterInstance* terrain, const std::vector<shared_ptr<PartInstance>>&)`, `signalBlast(parts)`.
- Overrides: `askSetParent`, `onServiceProvider` (+IStepped hookup), IAdornable render (`shouldRender3dAdorn() true`, `render3dAdorn(Adorn*)`), IStepped `onStepped(const Stepped&)`.

## Gotchas

- The explosion consumes itself on step (renderTime 0.1 s window) — placement timing matters.
- Terrain involvement goes through MegaClusterInstance pointer passed into doBlast.
- Public raw enum field + property pair — writes via the field skip property-change notifications.

## UNKNOWN

- Exact kill vs blast radius defaults and joint-break rules (.cpp — see [Explosion.md](../../v8datamodel/Explosion.md)).

## Cross-links

- Implementation: [App/v8datamodel/Explosion.md](../../v8datamodel/Explosion.md).
- Kin effects: [Fire.md](Fire.md), [Smoke.md](Smoke.md), [Sparkles.md](Sparkles.md); base [Effect.md](Effect.md); terrain [MegaCluster.md](MegaCluster.md).
