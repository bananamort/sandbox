# Mouse.cpp

## Purpose

Implements the legacy `Mouse` Instance (name "Mouse") — the script-facing 3D mouse object handed to Tools and MouseCommand-driven LocalScripts. It wraps the newest cached `InputObject` and exposes raycast results (Hit/Target/TargetSurface), screen coordinates, view size, key events, and the mouse icon.

## Key types and API

`class Mouse` (base declared in header; created per tool session, not creatable from Lua).

Reflection events: `Move`, `Idle`, `Button1Down`, `Button2Down`, `Button1Up`, `Button2Up`, `WheelForward`, `WheelBackward`, `KeyDown(key)` and `KeyUp(key)` (both flagged deprecated in favor of UserInputService InputBegin/InputEnd), plus lowercase deprecated duplicate `keyDown`.

Reflection properties: `Hit` (CoordinateFrame; deprecated lowercase alias `hit` marked HIDDEN_SCRIPTING), `Origin` (CoordinateFrame), `UnitRay` (RbxRay), `TargetFilter` (Instance ref, settable), `Target` (PartInstance ref; deprecated alias `target`), `TargetSurface` (NormalId enum), `X`, `Y` (ints, -1 before any event), `ViewSizeX`, `ViewSizeY`, `Icon` (TextureId).

Getters: `getHit()` returns a CoordinateFrame at Origin position with translation replaced by the filtered world-ray hit point (via `MouseCommand::getPartByLocalCharacter` honoring TargetFilter through `FilterDescendents`); `getUnitRay()`/`getOrigin()` derive from `MouseCommand::getUnitMouseRay(lastEvent, workspace)`; `getTarget()`/`getTargetSurface()` use `MouseCommand::getPart/getSurface` with the filter. All geometry getters call `checkActive()`, which throws "This Mouse is no longer active" once detached from a Workspace (plus RBXASSERT(0)).

`update(shared_ptr<InputObject>)` is the pump: TYPE_MOUSEMOVEMENT → cache + Move signal (with a "TODO: rate control this event" comment); TYPE_MOUSEIDLE → Idle; MOUSEBUTTON1/2 → Down/Up signals by event phase; MOUSEWHEEL → WheelForward/WheelBackward (no caching of the event); TYPE_KEYBOARD → KeyDown/KeyUp with a single-character string produced by casting the KeyCode to char — code comments call this out as a HACK that only works for ASCII-mapped keys (see SDL_keysym.h). `cacheInputObject` CLONES the incoming InputObject into a fresh instance (`Creatable<Instance>::create<InputObject>(*inputObject)`).

Icon handling routes through UserInputService's icon stack: setIcon pops the old icon then pushes the new one if non-empty (`popMouseIcon`/`pushMouseIcon`); setWorkspace pops the icon when leaving the old workspace. ViewSize getters subtract GuiService globalGuiInset from screen resolution.

## Usage / reflection touchpoints

Everything above is registered in one REFLECTION_BEGIN/END block, so Lua scripts receive this object as `mouse` in Tool activation callbacks and can bind `mouse.Button1Down:connect(...)` etc. Deprecated descriptors keep old script names alive while pointing at modern replacements. The class depends on MouseCommand for all raycasting and on GuiService/UserInputService providers found via the Workspace.

## Gotchas

- KeyDown/KeyUp deliver raw ASCII of the KeyCode byte — non-ASCII keys produce garbage characters; the file itself labels this a hack.
- X/Y return -1 and UnitRay/Hit degenerate when no input event has arrived yet.
- Wheel events fire WITHOUT updating the cached input object, so Hit/Target after a wheel tick reflect the previous move.
- Once the owning Workspace is gone every property read throws ("This Mouse is no longer active") rather than returning defaults.
- ViewSize excludes the global GUI inset — inset-adjusted space, matching X/Y semantics of this era.
- UNKNOWN: who constructs Mouse instances and calls update()/setWorkspace() (Tool/MouseCommand plumbing lives elsewhere).
