# Effect.cpp

## Purpose

Implements `Effect` — an empty base class TU: default ctor and destructor only. All Effect-family behavior (Smoke, Fire, Sparkles) is header-side or in subclasses.

## Key types and API

Nothing — no descriptors, no constants, no Security:: tiers. Just `Effect::Effect()` / `~Effect()`.

## Usage / reflection touchpoints

Base of [Smoke](Smoke.md)/[Fire](Fire.md)/[Sparkles](Sparkles.md).

## Gotchas

- Any reflection surface attributed to "Effect" itself comes from the header's REFLECTION block, not this file.
