# ToolMouseCommand.cpp

## Purpose

Implements `ToolMouseCommand`, the ScriptMouseCommand subclass wiring an equipped Tool to mouse input: left-down activates the Tool (with Humanoid TargetPoint replication ordering), hover/idle keep TargetPoint fresh, ctrl+click routes into ClickDetector logic instead, and unequip races are handled like StudioToolMouseCommand.md.

## Key types and API

Extends ScriptMouseCommand. FFlag UseFixedRightMouseClickBehaviour consumed (extern).

- Ctor(workspace, tool): connects tool->unequippedSignal → disconnect marker (NULL tool tolerated).
- `updateTargetPoint(inputObject, replicate)`: local humanoid only; ray hit via getPartByLocalCharacter else head-position + one ray-direction step; replicate ? `setTargetPoint` : `setTargetPointLocal`.
- `onMouseDown`: CTRL+click ⇒ tryClickable check (ClickDetector::isClickable with distanceToCharacter) then Super::onMouseUp (release). Otherwise: mouseIsDown=true; cache input on Mouse ("touch devices may not of updated recently"); updateTargetPoint LOCAL first, tool->activate(), then updateTargetPoint replicated — comment documents pending-items ordering requirement; keep-capture unless tool got unequipped mid-click.
- `onMouseHover`: legacy right-click part tracking (cleared when hovering a different part) unless fixed-behaviour flag; updateTargetPoint(mouseIsDown).
- `onMouseUp`: deactivate then replicated target point update, order-documented as above.

## Usage / reflection touchpoints

Not script-facing directly. Pairs with Tool.md, ScriptMouseCommand.md, ClickDetector.md in this folder.

## Gotchas

- The activate/target-point ordering comments reveal replicator internals: player-owned property changes prepend to pending list while events append — wrong order desyncs TargetPoint vs Activated.
- Ctrl+click path calls Super::onMouseUP (typo'd casing irrelevant but note it's the UP handler during DOWN).
- rightMouseClickPart member managed here but never read elsewhere in this TU beyond the legacy hover reset (UNKNOWN consumer header-side).
