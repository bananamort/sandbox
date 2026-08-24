# App/include/v8datamodel/Effect.h

## Purpose

Marker base class for graphical effect "nuggets" (per the file's own comment) — Fire, Smoke, Sparkles, particle emitters derive from it. No data or virtual contract beyond construction.

## Declared API

`class Effect`

- `Effect(); virtual ~Effect();` — entire interface.
- Note: `#include "Reflection/Reflection.h"` appears *before* `#pragma once` in this file (harmless but unusual ordering).

## Gotchas

- Pure tag type: no reflected members, no state; dynamic behavior lives entirely in subclasses.
- Non-Instance mixin — concrete effect classes multiply inherit (e.g. CustomParticleEmitter : Instance, Effect).

## Cross-links

- Implementation: [App/v8datamodel/Effect.md](../../v8datamodel/Effect.md).
- Subclasses: [CustomParticleEmitter.md](CustomParticleEmitter.md), [Fire.md](Fire.md), [Smoke.md](Smoke.md), [Sparkles.md](Sparkles.md).
