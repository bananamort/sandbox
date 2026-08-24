# ForceField.cpp

## Purpose

Implements `ForceField` ("ForceField") — the spawn-protection bubble: ancestor-search helper `partInForceField` (blast/join suppression elsewhere consults it) and the legacy pulsing-sphere render over the character's "Torso" part, disabled entirely under RenderNewParticles2Enable.

## Key types and API

Descriptors: none. Constants: `sForceField = "ForceField"`; static `cycles()` from header. Consumed flag: RenderNewParticles2Enable (declared in [Fire](Fire.md)).

Behavior:
- `askSetParent` — any parent EXCEPT Workspace.
- `containsForceField` / `ancestorContainsForceField` — child scan then parent walk bailing AT Workspace ("to prevent going through all workspace children"); `partInForceField(part)` is the public entry.
- `render3dAdorn` — flag ON → return immediately (new renderer draws it). Legacy path caches a "Torso" descendant of its parent; frame-advance via cycle counters (non-cyclic) or wall-clock 60 Hz phase (cyclic); renders two pulsing blue spheres sized by part magnitude ×largeSize with alpha ramps; skips parts with localTransparencyModifier ≥0.99.

## Usage / reflection touchpoints

Consulted by [Explosion](Explosion.md)::doBlast/doKill and joint destruction ([Feature](Feature.md)-adjacent); spawned around characters on team spawn ([SpawnLocation](SpawnLocation.md)).

## Gotchas

- Cyclic-mode bug: the wall-clock `cycle`/`invertCycle` are BLOCK-LOCAL variables that die before the render call — line 124 passes the stale MEMBER values instead, so in cyclic-executive mode the legacy bubble gets constant phase and never animates (non-cyclic branch does mutate the members).
- The torso lookup runs once and CACHES — swapping the character's Torso leaves the bubble rendering nothing until the ForceField is recreated.
- Protection semantics live at CALL SITES (explosion, joints), not here — this TU only answers the boolean.
