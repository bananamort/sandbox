# ClickDetector.cpp

## Purpose

Implements `ClickDetector` ("ClickDetector") — a child instance that makes its parent part (or any ancestor part up to Workspace) clickable/hoverable from a distance: MouseClick/MouseHoverEnter/MouseHoverLeave remote events carrying the clicking Player, gated by MaxActivationDistance. Also contains the ancestor-search helpers and a disabled pulsing-box debug renderer.

## Key types and API

Descriptors:
- `desc_MouseClick("MouseClick", "playerWhoClicked", Security::None, SCRIPTING, BROADCAST)`.
- `dep_MouseClick("mouseClick", …deprecated(desc_MouseClick)…)` — lowercase legacy alias bound to the SAME mouseClickSignal.
- `desc_MouseHoverEnter("MouseHoverEnter", "playerWhoHovered", Security::None, SCRIPTING, CLIENT_SERVER)`.
- `desc_MouseHoverLeave("MouseHoverLeave", "playerWhoHovered", Security::None, SCRIPTING, CLIENT_SERVER)`.
- `propMaxActivationDistance("MaxActivationDistance", category_Data)` — float BoundProp, default 32.0. No other Security:: tiers.

Constants: `sClickDetector = "ClickDetector"`; static `cycles()` for the render animation.

Behavior:
- Free functions: `containsClickDetector` / `ancestorContainsClickDetector` (bails AT Workspace level "to prevent going through all workspace children").
- `isClickable(part, distanceToCharacter, raiseClickedEvent, player)` — walks part→ancestors until Workspace; first ClickDetector within MaxActivationDistance wins; optionally fires MouseClick and returns true.
- `fireMouseClick(distance, player)` — strict `<` maxActivationDistance compare before replicating.
- Hover state machine per detector: `updateLastHoverPart(newHover, player)` fires Enter only on CHANGE of hovered instance; `isHovered` walks ancestors same as click path; `stopHover(part, player)` fires Leave along every ancestor chain detector and resets lastHoverPart.
- `render3dAdorn` — entire body commented out (pulsing green→red selection box debug).

## Usage / reflection touchpoints

Input pipeline invokes isClickable/isHovered from MouseCommand-style targeting ([MouseCommand](MouseCommand.md), [Tool](Tool.md)); events replicate via standard remotes ([Network](../../Network/)).

## Gotchas

- The FIRST ClickDetector found walking UP the ancestor chain handles the click — a deeper detector shadows outer ones regardless of distance settings.
- Distance check uses `<` strictly: clicking at exactly MaxActivationDistance fails.
- Hover tracking is per-detector lastHoverPart but Enter/Leave fire on ANY hover change crossing that detector's ancestry — nested detectors can produce enter/leave pairs in surprising order.
- mouseClick (lowercase) still works — deprecated alias kept for old content.
