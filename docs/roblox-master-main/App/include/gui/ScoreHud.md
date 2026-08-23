# App/include/gui/ScoreHud.h

## Purpose

Empty declaration unit: the header exists only to aggregate includes (`Gui.h`, `RunStateOwner.h`, `Network/Player.h`, `Network/Players.h`, `V8DataModel/team.h`, `V8DataModel/teams.h`) for score-HUD-related translation units; namespace RBX contains no declarations.

## Declared API

- None. (Empty `namespace RBX {}`.)

## Usage notes

- Treat like a precompiled-header shim: any behavior attributed to "ScoreHud" lives in the corresponding .cpp using this header, not here.

## Gotchas

- UNKNOWN: whether any ScoreHud implementation .cpp survived the prune; grep App sources before assuming behavior.
