# PluginMouse.cpp

## Purpose

Implements `PluginMouse` ("PluginMouse"), the Studio-plugin mouse object returned by `Plugin:GetMouse()` (see PluginManager.md). Adds one plugin-security event, `DragEnter`, fired when Studio asset-drag operations enter the viewport; otherwise inherits all raycasting/behavior from `Mouse`.

## Key types and API

Descriptors:
- `evt_dragEnterEvent("DragEnter(instances)")` — EventDesc carrying shared_ptr<const Instances>, **Security::Plugin**.

Method: `fireDragEnterEvent(instances, input)` — first `update(input)` (inherited mouse position/ray update from the synthesized InputObject), then raises `dragEnterEventSignal`.

## Usage / reflection touchpoints

Fired exclusively by `PluginManager::fireDragEnterEvent` during Studio drag-and-drop; pairs with Mouse.md, PluginManager.md in this folder, UserInputService.md (which receives setCurrentMousePosition alongside).

## Gotchas

- DragEnter fires with the instances being dragged — a plugin can intercept/inspect them but this event path bypasses normal UserInputService pipelines entirely.
- UNKNOWN: whether update(input) affects Target/Hit identically to real mouse movement (header-side Mouse::update).
