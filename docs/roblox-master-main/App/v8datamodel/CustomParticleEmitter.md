# CustomParticleEmitter.cpp

## Purpose

Implements `CustomParticleEmitter` (registered "ParticleEmitter") — the modern configurable particle emitter: texture/color/transparency/size sequences, emission rate/speed/spread/rotation/lifetime, motion accel/drag/velocity-inheritance, LockedToPart, ZOffset, EmissionDirection, plus an Emit(count) burst replicated to all clients. Pure state + change-tracked setters; simulation lives renderer-side.

## Key types and API

Descriptors — categories: CAT_VIS=category_Appearance, "Emission", "Motion", "Particles"; no Security:: arguments:
- Visual: prop_texture("Texture", default `rbxasset://textures/particles/sparkles_main.dds`), prop_color("Color", ColorSequence), prop_transp("Transparency", NumberSequence), prop_size("Size", NumberSequence), prop_lightEmission("LightEmission"), prop_zOffset("ZOffset").
- Emission: prop_enabled("Enabled", true), prop_rate("Rate", 20), prop_speed("Speed", NumberRange 5–5), prop_spread("VelocitySpread"), prop_rotation("Rotation"), prop_rotSpeed("RotSpeed"), prop_lifetime("Lifetime", 5–10), prop_emissionDirection("EmissionDirection", NormalId, NORM_Y).
- Motion: prop_accel("Acceleration"), prop_velocityInheritance("VelocityInheritance").
- Particles: prop_dampening("Drag") — GATED by DFFlag EnableParticleDrag; prop_lockedToLocalSpace("LockedToPart").

API: `desc_burst("Emit", "particleCount"[16], Security::None)` → requestBurst fires `event_onEmitRequested("OnEmitRequested", "particleCount", Security::None, REPLICATE_ONLY, BROADCAST)`.

Flags: `DYNAMIC_FASTFLAGVARIABLE(CustomEmitterInstanceEnabled, false)`, `EnableParticleDrag(false)`.

Behavior: every setter compares-then-raises; setDampening with flag OFF raises the property but DOESN'T STORE the value. GA "CustomParticleEmitter" tracked ONCE per process on first ancestor change.

## Usage / reflection touchpoints

Successor to [Sparkles](Sparkles.md)/[Smoke](Smoke.md); sequence payloads documented in [ColorSequence](ColorSequence.md)/[NumberSequence](NumberSequence.md)/[NumberRange](NumberRange.md).

## Gotchas

- Drag writes are silently discarded until EnableParticleDrag flips — property reads still return the stale 0.
- Emit() broadcasts to EVERY client (BROADCAST) — per-player burst targeting is impossible from this object.
- Lifetime default is a RANGE (5–10 s random), not fixed.
