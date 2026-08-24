# App/include/v8datamodel/ScriptService.h

## Purpose

`ScriptService` — non-creatable service placeholder for script management: the class body is EMPTY; everything (script lifecycle, source loading) lives in the base Service/Instance machinery or out-of-line reflection.

## Declared API

`class ScriptService : public DescribedNonCreatable<ScriptService, Instance, sScriptService>, public Service`

- No members, methods, signals — declaration only (`extern const char* const sScriptService`).

## Gotchas

- Marker service: its existence in the tree is the feature; do not expect behavior from this header.

## UNKNOWN

- What (if anything) the .cpp registers (methods/properties via reflection tables).

## Cross-links

- Implementation: [App/v8datamodel/ScriptService.md](../../v8datamodel/ScriptService.md).
- Script containers: [ServerScriptService.md](ServerScriptService.md), [PlayerScripts.md](PlayerScripts.md), [ReplicatedFirst.md](ReplicatedFirst.md).
