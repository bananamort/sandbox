# App/include/v8datamodel/CustomParticleEmitter.h

## Purpose

`ParticleEmitter` Instance (descriptor `sParticleEmitter`; class name CustomParticleEmitter) — the modern per-part particle system: texture + color/size/transparency sequences, rate/spread/lifetime/rotation ranges, physics knobs, and a replicable burst request.

## Declared API

`class CustomParticleEmitter : public DescribedCreatable<CustomParticleEmitter, Instance, sParticleEmitter>, public Effect`

- Prop descriptors: `prop_texture` (TextureId), `prop_color` (ColorSequence), `prop_transp`/`prop_size` (NumberSequence), `prop_enabled`, `prop_lightEmission`, `prop_rate`, `prop_speed` (NumberRange), `prop_spread`, `prop_rotation`, `prop_rotSpeed`, `prop_lifetime` (NumberRange), `prop_accel` (Vector3), `prop_zOffset`, `prop_velocityInheritance`, `prop_dampening`, `prop_lockedToLocalSpace`, `prop_emissionDirection` (EnumProp NormalId).
- Remote event: `event_onEmitRequested<void(int)>` (RemoteEventDesc) + local `rbx::remote_signal<void(int)> onEmitRequested;`
- Bound function: `desc_burst<void(int)>`.
- Getters/setters for every field above (`getEnabled/setEnabled(bool)`, `getLightEmission`, `getRate/setRate`, `getSpeed/setSpeed(const NumberRange&)`, spread, rotation, rotSpeed, lifetime, accel, zOffset, velocityInheritance, dampening, lockedToLocalSpace, emissionDirection; sequence accessors `getTexture/setTexture`, `getTransparency/setTransparency`, `getColor/setColor`, `getSize/setSize`).
- `void requestBurst(int value);`
- Tree rules: parent must be PartInstance; no children allowed (`askAddChild` → false); `onAncestorChanged` override.
- Private state mirrors every property (texture, color, transparency, size sequences; enabled/lightEmission/rate/speed/spread/rotation/rotSpeed/lifetime/accel/zOffset/velocityInheritance/dampening/lockedToLocalSpace/emissionDirection).

## Gotchas

- Class name vs descriptor: Lua sees "ParticleEmitter".
- Emission direction is a NormalId — emission is face-relative to the owning part.
- Burst travels as remote event with an int count.

## UNKNOWN

- Simulation/update loop location (.cpp or render side — see [CustomParticleEmitter.md](../../v8datamodel/CustomParticleEmitter.md)).

## Cross-links

- Implementation: [App/v8datamodel/CustomParticleEmitter.md](../../v8datamodel/CustomParticleEmitter.md).
- Value types: [ColorSequence.md](ColorSequence.md), [NumberSequence.md](NumberSequence.md), [NumberRange.md](NumberRange.md); base [Effect.md](Effect.md).
