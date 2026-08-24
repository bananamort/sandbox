# App/include/v8datamodel/PluginMouse.h

## Purpose

`PluginMouse` — non-creatable `Mouse` subclass for Studio plugins that adds one thing: a `dragEnterEventSignal` fired (via `fireDragEnterEvent`) when assets are dragged into the viewport. PluginManager's `fireDragEnterEvent` (IHostNotifier) routes here.

## Declared API

`class PluginMouse : public DescribedNonCreatable<PluginMouse, Mouse, sPluginMouse>`

- `PluginMouse(); ~PluginMouse();`
- `void fireDragEnterEvent(shared_ptr<const RBX::Instances> instances, shared_ptr<InputObject> input)`
- `rbx::signal<void(shared_ptr<const Instances>)> dragEnterEventSignal`

## Gotchas

- fireDragEnterEvent takes an InputObject but the signal drops it — only the dragged Instances reach listeners.
- All real mouse behavior inherited from [Mouse.md](Mouse.md).

## UNKNOWN

- Which host layer calls fireDragEnterEvent in practice (Studio shell, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PluginMouse.md](../../v8datamodel/PluginMouse.md).
- Base: [Mouse.md](Mouse.md); consumer: [PluginManager.md](PluginManager.md); drag source: [StudioPluginHost.md](StudioPluginHost.md).
