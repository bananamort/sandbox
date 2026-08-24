# CommonVerbs.cpp

## Purpose

Implements `CommonVerbs` — an aggregate struct that simply CONSTRUCTS the entire standard Studio verb set (60+ members) in one initializer list: stats HUD toggles, run/stop/reset, drag/rotate/resize/snap tools, surface-paint tools (flat/glue/weld/studs/inlet/universal/hinge/motors), anchor/lock/fill/material/color/dropper verbs, selection verbs, and game/clone/grab/hammer tools. No logic of its own.

## Key types and API

No descriptors, no Security:: tiers — pure composition.

- Single ctor `CommonVerbs(DataModel*)` initializing every verb member from Commands.cpp ([Commands](Commands.md)) and the tool-verb families declared header-side (ToolsModel/ToolsPart/ToolsSurface siblings).
- Member groups visible in the ctor order: stats (7), run state (3), transform tools (axisRotate/resize/advMove/advRotate/advArrow), manual-joint + grid settings (9), surface tools (11 incl. smoothNoOutlines), anchor/lock/fill/material/materialVerb/colorVerb/dropper, firstPerson/selectChildren/snap/playDelete/deleteSelection, moveUp plate+brick variants / moveDown / rotate / tilt, selectAll/allCanSelect/canNotSelect, translucent/canCollide/unlockAll, game/grab/clone/hammer tools.

## Usage / reflection touchpoints

Instantiated by the Studio shell to register all verbs at once; individual behaviors documented under [Commands](Commands.md) plus ToolsModel/ToolsPart/ToolsSurface in this folder.

## Gotchas

- Construction ORDER of members is fixed by declaration order in the header — verbs with ctor side effects (e.g. CameraCenterCommand forcing FilteredSelection creation) run in that order.
- This TU compiles to essentially nothing but ctors; debugging any single verb means following its member into its defining TU.
