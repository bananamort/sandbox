# App/include/v8datamodel/CommonVerbs.h

## Purpose

Aggregator object that instantiates the full standard set of Studio verbs from [Commands.h](Commands.md) plus every `TToolVerb` tool launcher as public members — one `CommonVerbs` per DataModel wires up edit/format/run/test/adv-build menus and all editor/runtime tools.

## Declared API

`class CommonVerbs` — ctor `CommonVerbs(DataModel* dataModel);`

Members by menu (all public, default-constructed in ctor):
- Play mode: `playDeleteSelectionVerb`.
- Edit: `deleteSelectionVerb`, `selectAllCommand`, `selectChildrenVerb`, `snapSelectionVerb`, `unlockAllVerb`, `colorVerb`, `materialVerb`.
- Format: `anchorVerb`, `translucentVerb`, `canCollideVerb`, `canNotSelectCommand`, `allCanSelectCommand`, `moveUpPlateVerb`, `moveUpBrickVerb`, `moveDownSelectionVerb`, `rotateSelectionVerb`, `tiltSelectionVerb`.
- Run: `runCommand`, `stopCommand`, `resetCommand`.
- Test: `firstPersonCommand`, stats family (`statsCommand`, `renderStatsCommand`, `engineStatsCommand`, `networkStatsCommand`, `physicsStatsCommand`, `summaryStatsCommand`, `customStatsCommand`), `joinCommand`.
- Adv build: `turnOnManualJointCreationVerb`, drag-grid trio, grid-size trio, manual-joint strength trio.
- Tools (TToolVerb<...>): `axisRotateToolVerb`, `advMoveToolVerb`, `advRotateToolVerb`, `advArrowToolVerb`, `resizeToolVerb` (MoveResizeJoinTool), surface tools (`flatToolVerb`, `glueToolVerb`, `weldToolVerb`, `studsToolVerb`, `inletToolVerb`, `universalToolVerb`, `hingeToolVerb`, `rightMotorToolVerb`, `leftMotorToolVerb`, `oscillateMotorToolVerb`, `smoothNoOutlinesToolVerb`), `anchorToolVerb`, `lockToolVerb`, (`fillToolVerb`, `materialToolVerb`, `dropperToolVerb`), runtime tools (`gameToolVerb`, `grabToolVerb`, `cloneToolVerb`, `hammerToolVerb`).

Includes pull in Tool/* headers (ToolsArrow, ResizeTool, HammerTool, GrabTool, CloneTool, NullTool, GameTool, AxisMove/Rotate, MoveResizeJoin, AdvMove/Rotate) and V8DataModel Tools{Part,Surface,Model}.

## Gotchas

- Class comment: "Contain a set of verbs used by Roblox" — it owns verb lifetimes by value; construction order matters.
- Header is a heavy include hub (drags most Tool headers into any TU that includes it).
- Forward-declared types (Fonts, GuiRoot, GuiItem, ContentProvider, TimeState, Hopper, PlayerHopper, StarterPackService, Adorn) are unused here — leftovers.

## UNKNOWN

- Where CommonVerbs is registered into the VerbContainer/menu system (.cpp).

## Cross-links

- Implementation: [App/v8datamodel/CommonVerbs.md](../../v8datamodel/CommonVerbs.md).
- Verb bases/tools: [Commands.md](Commands.md), [ToolsPart.md](ToolsPart.md), [ToolsSurface.md](ToolsSurface.md), [ToolsModel.md](ToolsModel.md).
